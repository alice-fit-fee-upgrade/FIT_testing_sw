import sys,contextlib,json,time,datetime
from pathlib import Path
sys.path.insert(0,'/home/codex-hil/fit-testing-publish/diagnostics/pm12/system')
from hold_spi import *
out=Path(__file__).parent;r={'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'measurements':[]};(out/'executed-measure.py').write_bytes(Path(__file__).read_bytes())
with contextlib.ExitStack() as st:
 for n in sorted(['atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001']):st.enter_context(acquire(Path.home()/'.cache'/(n+'.lock')))
 d=system.GatePhaseIPbusDevice();st.callback(d.close);c=system.Client();st.callback(c.close);a=HeldAdapter(d);a.stop();r['identity']=c.read(0,3);assert r['identity']==[0x504d1202,0x10002,0xc7c42d28]
 def snap():
  t=time.monotonic();k=d.read(0x10c);ref=d.read(0x110);p=c.read(5,2);end=time.monotonic();return {'time_mid':(t+end)/2,'span_s':end-t,'kasli_sys':k,'kasli_pm_ref':ref,'pm_sys':p[0]+(p[1]<<32)}
 for i in range(3):
  x=snap();time.sleep(2);y=snap();dt=y['time_mid']-x['time_mid'];r['measurements'].append({'before':x,'after':y,'elapsed_s':dt,'kasli_sys_hz':((y['kasli_sys']-x['kasli_sys'])&0xffffffff)/dt,'kasli_pm_ref_hz':((y['kasli_pm_ref']-x['kasli_pm_ref'])&0xffffffff)/dt,'pm_sys_hz':(y['pm_sys']-x['pm_sys'])/dt})
 r['held']=[d.read(0x144),d.read(0x150)];assert r['held']==[1,9]
 u=st.enter_context(console(dict(uart='/dev/serial/by-id/usb-Prolific_Technology_Inc._USB-Serial_Controller-if00-port0')));r['pgood']=wait_power_good(u,capture);r['mcu_status']=capture(u,'RS')
 # No @PLL command or SPI probe. Existing frozen raw ADC buffers are read-only.
 r['adc_cap_count_metadata']=c.read(0x13,2)
(out/'counters.json').write_text(json.dumps(r,indent=2)+'\n')
for x in r['measurements']:print({k:round(v,1) for k,v in x.items() if k.endswith('_hz')})
