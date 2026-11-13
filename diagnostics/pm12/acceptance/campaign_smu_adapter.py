#!/usr/bin/env python3
"""Offline four-CFD SMU validation and per-channel campaign receipts."""
import argparse
import csv
import json
import shutil
import statistics
import sys
from pathlib import Path
from campaign import Campaign, read, write, digest
CFD=Path(__file__).resolve().parents[1]/'cfd_simulator'
sys.path.insert(0,str(CFD))
from validate_smu_dacs import validate as validate_native
from smu_voltage import parse_voltage

EXPECTED_SPAN={'B':-2.048*100/5100,'C':-2.048*100/10000,'D':2.048*5100/9800}
LIMITS=dict(span_relative_error=0.05,reverse_step_V=0.0002,repeat_std_V=0.001)


def analyze_curve(rows,dac):
    codes=[round(i*65535/100) for i in range(101)]
    if len(rows)!=303 or sorted({int(r['code']) for r in rows})!=codes:
        raise ValueError('Incomplete DAC code grid')
    means=[];deviations=[]
    for code in codes:
        selected=[r for r in rows if int(r['code'])==code]
        if sorted(int(r['sample']) for r in selected)!=[0,1,2]:raise ValueError('Missing/duplicate repeat')
        values=[parse_voltage(','.join(str(r[k]) for k in ('volts','instrument_time','status')))[0] for r in selected]
        means.append(statistics.mean(values));deviations.append(statistics.stdev(values))
    expected=EXPECTED_SPAN[dac];span=means[-1]-means[0]
    reverse=max(0,max(-(b-a)*(1 if expected>0 else -1) for a,b in zip(means,means[1:])))
    interior=[(x,y) for x,y in zip(codes,means) if .05*65535<=x<=.95*65535]
    fit=statistics.linear_regression(*zip(*interior))
    gain_error=(fit.slope/(expected/65536)-1)*100
    passed=abs(span/expected-1)<=LIMITS['span_relative_error'] and reverse<=LIMITS['reverse_step_V'] and max(deviations)<=LIMITS['repeat_std_V']
    return dict(pass_=passed,codes=codes,mean_V=means,minimum_code_V=means[0],maximum_code_V=means[-1],span_V=span,
                interior_gain_error_percent=gain_error,maximum_reverse_step_V=reverse,maximum_repeat_std_V=max(deviations))


