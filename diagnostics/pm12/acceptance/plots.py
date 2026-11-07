"""Rebuild report figures from raw buffers/CSV, without hardware access."""
import csv
import json
from pathlib import Path
import tarfile
import sys
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch
HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE.parent/'cfd_simulator'))
sys.path.insert(0,str(HERE.parent/'ipbus_adc'))
from adc_decode import decode
COLORS=plt.get_cmap('tab20')(np.linspace(0,1,12))


def read(path):return json.loads(Path(path).read_text())

def save(fig,path):
    for suffix in ('.pdf','.png'):fig.savefig(path.with_suffix(suffix),dpi=160)
    plt.close(fig)


def extract(archive,out):
    out.mkdir(parents=True,exist_ok=True)
    with tarfile.open(archive) as tar:
        for member in tar.getmembers():
            # Only regular captures under a contained relative path; no links/devices.
            if not member.isfile():continue
            target=(out/member.name).resolve()
            if not target.is_relative_to(out.resolve()):raise ValueError('Unsafe archive path')
            target.parent.mkdir(parents=True,exist_ok=True)
            with tar.extractfile(member) as src,target.open('wb') as dst:dst.write(src.read())


def waveform(path):
    raw=np.frombuffer(path.read_bytes(),dtype='<u2')
    if len(raw)!=4096:raise ValueError('Truncated raw capture')
    samples,_=decode([int(w) for w in raw])
    return np.array(samples,dtype=float)


def wiring(out):
    fig,ax=plt.subplots(figsize=(11,6),layout='constrained');ax.set(xlim=(0,11),ylim=(0,7));ax.axis('off')
    boxes={'PM12':(1,3),'Kasli-DIOT':(7,3),'LHC clock':(4,6),'MOD-DAC-28':(1,.8),'Host':(7,.8),'CFD_SIM':(1,4.8)}
    patches={}
    for name,(x,y) in boxes.items():
        patch=FancyBboxPatch((x-.9,y-.35),1.8,.7,boxstyle='round,pad=.1',facecolor='#eaf0f7',edgecolor='#173b62')
        ax.add_patch(patch);patches[name]=patch
        ax.text(x,y,name,ha='center',va='center',fontsize=11)
    def arrow(a,b,label,xy):
        ax.annotate('',xy=boxes[b],xytext=boxes[a],arrowprops=dict(arrowstyle='<->',color='#315b7a',patchA=patches[a],patchB=patches[b],shrinkA=4,shrinkB=4))
        ax.text(*xy,label,ha='center',fontsize=9,bbox=dict(facecolor='white',edgecolor='none',alpha=.9))
    arrow('LHC clock','PM12','40.0787 MHz',(2.2,5.5));arrow('LHC clock','Kasli-DIOT','120.2361 MHz (x3)',(7.1,5.5))
    arrow('PM12','Kasli-DIOT','SFP private link via SFP1\nHDMI adapter to DIO slot6\nCFD LVDS stimulus / gates via slot7',(4.2,3.2))
    arrow('CFD_SIM','PM12','Channel under test',(1.4,3.9));arrow('MOD-DAC-28','PM12','CH0/1 analog USB pair\nvia CFD_SIM mux',(2.6,1.8))
    arrow('Host','Kasli-DIOT','IPbus / SFP0 control\nSFP2 bridges PM to LAN',(8.6,1.9));arrow('Host','MOD-DAC-28','SCPI Ethernet',(4,.7))
    ax.text(5.5,6.75,'Logical bench wiring — confirm physical mapping before each batch',ha='center',fontweight='bold')
    ax.text(5.5,.05,'MCU UART + PM/MCU JTAG/programmers are separate host connections. SFP3 is not used.\nDMM7510 reads shared MCX/J9 monitor; only one monitor mux may be enabled.',ha='center',fontsize=9)
    save(fig,out/'bench')


