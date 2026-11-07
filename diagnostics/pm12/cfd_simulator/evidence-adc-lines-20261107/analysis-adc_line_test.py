"""Adjacent ADC data-line exercise from an analog DC sweep, no test-pattern mode.

PASS excludes simple persistent stuck bits/equal adjacent pairs under sampled
conditions; it is not an electrical continuity, timing-margin or bit-order proof.
"""
import argparse
import math
import json
from pathlib import Path
import subprocess
import sys

BITS=12

def analyze(points,min_samples=64,min_per_setting=8,min_settings=3,min_fraction=.02):
    if min(min_samples,min_per_setting,min_settings)<1 or not 0<min_fraction<=.25:raise ValueError('Invalid evidence thresholds')
    hist=[0]*(1<<BITS);bit_counts=[[0,0] for _ in range(BITS)]
    pair_counts=[[0]*4 for _ in range(BITS-1)]
    bit_levels=[[set(),set()] for _ in range(BITS)]
    pair_levels=[[set() for _ in range(4)] for _ in range(BITS-1)]
    means=[];settings=set();interior=0
    for point in points:
        level=float(point['diff_setpoint_v'])
        if not math.isfinite(level):raise ValueError('Nonfinite stimulus setting')
        settings.add(level)
        local_bits=[[0,0] for _ in range(BITS)];local_pairs=[[0]*4 for _ in range(BITS-1)]
        total=weighted=0
        for code,count in point['histogram'].items():
            code=int(code)
            if type(count) is not int or count<1 or not 0<=code<len(hist):raise ValueError('Invalid ADC histogram')
            hist[code]+=count;total+=count;weighted+=code*count
            if code in (0,4095):continue # rails do not prove interior bit exercise
            interior+=count
            for bit in range(BITS):
                value=(code>>bit)&1;bit_counts[bit][value]+=count;local_bits[bit][value]+=count
            for bit in range(BITS-1):
                # labels show upper/lower bit: D(k+1),Dk =00,01,10,11
                value=(code>>bit)&3;pair_counts[bit][value]+=count;local_pairs[bit][value]+=count
        if not total:raise ValueError('Empty capture histogram')
        means.append(weighted/total)
        for bit in range(BITS):
            for state in range(2):
                if local_bits[bit][state]>=min_per_setting:bit_levels[bit][state].add(level)
        for bit in range(BITS-1):
            for state in range(4):
                if local_pairs[bit][state]>=min_per_setting:pair_levels[bit][state].add(level)
    span=max(means)-min(means) if means else 0
    commanded_span=max(settings)-min(settings) if settings else 0
    adequate=len(settings)>=16 and span>=3000 and interior>=4096
    activity=len(settings)>=16 and span>=512 and interior>=4096 and (commanded_span>=2.2 or span>=3000)
    def supported(counts,levels):return [c>=max(min_samples,math.ceil(min_fraction*interior)) and len(s)>=min_settings for c,s in zip(counts,levels)]
    bits=[];pairs=[]
    for bit in range(BITS):
        counts=bit_counts[bit];levels=bit_levels[bit];ok=supported(counts,levels)
        state='PASS' if all(ok) and adequate else 'INCONCLUSIVE'
        if activity and 0 in counts:state='SUSPECT_STUCK_BIT'
        bits.append(dict(bit=bit,counts=counts,settings=[len(x) for x in levels],status=state))
    for bit in range(BITS-1):
        counts=pair_counts[bit];levels=pair_levels[bit];ok=supported(counts,levels)
        state='PASS' if all(ok) and adequate else 'INCONCLUSIVE'
        if any(b['status']=='SUSPECT_STUCK_BIT' for b in bits[bit:bit+2]):state='SUSPECT_STUCK_BIT'
        elif activity and counts[1]+counts[2]==0 and ok[0] and ok[3]:state='SUSPECT_EQUAL_NEIGHBORS'
        elif activity and counts[0]+counts[3]==0 and ok[1] and ok[2]:state='SUSPECT_INVERSE_NEIGHBORS'
        elif activity and (counts[1]+counts[2])<min_fraction*interior and ok[0] and ok[3]:state='SUSPECT_NEAR_EQUAL_NEIGHBORS'
        pairs.append(dict(bits=[bit,bit+1],counts=counts,settings=[len(x) for x in levels],supported=ok,status=state))
    return dict(pass_=adequate and all(x['status']=='PASS' for x in bits+pairs),
                scope='Functional exercise of stable0/1 and all four adjacent-pair states; not electrical short exclusion, bit-order proof or ADC DNL',
                stimulus_adequate=adequate,diagnostic_activity=activity,commanded_span_v=commanded_span,distinct_settings=len(settings),interior_samples=interior,
                mean_span_codes=[min(means),max(means)] if means else [],
                thresholds=dict(min_samples=min_samples,min_per_setting=min_per_setting,min_settings=min_settings,min_fraction=min_fraction),
                rails_excluded_from_bit_decisions=[0,4095],state_order=['00','01','10','11'],
                bits=bits,adjacent_pairs=pairs,histogram=hist,visited_codes=sum(x>0 for x in hist),
                missing_codes=[i for i,x in enumerate(hist) if not x])


def analyze_report(report):
    banks={}
    for bank in [0,1]:
        points=[r for r in report['measurements'] if r['bank']==bank and r['injection_bank']==bank]
        banks['AB'[bank]]=analyze(points)
    return dict(pass_=report.get('pass',False) and all(r['pass_'] for r in banks.values()),
                acquisition_pass=report.get('pass',False),channel=report['channel'],banks=banks,
                missing_code_warning='Stepped DC is not a uniform continuous ramp. Unvisited codes alone are not ADC missing-code faults.')


def main():
    p=argparse.ArgumentParser(description=__doc__)
    modes=p.add_mutually_exclusive_group(required=True)
    modes.add_argument('--acquire',action='store_true',help='Run existing guarded external DAC scan first')
    modes.add_argument('--report',type=Path,help='Analyze an existing status.json; no hardware access')
    p.add_argument('--out',type=Path,required=True);p.add_argument('--afe',type=int,choices=range(1,13),default=12)
    p.add_argument('--points',type=int,default=257)
    a=p.parse_args()
    if not 17<=a.points<=4097:p.error('points must be17..4097')
    a.out.mkdir(parents=True,exist_ok=False)
    source=a.report
    if a.acquire:
        grid=[round(-1.2+2.4*i/(a.points-1),7) for i in range(a.points)]
        command=[sys.executable,str(Path(__file__).with_name('adc_dc_scan.py')),'--afe',str(a.afe),
                 '--out',str(a.out/'scan'),'--differences',*[str(x) for x in grid]]
        subprocess.run(command,check=True)
        source=a.out/'scan/status.json'
        from validate_adc_lines import validate
        raw_validation=validate(source.parent)
        (a.out/'raw-validation.json').write_text(json.dumps(raw_validation,indent=2)+'\n')
    report=json.loads(source.read_text());result=analyze_report(report)
    result['source_report']=str(source.resolve())
    (a.out/'line-test.json').write_text(json.dumps(result,indent=2)+'\n')
    for bank,r in result['banks'].items():
        print(bank,'PASS' if r['pass_'] else 'NOT PASS','visited codes',r['visited_codes'])
        for pair in r['adjacent_pairs']:print(pair['bits'],pair['status'],pair['counts'],pair['settings'])
    if not result['pass_']:raise SystemExit('Data-line test did not pass; inspect line-test.json')

if __name__=='__main__':main()
