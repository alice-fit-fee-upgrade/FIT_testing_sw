import struct,random
from migen import *
from migen.sim import run_simulation,passive
from capture import Capture
from server import Server
class Harness(Module):
 def __init__(self):
  self.inputs=[Signal(14) for _ in range(12)]
  self.submodules.cap=c=Capture(self.inputs)
  self.submodules.srv=s=Server(c)
  self.comb += [s.link.eq(1),s.locked.eq(1)]
  for ch,raw in enumerate(self.inputs):self.comb += raw.eq((ch+1)*17 | (s.ev<<12))
h=Harness();s=h.srv;responses=[];current=[];rng=random.Random(120)
@passive
def receiver():
 while True:
  ready=rng.randrange(4)!=0
  yield s.tx.ready.eq(ready)
  yield
  if (yield s.tx.valid) and ready:
   if (yield s.tx.first):assert not current
   current.append((yield s.tx.data))
   if (yield s.tx.last):responses.append(bytes(current));current.clear()
def test():
 yield s.rx.valid.eq(0)
 for _ in range(20):yield
 def send(op,ch=0,bank=0,page=0,magic=b'ADC1'):
  b=struct.pack('!4sBBBB',magic,op,ch,bank,page)
  for i,v in enumerate(b):
   yield s.rx.valid.eq(1);yield s.rx.data.eq(v);yield s.rx.first.eq(0);yield s.rx.last.eq(i==7);yield s.rx.length.eq(8);yield s.rx.ip_address.eq(0xc0a8026b);yield s.rx.src_port.eq(50000)
   yield
   while not (yield s.rx.ready):yield
  yield s.rx.valid.eq(0);yield s.rx.first.eq(0);yield s.rx.last.eq(0)
 def wait_reply(n):
  for _ in range(40000):
   if len(responses)==n:return
   yield
  raise AssertionError('reply timeout')
 yield from send(0);yield from wait_reply(1)
 assert len(responses[-1])==16
 yield from send(1,bank=1);yield from wait_reply(2)
 assert struct.unpack('!I',responses[-1][8:12])[0]==1
 for ch,page in [(0,0),(11,7),(5,3)]:
  yield from send(2,ch,1,page);yield from wait_reply(len(responses)+1)
  p=responses[-1];assert len(p)==1040
  values=struct.unpack('<512H',p[16:]);assert set(values)=={(ch+1)*17|4096},set(values)
 before=len(responses)
 yield from send(1,bank=0,magic=b'BAD!')
 for _ in range(200):yield
 assert len(responses)==before and (yield s.ev)==1
 yield from send(2,12,1,0)
 for _ in range(200):yield
 assert len(responses)==before
 yield from send(1,bank=0);yield from wait_reply(before+1)
 yield from send(2,11,0,7);yield from wait_reply(before+2)
 assert set(struct.unpack('<512H',responses[-1][16:]))=={204}
 print('CAPTURE_UDP_SIM_PASS: dual clocks, 12 memories, A/B, page addressing, TX backpressure and invalid requests')
run_simulation(h,[test(),receiver()],clocks={'sys':10,'cap':4})
