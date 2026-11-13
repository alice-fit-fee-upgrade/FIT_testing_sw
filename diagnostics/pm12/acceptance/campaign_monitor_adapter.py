#!/usr/bin/env python3
"""Offline functional assembly checks for all eight CFD monitor inputs."""
import argparse,json,shutil,statistics,sys
from pathlib import Path
from campaign import Campaign,read,write,digest
P=Path(__file__).resolve().parents[1];sys.path.insert(0,str(P/'cfd_simulator'))
from mcp23017 import report_voltage
from smu_voltage import parse_voltage
WINDOWS=[(.98,1.08),(-.02,.04),(.97,1.08),(.99,1.10),(1.45,1.62),(-6.05,-4.95),(1.17,1.43),(4.95,6.05)]

def voltage_checks(values):
 if len(values)!=8:raise ValueError('Eight monitor values required')
 checks=[low<=value<=high for value,(low,high) in zip(values,WINDOWS)]
 # Relative offset checks distinguish nearby reference inputs despite ref tolerance.
 checks += [.005<=values[0]-values[2]<=.016,.012<=values[3]-values[2]<=.030,1.45<=values[4]/values[2]<=1.55 if values[2] else False]
 return checks

def normalize(source,output,root,bid):
 r=read(source/'scan-report.json');assert r['pass_'] and not r.get('error')
 assert len(r['readings'])==32 and len(r['dac_zero'])==12
 for ch in r['connected_modules']:
  for dac in 'BCD':assert sum(v['command']==f'@DAC {ch} W {dac} 0000' and v['reply'].strip()==f'DAC SENT {dac} 0000' for v in r['dac_zero'])==1
 s=r['final_smu'];assert s['OUTP?']=='0' and s['OUTP:OFF:MODE?']=='HIZ' and s['OUTP:ON:AUTO?']=='0' and s['SOUR:FUNC:MODE?']=='CURR' and float(s['SOUR:CURR?'])==0 and s['SENS:REM?']=='0' and int(s['SYST:ERR?'].split(',')[0])==0
 assert set(r['final_tca'].values())=={0}
 for name,expected in r['executed_sources'].items():assert digest(source/name)==expected
 samples=[]
 for row in r['readings']:
  assert row['gpioa']&15==[0,4,2,6,1,5,3,7][row['mux_channel']] and len(row['samples'])==3
  samples += [(v['volts'],v['instrument_time'],v['status']) for v in row['samples']]
 raw=[parse_voltage(v['reply']) for v in r['commands'] if v.get('query')=='READ?'];assert raw==samples
 c=Campaign(root)
 with c.locked():
  directory,batch=c.batch(bid);c.check_identity(directory,batch);cfg=read(directory/'station.json');uid=c.data['board_uid']
 assert set(r['connected_modules'])==set(batch['channels'])
 output.mkdir(parents=True,exist_ok=False)
 for ch in r['connected_modules']:
  before=r['gpio_before'][str(ch)];after=r['gpio_final'][str(ch)]
  assert before['0']&0xf0==after['0']&0xf0 and before['20']&0xf0==after['20']&0xf0 and before['1']==after['1'] and before['21']==after['21'] and after['20']&8
  out=output/f'ch{ch:02d}';shutil.copytree(source,out/'acquisition');(out/'analysis-sources').mkdir();shutil.copy2(Path(__file__),out/'analysis-sources'/Path(__file__).name)
  rows=sorted([v for v in r['readings'] if v['physical_channel']==ch],key=lambda v:v['mux_channel']);assert [v['mux_channel'] for v in rows]==list(range(8))
  converted=[];metrics=[];spread=[]
  for row in rows:
   vals=[v['volts'] for v in row['samples']];v=report_voltage(row['mux_channel'],statistics.mean(vals));converted.append(v);spread.append(statistics.stdev(vals));metrics.append(dict(name=v['signal'],value=v['volts'],unit='V'))
  values=[v['volts'] for v in converted];checks=voltage_checks(values);passed=all(checks) and max(spread)<.002
  validation=dict(pass_=passed,physical_channel=ch,values=converted,checks=checks,max_raw_repeat_std_V=max(spread),raw_samples=96,control_preservation=True)
  write(out/'validation.json',validation)
  hardware=dict(pm_build='c7c42d28',kasli_build=dict(ABI='CFD4',expected_bit_sha256=cfg['measurement_configuration']['kasli_bit_sha256']),clock_profile=dict(reference_mhz=cfg['measurement_configuration']['reference_mhz'],adc_rate='2x reference',kasli_rate='3x reference'),cpld_gate_mode='original INTA/INTB enabled, nominal20MHz')
  receipt=dict(mode='LIVE',test='cfd-monitor',board_uid=uid,channel=ch,fixture_id=batch['assignments'][str(ch)],measured_utc=r['started_utc'],status='PASS' if passed else 'FAIL',protocol=dict(method='eight-monitor-assembly-v1',hardware_configuration=hardware,windows_V=WINDOWS,relative_offset_windows_V=[[.005,.016],[.012,.030]],vocm_ratio_window=[1.45,1.55],raw_repeat_std_limit_V=.002,divider_correction=53/33,settle_s=.2,samples_per_input=3,source_current_A=0,sense='local Force HI/LO',nplc=1,range_V=20),source_files=['acquisition/'+name for name in r['executed_sources']]+['analysis-sources/'+Path(__file__).name],validation=[dict(file='validation.json',key='pass_',equals=True)],channel_checks=[dict(file='validation.json',key='physical_channel')],connections=dict(shared_monitor_channels=r['connected_modules'],selection='one of four muxes active at a time'),metrics=metrics,curves=[dict(name='monitor_voltages',x=list(range(8)),y=values,x_unit='monitor input',y_unit='V')],limits='Functional assembly windows and relative reference checks; negative/positive supply dividers corrected by53/33. Three fresh0A-SMU voltage readings per input; no traceable voltage calibration or analog off-resistance claim')
  write(out/'campaign-result.json',receipt);print(ch,receipt['status'],values,flush=True)

def main():
 p=argparse.ArgumentParser(description=__doc__)
 for key in ['source','out','root']:p.add_argument('--'+key,type=Path,required=True)
 p.add_argument('--batch',required=True);a=p.parse_args();normalize(a.source,a.out,a.root,a.batch)
if __name__=='__main__':main()
