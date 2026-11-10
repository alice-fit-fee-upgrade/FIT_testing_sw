from migen import *
from migen.genlib.cdc import MultiReg, PulseSynchronizer
class Capture(Module):
 def __init__(self, inputs, depth=4096):
  self.arm=Signal();self.done=Signal();self.address=Signal(max=depth);self.pattern=Signal();self.bank=Signal();self.data=[]
  self.submodules.arm_cdc=a=PulseSynchronizer('sys','cap');self.submodules.done_cdc=d=PulseSynchronizer('cap','sys')
  self.comb += [a.i.eq(self.arm),self.done.eq(d.o)]
  pattern=Signal();bank=Signal();self.specials += [MultiReg(self.pattern,pattern,'cap'),MultiReg(self.bank,bank,'cap')]
  active=Signal();index=Signal(max=depth);self.comb += d.i.eq(active & (index==depth-1))
  self.sync.cap += If(a.o,active.eq(1),index.eq(0)).Elif(active,If(index==depth-1,active.eq(0)).Else(index.eq(index+1)))
  for ch,raw in enumerate(inputs):
   sampled=Signal(14);self.specials += MultiReg(raw,sampled,'cap')
   mem=Memory(16,depth,name='adc_trace'+str(ch));wp=mem.get_port(write_capable=True,clock_domain='cap');rp=mem.get_port(clock_domain='sys',mode=READ_FIRST)
   self.specials += mem,wp,rp
   self.comb += [wp.adr.eq(index),wp.dat_w.eq(Mux(pattern,index ^ (ch*0x1111) ^ (bank<<15),sampled)),wp.we.eq(active),rp.adr.eq(self.address)]
   self.data.append(rp.dat_r)
