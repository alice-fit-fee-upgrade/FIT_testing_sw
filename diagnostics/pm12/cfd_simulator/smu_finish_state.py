#!/usr/bin/env python3
"""Leased, explicit post-scan verification: SMU OFF/HIZ and four monitor muxes off."""
import argparse,contextlib,datetime,json,sys
from pathlib import Path
P=Path(__file__).resolve().parents[1]
sys.path[:0]=[str(P/'acceptance'),str(P/'cfd_simulator'),'/home/codex-hil/FIT_PM_FW_uPC/tools/hardware','/home/codex-hil/lab-instruments']
from lease import acquire
from station import console
from console import ConsoleI2C,Registers
from mcp23017 import MCP23017Monitor,afe_route
from pm12_power import wait_power_good
from pm12_console_regression import capture
from channel_settings import require_serial_reply
from labinstruments.transport import Transport
from labinstruments.drivers import Driver

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--directory',type=Path,required=True);p.add_argument('--connected',nargs=4,type=int,required=True);a=p.parse_args()
 assert len(set(a.connected))==4 and all(1<=ch<=12 for ch in a.connected)
 path=a.directory/'post-cleanup.json';assert not path.exists()
 report=dict(pass_=False,started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),connected_modules=a.connected)
 source=a.directory/'post-cleanup-source.py';source.write_text(Path(__file__).read_text())
 try:
  with contextlib.ExitStack() as st:
   for n in sorted(['atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001','b2910bl-MY63320299']):st.enter_context(acquire(Path.home()/'.cache'/(n+'.lock')))
   io=st.enter_context(Transport(dict(kind='tcp',host='192.168.2.19',port=5025,timeout=8,delay=.01)))
   d=Driver(io,'b2910bl','MY63320299');report['identity']=d.identify();d.off()
   u=st.enter_context(console(dict(uart='/dev/serial/by-id/usb-Prolific_Technology_Inc._USB-Serial_Controller-if00-port0')))
   report['pgood']=wait_power_good(u,capture);report['mcu']=capture(u,'RS');require_serial_reply(report['mcu']['reply'],'1803');bus=ConsoleI2C(u,capture)
   report['tca_before']={str(addr):bus.mux(addr) for addr in (0x70,0x71)};pins={}
   for ch in a.connected:
    with bus.routed(*afe_route(ch)):
     regs=Registers(bus);MCP23017Monitor(regs).initialize_monitor().off();pins[str(ch)]=regs.read(18);assert pins[str(ch)]&8
   for addr in (0x70,0x71):bus.mux(addr,0)
   report['final_tca']={str(addr):bus.mux(addr) for addr in (0x70,0x71)};report['monitor_GPIOA']=pins;report['i2c_records']=bus.records
   report['smu_settings']={q:io.query(q) for q in ['OUTP?','OUTP:ON:AUTO?','OUTP:OFF:MODE?','SOUR:FUNC:MODE?','SOUR:CURR?','SENS:REM?','SYST:ERR?']}
   s=report['smu_settings'];assert s['OUTP?']=='0' and s['OUTP:ON:AUTO?']=='0' and s['OUTP:OFF:MODE?']=='HIZ' and s['SOUR:FUNC:MODE?']=='CURR' and float(s['SOUR:CURR?'])==0 and s['SENS:REM?']=='0' and int(s['SYST:ERR?'].split(',')[0])==0
   assert set(report['final_tca'].values())=={0};report['pass_']=True
 except BaseException as e:report['error']=repr(e);raise
 finally:report['finished_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat();path.write_text(json.dumps(report,indent=2)+'\n')
 print('SMU_FINAL_STATE_PASS',flush=True)
if __name__=='__main__':main()
