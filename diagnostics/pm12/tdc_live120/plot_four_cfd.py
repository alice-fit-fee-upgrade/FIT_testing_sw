"""Render gate-DAC and TDC phase overlays from archived four-channel raw runs."""
import argparse,json,csv,math,sys
from pathlib import Path
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--run-root',type=Path,required=True);parser.add_argument('--out',type=Path,required=True);args=parser.parse_args()
root=args.run_root;out=args.out;out.mkdir(parents=True,exist_ok=False)
if (root/'gate-scan101/status.json').exists() and json.loads((root/'gate-scan101/status.json').read_text())['pass_']:
 gate=json.loads((root/'gate-scan101/status.json').read_text());points=gate['points'];gate_source='gate-scan101';channels=gate['channels']
else:
 a=json.loads((root/'gate-scan20/status.json').read_text());b=json.loads((root/'gate12-original20/status.json').read_text());points=[p for p in a['points'] if p['afe']!=12]+b['points'];gate_source='gate-scan20 + gate12-original20';channels=a['channels']
colors=dict(zip(channels,['#1864ab','#d9480f','#2b8a3e','#862e9c']))
summary={'gate_source':gate_source,'gate':{},'notes':['Times inferred from supplied 40.0787MHz reference; not frequency-counter verified.','DAC codes acknowledged by MCU, no DAC hardware readback.','Gate period = 48 serializer bins, two LHC periods.','Nearest-continuation phase unwrapping assumes adjacent movement below half a gate period.']}
fig,axes=plt.subplots(2,1,figsize=(10,8),layout='constrained',sharex=True)
with (out/'gate-phase.csv').open('w') as f:
 writer=csv.writer(f,lineterminator="\n");writer.writerow(['pm_channel','dac_code','logical_lane','gate','phase_ns','relative_unwrapped_ns','rising_edges','spread_bins','error'])
 for ch in channels:
  selected=sorted([p for p in points if p['afe']==ch],key=lambda p:p['code']);i=channels.index(ch);base=8+2*i;summary['gate'][ch]={}
  for index,lane in enumerate([base,base+1]):
   values=[];codes=[];last=None;records=0;errors=[];spreads=[]
   for p in selected:
    row=p['lanes'][str(lane)]
    if 'mean_ns' not in row:
     errors.append({'code':p['code'],**row});writer.writerow([ch,p['code'],lane,'AB'[index],'','','','',row.get('error')]);continue
    phase=row['mean_bin'];period=48
    if last is not None:phase+=period*round((last-phase)/period)
    last=phase;values.append(phase*1e3/(40.0787*24));codes.append(p['code']);records+=row['rising_edges'];spreads.append(row['spread_bins'])
   if values:
    relative=np.array(values)-values[0];axes[index].plot(codes,relative,'o-',ms=2.5,lw=1.2,color=colors[ch],label=f'PM channel {ch}')
    cursor=0
    for p in selected:
     row=p['lanes'][str(lane)]
     if 'mean_ns' in row:
      writer.writerow([ch,p['code'],lane,'AB'[index],row['mean_ns'],relative[cursor],row['rising_edges'],row['spread_bins'],'']);cursor+=1
    summary['gate'][ch]['AB'[index]]={'valid_points':len(values),'missing_points':len(errors),'span_ns':float(np.ptp(relative)),'start_to_end_ns':float(relative[-1]),'rising_edges':records,'max_spread_bins':max(spreads),'errors':errors}
   else:
    axes[index].plot([],[],color=colors[ch],label=f'PM channel {ch}: no edges');summary['gate'][ch]['AB'[index]]={'valid_points':0,'missing_points':len(errors),'errors':errors}
 for ax,g in zip(axes,'AB'):
  ax.set(ylabel='Relative unwrapped phase [ns]',title=f'Integrator gate {g}');ax.grid(alpha=.2);ax.legend(fontsize=9)
 axes[-1].set_xlabel('DAC A code [0–65535]');fig.suptitle('PM12 — CFD simulator phase-shifter response\nChannels '+', '.join(map(str,channels))+'; original CPLD gate mode during measurement',fontweight='bold')
 for ext in ['png','pdf','svg']:fig.savefig(out/f'gate-phase-four.{ext}',dpi=170)
if (root/'tdc-scan/status.json').exists():
 t=json.loads((root/'tdc-scan/status.json').read_text());summary['tdc_pass']=t['pass_'];summary['tdc']={};residual_series=[];fig,axes=plt.subplots(3,1,figsize=(10,11),layout='constrained',sharex=True)
 with (out/'tdc-phase.csv').open('w') as f:
  writer=csv.writer(f,lineterminator="\n");writer.writerow(['pm_channel','port','delay_ns','phase_bin','fine_mean_circular','relative_unwrapped_fine_codes','fine_std','count'])
  for ch in channels:
   ps=sorted([p for p in t['statistics'] if p['channel']==ch],key=lambda p:p['phase_bin']);u=[]
   for p in ps:
    v=p['fine_mean_circular']
    if u:v+=128*round((u[-1]-v)/128)
    u.append(v)
   if not u:continue
   rel=np.array(u)-u[0];x=[p['delay_ns'] for p in ps];sp=[p['fine_std_circular'] for p in ps]
   axes[0].errorbar(x,rel,yerr=sp,fmt='o-',lw=1,ms=3,capsize=2,color=colors[ch],label=f'PM channel {ch}')
   residual_series.append((ch,np.array(x),rel))
   axes[2].plot(x,sp,'o-',lw=1,ms=3,color=colors[ch],label=f'PM channel {ch}')
   fit=np.polyfit(x,rel,1);res=rel-np.polyval(fit,x)
   summary['tdc'][ch]={'points':len(ps),'events':sum(p['count'] for p in ps),'slope_codes_per_ns':float(fit[0]),'max_fit_residual_codes':float(max(abs(res))),'max_fine_std_codes':max(sp),'note':'Fine modulo128 only; assumes adjacent movement below64 codes. Not a calibrated time result.'}
   for p,v in zip(ps,rel):writer.writerow([ch,p['port'],p['delay_ns'],p['phase_bin'],p['fine_mean_circular'],v,p['fine_std_circular'],p['count']])
 common=np.polyfit(np.concatenate([x for ch,x,y in residual_series]),np.concatenate([y for ch,x,y in residual_series]),1)
 for ch,x,y in residual_series:axes[1].plot(x,y-np.polyval(common,x),'o-',lw=1,ms=3,color=colors[ch],label=f'PM channel {ch}')
 for ax in axes:ax.grid(alpha=.2);ax.legend(fontsize=9)
 axes[0].set(ylabel='Relative unwrapped fine phase [codes]',title='Mean ± circular standard deviation; 128 events / point')
 axes[1].set(ylabel='Residual from common linear fit [codes]')
 axes[2].set(ylabel='Circular standard deviation [fine codes]',xlabel='Programmed input delay relative to first point [ns]')
 fig.suptitle('PM12 — TDC input phase response\nOne OSERDES-bit steps across one LHC period; four CFD simulators',fontweight='bold')
 for ext in ['png','pdf','svg']:fig.savefig(out/f'tdc-phase-four.{ext}',dpi=170)
(out/'summary.json').write_text(json.dumps(summary,indent=2)+'\n');print(json.dumps(summary,indent=2)[:6000])