def build(datasets,out):
    out.mkdir(parents=True,exist_ok=False)
    wiring(out)
    summary={'channels':{},'phase':{},'figures':[]}
    for item in datasets:
        channel=int(item['channel']);entry=summary['channels'].setdefault(str(channel),{})
        if 'adc_scan' in item:
            scan=read(item['adc_scan'])
            from adc_line_test import analyze_report
            analysis=analyze_report(scan);entry['adc']=analysis
            (out/f'adc-analysis-ch{channel:02d}.json').write_text(json.dumps(analysis,indent=2)+'\n')
            if 'raw_archive' in item:
                raw=out/f'raw-ch{channel:02d}';extract(item['raw_archive'],raw)
                # Archives may include a prefix; locate the scan files deterministically.
                found=list(raw.rglob('mux0-point000-bank0.bin'))
                if len(found)!=1:raise ValueError('Ambiguous/missing raw scan archive')
                rawroot=found[0].parent
                (rawroot/'status.json').write_text(json.dumps(scan)+'\n')
            else:rawroot=Path(item['adc_scan']).parent
            from validate_adc_lines import validate
            entry['raw_validation']=validate(rawroot)
            (out/f'raw-validation-ch{channel:02d}.json').write_text(json.dumps(entry['raw_validation'],indent=2)+'\n')
            bankdata={}
            for bank in (0,1):
                rows=[r for r in scan['measurements'] if r['bank']==bank and r['injection_bank']==bank]
                i=min(range(len(rows)),key=lambda n:abs(rows[n]['diff_setpoint_v']))
                path=rawroot/f'mux{bank}-point{i:03d}-bank{bank}.bin'
                bankdata[str(bank)]=dict(points=rows,samples=waveform(path).tolist())
            entry['banks']=bankdata
        if 'phase_csv' in item:
            with open(item['phase_csv']) as f:rows=list(csv.DictReader(f))
            lanes={}
            for lane in sorted({r['logical'] for r in rows}):
                r=[v for v in rows if v['stage']=='sweep' and v['logical']==lane]
                lanes[lane]=dict(code=[int(v['code']) for v in r],ns=[float(v['relative_ns']) for v in r])
            summary['phase'][str(channel)]=lanes
    channels=summary['channels']
    if channels:
        for kind in ('transfer','waveform','fft','histogram'):
            fig,axes=plt.subplots(2,1,figsize=(11,8),layout='constrained')
            for ch,entry in sorted(channels.items(),key=lambda x:int(x[0])):
                if 'banks' not in entry:continue
                color=COLORS[int(ch)-1]
                for bank,ax in enumerate(axes):
                    b=entry['banks'][str(bank)];x=np.array(b['samples']);label=f'Channel {ch}'
                    if kind=='transfer':ax.plot([p['diff_setpoint_v'] for p in b['points']],[p['raw_mean'] for p in b['points']],'.-',lw=.8,ms=2,color=color,label=label)
                    elif kind=='waveform':ax.plot(np.arange(len(x))/80157400*1e6,x,lw=.6,color=color,label=label)
                    elif kind=='histogram':ax.plot(np.arange(4096),entry['adc']['banks']['AB'[bank]]['histogram'],lw=.6,color=color,label=label);ax.set_yscale('symlog',linthresh=1)
                    else:
                        x=x[:len(x)//4*4];x=x-x.mean();w=np.hanning(len(x));psd=abs(np.fft.rfft(x*w))**2/(80157400*sum(w*w));psd[1:-1]*=2
                        ax.plot(np.fft.rfftfreq(len(x),1/80157400)[1:]/1e6,10*np.log10(np.maximum(psd[1:]/(2048**2/2),1e-30)),lw=.7,color=color,label=label)
            labels={'transfer':('Requested differential voltage [V]','Mean ADC code'),'waveform':('Relative sample time [us]','ADC code'),'fft':('Frequency [MHz]','PSD [dBFS/Hz]'),'histogram':('ADC code','Sample count')}
            for bank,ax in enumerate(axes):
                ax.set(title='ADC '+'AB'[bank],xlabel=labels[kind][0],ylabel=labels[kind][1]);ax.grid(alpha=.2)
                if ax.lines:ax.legend(ncol=4,fontsize=8)
            fig.suptitle('PM12 — '+kind+'; measured channels: '+', '.join(channels),fontweight='bold')
            save(fig,out/kind);summary['figures'].append(kind)
    # Channel dispersion uses common stimulus settings only, no hidden interpolation.
    summary['dispersion']={}
    for bank in (0,1):
        curves={ch:{float(p['diff_setpoint_v']):float(p['raw_mean']) for p in e['banks'][str(bank)]['points']}
                for ch,e in channels.items() if 'banks' in e}
        if len(curves)<2:
            summary['dispersion']['AB'[bank]]={'status':'NOT_COMPARABLE','reason':'At least two measured channels required'}
            continue
        common=sorted(set.intersection(*(set(v) for v in curves.values())))
        if not common:raise ValueError('No common ADC stimulus settings; cannot compare channels')
        median={v:float(np.median([c[v] for c in curves.values()])) for v in common}
        summary['dispersion']['AB'[bank]]={'status':'OBSERVED','common_settings':len(common),'channels':{
            ch:{'max_abs_deviation_from_channel_median_codes':max(abs(c[v]-median[v]) for v in common),
                'rms_deviation_from_channel_median_codes':float(np.sqrt(np.mean([(c[v]-median[v])**2 for v in common])))}
            for ch,c in curves.items()}}
    if summary['phase']:
        fig,ax=plt.subplots(figsize=(11,5),layout='constrained')
        for ch,lanes in summary['phase'].items():
            for i,(lane,data) in enumerate(lanes.items()):ax.plot(data['code'],data['ns'],marker='.',ls='-' if i==0 else '--',color=COLORS[int(ch)-1],label=f'Ch {ch}, RX{lane}')
        ax.set(xlabel='Raw DAC-A code',ylabel='Relative sampled phase [nominal ns]',title='Gate phase — all measured channels on one axis');ax.grid(alpha=.2);ax.legend(ncol=3,fontsize=8)
        save(fig,out/'phase');summary['figures'].append('phase')
    # Keep large raw samples out of the human-facing summary; source archive remains.
    (out/'plot-summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    return summary


def failures(loaded,out):
    results=[]
    for root,run in loaded:
        for step in run.get('steps',[]):
            if step['status']=='PASS' or not step['id'].startswith('adc'):continue
            for file in (root/step['instance']/'data').rglob('mux*.bin'):
                raw=np.frombuffer(file.read_bytes(),dtype='<u2')
                if len(raw)!=4096:
                    results.append(dict(source=str(file.relative_to(root)),error='Unexpected raw word count',words=len(raw)))
                    continue
                edges=np.flatnonzero(((raw[:-1]&8192)==0)&((raw[1:]&8192)!=0))+1
                gaps=np.diff(edges);values,counts=np.unique(gaps,return_counts=True)
                name=f'failed-strobe-{len(results):02d}'
                fig,axes=plt.subplots(2,1,figsize=(10,6),layout='constrained')
                axes[0].plot(edges[1:],gaps,'.',ms=3);axes[0].axhline(4,color='grey',ls=':')
                axes[0].set(xlabel='Raw capture index',ylabel='STR rising-edge interval [samples]')
                axes[1].bar(values,counts,color='#b95025');axes[1].set(xlabel='Interval [samples]',ylabel='Occurrences');axes[1].set_xticks(values)
                for v,c in zip(values,counts):axes[1].text(v,c,str(c),ha='center',va='bottom')
                fig.suptitle('Rejected ADC capture — strict STR interval guard',fontweight='bold')
                save(fig,out/name)
                results.append(dict(source=str(file.relative_to(root)),sha256=__import__('hashlib').sha256(file.read_bytes()).hexdigest(),
                                    figure=name,rising_edges=len(edges),interval_counts={str(v):int(c) for v,c in zip(values,counts)},
                                    scope='Observed sampled strobe timing only; cause not established'))
    (out/'failed-capture-analysis.json').write_text(json.dumps(results,indent=2)+'\n')
    return results
