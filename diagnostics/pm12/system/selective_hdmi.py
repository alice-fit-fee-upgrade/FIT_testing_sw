#!/usr/bin/env python3
"""Selective resident-image HDMI test; no global STOP, OE, direction or PLL writes.

Each PM data output is exercised independently. SPI tests are coupled frames,
not individual SPI pin overrides. Three allowlisted read addresses only.
"""
import sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parent))
from hold_spi import *

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--out',type=Path,required=True);args=p.parse_args();out=args.out;out.mkdir(parents=True,exist_ok=False)
 (out/'executed.py').write_bytes(Path(__file__).read_bytes());r=dict(started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),cases=[],limitations='Individual SPI pins are not independently controllable in the resident master. No causal SEL/SCK/MOSI attribution from coupled frames.')
 def save():(out/'result.json').write_text(json.dumps(r,indent=2)+'\n')
 with contextlib.ExitStack() as st:
  for n in sorted(['atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001']):st.enter_context(acquire(Path.home()/'.cache'/(n+'.lock')))
  u=st.enter_context(console(dict(uart='/dev/serial/by-id/usb-Prolific_Technology_Inc._USB-Serial_Controller-if00-port0')))
  r['pgood_before']=wait_power_good(u,capture);r['mcu_before']=capture(u,'RS');assert 'Board S/N: 1803' in r['mcu_before']['reply']
  d=system.GatePhaseIPbusDevice();st.callback(d.close);c=system.Client();st.callback(c.close)
  r['identity']=c.read(0,3);assert r['identity']==[0x504d1202,0x10002,0xc7531465]
  a=HeldAdapter(d);a.stop();assert a.mask==0xb0
  initial=c.read(0x301)[0];divider=d.read(0x154)
  def snap():
   t=time.monotonic()
   try:
    v=c.read(5,2);return dict(t=t,ticks=v[0]+(v[1]<<32),enable=d.read(0x144),state=d.read(0x150))
   except TimeoutError:
    return dict(t=t,transport_timeout=True,enable=d.read(0x144),state=d.read(0x150))
  def run(label,fn,**meta):
   row=dict(label=label,**meta,trace=[snap()]);r['cases'].append(row);save()
   fn(row)
   for i in range(20):time.sleep(.005);row['trace'].append(snap())
   valid=[x for x in row['trace'] if 'ticks' in x];row['transport_timeouts']=sum(x.get('transport_timeout',False) for x in row['trace']);pairs=list(zip(valid,valid[1:]));row['sys_restart']=any(y['ticks']<x['ticks'] for x,y in pairs)
   row['outputs_held']=all(x['enable']==1 and x['state']&15==9 for x in row['trace']);assert row['outputs_held']
   save();print(label,'RESET' if row['sys_restart'] else 'stable',flush=True)
  def mode(v):
   try:c.write(0x301,[v])
   except TimeoutError:
    if c.read(0x301)!=[v]:raise
  try:
   mode(0);time.sleep(.15)
   for rep in range(3):
    run(f'idle-{rep}',lambda row:time.sleep(.1),group='idle',repeat=rep)
    for bit in range(4):
     def wave(row,bit=bit):
      for n in range(20):
       mode(1<<bit);row['trace'].append(snap());time.sleep(.002)
       mode(0);row['trace'].append(snap());time.sleep(.002)
     run(f'lvds-bit{bit}-{rep}',wave,group='lvds-single',bit=bit,repeat=rep,cycles=20)
   for div in [60,600,6000]:
    d.write(0x154,div)
    for rep in range(3):
     for addr in [0,1,2]:
      def frame(row,addr=addr):
       row['signature']=a.transfer(True,addr);row['trace'].append(snap());assert row['signature']==[0x4844,0x4d49,1][addr]
      run(f'spi-div{div}-addr{addr}-{rep}',frame,group='spi-frame',divider=div,address=addr,repeat=rep)
   r['completed']=True
  finally:
   # Only idempotent mode/divider restoration. No STOP or OE changes.
   mode(initial);d.write(0x154,divider);a.stop()
   r['pgood_after']=require_power_good(u,capture);r['mcu_after']=capture(u,'RS')
   r['frontend_ready']=c.read(0x205)[0];r['final']=snap();r['mode_restored']=c.read(0x301)[0]
   r['finished_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat();save()
if __name__=='__main__':main()
