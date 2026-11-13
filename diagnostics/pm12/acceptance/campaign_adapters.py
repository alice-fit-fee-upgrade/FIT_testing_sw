#!/usr/bin/env python3
"""Normalize actual ADC/integrator evidence for campaign.py; offline only."""
import argparse
import datetime
import hashlib
import json
from pathlib import Path
import shutil
import statistics
import struct
import sys
from campaign import Campaign,read,write,digest
HERE=Path(__file__).resolve().parent;CFD=HERE.parent/'cfd_simulator'
sys.path[:0]=[str(CFD),str(HERE.parent/'ipbus_adc')]
from adc_decode import decode
from adc_line_test import analyze_report
from validate_adc_lines import validate as validate_adc_raw
from integrator_analysis import integration_pair


def context(root,bid,channel):
    c=Campaign(root)
    with c.locked():
        directory,batch=c.batch(bid);c.check_identity(directory,batch)
        if channel not in batch['channels']:raise ValueError('Physical channel is not fitted')
        cfg=read(directory/'station.json')
        hardware=dict(pm_build='c7c42d28',kasli_build=dict(ABI='CFD4',expected_bit_sha256=cfg['measurement_configuration']['kasli_bit_sha256']),
                      clock_profile=dict(reference_mhz=cfg['measurement_configuration']['reference_mhz'],adc_rate='2x reference',kasli_rate='3x reference'),cpld_gate_mode='original INTA/INTB enabled, nominal20MHz')
        return c.data['board_uid'],batch['assignments'][str(channel)],hardware


def copied_sources(raw_report,raw_directory,relative_prefix):
    files=[]
    for name,expected in raw_report['executed_sources'].items():
        if digest(raw_directory/name)!=expected:raise ValueError('Executed-source snapshot mismatch')
        files.append(str(Path(relative_prefix)/name))
    return files


def analysis_sources(output):
    target=output/'analysis-sources';target.mkdir()
    files=[]
    for source in [Path(__file__),CFD/'adc_line_test.py',CFD/'validate_adc_lines.py',CFD/'integrator_analysis.py',HERE.parent/'ipbus_adc/adc_decode.py']:
        dest=target/source.name;shutil.copy2(source,dest);files.append(str(dest.relative_to(output)))
    return files


