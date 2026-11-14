#!/usr/bin/env python3
"""A/B HDMI parser hold-reset with unchanged Kasli; exact PM fallback finally."""
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
    load(new,'candidate-load');c=connect(newid);c.s.settimeout(.1);assert c.read(0x305)==[0x53520000]
    # Invalid hold writes must be rejected without altering the mode or state.
    mode=c.read(0x301)[0];reply=c.transact(1,0x305,values=[2],allow_error=True);assert reply[1]&15 and c.read(0x305)==[0x53520000] and c.read(0x301)==[mode]
    r['invalid_hold_rejected']=True
    def read_hold():
     end=time.monotonic()+5
     while True:
      try:return c.read(0x305)[0]
      except TimeoutError:
       if time.monotonic()>end:raise
       time.sleep(.02)
    def set_hold(v):
     a.stop()
     try:c.write(0x305,[v])
     except TimeoutError:
      if read_hold()!=0x53520000|v:raise
     assert read_hold()==0x53520000|v
    def snap():
     row=dict(t=time.monotonic(),enable=d.read(0x144),state=d.read(0x150))
     try:
      x=c.read(5,2);row['ticks']=x[0]+(x[1]<<32)
     except TimeoutError:row['timeout']=True
     row['t_done']=time.monotonic();assert row['enable']==1 and row['state']&15==9;return row
    def frame(address):
     assert address in [0,1,2,3]
     seq=d.read(0x158);d.write(0x148,(1<<31)|(address<<22));end=time.monotonic()+1
     while d.read(0x158)==seq:
      if time.monotonic()>end:raise TimeoutError('SPI completion')
     assert d.read(0x158)==(seq+1)&0xffffffff;a.stop();return d.read(0x14c)&65535
    # Mixed controls, then matched-zero A/B blocks: same read3 stimulus/MISO.
    schedule=[('signatures-before',0,[0,1,2]*4)]
    schedule += [(f'matched-zero-{i}',v,[3]*16)for i,v in enumerate([0,1,0,1,1,0])]
    schedule += [('held-signatures',1,[0,1,2]*4),('signatures-after',0,[0,1,2]*4)]
    for label,held,addresses in schedule:
     set_hold(0);frame(3) # prime all-zero MISO in normal mode before switching
     set_hold(held);time.sleep(.15);block=dict(label=label,held=held,frames=[]);r['blocks'].append(block);save()
     for address in addresses:
      row=dict(address=address,trace=[snap()]);block['frames'].append(row);save();row['readback']=frame(address)
      assert row['readback']==(0 if held else [0x4844,0x4d49,1,0][address])
      for _ in range(20):time.sleep(.005);row['trace'].append(snap())
      v=[x for x in row['trace']if'ticks'in x];row['counter_decreases']=sum(y['ticks']<x['ticks']for x,y in zip(v,v[1:]));row['timeouts']=sum(x.get('timeout',False)for x in row['trace']);save()
     block['hold_after']=read_hold();assert block['hold_after']==0x53520000|held;save();print(label,held,sum(x['counter_decreases']for x in block['frames']),sum(x['timeouts']for x in block['frames']),flush=True)
    set_hold(0);r['completed']=True;save()
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
