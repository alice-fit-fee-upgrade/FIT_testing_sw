import sys,contextlib,json,time,datetime
from pathlib import Path
sys.path.insert(0,'/home/codex-hil/fit-testing-publish/diagnostics/pm12/system')
from hold_spi import *
out=Path('/srv/codex-hil-nvme/pm12-spi-no-mcu-20261113');out.mkdir();(out/'executed.py').write_bytes(Path(__file__).read_bytes());r={'started_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'trials':[],'scope':'No UART/PLL command, no OE/direction/clock register write in test; live MCU background remains running'}
def save():(out/'result.json').write_text(json.dumps(r,indent=2)+'\n')
with contextlib.ExitStack() as st:
 for n in sorted(['atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001']):st.enter_context(acquire(Path.home()/'.cache'/(n+'.lock')))
 d=system.GatePhaseIPbusDevice();st.callback(d.close);c=system.Client();st.callback(c.close);assert c.read(0,3)==[0x504d1202,0x10002,0xc7c42d28];a=HeldAdapter(d);a.stop();assert d.read(0x154)==600
 def sample():return dict(seconds=time.monotonic(),uptime=c.read(5,2),mcu=c.read(0x20,2),enable=d.read(0x144),state=d.read(0x150))
 for addr in [None,0,None,1,None,2,None,0,1,2]:
  t={'address':addr,'samples':[sample()]};r['trials'].append(t);save()
  if addr is not None:t['value']=a.transfer(True,addr)
  end=time.monotonic()+.3
  while time.monotonic()<end:t['samples'].append(sample());time.sleep(.01)
  ticks=[x['uptime'][0]+(x['uptime'][1]<<32) for x in t['samples']];t['restarted']=any(y<x for x,y in zip(ticks,ticks[1:]));save();print(addr,t['restarted'],flush=True)
 a.stop();r['final']=sample();r['finished_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat();save()
