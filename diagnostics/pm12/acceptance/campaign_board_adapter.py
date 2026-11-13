#!/usr/bin/env python3
"""Offline board-level assembly evidence; HDMI reset failures stay visible."""
import argparse,json,re,shutil,struct,sys,datetime
from pathlib import Path
from campaign import Campaign,read,write,digest
P=Path(__file__).resolve().parents[1];sys.path[:0]=[str(P),str(P/'ipbus_adc'),'/home/codex-hil/kasli-phase-tester']
from test_board import analyze,controls
from client import describe
from host.hdmi_check import check_prbs,check_idle

RAILS={(4,1):('P1V0_LDO',1,.010),(4,2):('P1V2_LDO',1.2,.010),(4,3):('P1V8_LDO',1.8,.010),(5,1):('P3V8',3.8,.001),(5,2):('P3V3',3.3,.001),(5,3):('P1V8',1.8,.001),(6,1):('P1V0',1,.001),(6,2):('P5V5',5.5,.001)}
def ina_rows(records):
 result=[]
 for row in records:
  if row['command'] not in ['@INA 4','@INA 5','@INA 6']:continue
  for route,ch,shunt,bus,mv,ma,status in re.findall(r'INA (\d) CH=(\d) RAW=([0-9A-F]{4})/([0-9A-F]{4}) MV=(-?\d+) MA=(\S+) STATUS=([^\r\n]+)',row['reply']):
   route,ch=int(route),int(ch)
   if (route,ch) not in RAILS:continue
   name,nominal,resistance=RAILS[route,ch];raw=int(shunt,16);signed=raw-65536 if raw&32768 else raw;code=signed>>3
   result.append(dict(route=route,channel=ch,rail=name,voltage_V=int(mv)/1000,current_A=code*40e-6/resistance,nominal_V=nominal,shunt_ohm=resistance,shunt_code=code,firmware_current=ma,firmware_status=status))
 if len(result)!=8 or len({(r['route'],r['channel']) for r in result})!=8:raise ValueError('Missing populated INA rail')
 return result

def validate_safe(source):
 r=read(source/'result.json');assert r['pass'] and not r['unexpected_sys_resets'] and r['pm_identity']==[0x504d1202,0x10002,0xc7c42d28]
 payload=0
 for kind in ['synthetic','physical']:
  for bank in [0,1]:
   directory=source/'adc'/f'{kind}-{bank}';summary=read(directory/'summary.json');data=[]
   for ch in range(1,13):
    b=(directory/f'ch{ch:02d}.bin').read_bytes();assert len(b)==8192;payload+=len(b);data.append(list(struct.unpack('<4096H',b)))
   assert json.loads(json.dumps(describe(data,bank,kind=='synthetic')))==summary['channels']
 rows=r['suites']['tdc']['captures'];expected=[0]*12;expected[11]=64
 assert [v['counts'] for v in rows]==[[0]*12,expected,[0]*12]
 for row in rows:
  for ch,count in enumerate(row['counts'],1):
   b=(source/'tdc'/row['label']/f'tdc{ch:02d}.bin').read_bytes();assert len(b)==count*2 and all(w<=8191 for w in struct.unpack('<'+'H'*count,b))
 return dict(pass_=True,payload_bytes=payload,adc_channels=12,adc_banks=2,synthetic_and_physical=True,tdc_events=64,no_sys_resets=True)

def validate_hdmi(source):
 r=read(source/'result.json');h=r['suites']['hdmi'];mapping=h['mapping'];inversions={int(k):v for k,v in h['inversions'].items()};d=source/'hdmi'
 for row in h['walking']:
  cap=read(d/f"walking-{row['value']:02d}.json")
  lanes={lane['channel']:lane['words'] for lane in cap['channels']}
  for bit,lane in enumerate(mapping):assert set(lanes[lane])=={255 if ((row['value']>>bit)&1)^inversions[lane] else 0}
 for label,ratio in [('prbs-slow',768),('prbs-fast',3),('native-idle',None)]:
  cap=read(d/(label+'.json'));lanes={v['channel']:v['words'] for v in cap['channels']}
  for lane,seed in zip(mapping,[1,0x13,0x35,0x57]):
   words=[v^(255 if inversions[lane] else 0) for v in lanes[lane]]
   if ratio:check_prbs(words,seed,ratio,sample_hz=cap['sample_hz_nominal'])
   else:check_idle(words,sample_hz=cap['sample_hz_nominal'])
 assert h['spi_signature']==[0x4844,0x4d49,1]
 return dict(data_pass=True,spi_reads_pass=True,clock_health_pass=not h['pm_sys_reset_observed'],pass_=bool(h['pass'] and not h['pm_sys_reset_observed']))

