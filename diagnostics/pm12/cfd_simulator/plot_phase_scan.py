#!/usr/bin/env python3
"""Plot and summarize retained UART/IPbus phase-scan CSV without hardware access."""
import argparse
import csv
import json
from pathlib import Path
import statistics
from phase_estimator import wrapped_delta


def summarize(directory):
    report=json.loads((directory/'report.json').read_text())
    with (directory/'phase.csv').open() as stream:
        rows=[row for row in csv.DictReader(stream) if row['stage']=='sweep']
    with (directory/'phase.csv').open() as stream:
        restored={int(row['logical']):row for row in csv.DictReader(stream) if row['stage']=='restored'}
    lanes=sorted({int(row['logical']) for row in rows})
    result=dict(scan_pass=report.get('pass_',False),lanes={},
                scope='Sampled phase centroid; unwrapped delay assumes small adjacent steps, no absolute phase calibration')
    for lane in lanes:
        data=sorted((row for row in rows if int(row['logical'])==lane),key=lambda r:int(r['code']))
        codes=[int(row['code']) for row in data];phase=[float(row['relative_ns']) for row in data]
        if len(codes)<2:continue
        slope,intercept=statistics.linear_regression(codes,phase)
        restore_relative=None
        if lane in restored:
            period=report['result']['baseline'][str(lane)]['period_ns']
            restore_relative=wrapped_delta(float(restored[lane]['mean_ns']),float(data[0]['mean_ns']),period)
        residual=[y-(intercept+slope*x) for x,y in zip(codes,phase)]
        result['lanes'][lane]=dict(slot=int(data[0]['slot']),channel=int(data[0]['channel']),points=len(data),
                                  first_code=codes[0],last_code=codes[-1],codes=codes,relative_ns=phase,
                                  return_to_zero_relative_ns=restore_relative,
                                  endpoint_delay_ns=phase[-1]-phase[0],span_ns=max(phase)-min(phase),
                                  linear_slope_ns_per_code=slope,max_abs_linear_residual_ns=max(map(abs,residual)),
                                  min_edges=min(int(row['rising_edges']) for row in data),
                                  max_spread_bins=max(float(row['spread_bins']) for row in data))
    return result


def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('directory',type=Path)
    parser.add_argument('--plot',action='store_true',help='requires matplotlib; emits standalone PNG/SVG')
    args=parser.parse_args();result=summarize(args.directory)
    (args.directory/'analysis.json').write_text(json.dumps(result,indent=2)+'\n')
    if args.plot:
        import matplotlib
        matplotlib.use('Agg')
        import matplotlib.pyplot as plt
        fig,ax=plt.subplots(figsize=(9,5),layout='constrained')
        for lane,data in result['lanes'].items():
            line,=ax.plot(data['codes'],data['relative_ns'],'.-',ms=3,lw=1,
                    label=f"slot {data['slot']}, input {data['channel']} (RX {lane})")
            if data['return_to_zero_relative_ns'] is not None:
                ax.scatter([0],[data['return_to_zero_relative_ns']],marker='x',s=70,
                           color=line.get_color(),label=f"input {data['channel']}: return to 0")
        ax.set(xlabel='Raw DAC-A code',ylabel='Phase relative to code 0 (ns)',
               title='PM12 ADC clock delay — sampled phase centroid')
        ax.grid(alpha=.3);ax.legend()
        fig.savefig(args.directory/'phase-curve.png',dpi=180)
        fig.savefig(args.directory/'phase-curve.svg')
    print(json.dumps({k:v for k,v in result.items() if k!='lanes'}))
    for lane,data in result['lanes'].items():
        print(lane,{k:v for k,v in data.items() if k not in ('codes','relative_ns')})

if __name__=='__main__':main()
