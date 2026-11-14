#!/usr/bin/env python3
"""Trace SYS during long allowlisted SPI reads, holding all Kasli outputs driven."""
import sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parent))
from hold_spi import *
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--out',type=Path,required=True);args=p.parse_args();out=args.out;out.mkdir(parents=True,exist_ok=False);(out/'executed.py').write_bytes(Path(__file__).read_bytes());r=dict(started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),runs=[])
def save():(out/'result.json').write_text(json.dumps(r,indent=2)+'\n')
with contextlib.ExitStack() as st:
 for n in sorted(['atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001']):st.enter_context(acquire(Path.home()/'.cache'/(n+'.lock')))
 u=st.enter_context(console(dict(uart='/dev/serial/by-id/usb-Prolific_Technology_Inc._USB-Serial_Controller-if00-port0')));r['pgood_before']=wait_power_good(u,capture)
 d=system.GatePhaseIPbusDevice();st.callback(d.close);c=system.Client();st.callback(c.close);assert c.read(0,3)==[0x504d1202,0x10002,0xc7531465]
 a=HeldAdapter(d);a.stop();divider=d.read(0x154);initial=c.read(0x301)[0]
 try:
  c.write(0x301,[0]);d.write(0x154,65535)
  for rep in range(3):
   for address in [0,1,2]:
    row=dict(address=address,repeat=rep,trace=[]);r['runs'].append(row)
    def sample():
     v=dict(t=time.monotonic(),state=d.read(0x150),enable=d.read(0x144))
     try:
      z=c.read(5,2);v['ticks']=z[0]+(z[1]<<32)
     except TimeoutError:v['timeout']=True
     v['t_done']=time.monotonic();v['state_after']=d.read(0x150)
     row['trace'].append(v);assert v['enable']==1 and v['state']&9==9
    sample();seq=d.read(0x158);row['start']=time.monotonic();d.write(0x148,(1<<31)|(address<<22));deadline=time.monotonic()+.18
    while time.monotonic()<deadline:sample();time.sleep(.001)
    assert d.read(0x158)==(seq+1)&0xffffffff
    row['signature']=d.read(0x14c)&65535;assert row['signature']==[0x4844,0x4d49,1][address]
    valid=[v for v in row['trace'] if 'ticks' in v];events=[]
    for x,y in zip(valid,valid[1:]):
     if y['ticks']<x['ticks']:events.append(dict(previous=x,current=y))
    row['restarts']=events;save();print(address,len(events),[bool(e['current']['state']&2) for e in events],flush=True)
 finally:
  c.write(0x301,[initial]);d.write(0x154,divider);a.stop();r['pgood_after']=require_power_good(u,capture);r['mcu_after']=capture(u,'RS');r['identity_after']=c.read(0,3);r['frontend_ready']=c.read(0x205)[0]
  gen,status=c.acquire(0,False);data=c.download(gen)
  from client import save_capture
  r['adc_final']=save_capture(out/'adc-final',data,0,False,gen,status);r['finished_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat();save()
