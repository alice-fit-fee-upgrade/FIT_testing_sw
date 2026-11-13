#!/usr/bin/env python3
"""Offline raw TDC/ISERDES validation and physical-channel campaign receipts."""
import argparse,collections,gzip,json,math,shutil,statistics,struct,sys
from pathlib import Path
from campaign import Campaign,read,write,digest
P=Path(__file__).resolve().parents[1]
sys.path[:0]=[str(P/'cfd_simulator'),'/home/codex-hil/kasli-phase-tester']
from phase_estimator import estimate,scan_codes
from host.hdmi_check import check_phase_records


def unwrap(values,period):
    output=[]
    for value in values:
        output.append(value+period*round((output[-1]-value)/period) if output else value)
    return output


def fine_statistics(words):
    if not words or any(w>0x1fff for w in words):raise ValueError('Invalid13-bit TDC records')
    histogram=collections.Counter(w&127 for w in words)
    sx=sum(n*math.cos(2*math.pi*k/128) for k,n in histogram.items());sy=sum(n*math.sin(2*math.pi*k/128) for k,n in histogram.items())
    mean=(math.atan2(sy,sx)*128/(2*math.pi))%128
    spread=math.sqrt(sum(n*((k-mean+64)%128-64)**2 for k,n in histogram.items())/len(words))
    return histogram,mean,spread


def validate_tdc(source,report):
    mapping=report['expected_channels'];statistics_by_label={p['label']:p for p in report['statistics']}
    if len(mapping)!=4 or len(set(mapping))!=4 or len(report['captures'])!=112 or len(statistics_by_label)!=100:raise ValueError('Incomplete four-port TDC scan')
    previous=None;quiet=events=0
    for row in report['captures']:
        label=row['label'];summary=read(source/label/'summary.json')
        if any(row[k]!=v for k,v in summary.items()):raise ValueError('Capture summary differs from native receipt')
        port=int(label.split('-')[0][1:]);channel=mapping[port];expected=[0]*12
        if '-quiet-' in label:quiet+=1
        else:expected[channel-1]=16 if label.endswith('discover') else 128
        if row['counts']!=expected or row['status']&0x23!=1:raise ValueError('TDC count/crosstalk/freeze error')
        if previous is not None and row['generation']!=(previous+1)&0xffffffff:raise ValueError('Discontinuous TDC generations')
        previous=row['generation']
        selected=None
        for index,count in enumerate(expected):
            data=(source/label/f'tdc{index+1:02d}.bin').read_bytes()
            if len(data)!=count*2:raise ValueError('Raw length/count mismatch')
            words=list(struct.unpack('<'+'H'*count,data));hist=collections.Counter(w&127 for w in words)
            if any(w>0x1fff for w in words) or dict(hist)!={int(k):v for k,v in row['fine_histograms'][index].items()}:raise ValueError('Raw fine histogram mismatch')
            if count:selected=words
        if label in statistics_by_label:
            stat=statistics_by_label[label];hist,mean,spread=fine_statistics(selected)
            coarse=collections.Counter(w>>7 for w in selected)
            if stat['channel']!=channel or stat['port']!=port or stat['count']!=128 or abs(mean-stat['fine_mean_circular'])>1e-9 or abs(spread-stat['fine_std_circular'])>1e-9 or dict(coarse)!={int(k):v for k,v in stat['coarse_histogram'].items()}:raise ValueError('TDC statistics disagree with raw data')
            if dict(hist)!={int(k):v for k,v in stat['fine_histogram'].items()}:raise ValueError('TDC statistics histogram mismatch')
            if stat['phase_bin']!=row['phase_bin'] or abs(stat['delay_ns']-(stat['phase_bin']-24)/report['sample_hz_assumed']*1e9)>1e-9:raise ValueError('Stimulus phase mismatch')
            events+=len(selected)
    if quiet!=8 or events!=12800:raise ValueError('Missing quiet/phase acquisitions')
    final=report['final']
    if final['cfd_enabled'] or final['selected_port'] or final['pm_build']!=0xc7c42d28:raise ValueError('TDC restoration mismatch')
    for row in report['directions_final'].values():
        if row['after']!=[0,0]:raise ValueError('DIO not in input mode')
    return dict(raw_valid=True,captures=112,quiet_windows=quiet,phase_events=events,discovery_events=64)


