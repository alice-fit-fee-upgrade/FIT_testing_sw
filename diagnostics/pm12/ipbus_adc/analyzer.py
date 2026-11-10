from migen import *
from migen.genlib.cdc import MultiReg
class Analyzer(Module):
 def __init__(self,raw,command,cycles=120000000,depth=2048):
  self.arm=Signal();self.arm_count=Signal(32);self.address=Signal(max=depth);self.data=Signal(35)
  self.lines=Signal(3,reset=7);self.count=Signal(12);self.active=Signal();self.elapsed=Signal(32);self.tick=Signal(32);self.selected=Signal(35)
  cmd=Signal(16,reset=2);self.specials += [MultiReg(raw,self.lines),MultiReg(command,cmd)]
  prev=Signal(3,reset=7);arming=Signal();storing=Signal();index=Signal(max=depth);word=Signal(35);stamp=Signal(32)
  self.comb += [arming.eq(self.arm),storing.eq(arming|(self.active&(self.lines!=prev))),index.eq(Mux(arming,0,self.count)),stamp.eq(self.elapsed+1),word.eq(Cat(Mux(arming,0,stamp),self.lines))]
  # Replicate storage to preserve independent JTAG and IPbus read access.
  for i,adr in enumerate([cmd[:11],self.address]):
   mem=Memory(35,depth,name='i2c_events'+str(i));wp=mem.get_port(write_capable=True);rp=mem.get_port()
   self.specials += mem,wp,rp
   self.comb += [wp.adr.eq(index),wp.dat_w.eq(word),wp.we.eq(storing),rp.adr.eq(adr),(self.selected if i==0 else self.data).eq(rp.dat_r)]
  self.sync += [self.tick.eq(self.tick+1),If(arming,self.arm_count.eq(self.arm_count+1),self.active.eq(1),self.elapsed.eq(0),self.count.eq(1),prev.eq(self.lines)).Elif(self.active,self.elapsed.eq(self.elapsed+1),If(self.lines!=prev,prev.eq(self.lines),self.count.eq(self.count+1),If(self.count==depth-1,self.active.eq(0))),If(self.elapsed>=cycles-1,self.active.eq(0)))]
  self.report=Signal(512)
  self.comb += self.report.eq(Cat(Constant(0x504d5a04,32),self.tick,self.lines,Constant(0,5),self.count,Constant(0,4),self.active,Constant(0,7),self.elapsed,self.selected,Constant(0,29),cmd[:11],Constant(0,5)))
