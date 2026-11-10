"""Plot the measured DAC command->ADC chain, not calibrated ADC-only INL."""
import argparse,json,statistics,struct,csv,math,tarfile
from pathlib import Path
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

def phase4(path):
 raw=[w[0] for w in struct.iter_unpack('<H',path.read_bytes())]
 edges=[i for i in range(1,len(raw)) if not raw[i-1]&8192 and raw[i]&8192]
 v=[raw[i-1]&4095 for i in edges[1:]];means=[statistics.mean(v[k::4]) for k in range(4)]
 residual=[x-means[i%4] for i,x in enumerate(v)]
 return dict(mean=statistics.mean(v),rms=statistics.pstdev(v),phase_means=means,residual_rms=statistics.pstdev(residual))
def main():
 p=argparse.ArgumentParser();p.add_argument('--root',type=Path,required=True);p.add_argument('--out',type=Path,required=True);a=p.parse_args();a.out.mkdir(parents=True,exist_ok=False)
 reports={n:json.loads((a.root/n/'status.json').read_text()) for n in ['probe-01','dc-scan-01','edges-01','final-zero-01']}
 assert all(r['pass'] for r in reports.values())
 for n,r in reports.items():(a.out/(n+'.json')).write_text(json.dumps(r,indent=2)+'\n')
 rows=reports['dc-scan-01']['measurements']+reports['edges-01']['measurements'];summary={}
 for bank in [0,1]:
  fit=[r for r in reports['dc-scan-01']['measurements'] if r['bank']==bank]
  x=[r['diff_setpoint_v'] for r in fit];y=[r['raw_mean'] for r in fit];xm=statistics.mean(x);ym=statistics.mean(y)
  gain=sum((xx-xm)*(yy-ym) for xx,yy in zip(x,y))/sum((xx-xm)**2 for xx in x);offset=ym-gain*xm
  residuals=[yy-offset-gain*xx for xx,yy in zip(x,y)]
  noise=phase4(a.root/'dc-scan-01'/f'mux{bank}-point050-bank{bank}.bin')
  summary[str(bank)]=dict(adc='AB'[bank],gain_codes_per_commanded_v=gain,fit_offset_code=offset,
   max_abs_fit_residual_codes=max(abs(z) for z in residuals),zero_input=noise,fit_range_v=[-1,1])
 (a.out/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
 fields=['bank','diff_setpoint_v','ch0_setpoint_v','ch1_setpoint_v','raw_mean','raw_std','minimum','maximum','samples','generation']
 with (a.out/'dc.csv').open('w',newline='') as f:
  w=csv.DictWriter(f,fieldnames=fields,extrasaction='ignore',lineterminator='\n');w.writeheader();w.writerows(rows)
 with tarfile.open(a.out/'raw-captures.tar.gz','w:gz') as t:
  for run in reports:
   for path in sorted((a.root/run).glob('*.bin')):t.add(path,arcname=run+'/'+path.name)
 plt.rcParams.update({'font.size':10,'axes.spines.top':False,'axes.spines.right':False})
 fig,axes=plt.subplots(2,2,figsize=(11,8.2),layout='constrained');colors=['#1864ab','#d9480f']
 for bank,color in enumerate(colors):
  allrows=sorted([r for r in rows if r['bank']==bank],key=lambda r:r['diff_setpoint_v']);s=summary[str(bank)]
  axes[0,0].plot([r['diff_setpoint_v'] for r in allrows],[r['raw_mean'] for r in allrows],'.-',lw=1,ms=3,color=color,label='ADC '+s['adc'])
  fit=sorted([r for r in reports['dc-scan-01']['measurements'] if r['bank']==bank],key=lambda r:r['diff_setpoint_v'])
  axes[0,1].plot([r['diff_setpoint_v'] for r in fit],[r['raw_mean']-(s['fit_offset_code']+s['gain_codes_per_commanded_v']*r['diff_setpoint_v']) for r in fit],'.-',ms=3,lw=1,color=color,label='ADC '+s['adc'])
  noise=s['zero_input'];axes[1,0].plot(range(4),[v-noise['mean'] for v in noise['phase_means']],'o-',color=color,label='ADC '+s['adc'])
  axes[1,1].bar([bank-.17,bank+.17],[noise['rms'],noise['residual_rms']],width=.3,color=[color,color],alpha=.9)
  for x,y in [(bank-.17,noise['rms']),(bank+.17,noise['residual_rms'])]:axes[1,1].text(x,y*1.15,f'{y:.2f}',ha='center',fontsize=9)
 axes[0,0].set(title='DC transfer including saturation',xlabel='Requested CH0 − CH1 [V]',ylabel='Mean ADC code',ylim=(-100,4250));axes[0,0].legend(frameon=False)
 axes[0,1].set(title='Residual from linear fit over −1 to +1 V',xlabel='Requested CH0 − CH1 [V]',ylabel='Mean code − fitted code');axes[0,1].axhline(0,color='grey',lw=.8);axes[0,1].legend(frameon=False)
 axes[1,0].set(title='Four-sample pattern at zero differential input',xlabel='ADC sample index modulo 4',ylabel='Deviation from average [codes]');axes[1,0].set_xticks(range(4));axes[1,0].legend(frameon=False)
 axes[1,1].set(title='Spread at zero differential input',ylabel='RMS [ADC codes]',yscale='log',ylim=(.25,70));axes[1,1].set_xticks([0,1],['ADC A\nraw | pattern removed','ADC B\nraw | pattern removed'])
 for ax in axes.flat:ax.grid(alpha=.18)
 fig.suptitle('PM12 channel 12 — external MOD-DAC-28 differential DC test\nCommon mode: 1.0 V · DAC outputs: 0.4–1.6 V · integrator disabled',fontsize=14,fontweight='bold')
 fig.get_layout_engine().set(rect=(0,.1,1,.9))
 fig.text(.07,.025,'Voltage axis shows SCPI setpoints, not DMM measurements. Fit residual includes DAC, analog mux and ADC.\nThe four-sample template is subtracted in software for comparison; it does not identify the interference source.',fontsize=9,color='#495057')
 for ext in ['png','svg','pdf']:fig.savefig(a.out/f'adc-dc-characterization.{ext}',dpi=180)
 print(json.dumps(summary,indent=2))
if __name__=='__main__':main()
