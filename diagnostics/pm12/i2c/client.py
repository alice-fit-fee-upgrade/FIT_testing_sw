import socket,struct,time,json
class Bus:
 def __init__(self):
  self.s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);self.s.connect(('192.168.2.240',40000));self.s.settimeout(.3);self.seq=0;self.mask=0
 def gpio(self,mask=None):
  self.seq=(self.seq+1)&65535
  req=struct.pack('!4sBBH',b'I2C1',int(mask is not None),mask or 0,self.seq)
  self.s.send(req)
  while True:
   r=self.s.recv(128)
   if len(r)==16 and r[:4]==b'I2C1' and struct.unpack('!H',r[8:10])[0]==self.seq:break
  if r[4]!=req[4]|128 or r[5]!=req[5]:raise RuntimeError('Wrong GPIO response')
  if mask is not None:self.mask=mask
  return r[6]&7
 def set(self,sda,scl):
  mask=(not sda)|((not scl)<<1)
  lines=self.gpio(mask)
  if scl and not lines&2:
   until=time.monotonic()+.05
   while time.monotonic()<until and not lines&2:lines=self.gpio()
   if not lines&2:raise RuntimeError('SCL stuck low')
  if not lines&4:raise RuntimeError('MUX RESET remains low')
  return lines&1
 def start(self):
  self.set(1,0);self.set(1,1);self.set(0,1);self.set(0,0)
 def stop(self):self.set(0,0);self.set(0,1);self.set(1,1)
 def write(self,v):
  for i in range(7,-1,-1):
   b=(v>>i)&1;self.set(b,0);self.set(b,1);self.set(b,0)
  self.set(1,0);ack=not self.set(1,1);self.set(1,0);return ack
 def read(self,last=True):
  v=0
  for i in range(8):self.set(1,0);v=(v<<1)|self.set(1,1);self.set(1,0)
  self.set(last,0);self.set(last,1);self.set(1,0);return v
 def transfer(self,addr,data=b'',read=0):
  self.start()
  try:
   if not self.write(addr<<1|int(not data and read>0)):return None
   for v in data:
    if not self.write(v):raise RuntimeError('Data NACK')
   if data and read:
    self.start()
    if not self.write(addr<<1|1):raise RuntimeError('Read address NACK')
   return bytes(self.read(i==read-1) for i in range(read))
  finally:self.stop()
 def reg(self,addr,n):
  r=self.transfer(addr,bytes([n]),2)
  return None if r is None else int.from_bytes(r,'big')
def run():
 b=Bus();result={'initial_lines':b.gpio(0),'mux':{},'routes':[]}
 if result['initial_lines']!=7:raise RuntimeError('Bus not idle: '+str(result))
 result['line_drive']={}
 for mask,expected in [(1,6),(2,5)]:
  lines=b.gpio(mask);result['line_drive'][str(mask)]=lines
  assert lines==expected,(mask,lines)
  assert b.gpio(0)==7
 b.gpio(2);time.sleep(1.1)
 result['watchdog_lines']=b.gpio();assert result['watchdog_lines']==7
 original={a:b.transfer(a,read=1) for a in [0x70,0x71]}
 result['mux']={hex(a):None if r is None else r[0] for a,r in original.items()}
 print('MUX',result['mux'],flush=True)
 if any(r is None for r in original.values()):return result
 try:
  # Direct reset proof: select branches, assert B26, verify both masks clear.
  for a in original:assert b.transfer(a,b'\x01') is not None
  result['reset_asserted_lines']=b.gpio(4)
  result['reset_released_lines']=b.gpio(0)
  print('RESET_LINES',result['reset_asserted_lines'],result['reset_released_lines'],flush=True)
  result['reset_masks']={hex(a):b.transfer(a,read=1)[0] for a in original}
  result['reset_pass']=(result['reset_asserted_lines']==3 and result['reset_released_lines']==7 and all(v==0 for v in result['reset_masks'].values()))
  print('RESET_MASKS',result['reset_masks'],flush=True)
  for a in original:assert b.transfer(a,b'\0') is not None
  # Probe legal unreserved addresses, excluding the upstream switches; no sensor configuration writes.
  for a,channels in [(0x70,range(8)),(0x71,range(8))]:
   for ch in channels:
    b.transfer(a,bytes([1<<ch]));sel=b.transfer(a,read=1)
    assert sel==bytes([1<<ch]),(a,ch,sel)
    found=[addr for addr in [x for x in range(0x08,0x78) if x not in original] if b.transfer(addr) is not None]
    row={'mux':hex(a),'channel':ch,'addresses':[hex(x) for x in found]}
    if a==0x71 and ch in [4,5,6] and 0x40 in found:
     row['ina3221']={hex(n):b.reg(0x40,n) for n in [0xfe,0xff,0,1,2,3,4,5,6]}
     assert row['ina3221']['0xfe']==0x5449 and row['ina3221']['0xff']==0x3220
     row['repeated_measurements']=[{hex(n):b.reg(0x40,n) for n in range(1,7)} for _ in range(5)]
    result['routes'].append(row);print('ROUTE',row,flush=True)
    b.transfer(a,b'\0')
 finally:
  for a,r in original.items():b.transfer(a,r)
  b.gpio(0)
 result['final_lines']=b.gpio();return result
if __name__=='__main__':
 import sys
 result=run();open(sys.argv[1],'w').write(json.dumps(result,indent=2)+'\n')
