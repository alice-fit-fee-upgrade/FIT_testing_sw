"""Native IPbus2 client for the CERN controller; requests are never emulated."""
import socket,struct,time,json,array,statistics
from pathlib import Path
import sys
sys.path.insert(0,str(Path(__file__).resolve().parent))
from adc_decode import decode
class Client:
 def __init__(self,host='192.168.2.240',port=50001,order='>'):
  self.s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);self.s.connect((host,port));self.s.settimeout(1);self.order=order;self.tid=0;self.read_retry_events=[]
 def transact(self,kind,address,values=None,count=1,allow_error=False):
  assert 1<=count<=255
  header=0x20000000|((self.tid&4095)<<16)|(count<<8)|(kind<<4)|15;self.tid=(self.tid+1)&4095
  request=[0x200000f0,header,address]+list(values or [])
  self.s.send(struct.pack(self.order+str(len(request))+'I',*request));deadline=time.monotonic()+2
  while time.monotonic()<deadline:
   data=self.s.recv(4096)
   if len(data)%4:raise RuntimeError('unaligned IPbus reply')
   words=list(struct.unpack(self.order+str(len(data)//4)+'I',data))
   if len(words)<2 or words[0]!=request[0] or (words[1]&0xffff00f0)!=(header&0xffff00f0):continue
   error=words[1]&15
   if error and not allow_error:raise RuntimeError('IPbus bus error '+str(error)+' at '+hex(address))
   if not error and (words[1]&0xffffff00)!=(header&0xffffff00):raise RuntimeError('IPbus count mismatch')
   return words if allow_error else words[2:]
  raise TimeoutError('No matching transaction')
 def read(self,address,count=1,increment=True):
  # Register and frozen-memory reads have no side effects. Writes/RMW/ARM
  # are never automatically retried; a lost write reply stays an error.
  for attempt in range(3):
   try:return self.transact(0 if increment else 2,address,count=count)
   except TimeoutError:
    self.read_retry_events.append({'address':address,'count':count,'attempt':attempt})
    if attempt==2:raise
 def write(self,address,values,increment=True):return self.transact(1 if increment else 3,address,values,count=len(values))
 def block(self,address,count):
  data=[]
  for i in range(0,count,128):data+=self.read(address+i,min(128,count-i))
  return data
 def acquire(self,bank=0,pattern=False):
  old=self.read(0x12)[0];self.write(0x10,[1|(bank<<1)|(int(pattern)<<8)]);end=time.monotonic()+2
  while time.monotonic()<end:
   state=self.read(0x11)[0]
   if state&1 and not state&2:
    ident=self.read(0x12)[0];assert ident==(old+1)&0xffffffff
    assert state&12==12 and ((state>>4)&1)==int(pattern) and ((state>>5)&1)==bank
    return ident,state
   if state&64:raise RuntimeError('Acquisition timeout/MMCM loss')
   time.sleep(.001)
  raise TimeoutError('capture not complete')
 def download(self,ident):
  result=[self.block(0x10000+ch*0x1000,4096) for ch in range(12)]
  assert self.read(0x12)==[ident],'Capture changed during download'
  return result
 def close(self):self.s.close()
def describe(data,bank,pattern):
 rows=[]
 for ch,v in enumerate(data):
  assert len(v)==4096 and all(0<=n<65536 for n in v)
  if pattern:
   assert v==[i^(ch*0x1111)^(bank<<15) for i in range(4096)],('pattern mismatch',ch)
   rows.append({'channel':ch+1,'kind':'synthetic transport validation','samples':len(v)})
  else:
   tags=[(n>>12)&1 for n in v];assert all(t==bank for t in tags),('EV selector mismatch',ch)
   samples,timing=decode(v,bank)
   hz=80000000
   codes=[n&4095 for n in v];rows.append({'channel':ch+1,'kind':'physical CPLD/ADC inputs','clock_hz_nominal':hz,'strobe_timing':timing,'selector':bank,'adc_min':min(codes),'adc_max':max(codes),'adc_mean':statistics.mean(codes),'adc_stddev':statistics.pstdev(codes),'unique_codes':len(set(codes))})
 return rows
def save_capture(root,data,bank,pattern,ident,status):
 root=Path(root);root.mkdir(parents=True,exist_ok=False)
 for ch,v in enumerate(data):
  (root/f'ch{ch+1:02d}.bin').write_bytes(struct.pack('<4096H',*v))
 summary={'capture_id':ident,'status':status,'bank':bank,'synthetic':pattern,'format':'12files each4096little-endianu16; ADC bits0..11,EV12,STR13 for physical mode','sample_rate_nominal_hz':320000000,'channels':describe(data,bank,pattern)}
 (root/'summary.json').write_text(json.dumps(summary,indent=2)+'\n');return summary

if __name__=='__main__':
 import argparse
 p=argparse.ArgumentParser(description='Read a frozen PM12 ADC capture through standard IPbus2. No acquisition by default.')
 p.add_argument('--host',default='192.168.2.240');p.add_argument('--out',type=Path,required=True)
 p.add_argument('--acquire',action='store_true',help='arm a new capture; real ADC mode requires the programmed CPLD mux image')
 p.add_argument('--bank',type=int,choices=[0,1],default=0);p.add_argument('--pattern',action='store_true')
 a=p.parse_args()
 import fcntl
 leases=[]
 for name in ['atmel-ice-J41800043065','pm12-210249A73E43']:
  f=(Path.home()/'.cache'/(name+'.lock')).open('a+');fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB);leases.append(f)
 c=Client(a.host)
 try:
  if c.read(0)!=[0x504d1202]:raise RuntimeError('Unexpected endpoint identity')
  if a.acquire:ident,state=c.acquire(a.bank,a.pattern)
  else:
   state=c.read(0x11)[0];ident=c.read(0x12)[0]
   if not state&1 or state&2:raise RuntimeError('No frozen completed capture available')
  data=c.download(ident);summary=save_capture(a.out,data,(state>>5)&1,bool(state&16),ident,state)
  print(json.dumps(summary,indent=2))
 finally:c.close()