def validate_gate(source,report):
    channels=report['channels'];points=report['points'];grid=scan_codes(100)
    if len(channels)!=4 or len(set(channels))!=4 or len(points)!=404 or set(report['restored_zero'])!=set(channels):raise ValueError('Incomplete four-CFD gate sweep')
    for channel in channels:
        selected=[p for p in points if p['afe']==channel]
        if [p['code'] for p in selected]!=grid:raise ValueError('Gate DAC grid mismatch')
    errors=[];bits=records=0
    for point in points:
        path=source/f"ch{point['afe']:02d}-{point['index']:03d}-{point['code']:05d}.json.gz"
        with gzip.open(path,'rt') as stream:data=json.load(stream)
        if sorted(lane['logical'] for lane in data['channels'])!=list(range(8,16)):raise ValueError('Missing/duplicate phase receiver')
        for lane in data['channels']:
            check_phase_records(lane);bits+=len(lane['words'])*8;records+=len(lane['phase_records'])
            try:value=estimate([lane],1e12/(40.0787e6*24),24,edge_period_bins=48)
            except ValueError as error:
                value=dict(error=str(error),high_samples=sum(w.bit_count() for w in lane['words']));errors.append(dict(channel=point['afe'],code=point['code'],lane=lane['logical'],error=str(error)))
            if json.loads(json.dumps(value))!=point['lanes'][str(lane['logical'])]:raise ValueError('Gate statistics differ from raw ISERDES samples')
    for row in report['final_directions'].values():
        if row['after']!=[0,0]:raise ValueError('DIO not in input mode')
    if set(report['tca_final'].values())!={0}:raise ValueError('TCA masks not zero')
    return dict(raw_valid=True,captures=len(points),sampled_bits=bits,checked_phase_records=records,estimator_errors=errors,all_eight_valid=not errors)


