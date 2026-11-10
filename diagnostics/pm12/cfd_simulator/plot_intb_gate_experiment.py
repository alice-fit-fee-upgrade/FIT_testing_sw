"""Offline comparison of captured INTB gate-isolation experiment; raw data retained."""
import argparse,json,sys,hashlib
from pathlib import Path
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
PM=Path(__file__).resolve().parents[1]
sys.path[:0]=[str(PM/'ipbus_adc'),str(PM/'cfd_simulator')]
from adc_decode import decode
from plot_adc_fft import analyze
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--data',type=Path,required=True);p.add_argument('--out',type=Path,required=True);a=p.parse_args()
data=a.data;out=a.out;out.mkdir(parents=True,exist_ok=False)
fs=80157400.;results={};series={}
for stage in ['original','intb-off']:
 results[stage]={}
 for bank in 'AB':
  samples=[];stats=[]
  for file in sorted(data.glob(f'{stage}-adc{bank}-*.bin')):
   f,p,res,s=analyze(file,fs);s['file']=file.name;stats.append(s)
   decoded,t=decode([int(w) for w in np.fromfile(file,dtype='<u2')]);samples.append(np.array(decoded[:1020],dtype=float))
  assert len(stats)==8
  fields=['mean_code','raw_rms_codes','residual_rms_codes','fs_over_4_rms_codes','fs_over_2_rms_codes']
  results[stage][bank]={'captures':stats,'aggregate':{k:{'mean':float(np.mean([s[k] for s in stats])),'min':float(min(s[k] for s in stats)),'max':float(max(s[k] for s in stats))} for k in fields}}
  series[stage,bank]=samples
fig,axes=plt.subplots(2,2,figsize=(12,7),layout='constrained')
colors={'original':'#1971c2','intb-off':'#e8590c'}
for j,bank in enumerate('AB'):
 for stage in ['original','intb-off']:
  x=series[stage,bank][0];rms=results[stage][bank]['aggregate']['raw_rms_codes']['mean']
  axes[0,j].plot(np.arange(80)/fs*1e6,x[:80]-x.mean(),label=f'{stage}: {rms:.2f} codes RMS',color=colors[stage],lw=1.1)
  # Average independent periodograms; raw inputs only, DC removed, Hann window.
  ps=[]
  for x in series[stage,bank]:
   w=np.hanning(len(x));p=abs(np.fft.rfft((x-x.mean())*w))**2/(fs*np.sum(w*w));p[1:-1]*=2;ps.append(p)
  f=np.fft.rfftfreq(len(x),1/fs)
  axes[1,j].plot(f[1:]/1e6,10*np.log10(np.maximum(np.mean(ps,axis=0)[1:]/(2048**2/2),1e-30)),label=stage,color=colors[stage],lw=1)
 axes[0,j].set(title=f'ADC {bank} — zero differential input',xlabel='Time [µs]',ylabel='ADC code − buffer mean')
 axes[1,j].set(xlabel='Frequency [MHz]',ylabel='PSD [dBFS/Hz]',title=f'ADC {bank} — mean of 8 spectra',xlim=(0,fs/2e6))
 for ax in axes[:,j]:ax.grid(alpha=.2);ax.legend()
 for freq in [fs/4,fs/2]:axes[1,j].axvline(freq/1e6,color='gray',ls=':',lw=.8)
fig.suptitle('PM12 channel 12: INTB gate disabled, INTA gate retained\nExternal DAC = 1 V / 1 V; CFD integrator disabled; raw ADC data',fontweight='bold')
for ext in ['png','pdf','svg']:fig.savefig(out/('intb-gate-comparison.'+ext),dpi=170)
# Digital gate validation from actual Kasli captures.
gates={}
for stage in ['original','intb-off']:
 d=json.loads((data/(stage+'-gate.json')).read_text());gates[stage]={}
 for ch in d['channels']:
  bits=[(w>>i)&1 for w in ch['words'] for i in range(8)]
  rising=sum(not a and b for a,b in zip(bits,bits[1:]));falling=sum(a and not b for a,b in zip(bits,bits[1:]))
  gates[stage][str(ch['logical'])]={'samples':len(bits),'high_samples':sum(bits),'rising_edges':rising,'falling_edges':falling,'raw_sha256':hashlib.sha256((data/(stage+'-gate.json')).read_bytes()).hexdigest()}
 assert gates[stage]['8']['rising_edges']>=680
 if stage=='original':assert gates[stage]['9']['rising_edges']>=680
 else:assert gates[stage]['9']['high_samples']==0
status=json.loads((data/'status.json').read_text())
summary={'hardware_pass':status['pass_'],'fs_hz_inferred_not_counter_verified':fs,'statistics':results,'gate_validation':gates,'scope':'Whole-chain zero-input observation; no intrinsic ADC noise or analog isolation claim. Sequential A/B injection selection. Raw per-capture RMS and coherent tone RMS averaged across 8 captures.'}
(out/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
for stage in results:
 for bank in results[stage]: print(stage,bank,{k:round(v['mean'],4) for k,v in results[stage][bank]['aggregate'].items()})
