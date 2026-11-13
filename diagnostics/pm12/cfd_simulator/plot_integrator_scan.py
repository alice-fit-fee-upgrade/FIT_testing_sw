"""Offline signed-ramp analysis and figures; no instrument connections."""
import argparse,csv,hashlib,json,struct,sys,statistics
from pathlib import Path
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from integrator_analysis import integration_pair
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'ipbus_adc'))
from adc_decode import decode


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--root',type=Path,required=True);p.add_argument('--out',type=Path,required=True);p.add_argument('--runs',nargs='+',default=['sweep01','fine01']);a=p.parse_args();a.out.mkdir(exist_ok=True,parents=True)
    retained=[];rejected=[];waveforms={};inputs={}
    for name in a.runs:
        directory=a.root/name;r=json.loads((directory/'status.json').read_text());assert r['pass_']
        assert r['reference_nominal_V']==[2.048,1.024], 'Different input coordinate system'
        for point in r['points']:
            for capture in point['captures']:
                path=directory/capture['file'];data=path.read_bytes();inputs[str(path)]=hashlib.sha256(data).hexdigest();samples,_=decode(list(struct.unpack('<4096H',data)),capture['bank'])
                base=dict(run=name,point=point['index'],bank=capture['bank'],offset_V=point['actual_requested_offset_V'],CH0_V=point['setpoints_V'][0],CH1_V=point['setpoints_V'][1],file=str(path))
                try:
                    row={**base,**integration_pair(samples)};retained.append(row);waveforms[(name,point['index'],capture['bank'])]=(samples,row)
                except ValueError as e:rejected.append({**base,'reason':str(e)})
    grouped=[]
    for name in a.runs:
        for bank in [0,1]:
            keys=sorted({r['point'] for r in retained if r['run']==name and r['bank']==bank})
            for key in keys:
                rr=[r for r in retained if r['run']==name and r['bank']==bank and r['point']==key]
                grouped.append(dict(run=name,point=key,bank=bank,offset_V=rr[0]['offset_V'],CH0_V=rr[0]['CH0_V'],CH1_V=rr[0]['CH1_V'],mean_change=statistics.mean(r['mean_change'] for r in rr),buffer_std=statistics.stdev(r['mean_change'] for r in rr) if len(rr)>1 else 0,buffers=len(rr),cycles=sum(r['cycles'] for r in rr)))
    fits={};dt=1e9/80157400
    for bank in [0,1]:
        rows=[r for r in grouped if r['run']=='fine01' and r['bank']==bank];x=np.array([r['offset_V'] for r in rows]);y=np.array([r['mean_change'] for r in rows]);(k,b),cov=np.polyfit(x,y,1,cov=True);zero=-b/k;gradient=np.array([b/k**2,-1/k]);se=float(np.sqrt(gradient@cov@gradient))
        fits['AB'[bank]]=dict(balance_offset_V=float(zero),CH0_at_balance_V=float(2.048+zero/2),CH1_at_balance_V=float(1.024-zero/2),physical_CH0_minus_CH1_at_balance_V=float(1.024+zero),gain_codes_per_commanded_V=float(k),gain_codes_per_ns_per_commanded_V=float(k/dt),fit_residual_rms_codes=float(np.std(y-(k*x+b))),fit_only_balance_se_V=se,ADC_interval_assumed_ns=dt,points=len(rows))
    for bank in [0,1]:
        rows=sorted([r for r in grouped if r['run']=='fine01' and r['bank']==bank],key=lambda r:r['offset_V'])
        crossings=[]
        for left,right in zip(rows,rows[1:]):
            if left['mean_change']<=0<=right['mean_change']:
                root=left['offset_V']-left['mean_change']*(right['offset_V']-left['offset_V'])/(right['mean_change']-left['mean_change'])
                crossings.append(root)
        if len(crossings)!=1:raise ValueError('Missing or ambiguous local zero crossing')
        fit=fits['AB'[bank]];fit['local_bracket_balance_offset_V']=crossings[0];fit['local_CH0_V']=2.048+crossings[0]/2;fit['local_CH1_V']=1.024-crossings[0]/2
    fig,axs=plt.subplots(1,2,figsize=(12,5),layout='constrained')
    for bank,color in [(0,'#1864ab'),(1,'#d9480f')]:
        label='ADC '+'AB'[bank];fit=fits['AB'[bank]]
        for ax,name in zip(axs,['sweep01','fine01']):
            rr=sorted([r for r in grouped if r['run']==name and r['bank']==bank],key=lambda r:r['offset_V']);x=np.array([r['offset_V'] for r in rr]);y=[r['mean_change'] for r in rr];ax.errorbar(x*1000,y,yerr=[r['buffer_std'] for r in rr],fmt='o',ms=3,color=color,label=label)
            if name=='fine01':ax.plot(x*1000,fit['gain_codes_per_commanded_V']*(x-fit['balance_offset_V']),color=color,lw=1);ax.axvline(fit['balance_offset_V']*1000,color=color,ls=':',lw=1)
    for ax,title in zip(axs,['Coarse scan: usable, unclipped buffers','Fine scan: signed ramp zero crossings']):ax.axhline(0,color='black',lw=.7);ax.set(title=title,xlabel='Commanded offset δ (mV)',ylabel='Integration pair: late − early (ADC codes)');ax.grid(alpha=.3);ax.legend()
    fig.suptitle('PM12 channel 12 — integrator balance, normal 20 MHz gating\nCH0 = 2.048 V + δ/2; CH1 = 1.024 V − δ/2')
    for ext in ['png','pdf','svg']:fig.savefig(a.out/f'integrator-balance.{ext}',dpi=180)
    fig,axs=plt.subplots(2,1,figsize=(11,7),layout='constrained')
    for bank,ax in enumerate(axs):
        for requested,color in [(-.02,'#862e9c'),(fits['AB'[bank]]['balance_offset_V'],'#2b8a3e'),(.02,'#e67700')]:
            near_zero=abs(requested-fits['AB'[bank]]['balance_offset_V'])<1e-9
            name=('validation02' if 'validation02' in a.runs else 'fine01') if near_zero else 'sweep01'
            choices=[r for r in grouped if r['run']==name and r['bank']==bank]
            row=min(choices,key=(lambda r:abs(r['mean_change'])) if near_zero and name=='validation02' else (lambda r:abs(r['offset_V']-requested)))
            samples,detail=waveforms[(name,row['point'],bank)];phase=detail['phase'];x=np.array(samples[phase:phase+24]);ax.plot(np.arange(len(x))*dt,x,'o-',ms=3,color=color,label=f"δ={row['offset_V']*1000:.2f} mV")
        ax.set(title='ADC '+'AB'[bank],xlabel='Relative time (ns), aligned to observed integration pair',ylabel='ADC code');ax.grid(alpha=.3);ax.legend()
    fig.suptitle('PM12 integrator waveforms — raw strobe-decimated ADC samples\nSeparate captures; alignment from four-phase waveform, not a shared trigger')
    for ext in ['png','pdf','svg']:fig.savefig(a.out/f'integrator-waveforms.{ext}',dpi=180)
    result=dict(fits=fits,retained_buffers=len(retained),rejected_buffers=rejected,points=grouped,phase_assignment='Highest adjacent pair in a separated four-phase template; waveform-based integration/reset assignment, not externally timestamped gate alignment',limits=['SCPI setpoints, not independently measured DAC voltages','Only channel12 and present USB fixture','Slope between two ADC samples, not resolved ramp curvature','Nominal timing inferred from40.0787MHz LHC reference','Fits are differential whole-chain balance, not independent opamp input bias measurements'],source_sha256=inputs)
    (a.out/'analysis.json').write_text(json.dumps(result,indent=2)+'\n')
    with (a.out/'ramp-points.csv').open('w',newline='') as f:
        w=csv.DictWriter(f,fieldnames=grouped[0].keys());w.writeheader();w.writerows(grouped)
    print(json.dumps(fits,indent=2));print('retained',len(retained),'rejected',len(rejected))
if __name__=='__main__':main()
