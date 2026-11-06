#!/usr/bin/env python3
"""Compare repeat phase curves after subtracting each scan's code0 phase.

No hardware access; no acceptance threshold inferred from the sampled bin size.
"""
import argparse
import json
import math
from pathlib import Path
from plot_phase_scan import summarize


def compare(first, second):
    a=summarize(first);b=summarize(second)
    if not a['scan_pass'] or not b['scan_pass']:
        raise ValueError('both scans must have completed and restored successfully')
    ra=json.loads((first/'report.json').read_text());rb=json.loads((second/'report.json').read_text())
    for field in ('afe','words','repeats','settle','lanes','board_serial'):
        if ra['args'][field]!=rb['args'][field]:raise ValueError('scan setting mismatch: '+field)
    if ra['codes']!=rb['codes']:raise ValueError('DAC code grid differs')
    if set(a['lanes'])!=set(b['lanes']):raise ValueError('lane set differs')
    result=dict(scope='Relative curves only; absolute epoch phase offsets removed, no calibrated accuracy inference',lanes={})
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
        result['lanes'][lane]=dict(slot=x['slot'],channel=x['channel'],points=len(delta),
            codes=x['codes'],delta_ns=delta,max_abs_delta_ns=max(map(abs,delta)),
            rms_delta_ns=math.sqrt(sum(v*v for v in delta)/len(delta)),
            endpoint_delta_ns=delta[-1],slope_difference_ns_per_code=y['linear_slope_ns_per_code']-x['linear_slope_ns_per_code'])
    return result


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('first',type=Path);parser.add_argument('second',type=Path)
    parser.add_argument('--out',type=Path,required=True)
    args=parser.parse_args();result=compare(args.first,args.second)
    args.out.write_text(json.dumps(result,indent=2)+'\n')
    for lane,data in result['lanes'].items():print(lane,{k:v for k,v in data.items() if k not in ('codes','delta_ns')})

if __name__=='__main__':main()
