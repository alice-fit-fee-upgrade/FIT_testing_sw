"""Four physical CFD inputs; discovered mapping and finite one-ns phase scan."""
import argparse,sys,json,contextlib,time,collections,math
from pathlib import Path
P=Path(__file__).resolve().parents[1];sys.path[:0]=[str(P/'acceptance'),str(P/'ipbus_adc'),str(P/'tdc_live120'),'/home/codex-hil/kasli-phase-tester','/home/codex-hil/FIT_PM_FW_uPC/tools/hardware']
from lease import acquire as lease
from station import console
from pm12_power import wait_power_good,require_power_good
from pm12_console_regression import capture
from host.pm_tdc_test import acquire,Client
from host.cfd_pattern import CFDBurstDevice,pattern_words
from host.gate_phase_ipbus import GatePhaseIPbusDevice
from host.lvds8_dio import dio_directions
from host.gate_phase_dio import input_cards
class RoutedBurst(CFDBurstDevice):
 def __init__(self,device,port):
  super().__init__(device);assert device.read(0xd8)==0x43464434;self.port=port;self.mask=1<<(4*port)
  self.stop();device.write(0xdc,port);assert device.read(0xdc)==port
 def directions(self,mask):
  if mask!=self.mask:raise ValueError('Wrong selected CFD port direction')
  assert self.device.read(0xdc)==self.port;self.idle()
 def upload_patch(self,words):
  # Commit flips the RAM bank: compare against the INACTIVE bank's image.
  # Comparing only with the last transmitted pattern can leave stale pulse bits.
  if not hasattr(self,'bank_images'):
   self.upload(words);self.bank_images=[list(words),None];self.active_shadow=0
   return
  target=1-self.active_shadow;previous=self.bank_images[target]
  if previous is None or len(previous)!=len(words):self.upload(words)
  else:
   assert not self.device.read(0xe4)&0x1c
   for i,(a,b) in enumerate(zip(previous,words)):
    if a!=b:self.device.write(0xe8,i);self.device.write(0xec,b)
   self.device.write(0xf0,len(words))
   end=time.monotonic()+.5
   while self.device.read(0xe4)&8:
    if time.monotonic()>end:raise TimeoutError('Commit patch')
   assert not self.device.read(0xe4)&16
  self.bank_images[target]=list(words);self.active_shadow=target
parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--out',type=Path,required=True);parser.add_argument('--channels',type=int,nargs='+',default=[12,10,8,6]);args=parser.parse_args()
if not 1<=len(args.channels)<=4 or len(set(args.channels))!=len(args.channels) or any(c not in range(1,13) for c in args.channels):parser.error('One to four distinct PM channels1..12 required')
out=args.out.resolve();out.mkdir(parents=True,exist_ok=False)
report={'pass_':False,'mapping':{},'captures':[],'statistics':[],'sample_hz_assumed':40.0787e6*24,'stimulus':'128 finite pulses at each of 25 phase positions, step one OSERDES bit; no TDC time calibration','expected_channels':args.channels}
def save():(out/'status.json').write_text(json.dumps(report,indent=2)+'\n')
def statistics(row):
 words=[]
 import struct
 ch=row['expected_channel'];raw=(out/row['label']/f'tdc{ch:02d}.bin').read_bytes();words=list(struct.unpack('<%dH'%(len(raw)//2),raw))
 hist=collections.Counter(w&127 for w in words)
 if not words:raise RuntimeError('No requested TDC records')
 sx=sum(n*math.cos(2*math.pi*k/128) for k,n in hist.items());sy=sum(n*math.sin(2*math.pi*k/128) for k,n in hist.items());mean=(math.atan2(sy,sx)*128/(2*math.pi))%128
 spread=math.sqrt(sum(n*((k-mean+64)%128-64)**2 for k,n in hist.items())/len(words))
 return {'channel':ch,'port':row['port'],'phase_bin':row['phase_bin'],'delay_ns':(row['phase_bin']-24)/report['sample_hz_assumed']*1e9,'fine_mean_circular':mean,'fine_std_circular':spread,'fine_histogram':dict(hist),'coarse_histogram':dict(collections.Counter(w>>7 for w in words)),'count':len(words),'label':row['label']}
with contextlib.ExitStack() as st:
 for n in sorted(['atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001']):st.enter_context(lease(Path.home()/'.cache'/(n+'.lock')))
 u=st.enter_context(console({'uart':'/dev/serial/by-id/usb-Prolific_Technology_Inc._USB-Serial_Controller-if00-port0'}));report['pg']=wait_power_good(u,capture);report['mcu']=capture(u,'RS');assert 'Board S/N: 1803' in report['mcu']['reply']
 d=GatePhaseIPbusDevice();st.callback(d.close);c=Client();st.callback(c.close)
 assert c.read(0,3)==[0x504d1202,0x10002,0xc7c42d28] and c.read(0x205)==[0xfff]
 assert d.read(0xd8)==0x43464434 and d.read(0x120)&1
 report['tdc_id_registers']=[capture(u,f'@TDC {n} 83') for n in range(3)]
 report['directions_before']=input_cards(d)
 try:
  for port,ch in enumerate(report['expected_channels']):
   burst=RoutedBurst(d,port)
   with dio_directions(burst,burst.mask):
    quiet=acquire(c,out,f'p{port}-quiet-before');report['captures'].append(quiet)
    burst.upload_patch(pattern_words(1200,24,20))
    row=acquire(c,out,f'p{port}-discover',burst,16,24);row.update(port=port,expected_channel=ch);report['captures'].append(row)
    expected=[0]*12;expected[ch-1]=16
    if row['counts']!=expected:save();raise RuntimeError('CFD mapping/count mismatch: '+repr(row['counts']))
    report['mapping'][port]={'physical_channel':ch,'dio_channel':4*port,'discovery_counts':row['counts']};save()
    for phase in range(24,49):
     require_power_good(u,capture);burst.upload_patch(pattern_words(1200,phase,20))
     row=acquire(c,out,f'p{port}-phase{phase:02d}',burst,128,phase);row.update(port=port,expected_channel=ch);report['captures'].append(row)
     expected=[0]*12;expected[ch-1]=128
     if row['counts']!=expected:save();raise RuntimeError('Unexpected count/crosstalk: '+repr(row['counts']))
     report['statistics'].append(statistics(row));save()
    quiet=acquire(c,out,f'p{port}-quiet-after');report['captures'].append(quiet);assert quiet['counts']==[0]*12
  report['pg_final']=require_power_good(u,capture);report['pass_']=True
 finally:
  d.write(0xe0,0);d.stop();d.write(0xdc,0);report['directions_final']=input_cards(d);report['final']={'cfd_enabled':d.read(0xe0),'selected_port':d.read(0xdc),'pm_build':c.read(2)[0],'tdc_status':c.read(0x201)[0]};save()
print('FOUR_TDC_SCAN_PASS',flush=True)
