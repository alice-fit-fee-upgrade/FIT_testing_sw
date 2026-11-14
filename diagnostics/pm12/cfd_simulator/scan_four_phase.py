"""Acquire DAC-A phase responses; caller must establish appropriate CPLD gate mode.
No FPGA/CPLD programming; explicitly initialize/restore DAC A=0.
"""
import datetime,signal
import argparse,contextlib,sys,json,gzip,time,math,csv
from pathlib import Path
P=Path(__file__).resolve().parents[1];sys.path[:0]=[str(P/'acceptance'),str(P/'cfd_simulator'),str(P/'ipbus_adc'),'/home/codex-hil/kasli-phase-tester','/home/codex-hil/FIT_PM_FW_uPC/tools/hardware']
from lease import acquire
from station import console
from phase_scan import ConsoleDAC
from phase_estimator import estimate,scan_codes,wrapped_delta
from console import ConsoleI2C,Registers
from mcp23017 import afe_route,MCP23017Monitor
from pm12_console_regression import capture
from pm12_power import wait_power_good,require_power_good
from host.gate_phase_ipbus import GatePhaseIPbusDevice
from host.gate_phase_dio import input_cards
from host.hdmi_check import check_phase_records
from client import Client as PMClient
from channel_settings import snapshot_sources

def snapshot_local_sources(out):
 roots=[P.resolve(),Path('/home/codex-hil/kasli-phase-tester').resolve(),Path('/home/codex-hil/FIT_PM_FW_uPC/tools/hardware').resolve()]
 names=[]
 for name,module in list(sys.modules.items()):
  value=getattr(module,'__file__',None)
  if value and Path(value).suffix=='.py' and any(Path(value).resolve().is_relative_to(root) for root in roots):names.append(name)
 return snapshot_sources(out,sorted(names))
def terminated(signum,frame):raise KeyboardInterrupt('Termination signal '+str(signum))
signal.signal(signal.SIGTERM,terminated)
parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--out',type=Path,required=True);parser.add_argument('--channels',type=int,nargs='+',default=[12,10,8,6]);parser.add_argument('--intervals',type=int,default=100);args=parser.parse_args()
if len(set(args.channels))!=len(args.channels) or any(c not in range(1,13) for c in args.channels):parser.error('Distinct PM channels1..12 required')
scan_codes(args.intervals)
out=args.out.resolve();out.mkdir(parents=True,exist_ok=False);report={'started_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'executed_sources':snapshot_local_sources(out),'pass_':False,'channels':args.channels,'points':[],'console':[],'clock_hz_assumed':40.0787e6,'note':'DAC-A codes are explicitly initialized/restored to zero; no hardware DAC readback; counter phase may change after power cycles.'}
def save():(out/'status.json').write_text(json.dumps(report,indent=2)+'\n')
with contextlib.ExitStack() as st:
 for n in sorted(['atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001']):st.enter_context(acquire(Path.home()/'.cache'/(n+'.lock')))
 u=st.enter_context(console({'uart':'/dev/serial/by-id/usb-Prolific_Technology_Inc._USB-Serial_Controller-if00-port0'}));report['pg']=wait_power_good(u,capture);report['mcu']=capture(u,'RS');assert 'Board S/N: 1803' in report['mcu']['reply']
 d=GatePhaseIPbusDevice();st.callback(d.close);pm=PMClient();st.callback(pm.close);report['pm_identity']=pm.read(0,3);assert report['pm_identity']==[0x504d1202,0x10002,0xc7c42d28];assert d.read(0xd8)==0x43464434;d.stop();report['directions']=input_cards(d);bus=ConsoleI2C(u,capture)
 try:
  report['monitor_inhibit']={}
  for ch in report['channels']:
   require_power_good(u,capture)
   with bus.routed(*afe_route(ch)):
    regs=Registers(bus);m=MCP23017Monitor(regs);mux=m.initialize_monitor();report['monitor_inhibit'][ch]={'iodira':regs.read(0),'olata':regs.read(0x14)};assert regs.read(0x14)&8
  for ch in report['channels']:
   dac=ConsoleDAC(u,ch,capture,lambda row:report['console'].append(row));require_power_good(u,capture);dac.set_code(0)
  for ch in report['channels']:
   dac=ConsoleDAC(u,ch,capture,lambda row:report['console'].append(row))
   try:
    for index,code in enumerate(scan_codes(args.intervals)):
     require_power_good(u,capture);dac.set_code(code);time.sleep(.1)
     data=d.capture(4095,channels=list(range(8,16)))
     with gzip.open(out/f'ch{ch:02d}-{index:03d}-{code:05d}.json.gz','wt') as f:json.dump(data,f)
     row={'afe':ch,'code':code,'index':index,'lanes':{}}
     for lane in data['channels']:
      check_phase_records(lane)
      try:e=estimate([lane],1e12/(40.0787e6*24),24,edge_period_bins=48);row['lanes'][lane['logical']]=e
      except ValueError as error:row['lanes'][lane['logical']]={'error':str(error),'high_samples':sum(w.bit_count() for w in lane['words'])}
     report['points'].append(row);save();print('CH',ch,'DAC',code,'phases',{k:round(v.get('mean_ns',-1),3) for k,v in row['lanes'].items()},flush=True)
   finally:
    require_power_good(u,capture);dac.set_code(0);report.setdefault('restored_zero',[]).append(ch);save()
  report['pg_final']=require_power_good(u,capture);report['pass_']=True
 finally:
  d.write(0xe0,0);d.stop();d.write(0xdc,0);report['final_directions']=input_cards(d);report['i2c']=bus.records;report['tca_final']={str(a):bus.mux(a) for a in [0x70,0x71]};report['finished_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat();save()
print('GATE_SCAN_PASS',flush=True)
