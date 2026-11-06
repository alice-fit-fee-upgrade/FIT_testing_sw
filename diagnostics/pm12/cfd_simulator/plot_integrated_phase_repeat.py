"""Compare matching phase scan grids with explicit firmware labels."""
import argparse
from pathlib import Path
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from plot_phase_scan import summarize


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('previous',type=Path);p.add_argument('current',type=Path);p.add_argument('--out',type=Path,required=True)
    a=p.parse_args();old=summarize(a.previous);new=summarize(a.current)
    fig,axes=plt.subplots(2,1,figsize=(10,7),sharex=True,layout='constrained')
    for lane,color in zip(sorted(new['lanes']),['#1864ab','#d9480f']):
        before=old['lanes'][lane];now=new['lanes'][lane];assert before['codes']==now['codes']
        label=f"RX{lane} (slot {now['slot']}, input {now['channel']})"
        axes[0].plot(before['codes'],before['relative_ns'],'o-',ms=4,color=color,label=label+' — previous')
        axes[0].plot(now['codes'],now['relative_ns'],'x--',ms=5,color=color,label=label+' — integrated')
        axes[1].plot(now['codes'],[y-x for x,y in zip(before['relative_ns'],now['relative_ns'])],'o-',ms=4,color=color,label=label)
    axes[0].set(title='PM12 channel 12 — DAC-A phase scan on integrated gateware',ylabel='Phase relative to code 0 [ns]')
    axes[1].set(xlabel='Raw DAC-A code',ylabel='Integrated − previous [ns]')
    axes[1].axhline(0,color='grey',lw=.8)
    for ax in axes:ax.grid(alpha=.2);ax.legend(fontsize=8)
    fig.get_layout_engine().set(rect=(0,.08,1,.91))
    fig.text(.09,.02,'20 MHz complementary gate outputs; 20 DAC settings; 4095 x8 words per input and point.\nNominal 960 MS/s time scale, sampled centroid; no calibrated absolute phase or delay accuracy.',fontsize=9)
    for ext in ['png','pdf']:fig.savefig(a.out.with_suffix('.'+ext),dpi=180)

if __name__=='__main__':main()
