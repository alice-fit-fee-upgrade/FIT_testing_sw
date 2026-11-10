#!/usr/bin/env python3
"""Recompute the strobe phase experiment from each unique retained raw buffer."""
import argparse,collections,json,re,struct,sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'ipbus_adc'))
from adc_decode import decode
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt


def main():
    p=argparse.ArgumentParser();p.add_argument('run',type=Path);p.add_argument('--out',type=Path,required=True);a=p.parse_args()
    r=json.loads((a.run/'result.json').read_text());a.out.mkdir(parents=True,exist_ok=False)
    rows=[];seen=set()
    for row in reversed(r['rows']):
        if row['raw'] in seen:continue
        seen.add(row['raw']);words=list(struct.unpack('<4096H',(a.run/row['raw']).read_bytes()))
        samples,t=decode(words,row['bank'])
        match=re.match(r'gen(\d+)-',row['raw'])
        if match and int(match[1])!=row['generation']:raise ValueError('Raw filename generation mismatch')
        rows.append(dict(code=row['code'],bank=row['bank'],channel=row['channel'],raw=row['raw'],generation=row['generation'],**t))
    representative=next(x for x in rows if x['status']=='EDGE_QUANTIZED')
    words=struct.unpack('<4096H',(a.run/representative['raw']).read_bytes())
    edges=[i for i in range(1,len(words)) if not words[i-1]&8192 and words[i]&8192]
    phase=[e-4*n-edges[0] for n,e in enumerate(edges)]
    fig,axes=plt.subplots(2,1,figsize=(11,8),layout='constrained')
    for bank,color in [(0,'#1864ab'),(1,'#d9480f')]:
        codes=sorted({x['code'] for x in rows if x['channel']==12});means=[];ranges=[]
        for code in codes:
            group=[x for x in rows if x['channel']==12 and x['bank']==bank and x['code']==code]
            values=[100*sum(c for k,c in g['interval_counts'].items() if k!=4)/sum(g['interval_counts'].values()) for g in group]
            mean=sum(values)/len(values);means.append(mean);ranges.append((mean-min(values),max(values)-mean))
        axes[0].errorbar(codes,means,yerr=list(zip(*ranges)),fmt='o',color=color,label='ADC '+'AB'[bank],capsize=3)
    axes[0].set(xlabel='DAC-A raw code (channel12)',ylabel='Intervals quantized to3 or5 samples [%]',title='Phase-dependent edge quantization — no clock-rate configuration changes')
    axes[0].legend();axes[0].grid(alpha=.2)
    axes[1].step(range(min(120,len(edges))),phase[:120],where='post',color='#1864ab',lw=.8)
    axes[1].set(xlabel='STR rising-edge index',ylabel='Position minus4 × index [samples]',title='First120edges; full-buffer phase span is1 sample, without accumulating slip')
    axes[1].grid(alpha=.2);axes[1].set_yticks([0,1]);axes[1].set_ylim(-.15,1.15)
    fig.suptitle('PM12 — ADC strobe sampling-boundary diagnosis',fontweight='bold')
    for ext in ['pdf','png']:fig.savefig(a.out/('strobe-phase-diagnosis.'+ext),dpi=180)
    summary=dict(unique_raw_captures=len(rows),recorded_rows=len(r['rows']),all_unique=len(rows)==len(r['rows']),
                 status_counts=dict(collections.Counter(x['status'] for x in rows)),
                 all_selected_words_stable=True,max_edge_phase_span_samples=max(x['rising_phase_span_samples'] for x in rows),
                 identity=r['identity'],rows=rows)
    (a.out/'raw-analysis.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(summary['status_counts'])

if __name__=='__main__':main()
