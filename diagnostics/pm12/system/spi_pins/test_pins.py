#!/usr/bin/env python3
"""Leased temporary Kasli pin override; exact four-port image restored finally.

No SPI clocks with SEL high during raw tests. No output-direction reversal.
"""
import sys,subprocess,re
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from hold_spi import *
from host.hardware_test import identify,jtag
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--work',type=Path,required=True);p.add_argument('--output-name',default='hardware');args=p.parse_args();root=args.work;out=root/args.output_name;out.mkdir(exist_ok=False);(out/'executed.py').write_bytes(Path(__file__).read_bytes())
new=root/'candidate/gate_phase_qualified.bit';old=Path('/srv/codex-hil-nvme/pm12-cfd-four-20261110/kasli-qualified/gate_phase_qualified.bit')
assert hashlib.sha256(old.read_bytes()).hexdigest()=='a71a08a258620b0e5a52c5d03aefd8c69040c9d15e8de6391c484ac182b7173b'
q=json.loads((root/'candidate/qualification-values.json').read_text());assert q['wns_ns']>=0 and q['whs_ns']>=0 and q['drc_errors']==0 and q['differential_output_buffers']==10 and q['iserdes_count']==18
r=dict(started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),qualification=q,candidate_sha256=hashlib.sha256(new.read_bytes()).hexdigest(),old_sha256=hashlib.sha256(old.read_bytes()).hexdigest(),cases=[])
def save():(out/'result.json').write_text(json.dumps(r,indent=2)+'\n')
def reconnect():
 end=time.monotonic()+25
 while True:
  try:d=system.GatePhaseIPbusDevice();break
  except TimeoutError:
   if time.monotonic()>end:raise
 d.write(0x100,256);time.sleep(.05);d.write(0x100,0);d.write(0x120,1)
 d.write(0x144,1);HeldAdapter(d).stop();return d
with contextlib.ExitStack() as st:
 for n in sorted(['atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001']):st.enter_context(acquire(Path.home()/'.cache'/(n+'.lock')))
 u=st.enter_context(console(dict(uart='/dev/serial/by-id/usb-Prolific_Technology_Inc._USB-Serial_Controller-if00-port0')))
 r['pgood_before']=wait_power_good(u,capture);r['mcu_before']=capture(u,'RS');assert 'Board S/N: 1803' in r['mcu_before']['reply']
 c=system.Client();st.callback(c.close);r['pm_hdmi_mode']=c.read(0x301)[0];r['pm_identity']=c.read(0,3);assert r['pm_identity']==[0x504d1202,0x10002,0xc7531465]
 d=system.GatePhaseIPbusDevice();HeldAdapter(d).stop();assert d.read(0xe0)==0;r['old_hdmi_divider']=d.read(0x154);d.close();d=None
 usb=identify();r['usb']=usb;cmd='adapter usb location '+Path(usb['sysfs']).name+'; init; '
 def load(bit,label):jtag(cmd+'pld load 0 {'+str(bit)+'}; shutdown',label,out)
 try:
  save();load(new,'candidate-load');d=reconnect();assert d.read(0x17c)>>16==0x5350;assert d.read(0xd8)==0x43464434
  a=HeldAdapter(d)
  with hold_directions(a,a.mask) as state:r['directions']=state
  c.s.settimeout(.025);time.sleep(1)
  def pins(value):
   assert 0<=value<=7
   d.write(0x17c,8|value);z=d.read(0x17c);assert (z>>8)&255==8|value
  def snap():
   t=time.monotonic();v=dict(t=t,enable=d.read(0x144),state=d.read(0x150),pin_control=d.read(0x17c))
   try:
    z=c.read(5,2);v['ticks']=z[0]+(z[1]<<32)
   except TimeoutError:v['timeout']=True
   v['t_done']=time.monotonic();assert v['enable']==1 and v['state']&15==9;return v
  def case(label,lo,hi,cycles,delay):
   pins(lo);time.sleep(.1);row=dict(label=label,low=lo,high=hi,cycles=cycles,delay=delay,trace=[snap()]);r['cases'].append(row);save()
   for _ in range(cycles):
    pins(hi);row['trace'].append(snap());time.sleep(delay)
    pins(lo);row['trace'].append(snap());time.sleep(delay)
   for _ in range(30):time.sleep(.01);row['trace'].append(snap())
   v=[x for x in row['trace'] if 'ticks'in x];row['transport_timeouts']=sum(x.get('timeout',False) for x in row['trace']);row['counter_decreases']=sum(y['ticks']<x['ticks'] for x,y in zip(v,v[1:]));save();print(label,row['counter_decreases'],flush=True)
  def controls(label):
   d.write(0x17c,0);a.stop();rows=[];r[label]=rows
   for rep in range(4):
    for address in [0,1,2]:
     row=dict(address=address,repeat=rep,before=snap(),value=a.transfer(True,address));assert row['value']==[0x4844,0x4d49,1][address]
     time.sleep(.12);row['after']=snap();row['transport_timeout']=row['before'].get('timeout',False) or row['after'].get('timeout',False);row['counter_decrease']=row['after'].get('ticks',2**64)<row['before'].get('ticks',0);rows.append(row);save()
  r['pin_mapping']=[];baseline=None
  for value in [0,1,2,4,5,0]:
   before=snap();pins(value);time.sleep(.01);hw=capture(u,'@HW');after=snap()
   match=re.search(r'PORTS A[.][.]F=([0-9A-F]{12})',hw['reply']);assert match,hw
   port_d=int(match[1][6:8],16);bits=port_d&0xb0
   if baseline is None:baseline=bits
   expected=(0x10 if value&1 else 0)|(0x80 if value&2 else 0)|(0x20 if value&4 else 0)
   row=dict(value=value,port_d=port_d,expected_delta=expected,actual_delta=bits^baseline,reply=hw,before=before,after=after);r['pin_mapping'].append(row);save();assert row['actual_delta']==expected,row
  pins(0)
  controls('spi_control_before')
  pins(0)
  case('idle',0,0,10,.01)
  for rep in range(3):
   for bit,name in [(0,'SEL'),(1,'SCK'),(2,'MOSI')]:
    case(f'{name}-fast-{rep}',0,1<<bit,8,.001)
    case(f'{name}-slow-{rep}',0,1<<bit,4,.01)
   # MOSI transitions with SEL held high and SCK held LOW: no frame clocks.
   case(f'MOSI-selected-no-clock-{rep}',1,5,8,.001)
   pins(0)
  d.write(0x17c,0);assert (d.read(0x17c)>>8)&255==0
  controls('spi_control_after')
  r['completed']=True
 finally:
  c.s.settimeout(1)
  if d:
   try:d.write(0x17c,8) # manual LOW before reload; no PCF/OE changes
   finally:d.close();d=None
  load(old,'golden-restore');d=reconnect()
  try:
   d.write(0x154,r['old_hdmi_divider']);a=HeldAdapter(d)
   with hold_directions(a,a.mask) as state:r['final_directions']=state
   c.write(0x301,[r['pm_hdmi_mode']]);r['pm_after']=c.read(0,3);r['tdc_frontend']=c.read(0x205)[0];r['pgood_after']=require_power_good(u,capture);r['mcu_after']=capture(u,'RS');r['held_enable']=d.read(0x144);r['held_state']=d.read(0x150)
   gen,status=c.acquire(0,False);data=c.download(gen)
   from client import save_capture
   r['adc_final']=save_capture(out/'adc-final',data,0,False,gen,status);r['restored']=True
  finally:d.close();r['finished_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat();save()