def adc(source,output,root,bid,kind):
    report=read(source/'scan/status.json');channel=report['channel']
    uid,fixture,hardware=context(root,bid,channel)
    raw_check=validate_adc_raw(source/'scan')
    line=analyze_report(report)
    existing=read(source/'line-test.json')
    if line['banks']!=existing['banks'] or line['pass_']!=existing['pass_']:
        raise ValueError('Line-test summary differs from raw-revalidated analysis')
    output.mkdir(parents=True,exist_ok=False);shutil.copytree(source,output/'acquisition')
    source_files=copied_sources(report,output/'acquisition/scan','acquisition/scan')+analysis_sources(output)
    metrics=[];curves=[];dc_pass=report['pass'] and raw_check['pass']
    for bank,label in enumerate('AB'):
        rows=sorted([r for r in report['measurements'] if r['bank']==bank and r['injection_bank']==bank],key=lambda r:r['diff_setpoint_v'])
        if len(rows)<16:raise ValueError('Insufficient transfer points')
        fit=[r for r in rows if abs(r['diff_setpoint_v'])<=.8 and r['minimum']>0 and r['maximum']<4095]
        if len(fit)<8:raise ValueError('Insufficient unclipped fit interval')
        regression=statistics.linear_regression([r['diff_setpoint_v'] for r in fit],[r['raw_mean'] for r in fit])
        dc_pass &= max(r['raw_mean'] for r in rows)-min(r['raw_mean'] for r in rows)>3000
        if kind=='adc-dc':
            zero=min(rows,key=lambda r:abs(r['diff_setpoint_v']))
            metrics.extend([dict(name='gain',bank=label,value=regression.slope,unit='code/V'),dict(name='zero_mean',bank=label,value=zero['raw_mean'],unit='code'),dict(name='zero_total_rms',bank=label,value=zero['raw_std'],unit='code')])
            curves.append(dict(name='adc_response',bank=label,x_unit='V',y_unit='code',x=[r['diff_setpoint_v'] for r in rows],y=[r['raw_mean'] for r in rows]))
            import numpy as np
            index=report['measurements'].index(zero) % len(rows)
            data=(source/'scan'/f'mux{bank}-point{index:03d}-bank{bank}.bin').read_bytes()
            samples,_=decode(list(struct.unpack('<4096H',data)),bank)
            n=len(samples)//4*4;values=np.asarray(samples[:n],dtype=float);ac=values-values.mean()
            template=np.array([values[i::4].mean() for i in range(4)])
            residual=values-template[np.arange(n)%4]
            metrics.append(dict(name='zero_four_phase_removed_rms',bank=label,value=float(np.std(residual)),unit='code'))
            transform=np.fft.rfft(ac);amplitudes=abs(transform)*np.sqrt(2)/n
            amplitudes[0]/=np.sqrt(2);amplitudes[-1]/=np.sqrt(2)
            if not np.isclose(sum(amplitudes**2),np.mean(ac**2),rtol=1e-9,atol=1e-9):raise ValueError('FFT power normalization error')
            curves.append(dict(name='zero_input_fft',bank=label,x_unit='Hz (assumed sample rate)',y_unit='code RMS/bin',x=np.fft.rfftfreq(n,1/80157400).tolist(),y=amplitudes.tolist()))
            curves.append(dict(name='zero_input_time',bank=label,x_unit='ns (local capture origin)',y_unit='code',x=(np.arange(40)*1e9/80157400).tolist(),y=values[:40].tolist()))

        else:
            supported=sum(sum(pair['supported']) for pair in line['banks'][label]['adjacent_pairs'])
            metrics.extend([dict(name='adjacent_pair_states',bank=label,value=supported,unit='state'),dict(name='visited_codes',bank=label,value=line['banks'][label]['visited_codes'],unit='code')])
    if not all(report['dac_initial_setpoints'][i]==report['dac_final_setpoints'][i] for i in range(8) if i not in report['dac_channels']):
        raise ValueError('Unselected DAC outputs changed')
    checks=dict(adc_dc_pass=bool(dc_pass),adc_line_pass=bool(line['pass_']),raw=raw_check,physical_channel=channel)
    write(output/'validation.json',checks)
    passed=checks['adc_dc_pass'] if kind=='adc-dc' else checks['adc_line_pass']
    result=dict(mode='LIVE',board_uid=uid,test=kind,channel=channel,fixture_id=fixture,
                measured_utc=report['started_utc'],status='PASS' if passed else 'FAIL',
                protocol=dict(method='direct-ADC-DC-v1' if kind=='adc-dc' else 'adjacent-pair-states-v1',hardware_configuration=hardware,
                              stimulus_points_per_bank=len(rows),commanded_range_V=[rows[0]['diff_setpoint_v'],rows[-1]['diff_setpoint_v']],common_mode_V=report['common_mode_v'],dac_channels=report['dac_channels'],
                              fit_interval_V=[-.8,.8],fft_sample_rate_assumed_Hz=80157400,integrator_input_parked_V=report['dac_initial_setpoints'][2:4]),
                source_files=source_files,validation=[dict(file='validation.json',key='adc_dc_pass' if kind=='adc-dc' else 'adc_line_pass',equals=True)],
                channel_checks=[dict(file='acquisition/scan/status.json',key='channel')],
                connections=dict(usb_input='J8',stimulus_channel=channel,dac_channels=report['dac_channels']),metrics=metrics,curves=curves,
                limits='Commanded DAC voltages, whole connected chain; not calibrated ADC-only INL/noise or electrical continuity proof')
    write(output/'campaign-result.json',result)
    return result


