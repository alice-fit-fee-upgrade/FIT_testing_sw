#!/usr/bin/env python3
"""Finite PM12 TDC clock40 retest; slot6 HDMI SPI stays driven throughout.

Physical mapping is verified with discovery, then count controls,25phase
positions and quiet windows. Old results/contracts are not imported or replaced.
"""
import argparse,contextlib,datetime,json,math,signal,struct,sys,time,hashlib,shutil
from pathlib import Path
from collections import Counter
BASE=Path(__file__).resolve().parents[2]
sys.path[:0]=[str(BASE/'acceptance'),str(BASE/'ipbus_adc'),str(BASE/'cfd_simulator'),str(BASE/'system'),'/home/codex-hil/kasli-phase-tester','/home/codex-hil/FIT_PM_FW_uPC/tools/hardware']
from hold_spi import HeldAdapter
from lease import acquire as lease
from station import console
from pm12_power import wait_power_good,require_power_good
from pm12_console_regression import capture
from host.pm_tdc_test import acquire,Client
from host.cfd_pattern import CFDBurstDevice,pattern_words
from host.gate_phase_ipbus import GatePhaseIPbusDevice
from host.lvds8_dio import dio_directions

class HeldCFD(CFDBurstDevice):
 def stop(self):
  self.device.write(0xe0,0)
  if self.device.read(0xe0):raise RuntimeError('CFD transmitter did not stop')
  # Never call the legacy global Device.stop(): it releases HDMI SPI too.
  HeldAdapter(self.device).stop()
class RoutedBurst(HeldCFD):
 def __init__(self,device,port):
  super().__init__(device);assert device.read(0xd8)==0x43464434;self.port=port;self.mask=1<<(4*port)
  self.stop();device.write(0xdc,port);assert device.read(0xdc)==port
 def directions(self,mask):
  if mask!=self.mask:raise ValueError('Wrong CFD direction')
  self.idle()
 def upload_patch(self,words):
  if not hasattr(self,'bank_images'):
   self.upload(words);self.bank_images=[list(words),None];self.active_shadow=0;return
  target=1-self.active_shadow;previous=self.bank_images[target]
  if previous is None or len(previous)!=len(words):self.upload(words)
  else:
   assert not self.device.read(0xe4)&0x1c
   for i,(a,b) in enumerate(zip(previous,words)):
    if a!=b:self.device.write(0xe8,i);self.device.write(0xec,b)
   self.device.write(0xf0,len(words));end=time.monotonic()+.5
   while self.device.read(0xe4)&8:
    if time.monotonic()>end:raise TimeoutError('CFD commit')
   assert not self.device.read(0xe4)&16
  self.bank_images[target]=list(words);self.active_shadow=target
class Slot7Inputs:
 slot=7
 def __init__(self,d):self.d=d
 def stop(self):self.d.write(0xe0,0);HeldAdapter(self.d).stop()
 def directions(self,mask):
  if mask:raise ValueError('Input-only helper')
  assert self.d.read(0xe0)==0

def stats(words,mod):
 hist=Counter(w%mod for w in words);x=sum(n*math.cos(2*math.pi*k/mod) for k,n in hist.items());y=sum(n*math.sin(2*math.pi*k/mod) for k,n in hist.items());mean=math.atan2(y,x)*mod/(2*math.pi)%mod
 return {'mean_circular':mean,'std_circular':math.sqrt(sum(n*((k-mean+mod/2)%mod-mod/2)**2 for k,n in hist.items())/len(words)),'histogram':dict(hist)}

