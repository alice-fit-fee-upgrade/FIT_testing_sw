import sys,contextlib,json,time
from pathlib import Path
from collections import Counter
sys.path.insert(0,'/home/codex-hil/fit-testing-publish/diagnostics/pm12/system')
from hold_spi import *
root=Path(__file__).parent;(root/'executed-local-clocks.py').write_bytes(Path(__file__).read_bytes());r={}
with contextlib.ExitStack() as st:
 for n in sorted(['atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001']):st.enter_context(acquire(Path.home()/'.cache'/(n+'.lock')))
 d=system.GatePhaseIPbusDevice();st.callback(d.close);c=system.Client();st.callback(c.close);a=HeldAdapter(d);a.stop();assert c.read(0,3)==[0x504d1202,0x10002,0xc7c42d28]
 gen,status=c.acquire(0,False);words=c.block(0x1b000,4096);r['adc_ch12']={'generation':gen,'status':status,'raw':words}
 rises=[i for i in range(1,len(words)) if not words[i-1]&8192 and words[i]&8192];r['adc_ch12']['rise_gaps_cap_ticks']=dict(Counter(b-a for a,b in zip(rises,rises[1:])))
 ticket=d.arm_test(512);d.trigger();end=time.monotonic()+3
 while not (d.status()['valid'] and d.read(0x64)==ticket['generation']):
  if time.monotonic()>end:raise TimeoutError('Kasli gate capture')
 for lane in [8,9]:
  raw=d.client.block(0x10000+(lane<<12),512);bits=[(w>>i)&1 for w in raw for i in range(8)];edges=[i for i in range(1,len(bits)) if bits[i] and not bits[i-1]];r['gate_lane'+str(lane)]={'raw':raw,'rise_gaps_sample_ticks':dict(Counter(b-a for a,b in zip(edges,edges[1:])))}
 a.stop();r['held']=[d.read(0x144),d.read(0x150)];r['pm_uptime']=c.read(5,2)
(root/'local-clocks.json').write_text(json.dumps(r,indent=2)+'\n')
print({k:{a:b for a,b in v.items() if a!='raw'} if isinstance(v,dict) else v for k,v in r.items()})