def normalize(kind,source,output,root,bid):
    report=read(source/'status.json')
    if not report['pass_'] or not report.get('finished_utc'):raise ValueError('Native acquisition incomplete')
    c=Campaign(root)
    with c.locked():
        directory,batch=c.batch(bid);c.check_identity(directory,batch);cfg=read(directory/'station.json');uid=c.data['board_uid']
    channels=report['expected_channels'] if kind=='tdc' else report['channels']
    if set(channels)!=set(batch['channels']):raise ValueError('Wrong fitting inventory')
    for port,ch in enumerate(channels):
        if batch['connections'][str(ch)]['rj45_port']!=port:raise ValueError('Physical channel/port order differs from confirmed fitting')
    validation=validate_tdc(source,report) if kind=='tdc' else validate_gate(source,report)
    for name,expected in report['executed_sources'].items():
        if digest(source/name)!=expected:raise ValueError('Executed source snapshot mismatch')
    hardware=dict(pm_build='c7c42d28',kasli_build=dict(ABI='CFD4',expected_bit_sha256=cfg['measurement_configuration']['kasli_bit_sha256']),clock_profile=dict(reference_mhz=cfg['measurement_configuration']['reference_mhz'],adc_rate='2x reference',kasli_rate='3x reference'),cpld_gate_mode='original INTA/INTB enabled, nominal20MHz')
    output.mkdir(parents=True,exist_ok=False)
    for port,ch in enumerate(channels):
        out=output/f'ch{ch:02d}';acq=out/'acquisition';acq.mkdir(parents=True);shutil.copy2(source/'status.json',acq/'status.json');shutil.copytree(source/'sources',acq/'sources')
        sources=['acquisition/'+name for name in report['executed_sources']]
        (out/'analysis-sources').mkdir()
        for name in [Path(__file__),P/'cfd_simulator/phase_estimator.py',Path('/home/codex-hil/kasli-phase-tester/host/hdmi_check.py')]:
            shutil.copy2(name,out/'analysis-sources'/name.name);sources.append('analysis-sources/'+name.name)
        metrics=[];curves=[];notes=[];passed=True
        if kind=='tdc':
            labels=[row['label'] for row in report['captures'] if row['label'].startswith(f'p{port}-')]
            for label in labels:shutil.copytree(source/label,acq/label)
            points=sorted([p for p in report['statistics'] if p['channel']==ch],key=lambda p:p['phase_bin'])
            if [p['phase_bin'] for p in points]!=list(range(24,49)):raise ValueError('Missing TDC phase positions')
            x=[p['delay_ns'] for p in points];y=unwrap([p['fine_mean_circular'] for p in points],128);y=[v-y[0] for v in y];fit=statistics.linear_regression(x,y);residual=max(abs(v-(fit.slope*t+fit.intercept)) for t,v in zip(x,y))
            passed=-60<fit.slope< -20 and residual<10
            for name,value,unit in [('slope',fit.slope,'fine code/ns'),('max_fit_residual',residual,'fine code'),('max_circular_spread',max(p['fine_std_circular'] for p in points),'fine code'),('events',3200,'event')]:metrics.append(dict(name=name,value=value,unit=unit))
            curves=[dict(name='tdc_response',x=x,y=y,x_unit='ns',y_unit='fine code'),dict(name='tdc_spread',x=x,y=[p['fine_std_circular'] for p in points],x_unit='ns',y_unit='fine code')]
            protocol=dict(method='finite-OSERDES-TDC-phase-v1',hardware_configuration=hardware,phase_slots=list(range(24,49)),sample_hz=report['sample_hz_assumed'],events_per_phase=128,discovery_events=16,response_slope_window=[-60,-20],maximum_residual_fine_codes=10)
            limits='Fine modulo128 unwrapped by nearest continuation; coarse fields retained without repair. Programmed slot1.0396ns assumes40.0787MHz; not calibrated TDC timing or intrinsic jitter'
        else:
            selected=[p for p in report['points'] if p['afe']==ch]
            for point in selected:
                name=f"ch{ch:02d}-{point['index']:03d}-{point['code']:05d}.json.gz";shutil.copy2(source/name,acq/name)
            for bank,lane in zip('AB',[8+2*port,9+2*port]):
                values=[p['lanes'][str(lane)] for p in selected]
                valid=[(point,value) for point,value in zip(selected,values) if 'mean_bin' in value]
                metrics.append(dict(name='valid_points',bank=bank,value=len(valid),unit='point'))
                if len(valid)!=101:passed=False
                if not valid:continue
                y=unwrap([v['mean_bin'] for p,v in valid],48);y=[(v-y[0])*1e9/(40.0787e6*24) for v in y];span=max(y)-min(y);step=max(abs(b-a) for a,b in zip(y,y[1:]));passed &= span>=5
                for name,value,unit in [('observed_excursion',span,'ns'),('end_to_end',y[-1],'ns'),('largest_step',step,'ns'),('max_spread',max(v['spread_bins'] for p,v in valid)*1e9/(40.0787e6*24),'ns')]:metrics.append(dict(name=name,bank=bank,value=value,unit=unit))
                curves.append(dict(name='gate_phase',bank=bank,x=[p['code'] for p,v in valid],y=y,x_unit='DAC code',y_unit='ns'))
                if step>2e9/(40.0787e6*24):notes.append(f'Gate{bank}: adjacent phase step {step:.3f}ns exceeds two sampler bins. Retained observed excursion is not a certified continuous tuning range')
            protocol=dict(method='DAC-A-ISERDES-gate-phase-v1',hardware_configuration=hardware,codes=scan_codes(100),sample_hz=40.0787e6*24,gate_period_bins=48,capture_words=4095,minimum_functional_excursion_ns=5)
            limits='Occupancy-weighted sampled phase centroid; nominal1.0396ns bins and49.9ns gate period. Nearest-continuation unwrap; discontinuities retained. No calibrated sub-bin precision or independent-edge sqrt(N) uncertainty. DAC A commanded0000 at cleanup, without hardware code readback'
        checks=dict(pass_=bool(passed),physical_channel=ch,raw=validation);write(out/'validation.json',checks)
        receipt=dict(mode='LIVE',test=kind,board_uid=uid,channel=ch,fixture_id=batch['assignments'][str(ch)],measured_utc=report['started_utc'],status='PASS' if passed else 'FAIL',protocol=protocol,source_files=sources,validation=[dict(file='validation.json',key='pass_',equals=True)],channel_checks=[dict(file='validation.json',key='physical_channel'),dict(file='acquisition/status.json',key='expected_channels' if kind=='tdc' else 'channels')],connections=dict(slot=7,rj45_port=port,phase_lanes=[8+2*port,9+2*port],stimulus_dio=4*port),metrics=metrics,curves=curves,limits=limits,notes=notes)
        write(out/'campaign-result.json',receipt);print(kind,ch,receipt['status'],flush=True)


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('kind',choices=['tdc','gate-phase'])
    for key in ['source','out','root']:p.add_argument('--'+key,type=Path,required=True)
    p.add_argument('--batch',required=True);a=p.parse_args();normalize(a.kind,a.source,a.out,a.root,a.batch)
if __name__=='__main__':main()