def integrator(source,analysis,output,root,bid):
    calculated=read(analysis/'analysis.json');runs=sorted({p['run'] for p in calculated['points']} | {Path(p).parent.name for p in calculated['source_sha256']})
    reports={name:read(source/name/'status.json') for name in runs}
    channels={r['physical_channel'] for r in reports.values()}
    if len(channels)!=1:raise ValueError('Integrator inputs mix physical channels')
    channel=channels.pop();uid,fixture,hardware=context(root,bid,channel)
    if not all(r['pass_'] for r in reports.values()):raise ValueError('Incomplete integrator acquisition')
    for r in reports.values():
        if not all(r['dac_before'][i]==r['dac_final'][i] for i in range(8) if i not in r['dac_channels']):raise ValueError('Unselected DAC changed in integrator stage')
    if len({tuple(r['dac_channels']) for r in reports.values()})!=1:raise ValueError('DAC pair changed within scan')
    # Rebuild every plotted point from raw ADC words, not merely saved fit values.
    rebuilt={};buffers=0;raw_samples=0
    for name,r in reports.items():
        for point in r['points']:
            for cap in point['captures']:
                data=(source/name/cap['file']).read_bytes();samples,_=decode(list(struct.unpack('<4096H',data)),cap['bank']);raw_samples+=len(samples);buffers+=1
                try:measurement=integration_pair(samples)
                except ValueError:continue
                rebuilt.setdefault((name,point['index'],cap['bank']),[]).append(measurement['mean_change'])
    for point in calculated['points']:
        values=rebuilt[(point['run'],point['point'],point['bank'])]
        if len(values)!=point['buffers'] or abs(statistics.mean(values)-point['mean_change'])>1e-9:raise ValueError('Integrator point differs from raw buffers')
    for path,expected in calculated['source_sha256'].items():
        p=Path(path)
        if digest(source/p.parent.name/p.name)!=expected:raise ValueError('Integrator raw hash mismatch')
    output.mkdir(parents=True,exist_ok=False);(output/'acquisition').mkdir()
    for name in runs:shutil.copytree(source/name,output/'acquisition'/name)
    shutil.copytree(analysis,output/'analysis')
    native_sources=None;source_files=[]
    for name,r in reports.items():
        files=copied_sources(r,output/'acquisition'/name,'acquisition/'+name)
        current={Path(key).name:value for key,value in r['executed_sources'].items()}
        if native_sources is not None and current!=native_sources:raise ValueError('Acquisition sources changed within integrator sequence')
        if native_sources is None:source_files.extend(files)
        native_sources=current
    source_files+=analysis_sources(output)
    metrics=[];curves=[];validation={};passed=True
    for bank,label in enumerate('AB'):
        points=sorted([p for p in calculated['points'] if p['run']=='fine01' and p['bank']==bank],key=lambda p:p['offset_V'])
        if len(points)<8 or not min(p['mean_change'] for p in points)<0<max(p['mean_change'] for p in points):raise ValueError('No unclipped signed zero crossing')
        fit=statistics.linear_regression([p['offset_V'] for p in points],[p['mean_change'] for p in points])
        if abs(fit.slope-calculated['fits'][label]['gain_codes_per_commanded_V'])>1e-5:raise ValueError('Fit differs from raw-rebuilt points')
        roots=[]
        for left,right in zip(points,points[1:]):
            if left['mean_change'] * right['mean_change'] < 0:
                roots.append(left['offset_V']-left['mean_change']*(right['offset_V']-left['offset_V'])/(right['mean_change']-left['mean_change']))
        if len(roots)!=1:raise ValueError('Ambiguous balance zero')
        checks=[p for p in calculated['points'] if p['run'].startswith('validation') and p['bank']==bank]
        if not checks:raise ValueError('No independent returns/offset checks')
        closest=min(checks,key=lambda p:abs(p['mean_change']))
        return_points=[p for p in checks if abs(p['offset_V']-closest['offset_V'])<1e-8]
        if len(return_points)<2 or any(p['buffers']<4 or abs(p['mean_change'])>2 for p in return_points):passed=False
        if not any(p['mean_change']< -4 for p in checks) or not any(p['mean_change']>4 for p in checks):passed=False
        validation[label]=dict(balance_delta=roots[0],gain=fit.slope,returned_change_codes=[p['mean_change'] for p in return_points],candidate_offset_V=closest['offset_V'])
        metrics.extend([dict(name='balance_delta',bank=label,value=roots[0],unit='V'),dict(name='gain',bank=label,value=fit.slope,unit='code/V'),dict(name='near_balance_change',bank=label,value=statistics.mean(p['mean_change'] for p in return_points),unit='code')])
        curves.append(dict(name='ramp_response',bank=label,x_unit='V',y_unit='code',x=[p['offset_V'] for p in points],y=[p['mean_change'] for p in points]))
    final=reports[sorted(reports)[-1]]
    final=reports.get('validation02',final)
    if final['mcp_final']['18']&0x88!=8 or not final['mcp_final']['21']&32 or set(final['tca_final'].values())!={0}:raise ValueError('Final integrator GPIO restoration state differs')
    checks=dict(pass_=bool(passed),physical_channel=channel,banks=validation,raw_buffers=buffers,raw_ADC_samples=raw_samples)
    write(output/'validation.json',checks)
    pair=final['dac_channels']
    result=dict(mode='LIVE',board_uid=uid,test='integrator',channel=channel,fixture_id=fixture,measured_utc=min(r['started_utc'] for r in reports.values()),status='PASS' if passed else 'FAIL',
                protocol=dict(method='signed-integration-pair-v1',hardware_configuration=hardware,dac_channels=pair,base_V=final['reference_nominal_V'],coarse_offsets_V=reports['sweep01']['points'] and [p['offset_V'] for p in reports['sweep01']['points']],fine_method='26 points,0.4mV step around coarse estimate',return_method='two candidate revisits and +/-5mV offsets;near-zero <=2codes; signed response >4codes'),
                source_files=source_files,validation=[dict(file='validation.json',key='pass_',equals=True)],channel_checks=[dict(file='validation.json',key='physical_channel')],
                connections=dict(usb_input='J6',stimulus_channel=channel,dac_channels=pair),metrics=metrics,curves=curves,limits='Effective differential whole-chain balance; waveform-based integration pair, not an absolute gate timestamp or calibrated opamp bias')
    write(output/'campaign-result.json',result)
    return result


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('kind',choices=['adc-dc','adc-lines','integrator']);p.add_argument('--source',type=Path,required=True);p.add_argument('--analysis',type=Path);p.add_argument('--out',type=Path,required=True);p.add_argument('--root',type=Path,required=True);p.add_argument('--batch',required=True);a=p.parse_args()
    result=integrator(a.source,a.analysis,a.out,a.root,a.batch) if a.kind=='integrator' else adc(a.source,a.out,a.root,a.batch,a.kind)
    print(result['test'],result['channel'],result['status'])
if __name__=='__main__':main()
