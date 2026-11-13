import sys,contextlib,json,time,datetime
from pathlib import Path
sys.path.insert(0,'/home/codex-hil/fit-testing-publish/diagnostics/pm12/system')
from hold_spi import *
out=Path('/srv/codex-hil-nvme/pm12-hdmi-held-isolate-20261113');out.mkdir(exist_ok=False);(out/'executed.py').write_bytes(Path(__file__).read_bytes());r={'trace':[],'started_utc':datetime.datetime.now(datetime.timezone.utc).isoformat()}
with contextlib.ExitStack() as st:
 for n in sorted(['atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001']):st.enter_context(acquire(Path.home()/'.cache'/(n+'.lock')))
 u=st.enter_context(console(dict(uart='/dev/serial/by-id/usb-Prolific_Technology_Inc._USB-Serial_Controller-if00-port0')));r['pgood']=wait_power_good(u,capture)
 d=system.GatePhaseIPbusDevice();st.callback(d.close);c=system.Client();st.callback(c.close);assert c.read(0,3)==[0x504d1202,0x10002,0xc7c42d28]
 a=HeldAdapter(d);a.stop()
 def snap(label):
  x=dict(label=label,seconds=time.monotonic(),uptime=c.read(5,2),mcu_scratch=c.read(0x20,2),scratch=c.read(3,2),enable=d.read(0x144),state=d.read(0x150),mode=c.read(0x301));r['trace'].append(x);(out/'result.json').write_text(json.dumps(r,indent=2)+'\n');print(x,flush=True)
 snap('initial held')
 for i in range(4):time.sleep(.25);snap('idle '+str(i))
 # Keep card directions unchanged; already held from preceding test.
 for mode in [0,15,1,2,4,8,5,10,0x30,0x20,0x10,0]:
  snap('before mode '+str(mode));c.write(0x301,[mode]);time.sleep(.05);snap('after mode '+str(mode))
 for address in [0,1,2]:
  snap('before SPI '+str(address));value=a.transfer(True,address);snap('after SPI '+str(address));r.setdefault('spi',[]).append([address,value]);time.sleep(.1);snap('settled SPI '+str(address))
 for i in range(4):time.sleep(.25);snap('final idle '+str(i))
 r['pgood_after']=require_power_good(u,capture);r['mcu_status']=capture(u,'RS');r['finished_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat();(out/'result.json').write_text(json.dumps(r,indent=2)+'\n')
