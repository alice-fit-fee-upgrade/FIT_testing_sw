import sys,contextlib,subprocess,json,time,hashlib,re,datetime
from pathlib import Path
sys.path.insert(0,'/home/codex-hil/fit-testing-publish/diagnostics/pm12/system')
from hold_spi import *
from station import jtag_command,identify,load_dependencies
sys.path.insert(0,str(BASE))
from test_board import payload
root=Path(__file__).parent;out=root/'hardware';out.mkdir(exist_ok=False);(out/'executed.py').write_bytes(Path(__file__).read_bytes())
cfg=json.loads(Path('/srv/codex-hil-nvme/pm12-campaigns/PM12-K7-3A17A1B402212223/four-cfd-20261113/staging/board-station.json').read_text());cfg['jtag_workspace']=str(root/'jtag-work');load_dependencies(cfg)
golden=Path(cfg['boundary']['restore_bit']);candidate=root/'candidate/pm12_ipbus_adc.bit';assert hashlib.sha256(golden.read_bytes()).hexdigest()=='1dbafd99033f803a086d4153ed3d873adfc9b4208b806785f00d3024bdfbf1ac'
q=json.loads((root/'candidate/qualification.json').read_text());assert q['pass'] and hashlib.sha256(candidate.read_bytes()).hexdigest()==q['bit_sha256']
new_id=int(json.loads((root/'source/observer-build.json').read_text())['build_id'],16)
r={'started_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'trials':[],'bit_sha256':q['bit_sha256']}
def save():(out/'result.json').write_text(json.dumps(r,indent=2)+'\n')
def connect_pm(expected):
 c=system.Client()
 for _ in range(15):
  try:
   if c.read(0,3)==[0x504d1202,0x10002,expected]:return c
  except (TimeoutError,OSError):pass
  time.sleep(.1)
 c.close();raise RuntimeError('Expected PM identity not recovered')
with contextlib.ExitStack() as st:
 for n in sorted(['atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001']):st.enter_context(acquire(Path.home()/'.cache'/(n+'.lock')))
 d=system.GatePhaseIPbusDevice();st.callback(d.close);a=HeldAdapter(d);a.stop()
 r['identity']=identify(cfg,out);assert r['identity']['identity']['uid']=='PM12-K7-3A17A1B402212223';save()
 with jtag_command(cfg,out) as prefix:
  source=(BASE/'adc/tools/load_fpga.tcl').read_text().replace('source [file join [file dirname [info script]] common.tcl]','source '+str(BASE/'adc/tools/common.tcl')).replace('0x504dad01','0x504d5a04');(out/'load.tcl').write_text(source)
  def load(bit,label):
   bits=payload(bit,out/'payload.hex')
   with (out/(label+'.log')).open('w') as log:subprocess.run(prefix+['-mode','batch','-nolog','-nojournal','-notrace','-source',str(out/'load.tcl'),'-tclargs',cfg['jtag_cable'],cfg['hw_server'],str(out/'payload.hex'),str(bits)],stdout=log,stderr=subprocess.STDOUT,check=True,timeout=300)
   (out/'payload.hex').unlink();assert 'LOAD_PASS' in (out/(label+'.log')).read_text()
  try:
   load(candidate,'candidate-load');c=connect_pm(new_id)
   try:
    assert c.read(0x380)==[0x434c4b31]
    # No UART or PLL access during trace trials; no changes to Kasli directions/OE.
    for index,address in enumerate([None,0,1,2,0,1]):
     a.stop();t={'address':address,'uptime_before':c.read(5,2),'mcu_before':c.read(0x20,2)};r['trials'].append(t);save()
     c.write(0x380,[0x41524d31]);time.sleep(.01);assert c.read(0x381)[0]&1
     if address is not None:t['signature']=a.transfer(True,address)
     end=time.monotonic()+12
     while True:
      try:status=c.read(0x381)[0]
      except TimeoutError:
       if time.monotonic()>end:raise
       continue
      if status&2:break
      if time.monotonic()>end:raise TimeoutError('Independent trace did not freeze')
      time.sleep(.02)
     count=c.read(0x382)[0];assert 0<count<=512
     words=c.block(0x8000,count*2);assert c.read(0x381)==[status] and c.read(0x382)==[count]
     t.update(status=status,count=count,raw_words=words,uptime_after=c.read(5,2),mcu_after=c.read(0x20,2),events=[{'tick':words[i],'state':words[i+1]&127,'ref_age':(words[i+1]>>7)&511,'max_ref_age':words[i+1]>>16} for i in range(0,len(words),2)])
     (out/f'trace{index:02d}.json').write_text(json.dumps(t,indent=2)+'\n');save();print(address,hex(status),count,flush=True)
   finally:c.close()
  finally:
   # Always return PM SRAM to exact golden diagnostic; Kasli remains driven.
   load(golden,'golden-restore');c=connect_pm(0xc7c42d28)
   try:
    a.stop();r['final']={'identity':c.read(0,3),'mcu':c.read(0x20,2),'uptime':c.read(5,2),'enable':d.read(0x144),'state':d.read(0x150)}
    gen,status=c.acquire(0,False);r['final']['adc_generation']=gen;r['final']['adc_status']=status
   finally:c.close();r['finished_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat();save()