def run(d,c,u,out,expected_build,channels=(12,11,10,9)):
 out.mkdir(parents=True,exist_ok=False);(out/'executed-retest.py').write_bytes(Path(__file__).read_bytes())
 r={'started_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'expected_channels':channels,'expected_build':f'{expected_build:08x}','sample_hz_assumed':40.0787e6*24,'pass':False,'captures':[],'statistics':[],'mapping':{},'scope':'New clock-corrected functional acquisition; no absolute TDC calibration'}
 sources={}
 for name,module in list(sys.modules.items()):
  f=getattr(module,'__file__',None)
  if f and Path(f).suffix=='.py' and any(Path(f).resolve().is_relative_to(root) for root in [BASE,Path('/home/codex-hil/kasli-phase-tester'),Path('/home/codex-hil/FIT_PM_FW_uPC/tools/hardware')]):
   target=out/'sources'/(name+'.py');target.parent.mkdir(exist_ok=True);shutil.copy2(f,target);sources[name]={'original':str(Path(f).resolve()),'sha256':hashlib.sha256(Path(f).read_bytes()).hexdigest()}
 r['source_versions']=sources
 def save():(out/'status.json').write_text(json.dumps(r,indent=2)+'\n')
 def hold():HeldAdapter(d).stop()
 def timed_capture(label,burst=None,count=0,phase=None,ch=None,port=None):
  before=c.read(5,2);row=acquire(c,out,label,burst,count,phase);after=c.read(5,2);row.update(pm_uptime_before=before,pm_uptime_after=after,port=port,expected_channel=ch);r['captures'].append(row);save();hold()
  if after[0]+(after[1]<<32)<before[0]+(before[1]<<32):raise RuntimeError('SYS reset during TDC capture')
  expected=[0]*12
  if ch is not None:expected[ch-1]=count
  if row['counts']!=expected:raise RuntimeError('Count/crosstalk mismatch '+repr(row['counts']))
  return row
 try:
  hold();r['identity']=c.read(0,3);assert r['identity']==[0x504d1202,0x10002,expected_build]
  assert d.read(0xd8)==0x43464434 and d.read(0x120)&1
  r['pgood']=wait_power_good(u,capture);r['mcu']=capture(u,'RS');assert 'Board S/N: 1803' in r['mcu']['reply']
  end=time.monotonic()+10
  while c.read(0x205)!=[0xfff]:
   if time.monotonic()>end:raise TimeoutError('TDC frontends not ready')
   time.sleep(.01)
  # Service only slot7. Leave slot6 mask/OE untouched.
  with dio_directions(Slot7Inputs(d),0):pass
  for port,ch in enumerate(channels):
   burst=RoutedBurst(d,port)
   with dio_directions(burst,burst.mask):
    timed_capture(f'p{port}-quiet-before',port=port)
    burst.upload_patch(pattern_words(1200,24,20))
    row=timed_capture(f'p{port}-discover',burst,16,24,ch,port);r['mapping'][port]={'physical_channel':ch,'discovery_counts':row['counts']};save()
    for count in [1,64,512,1024]:timed_capture(f'p{port}-count{count}',burst,count,24,ch,port)
    for phase in range(24,49):
     require_power_good(u,capture);burst.upload_patch(pattern_words(1200,phase,20));row=timed_capture(f'p{port}-phase{phase:02d}',burst,128,phase,ch,port)
     words=list(struct.unpack('<128H',(out/row['label']/f'tdc{ch:02d}.bin').read_bytes()));assert all(w<8192 for w in words)
     r['statistics'].append({'channel':ch,'port':port,'phase_bin':phase,'delay_ns':(phase-24)/r['sample_hz_assumed']*1e9,'count':128,'fine':stats(words,128),'coarse':stats([w>>7 for w in words],64),'label':row['label']});save()
    timed_capture(f'p{port}-quiet-after',port=port)
  r['pass']=True
 except BaseException as error:r['error']=repr(error);raise
 finally:
  try:
   d.write(0xe0,0);d.write(0xdc,0);hold()
   r['final']={'pm_build':c.read(2)[0],'tdc_status':c.read(0x201)[0],'frontend_ready':c.read(0x205)[0],'kasli_hdmi_enable':d.read(0x144),'kasli_hdmi_state':d.read(0x150),'cfd_enable':d.read(0xe0),'cfd_port':d.read(0xdc)}
   r['pgood_after']=require_power_good(u,capture)
   if any(hashlib.sha256(Path(v['original']).read_bytes()).hexdigest()!=v['sha256'] for v in sources.values()):raise RuntimeError('Measurement sources changed during acquisition')
  except BaseException as error:r['cleanup_error']=repr(error);r['pass']=False;raise
  finally:r['finished_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat();save()
 return r

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--out',type=Path,required=True);p.add_argument('--expected-build',type=lambda s:int(s,16),required=True);a=p.parse_args()
 with contextlib.ExitStack() as st:
  for name in sorted(['atmel-ice-J41800043065','kasli-diot-00001','pm12-210249A73E43']):st.enter_context(lease(Path.home()/'.cache'/(name+'.lock')))
  u=st.enter_context(console({'uart':'/dev/serial/by-id/usb-Prolific_Technology_Inc._USB-Serial_Controller-if00-port0'}));d=GatePhaseIPbusDevice();st.callback(d.close);c=Client();st.callback(c.close);run(d,c,u,a.out,a.expected_build)
if __name__=='__main__':main()
