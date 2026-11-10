from migen import *
from migen.sim import run_simulation
from capture import Capture
from analyzer import Analyzer
from registers import Registers
class DUT(Module):
 def __init__(self):
  self.clock_domains.cd_sys=ClockDomain('sys');self.clock_domains.cd_cap=ClockDomain('cap')
  self.inputs=[Signal(14) for _ in range(12)];self.raw=Signal(3,reset=7);self.command=Signal(16,reset=2)
  self.submodules.cap=Capture(self.inputs,depth=32);self.submodules.trace=Analyzer(self.raw,self.command,cycles=64,depth=16);self.submodules.regs=Registers(self.cap,self.trace,settle=4,timeout=100)
  counter=Signal(12);self.sync.cap+=counter.eq(counter+1)
  for ch,v in enumerate(self.inputs):self.comb += v.eq(Cat((counter+ch*37)[:12],self.regs.ev,counter[1]))
d=DUT();r=d.regs

def burst(addresses,values=None,errors=False):
 results=[]
 yield r.strobe.eq(1);yield r.write.eq(values is not None)
 for i,a in enumerate(addresses):
  yield r.address.eq(a)
  if values is not None:yield r.wdata.eq(values[i])
  yield
  for timeout in range(20):
   if (yield r.ack):break
   yield
  else:raise AssertionError('IPbus ack timeout')
  val=(yield r.rdata);err=(yield r.err);assert err==int(errors),(hex(a),hex(val),err)
  results.append(val)
 yield r.strobe.eq(0)
 yield;yield
 return results

def rd(a,n=1,errors=False):return (yield from burst(range(a,a+n),errors=errors))
def wr(a,v,errors=False):return (yield from burst([a],[v],errors=errors))
def wait_ready():
 for i in range(100):
  if not (yield r.busy):return
  yield
 raise AssertionError('capture timeout')
def test():
 yield r.locked.eq(1);yield r.link.eq(1)
 for _ in range(5):yield
 assert (yield from rd(0))==[0x504d1202]
 yield from rd(0x10000,errors=True)
 yield from wr(0,99,errors=True);yield from rd(0xdead,errors=True)
 for v in [0,0xffffffff,0xa55a1234]:
  yield from wr(3,v);assert (yield from rd(3))==[v]
 # Continuous-strobe nonincrementing writes are one accepted word per ack.
 before=(yield r.writes);yield from burst([3]*4,[1,2,3,4]);assert (yield r.writes)==before+4 and (yield from rd(3))==[4]
 for bank in [0,1,0]:
  yield from wr(0x10,1|(bank<<1)|0x100)
  yield from wr(0x10,1,errors=True)
  yield from wait_ready();assert (yield r.valid)
  for ch in range(12):
   data=yield from rd(0x10000+(ch<<12),32)
   assert data==[i^(ch*0x1111)^(bank<<15) for i in range(32)],(bank,ch,data)
  old=yield from rd(0x10000,4)
  for _ in range(20):yield
  assert (yield from rd(0x10000,4))==old
 assert (yield r.capture_id)==3
 yield from wr(0x10,0);yield from rd(0x10000,errors=True)
 yield from wr(0x10,0x80000001,errors=True)
 # Real-input model: forwarded clock/data/tag path, not the synthetic source.
 yield from wr(0x10,3);yield from wait_ready()
 for ch in range(12):
  data=yield from rd(0x10000+(ch<<12),32);assert all((v>>12)&1 for v in data) and len(set(v&0xfff for v in data))>1
 # Timeout/recovery and no commands accepted with MMCM unlocked.
 yield r.locked.eq(0);yield
 yield from wr(0x10,1,errors=True)
 yield r.locked.eq(1);yield
 yield from wr(0x10,1);yield r.locked.eq(0);yield
 yield from wait_ready();assert not (yield r.valid) and (yield r.timed_out)
 yield r.locked.eq(1);yield
 yield from wr(0x10,0x101);yield from wait_ready();assert (yield r.valid) and not (yield r.timed_out)
 # Passive trace via bus, then the same records through its independent JTAG port.
 yield from wr(0x100,1)
 for i in range(12):yield d.raw.eq(7^(2*(i&1)));yield;yield
 for _ in range(70):yield
 n=(yield d.trace.count);assert n>2 and not(yield d.trace.active)
 words=yield from rd(0x2000,n*2);ts=words[::2];assert ts[0]==0 and all(b>a for a,b in zip(ts,ts[1:]))
 for i in range(n):
  yield d.command.eq(i)
  for _ in range(6):yield
  v=(yield d.trace.selected);assert (v&0xffffffff)==words[2*i] and (v>>32)==words[2*i+1]
 yield from rd(0x2000+n*2,errors=True)
 # Hardware-manager USER2 scans must never arm/overwrite the trace.
 held_count=(yield d.trace.count);held_elapsed=(yield d.trace.elapsed);held_id=(yield d.trace.arm_count)
 for command in [0x8000,0xffff,0,0xa55a,0x5a5a,0x8000,0]:
  yield d.command.eq(command)
  for _ in range(8):yield
  assert not(yield d.trace.active) and (yield d.trace.count)==held_count and (yield d.trace.elapsed)==held_elapsed and (yield d.trace.arm_count)==held_id,'USER2 scan overwrote frozen trace'
 yield from wr(0x100,1)
 for _ in range(8):yield
 assert (yield d.trace.active) and (yield d.trace.arm_count)==held_id+1,'fresh IPbus ARM did not rearm'
 assert ((yield d.trace.report)&0xffffffff)==0x504d5a04
 print('PASS IPbus burst/nonincrementing/error/side-effect semantics,12 buffers pattern A/B/A and raw inputs,freeze,MMCM loss/recovery,independent passive trace/JTAG access,arbitrary USER2 scans preserve frozen trace and explicit IPbus ARM rearms')
run_simulation(d,test(),clocks={'sys':16,'cap':2})
