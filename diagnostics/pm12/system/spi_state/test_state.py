#!/usr/bin/env python3
"""Reset-independent SPI-state correlation with unchanged Kasli and exact PM restoration."""
import sys,subprocess
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from hold_spi import *
from station import jtag_command,read_dna,load_dependencies
sys.path.insert(0,str(BASE));from test_board import payload
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--work',type=Path,required=True);args=p.parse_args();root=args.work;out=root/'hardware';out.mkdir(exist_ok=False);(out/'executed.py').write_bytes(Path(__file__).read_bytes())
cfg=json.loads(Path('/srv/codex-hil-nvme/pm12-campaigns/PM12-K7-3A17A1B402212223/four-cfd-20261113/staging/board-station.json').read_text());cfg['jtag_workspace']=str(root/'jtag-work');load_dependencies(cfg)
new=root/'candidate/pm12_ipbus_adc.bit';gold=Path('/srv/codex-hil-nvme/pm12-tdc-clock40-20261114/candidate/pm12_ipbus_adc.bit');assert hashlib.sha256(gold.read_bytes()).hexdigest()=='4f0b3edba1271eed41757bc7f21845e43a4ecb2e2c023abe28f3b5770abc8c16'
q=json.loads((root/'candidate/qualification.json').read_text());assert q['pass'] and hashlib.sha256(new.read_bytes()).hexdigest()==q['bit_sha256'];newid=int(q['build_id'],16)
r=dict(started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),qualification=q,blocks=[])
def save():(out/'result.json').write_text(json.dumps(r,indent=2)+'\n')
def connect(expected):
 c=system.Client();end=time.monotonic()+20
 while True:
  try:
   if c.read(0,3)==[0x504d1202,0x10002,expected]:return c
  except TimeoutError:pass
  if time.monotonic()>end:c.close();raise TimeoutError('PM identity')
  time.sleep(.1)
with contextlib.ExitStack() as st:
 for n in sorted(['atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001']):st.enter_context(acquire(Path.home()/'.cache'/(n+'.lock')))
 d=system.GatePhaseIPbusDevice();st.callback(d.close);a=HeldAdapter(d);a.stop();assert d.read(0xe0)==0
 r['kasli']=dict(cfd=d.read(0xd8),map=d.read(0x15c),enable=d.read(0x144),state=d.read(0x150));r['old_divider']=d.read(0x154);d.write(0x154,600)
 with console(cfg) as preflight_uart:
  pg=wait_power_good(preflight_uart,capture);mcu=capture(preflight_uart,'RS');assert 'Board S/N: 1803'in mcu['reply']
 preflight=connect(0xc7531465)
 try:
  before=preflight.read(5,2);dna=read_dna(cfg,out);after=preflight.read(5,2);assert int(dna,16)==int('3A17A1B402212223',16);assert after[0]+(after[1]<<32)>=before[0]+(before[1]<<32)
  r['identity_before']=dict(uid='PM12-K7-3A17A1B402212223',dna=dna,fpga=preflight.read(0,3),mcu=mcu,pgood=pg)
 finally:preflight.close()
 save()
 with console(cfg) as u:
  r['pgood_before']=wait_power_good(u,capture)
  with jtag_command(cfg,out) as prefix:
   s=(BASE/'adc/tools/load_fpga.tcl').read_text().replace('source [file join [file dirname [info script]] common.tcl]','source '+str(BASE/'adc/tools/common.tcl')).replace('0x504dad01','0x504d5a04');(out/'load.tcl').write_text(s)
   def load(bit,label):
    bits=payload(bit,out/'payload.hex')
    with (out/(label+'.log')).open('w') as log:subprocess.run(prefix+['-mode','batch','-nolog','-nojournal','-notrace','-source',str(out/'load.tcl'),'-tclargs',cfg['jtag_cable'],cfg['hw_server'],str(out/'payload.hex'),str(bits)],stdout=log,stderr=subprocess.STDOUT,check=True,timeout=300)
    (out/'payload.hex').unlink();assert 'LOAD_PASS'in(out/(label+'.log')).read_text()
   c=None
   try:
    load(new,'candidate-load');c=connect(newid);c.s.settimeout(.1);assert c.read(0x380)==[0x53504932]
    assert c.read(0x380)==[0x53504932] and c.read(0x383)==[40078700] and c.read(0x384)==[0x30002]
    def frame(address):
     assert address in [0,1,2]
     return a.transfer(True,address)
    def trace(label,divider,address):
     a.stop();d.write(0x154,divider);assert d.read(0x154)==divider
     row=dict(label=label,divider=divider,address=address,uptime_before=c.read(5,2),kasli_before=d.read(0x150));r['trials'].append(row);save()
     seen=c.read(0x381)[0]&0x1000
     try:c.write(0x380,[0x41524d31])
     except TimeoutError:row['arm_ack_timeout']=True
     end=time.monotonic()+5
     while True:
      try:status=c.read(0x381)[0]
      except TimeoutError:
       if time.monotonic()>end:raise
       continue
      if status&0x1000!=seen and status&3:break
      if time.monotonic()>end:raise TimeoutError('Observer ARM not acknowledged')
     time.sleep(.005)
     if address is not None:
      row['signature']=frame(address);assert row['signature']==[0x4844,0x4d49,1][address]
     row['kasli_after_frame']=d.read(0x150)
     while True:
      try:status=c.read(0x381)[0]
      except TimeoutError:
       if time.monotonic()>end:raise
       continue
      if status&2:break
      if time.monotonic()>end:raise TimeoutError('Observer did not freeze')
      time.sleep(.01)
     count=c.read(0x382)[0];assert 1<=count<=512
     words=c.block(0x8000,count*3);assert c.read(0x381)==[status] and c.read(0x382)==[count]
     row.update(status=status,count=count,raw_words=words,kasli_final=d.read(0x150))
     (out/(label+'.json')).write_text(json.dumps(row,indent=2)+'\n');save()
     try:row['uptime_after']=c.read(5,2)
     except TimeoutError:row['uptime_after_timeout']=True
     save();print(label,hex(status),count,flush=True)
    r.pop('blocks');r['trials']=[];time.sleep(.5)
    trace('idle-before',600,None)
    for divider in [600,601,602,60,61,62,6000,6001,6002]:
     for repeat in range(2):
      for address in [0,1,2]:trace(f'div{divider}-rep{repeat}-read{address}',divider,address)
    trace('idle-after',600,None)
    r['completed']=True;save()
   except BaseException as e:r['error']=repr(e);save();raise
   finally:
    if c:c.close()
    load(gold,'golden-restore');c=connect(0xc7531465);r['restored']=True;save()
    try:
     d.write(0x154,r['old_divider']);a.stop();r['identity_after']=c.read(0,3);r['frontend_ready']=c.read(0x205)[0];r['pgood_after']=require_power_good(u,capture)
     from client import save_capture
     r['adc_attempts']=[]
     for attempt in range(2):
      gen,status=c.acquire(0,False);raw=c.download(gen)
      try:
       r['adc_final']=save_capture(out/f'adc-final-{attempt}',raw,0,False,gen,status);r['adc_attempts'].append(dict(pass_=True));break
      except ValueError as error:r['adc_attempts'].append(dict(pass_=False,error=str(error)));save()
     r['adc_validated']=bool(r.get('adc_final'))
    finally:c.close();r['finished_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat();save();a.stop()
