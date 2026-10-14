from migen import *
from migen.genlib.cdc import MultiReg,PulseSynchronizer
class Capture(Module):
 def __init__(self,inputs,depth=4096):
  self.arm=Signal();self.done=Signal();self.address=Signal(max=depth)
  self.data=[]
  self.submodules.arm_cdc=a=PulseSynchronizer('sys','cap')
  self.submodules.done_cdc=d=PulseSynchronizer('cap','sys')
  self.comb += [a.i.eq(self.arm),self.done.eq(d.o)]
  active=Signal();index=Signal(max=depth)
  self.comb += d.i.eq(active & (index==depth-1))
  self.sync.cap += If(a.o,active.eq(1),index.eq(0)).Elif(active,If(index==depth-1,active.eq(0)).Else(index.eq(index+1)))
  for raw in inputs:
   sampled=Signal(14);self.specials += MultiReg(raw,sampled,'cap')
   mem=Memory(16,depth,name=f"adc_trace{len(self.data)}");wp=mem.get_port(write_capable=True,clock_domain='cap');rp=mem.get_port(clock_domain='sys',mode=READ_FIRST)
   self.specials += mem,wp,rp
   self.comb += [wp.adr.eq(index),wp.dat_w.eq(sampled),wp.we.eq(active),rp.adr.eq(self.address)]
   self.data.append(rp.dat_r)