def normalize(source,output,root,bid):
    source=Path(source);output=Path(output)
    native=validate_native(source);report=read(source/'scan-report.json')
    rows=list(csv.DictReader((source/'samples.csv').open()))
    if not (source/'post-cleanup.json').exists():raise ValueError('Explicit post-scan verification is required for this campaign method')
    if report['identity']!='Keysight Technologies,B2910BL,MY63320299,5.0.2429.8966':
        raise ValueError('Unexpected SMU identity/version; review protocol')
    for row,saved in zip(rows,report['measurements']):
        for key in ('pm_channel','code','mux_channel','sample','status'):
            if int(row[key])!=saved[key]:raise ValueError('Raw CSV/JSON disagreement')
        if row['dac']!=saved['dac'] or any(float(row[key])!=saved[key] for key in ('volts','instrument_time')):
            raise ValueError('Raw CSV/JSON disagreement')
    preflight=report.get('preflight_1v3',[])
    if {p['pm_channel'] for p in preflight}!=set(report['connected_modules']):raise ValueError('Missing fresh reference checks')
    for item in preflight:
        if len(item['samples'])!=3 or not all(.9<v<1.6 for v,_,_ in item['samples']):raise ValueError('Implausible reference rail')
    read_replies=[parse_voltage(item['reply']) for item in report['commands'] if item.get('query')=='READ?']
    expected_reads=[tuple(s) for p in preflight for s in p['samples']]+[(r['volts'],r['instrument_time'],r['status']) for r in report['measurements']]
    if read_replies!=expected_reads:raise ValueError('Fresh READ receipts disagree with samples')
    c=Campaign(root)
    with c.locked():
        directory,batch=c.batch(bid);c.check_identity(directory,batch);cfg=read(directory/'station.json')
        if set(report['connected_modules'])!=set(batch['channels']):raise ValueError('Incomplete fitted monitor inventory')
        uid=c.data['board_uid'];assignments=batch['assignments']
    output.mkdir(parents=True,exist_ok=False)
    for ch in report['scanned_modules']:
        destination=output/f'ch{ch:02d}';shutil.copytree(source,destination/'acquisition')
        sources=[]
        for name,expected in report['executed_sources'].items():
            if digest(destination/'acquisition'/name)!=expected:raise ValueError('Executed source hash mismatch')
            sources.append('acquisition/'+name)
        sources.append('acquisition/post-cleanup-source.py')
        (destination/'analysis-sources').mkdir()
        for path in [Path(__file__),CFD/'validate_smu_dacs.py',CFD/'smu_voltage.py']:
            shutil.copy2(path,destination/'analysis-sources'/path.name);sources.append('analysis-sources/'+path.name)
        curves=[];metrics=[];analysis={}
        for dac in 'BCD':
            result=analyze_curve([r for r in rows if int(r['pm_channel'])==ch and r['dac']==dac],dac);analysis[dac]=result
            curves.append(dict(name='dac_'+dac,x=result['codes'],y=result['mean_V'],x_unit='DAC code',y_unit='V'))
            for name in ('minimum_code_V','maximum_code_V','span_V','maximum_reverse_step_V','maximum_repeat_std_V','interior_gain_error_percent'):
                metrics.append(dict(name='dac_'+dac+'_'+name,value=result[name],unit='%' if name.endswith('percent') else 'V'))
        checks=dict(pass_=all(a['pass_'] for a in analysis.values()),physical_channel=ch,native=native,curves=analysis)
        write(destination/'validation.json',checks)
        hardware=dict(pm_build='c7c42d28',kasli_build=dict(ABI='CFD4',expected_bit_sha256=cfg['measurement_configuration']['kasli_bit_sha256']),
                      clock_profile=dict(reference_mhz=cfg['measurement_configuration']['reference_mhz'],adc_rate='2x reference',kasli_rate='3x reference'),cpld_gate_mode='original INTA/INTB enabled, nominal20MHz')
        receipt=dict(mode='LIVE',test='cfd-dacs',board_uid=uid,channel=ch,fixture_id=assignments[str(ch)],measured_utc=report['started_utc'],status='PASS' if checks['pass_'] else 'FAIL',
                     protocol=dict(method='shared-monitor-SMU-BCD-v1',hardware_configuration=hardware,instrument_identity=report['identity'],sense='Force HI/LO, local',source_current_A=0,source_range_A=1e-6,voltage_range_V=20,nplc=1,settling_s=.1,points=101,repeats=3,limits=LIMITS,post_scan_verification='SMU OFF/HIZ, four monitor muxes inhibited, explicit TCA masks0'),
                     source_files=sources,validation=[dict(file='validation.json',key='pass_',equals=True)],
                     channel_checks=[dict(file='validation.json',key='physical_channel'),dict(file='acquisition/scan-report.json',key='scanned_modules')],
                     connections=dict(shared_monitor_channels=report['connected_modules'],selection='one monitor mux enabled; all others inhibited'),metrics=metrics,curves=curves,
                     limits='Functional assembled-chain transfer check: span within5% of schematic scaling, reverse step <=0.2mV, repeat standard deviation <=1mV. Not traceable calibration or exhaustive16-bit INL/DNL. DAC-A unchanged; exercised B/C/D end at0000.')
        write(destination/'campaign-result.json',receipt)
        print(ch,receipt['status'],flush=True)


def main():
    p=argparse.ArgumentParser(description=__doc__)
    for key in ['source','out','root']:p.add_argument('--'+key,type=Path,required=True)
    p.add_argument('--batch',required=True);a=p.parse_args();normalize(a.source,a.out,a.root,a.batch)
if __name__=='__main__':main()
