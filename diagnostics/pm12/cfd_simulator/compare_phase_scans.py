#!/usr/bin/env python3
"""Compare repeat phase curves after subtracting each scan's code0 phase.

No hardware access; no acceptance threshold inferred from the sampled bin size.
"""
import argparse
import json
import math
import statistics
from pathlib import Path
from plot_phase_scan import summarize


def compare(first, second, allow_phase_return_failure=False):
    a=summarize(first);b=summarize(second)
    if not a['scan_pass'] or not b['scan_pass']:
        if not allow_phase_return_failure:raise ValueError('phase-return check failed; explicit data-only comparison required')
        for directory in (first,second):
            validation=json.loads((directory/'validation.json').read_text())
            if not validation.get('raw_data_pass'):raise ValueError('raw data not independently verified')
    ra=json.loads((first/'report.json').read_text());rb=json.loads((second/'report.json').read_text())
    for field in ('afe','words','repeats','settle','lanes','board_serial'):
        if ra['args'][field]!=rb['args'][field]:raise ValueError('scan setting mismatch: '+field)
    if ra['args'].get('clock_mhz',80)!=rb['args'].get('clock_mhz',80):raise ValueError('gate frequency differs')
    if ra['codes']!=rb['codes']:raise ValueError('DAC code grid differs')
    if set(a['lanes'])!=set(b['lanes']):raise ValueError('lane set differs')
    result=dict(scope='Relative curves only; absolute epoch phase offsets removed, no calibrated accuracy inference',phase_return_pass=[a['scan_pass'],b['scan_pass']],lanes={})
    for lane,x in a['lanes'].items():
        y=b['lanes'][lane]
        if x['codes']!=ra['codes'] or y['codes']!=rb['codes']:
            raise ValueError('retained CSV is incomplete')
        ba=ra['result']['baseline'][str(lane)];bb=rb['result']['baseline'][str(lane)]
        if (ba['sample_ps'],ba['period_bins'])!=(bb['sample_ps'],bb['period_bins']):
            raise ValueError('sample clock/edge period differs')
        if (x['slot'],x['channel'],x['codes'])!=(y['slot'],y['channel'],y['codes']):
            raise ValueError('physical mapping or retained code set differs')
        delta=[q-p for p,q in zip(x['relative_ns'],y['relative_ns'])]
        offset=statistics.median(delta[1:])
        result['lanes'][lane]=dict(median_delta_excluding_zero_ns=offset,max_abs_centered_delta_excluding_zero_ns=max(abs(d-offset) for d in delta[1:]),slot=x['slot'],channel=x['channel'],points=len(delta),
            codes=x['codes'],delta_ns=delta,max_abs_delta_ns=max(map(abs,delta)),
            rms_delta_ns=math.sqrt(sum(v*v for v in delta)/len(delta)),
            endpoint_delta_ns=delta[-1],slope_difference_ns_per_code=y['linear_slope_ns_per_code']-x['linear_slope_ns_per_code'])
    return result


def plot(first,second,result,stem):
    import matplotlib
    matplotlib.use('Agg')
    import matplotlib.pyplot as plt
    a=summarize(first);b=summarize(second)
    fig,axes=plt.subplots(2,1,figsize=(9,7),layout='constrained',sharex=True)
    for lane,data in a['lanes'].items():
        other=b['lanes'][lane]
        line,=axes[0].plot(data['codes'],data['relative_ns'],'o-',ms=4,label=f"first input {data['channel']}")
        axes[0].plot(other['codes'],other['relative_ns'],'x--',color=line.get_color(),ms=5,label=f"second input {other['channel']}")
        d=result['lanes'][lane];offset=d['median_delta_excluding_zero_ns']
        axes[1].plot(d['codes'][1:],[v-offset for v in d['delta_ns'][1:]],'.-',color=line.get_color(),label=f"input {data['channel']}, offset {offset:.3f} ns")
    axes[0].set(ylabel='Phase relative to each scan code 0 (ns)',title='DAC phase scans: first vs second')
    axes[1].set(xlabel='Raw DAC-A code',ylabel='Second minus first after constant offset (ns)')
    axes[1].axhline(0,color='black',lw=.6)
    for ax in axes:ax.grid(alpha=.3);ax.legend(fontsize=8)
    fig.savefig(stem.with_suffix('.png'),dpi=180);fig.savefig(stem.with_suffix('.svg'))


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('first',type=Path);parser.add_argument('second',type=Path)
    parser.add_argument('--out',type=Path,required=True)
    parser.add_argument('--allow-phase-return-failure',action='store_true')
    parser.add_argument('--plot',action='store_true',help='Optional matplotlib PNG/SVG beside comparison JSON')
    args=parser.parse_args();result=compare(args.first,args.second,args.allow_phase_return_failure)
    args.out.write_text(json.dumps(result,indent=2)+'\n')
    if args.plot:plot(args.first,args.second,result,args.out)
    for lane,data in result['lanes'].items():print(lane,{k:v for k,v in data.items() if k not in ('codes','delta_ns')})

if __name__=='__main__':main()
