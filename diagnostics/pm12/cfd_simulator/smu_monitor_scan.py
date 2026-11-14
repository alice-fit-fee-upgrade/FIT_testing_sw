#!/usr/bin/env python3
"""Four shared CFD monitor muxes, all eight inputs, SMU0A/local sensing."""
import argparse,contextlib,datetime,json,os,signal,sys,time
from pathlib import Path
P=Path(__file__).resolve().parents[1];sys.path[:0]=[str(P/'acceptance'),str(P/'cfd_simulator'),'/home/codex-hil/FIT_PM_FW_uPC/tools/hardware','/home/codex-hil/lab-instruments']
from lease import acquire
from station import console
from console import ConsoleI2C,Registers
from mcp23017 import MCP23017Monitor,afe_route,report_voltage
from pm12_power import wait_power_good,require_power_good
from pm12_console_regression import capture
from channel_settings import snapshot_sources,require_serial_reply,connected_channels
from labinstruments.transport import Transport
from labinstruments.drivers import Driver
from smu_voltage import parse_voltage

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--out',type=Path,required=True);p.add_argument('--connected',nargs=4,type=int,required=True);a=p.parse_args();channels,_=connected_channels(a.connected)
 out=a.out;out.mkdir(parents=True,exist_ok=False);r=dict(pass_=False,connected_modules=channels,started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),readings=[],commands=[],dac_zero=[],gpio_before={},gpio_final={})
 r['executed_sources']=snapshot_sources(out,['__main__','lease','station','console','mcp23017','control','pm12_power','pm12_console_regression','channel_settings','labinstruments.transport','labinstruments.drivers','smu_voltage'])
 def save():
  tmp=out/'scan-report.json.tmp';tmp.write_text(json.dumps(r,indent=2)+'\n');os.replace(tmp,out/'scan-report.json')
 def stop(signum,frame):raise KeyboardInterrupt('Termination signal '+str(signum))
 signal.signal(signal.SIGTERM,stop)
 with contextlib.ExitStack() as st:
  for name in sorted(['atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001','b2910bl-MY63320299']):st.enter_context(acquire(Path.home()/'.cache'/(name+'.lock')))
  io=st.enter_context(Transport(dict(kind='tcp',host='192.168.2.19',port=5025,timeout=8,delay=.01)));meter=Driver(io,'b2910bl','MY63320299');r['identity']=meter.identify();meter.off()
  u=st.enter_context(console(dict(uart='/dev/serial/by-id/usb-Prolific_Technology_Inc._USB-Serial_Controller-if00-port0')));r['pgood']=wait_power_good(u,capture);r['mcu']=capture(u,'RS');require_serial_reply(r['mcu']['reply'],'1803');bus=ConsoleI2C(u,capture)
  def q(command):
   value=io.query(command);r['commands'].append(dict(query=command,reply=value));return value
  def w(command):io.write(command);r['commands'].append(dict(write=command))
  def gpio(regs):return {str(k):regs.read(k) for k in [0,1,0x14,0x15]}
  def off_all(final=False):
   for ch in channels:
    with bus.routed(*afe_route(ch)):
     regs=Registers(bus)
     if not final:r['gpio_before'][str(ch)]=gpio(regs)
     MCP23017Monitor(regs).initialize_monitor().off();assert regs.read(0x12)&8
     if final:r['gpio_final'][str(ch)]=gpio(regs)
  try:
   for addr in [0x70,0x71]:bus.mux(addr,0)
   off_all();w('ABOR');w('OUTP:ON:AUTO OFF')
   r['initial_errors']=[]
   for _ in range(10):
    error=q('SYST:ERR?');r['initial_errors'].append(error)
    if int(error.split(',')[0])==0:break
   for command in ['SOUR:FUNC:MODE CURR','SOUR:CURR:MODE FIX','SOUR:CURR 0','SOUR:CURR:RANG 1e-6','SENS:VOLT:PROT 6','SENS:REM OFF','SENS:FUNC "VOLT"','SENS:VOLT:RANG:AUTO OFF','SENS:VOLT:RANG 20','SENS:VOLT:NPLC 1','TRIG:ACQ:SOUR AINT','TRIG:ACQ:COUN 1','FORM:ELEM:SENS VOLT,TIME,STAT']:
    w(command);assert int(q('SYST:ERR?').split(',')[0])==0
   r['settings']={key:q(key) for key in ['OUTP?','OUTP:ON:AUTO?','SOUR:FUNC:MODE?','SOUR:CURR?','SENS:REM?','SENS:VOLT:RANG?','SENS:VOLT:NPLC?']};assert r['settings']['OUTP?']=='0' and r['settings']['SOUR:FUNC:MODE?']=='CURR' and float(r['settings']['SOUR:CURR?'])==0 and r['settings']['SENS:REM?']=='0'
   for ch in channels:
    for dac in 'BCD':
     row=capture(u,f'@DAC {ch} W {dac} 0000');r['dac_zero'].append(row);assert row['reply'].strip()==f'DAC SENT {dac} 0000'
   w('OUTP ON');assert q('OUTP?')=='1';save()
   for ch in channels:
    require_power_good(u,capture)
    with bus.routed(*afe_route(ch)):
     regs=Registers(bus);mux=MCP23017Monitor(regs).initialize_monitor()
     try:
      for selection in range(8):
       mux.select(selection);pins=regs.read(0x12);assert pins&15==[0,4,2,6,1,5,3,7][selection]
       time.sleep(.2);assert q('OUTP?')=='1';values=[parse_voltage(q('READ?')) for _ in range(3)]
       row=dict(physical_channel=ch,mux_channel=selection,gpioa=pins,samples=[dict(volts=v,instrument_time=t,status=status) for v,t,status in values]);r['readings'].append(row);save();print(ch,selection,report_voltage(selection,sum(v[0] for v in values)/3),flush=True)
     finally:mux.off()
   r['pass_']=True
  except BaseException as error:r['error']=repr(error);raise
  finally:
   try:
    meter.off();off_all(final=True)
    for addr in [0x70,0x71]:bus.mux(addr,0)
    r['final_tca']={str(addr):bus.mux(addr) for addr in [0x70,0x71]};r['final_smu']={key:q(key) for key in ['OUTP?','OUTP:ON:AUTO?','OUTP:OFF:MODE?','SOUR:FUNC:MODE?','SOUR:CURR?','SENS:REM?','SYST:ERR?']}
   finally:r['i2c_records']=bus.records;r['finished_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat();save()
 print('MONITOR_SCAN_COMPLETE',flush=True)
if __name__=='__main__':main()