def normalize(work,sources,output,root,bid):
 c=Campaign(root)
 with c.locked():directory,batch=c.batch(bid);c.check_identity(directory,batch);cfg=read(directory/'station.json');uid=c.data['board_uid']
 mcu=read(work/'board-mcu01/result.json');assert mcu['status']=='PASS' and mcu['identity']['uid']==uid
 manifest=read(sources/'manifest.json')
 for name,row in manifest['sources'].items():assert digest(sources/name)==row['sha256'] and digest(Path(row['original']))==row['sha256']
 safe=validate_safe(work/'board-safe-final');hdmi=validate_hdmi(work/'board-resident01')
 j=read(work/'board-boundary01/diagnostic/report.json');diag=work/'board-boundary01/diagnostic'
 assert j['status']=='PASS' and j['nonvolatile_programming'] is False
 for key,name,is_boundary in [('gateware','discover.log',False),('boundary','boundary.log',True)]:assert json.loads(json.dumps(analyze((diag/name).read_text(),is_boundary)))==j[key] and j[key]['matched']==168 and j[key]['passed']
 assert controls((diag/'control.log').read_text())['passed'] and 'LOAD_PASS' in (work/'board-boundary01/restore.log').read_text()
 rails=ina_rows(mcu['records']);power_pass=all(.9*v['nominal_V']<=v['voltage_V']<=1.1*v['nominal_V'] and -4096<v['shunt_code']<4095 for v in rails)
 output.mkdir(exist_ok=False,parents=True)
 hardware=dict(pm_build='c7c42d28',kasli_build=dict(ABI='CFD4',expected_bit_sha256=cfg['measurement_configuration']['kasli_bit_sha256']),clock_profile=dict(reference_mhz=cfg['measurement_configuration']['reference_mhz'],adc_rate='2x reference',kasli_rate='3x reference'),cpld_gate_mode='original INTA/INTB enabled, nominal20MHz')
 for kind in ['jtag','mcu','i2c','ethernet','hdmi']:
  out=output/kind;out.mkdir();shutil.copytree(sources,out/'sources');(out/'analysis-sources').mkdir();shutil.copy2(Path(__file__),out/'analysis-sources'/Path(__file__).name)
  sources_list=['sources/'+name for name in manifest['sources']]+['analysis-sources/'+Path(__file__).name]
  notes=[];metrics=[]
  if kind=='jtag':
   shutil.copytree(work/'board-boundary01',out/'acquisition');shutil.copytree(work/'board-safe-final',out/'safe-final');passed=True;check=dict(pass_=True,static_gateware_links=168,static_boundary_links=168,static_vectors_per_path=338,restoration_safe_tests=safe)
   notes=['Legacy combined boundary wrapper reports ERROR because its post-restore HDMI check resets SYS. The independently rebuilt338vectors in each path all PASS and checksum-verified SRAM restoration is confirmed by fresh stable ADC/TDC transfers. This JTAG case is scoped to static links and restoration; the separate HDMI case remains FAIL']
   metrics=[dict(name='links_per_path',value=168,unit='connection'),dict(name='vectors_per_path',value=338,unit='vector')]
  elif kind in ['mcu','i2c']:
   shutil.copytree(work/'board-mcu01',out/'acquisition');passed=kind=='mcu' or power_pass;check=dict(pass_=passed,rails=rails if kind=='i2c' else [],walking_patterns=32 if kind=='mcu' else None)
   if kind=='mcu':
    assert any(v['command']=='@FPGATEST' and v['reply']=='FPGA TEST PASS 32 RESTORED\r\n' for v in mcu['records']);metrics=[dict(name='walking_patterns',value=32,unit='pattern')]
   else:
    for v in rails:metrics += [dict(name=v['rail']+'_voltage',value=v['voltage_V'],unit='V'),dict(name=v['rail']+'_nominal_current',value=v['current_A'],unit='A')]
    notes=['Firmware still labels R15/P3V8 current as not fitted. Owner confirmed R15 fitted; schematic R15=1mOhm, so host converts the retained signed13-bit shunt code at40uV/LSB. Original NA/status text is retained and no MCU firmware was changed. Route6/channel3 is unpopulated and excluded']
  elif kind=='ethernet':
   shutil.copytree(work/'board-safe-final',out/'acquisition');passed=True;check=safe;metrics=[dict(name='verified_ADC_payload',value=safe['payload_bytes'],unit='byte')]
  else:
   shutil.copytree(work/'board-resident01',out/'acquisition');shutil.copytree(work/'hdmi-reset-isolation',out/'isolation');shutil.copytree(work/'board-boundary01/post-restore',out/'repeat');passed=hdmi['pass_'];check=hdmi
   notes=['All four HDMI data lanes pass walking patterns, slow/fast PRBS and empty frames. Signature reads0/1/2 are correct, but SYS uptime resets when FPGA pads are released after SPI reads, before DIO direction restoration. Idle-only output enable/release does not reset. Two integrated runs and controlled isolation retain the failure; shared-MCU SPI release remains unqualified and is not assigned to a PM assembly defect without further isolation']
  write(out/'validation.json',check)
  receipt=dict(mode='LIVE',test=kind,board_uid=uid,measured_utc=mcu['identity']['observed_utc'],status='PASS' if passed else 'FAIL',protocol=dict(method='board-assembly-'+kind+'-v1',hardware_configuration=hardware,scope='separate static-link/CPU/sensor/network/HDMI cases; shared-SPI clock guard retained'),source_files=sources_list,validation=[dict(file='validation.json',key='pass_',equals=True)],metrics=metrics,curves=[],notes=notes,limits='Functional assembly evidence; no supply fault injection, calibrated current accuracy, Ethernet throughput/BER or unconnected analog-channel acceptance')
  # Board measurements occurred after the fitting identity. Use the actual source
  # observation for this case, not a later MCU timestamp for earlier acquisitions.
  if kind=='ethernet':receipt['measured_utc']=read(work/'hdmi-reset-isolation/status.json')['finished_utc']
  if kind=='hdmi':receipt['measured_utc']=read(work/'board-resident01/result.json')['identity']['observed_utc']
  elif kind=='jtag':receipt['measured_utc']=datetime.datetime.strptime(j['time_utc'],'%Y%m%dT%H%M%SZ').replace(tzinfo=datetime.timezone.utc).isoformat()
  write(out/'campaign-result.json',receipt);print(kind,receipt['status'],flush=True)

def main():
 p=argparse.ArgumentParser(description=__doc__)
 for key in ['work','sources','out','root']:p.add_argument('--'+key,type=Path,required=True)
 p.add_argument('--batch',required=True);a=p.parse_args();normalize(a.work,a.sources,a.out,a.root,a.batch)
if __name__=='__main__':main()
