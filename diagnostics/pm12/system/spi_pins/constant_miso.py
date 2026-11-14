#!/usr/bin/env python3
"""Constant-zero MISO diagnostic read3; no writes or buffer reversal.

The retained PM hdmi_slave.v contents(3)=0. This is an isolated diagnostic
register read, not a write to an external peripheral. Repeated read3 leaves
shift-register MISO zero while selected; physical output still gates with SEL.
"""
import sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from hold_spi import *
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--out',type=Path,required=True);args=p.parse_args();out=args.out;out.mkdir(exist_ok=False);(out/'executed.py').write_bytes(Path(__file__).read_bytes());r=dict(started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),trials=[])
def save():(out/'result.json').write_text(json.dumps(r,indent=2)+'\n')
with contextlib.ExitStack() as st:
 for n in sorted(['atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001']):st.enter_context(acquire(Path.home()/'.cache'/(n+'.lock')))
 u=st.enter_context(console(dict(uart='/dev/serial/by-id/usb-Prolific_Technology_Inc._USB-Serial_Controller-if00-port0')));r['pgood_before']=wait_power_good(u,capture)
 d=system.GatePhaseIPbusDevice();st.callback(d.close);c=system.Client();st.callback(c.close);assert c.read(0,3)==[0x504d1202,0x10002,0xc7531465]
 a=HeldAdapter(d);a.stop();assert d.read(0x17c)>>16!=0x5350 # exact original Kasli restored
 divider=d.read(0x154)
 def snap():
  row=dict(t=time.monotonic(),enable=d.read(0x144),state=d.read(0x150))
  try:
   x=c.read(5,2);row['ticks']=x[0]+(x[1]<<32)
  except TimeoutError:row['timeout']=True
  row['t_done']=time.monotonic();return row
 def read(address):
  assert address in [0,1,2,3]
  before=d.read(0x158);d.write(0x148,(1<<31)|(address<<22));end=time.monotonic()+1
  while d.read(0x158)==before:
   if time.monotonic()>end:raise TimeoutError('SPI sequence')
  assert d.read(0x158)==(before+1)&0xffffffff
  value=d.read(0x14c)&65535;assert value==[0x4844,0x4d49,1,0][address];a.stop();return value
 try:
  d.write(0x154,600)
  for address,count in [(3,13),(0,6),(1,6),(2,6),(3,12)]:
   for i in range(count):
    row=dict(address=address,index=i,warmup=address==3 and i==0,trace=[snap()]);r['trials'].append(row);save();row['readback']=read(address)
    for _ in range(20):time.sleep(.005);row['trace'].append(snap())
    v=[x for x in row['trace'] if 'ticks'in x];row['counter_decreases']=sum(y['ticks']<x['ticks']for x,y in zip(v,v[1:]));row['timeouts']=sum(x.get('timeout',False)for x in row['trace']);save();print(address,i,row['counter_decreases'],row['timeouts'],flush=True)
  r['completed']=True
 finally:
  try:
   d.write(0x154,divider);a.stop();r['pgood_after']=require_power_good(u,capture);r['identity_after']=c.read(0,3);r['frontend_ready']=c.read(0x205)[0]
   gen,status=c.acquire(0,False);data=c.download(gen)
   from client import save_capture
   r['adc_final']=save_capture(out/'adc-final',data,0,False,gen,status);r['finished_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat();save()
  except BaseException as error:
   r['postflight_error']=repr(error);raise
  finally:
   r['finished_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat();save()
