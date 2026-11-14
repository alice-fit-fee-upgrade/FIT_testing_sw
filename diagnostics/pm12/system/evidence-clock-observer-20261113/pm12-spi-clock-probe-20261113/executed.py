import sys,contextlib,json,time,datetime
from pathlib import Path
sys.path.insert(0,'/home/codex-hil/fit-testing-publish/diagnostics/pm12/system')
from hold_spi import *
out=Path('/srv/codex-hil-nvme/pm12-spi-clock-probe-20261113');out.mkdir();(out/'executed.py').write_bytes(Path(__file__).read_bytes());r={'started_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'trials':[]}
def save():(out/'result.json').write_text(json.dumps(r,indent=2)+'\n')
with contextlib.ExitStack() as st:
 for n in sorted(['atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001']):st.enter_context(acquire(Path.home()/'.cache'/(n+'.lock')))
 u=st.enter_context(console(dict(uart='/dev/serial/by-id/usb-Prolific_Technology_Inc._USB-Serial_Controller-if00-port0')));r['pgood']=wait_power_good(u,capture)
 d=system.GatePhaseIPbusDevice();st.callback(d.close);c=system.Client();st.callback(c.close);assert c.read(0,3)==[0x504d1202,0x10002,0xc7c42d28];a=HeldAdapter(d);a.stop()
 r['pll_before']=capture(u,'@PLL');r['hw_before']=capture(u,'@HW');save()
 def sample():
  return dict(seconds=time.monotonic(),uptime=c.read(5,2),mcu=c.read(0x20,2),writes=c.read(4)[0],enable=d.read(0x144),state=d.read(0x150))
 for divider,address in [(600,None),(600,0),(600,0),(600,1),(600,1),(600,2),(600,2),(2400,0),(2400,1),(2400,2)]:
  a.stop();d.write(0x154,divider);t={'divider':divider,'address':address,'before':sample(),'samples':[]};r['trials'].append(t);save()
  if address is not None:t['value']=a.transfer(True,address)
  end=time.monotonic()+.35
  while time.monotonic()<end:t['samples'].append(sample());time.sleep(.005)
  t['after']=sample();t['hw']=capture(u,'@HW');t['pll']=capture(u,'@PLL');t['after_telemetry']=sample();save()
  vals=[t['before']]+t['samples']+[t['after'],t['after_telemetry']];ticks=[x['uptime'][0]+(x['uptime'][1]<<32) for x in vals];t['restarted']=any(y<x for x,y in zip(ticks,ticks[1:]));save();print(divider,address,t['restarted'],t['hw']['reply'].strip(),t['pll']['reply'].strip(),flush=True)
 # Retain original divider; no OE or direction writes.
 d.write(0x154,600);a.stop();r['final']=sample();r['pgood_after']=require_power_good(u,capture);r['finished_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat();save()
