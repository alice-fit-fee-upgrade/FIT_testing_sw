"""Adjacent data-bit state coverage and uncalibrated stepped-ramp histograms."""
import argparse,json
from pathlib import Path
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('report',type=Path);p.add_argument('--out',type=Path,required=True);a=p.parse_args()
    r=json.loads(a.report.read_text());fig,axes=plt.subplots(2,2,figsize=(12,8),layout='constrained')
    for col,(bank,data) in enumerate(r['banks'].items()):
        counts=np.array([p['counts'] for p in data['adjacent_pairs']],dtype=float)
        fractions=counts/counts.sum(axis=1,keepdims=True)*100
        ax=axes[0,col];im=ax.imshow(fractions,vmin=0,vmax=50,cmap='Blues',aspect='auto')
        ax.set(title=f'ADC {bank}: adjacent pair states',xlabel='D(k+1), Dk')
        ax.set_xticks(range(4),['00','01','10','11']);ax.set_yticks(range(11),[f'D{k} / D{k+1}' for k in range(11)])
        for y in range(11):
            for x in range(4):ax.text(x,y,f'{fractions[y,x]:.1f}%',ha='center',va='center',fontsize=8)
        fig.colorbar(im,ax=ax,label='Share of non-rail samples [%]')
        ax=axes[1,col];ax.plot(range(4096),data['histogram'],lw=.6,color=['#1864ab','#d9480f'][col])
        ax.set(title=f"ADC {bank}: {data['visited_codes']}/4096 codes observed",xlabel='ADC output code',ylabel='Samples / code')
        ax.set_yscale('symlog',linthresh=1)
        ax.grid(alpha=.2)
    fig.suptitle(f"PM12 channel {r['channel']} — analog-ramp data-line exercise",fontweight='bold')
    fig.get_layout_engine().set(rect=(0,.08,1,.88))
    fig.text(.08,.02,'Only interior codes enter bit-state decisions; stable rail codes are excluded.\nStepped DC stimulus: unvisited codes are not, by themselves, ADC missing-code/DNL failures.',fontsize=9)
    for ext in ['png','pdf']:fig.savefig(a.out.with_suffix('.'+ext),dpi=180)

if __name__=='__main__':main()
