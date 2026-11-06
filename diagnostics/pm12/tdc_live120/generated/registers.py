from migen import *
class Registers(Module):
 def __init__(self, cap, trace, build_id=0x20261015, settle=1000, timeout=40000, tdc=None):
  self.address=Signal(32);self.wdata=Signal(32);self.strobe=Signal();self.write=Signal();self.rdata=Signal(32);self.ack=Signal();self.err=Signal()
  self.link=Signal();self.locked=Signal();self.ev=Signal();self.scratch=Signal(32);self.writes=Signal(32);self.valid=Signal();self.busy=Signal();self.capture_id=Signal(32);self.timed_out=Signal()
  self.mcu_scratch=Signal(16);self.mcu_writes=Signal(16)
  pattern=Signal();bank=Signal();remaining=Signal(max=max(settle,timeout)+1);settling=Signal();arm=Signal();trace_arm=Signal()
  self.comb += [cap.arm.eq(arm),cap.pattern.eq(pattern),cap.bank.eq(bank),trace.arm.eq(trace_arm)]
  self.sync += [arm.eq(0),trace_arm.eq(0),If(self.busy,
   If(settling,If(remaining==0,arm.eq(1),settling.eq(0),remaining.eq(timeout)).Else(remaining.eq(remaining-1))).Else(
    If((remaining==0)|~self.locked,self.busy.eq(0),self.valid.eq(0),self.timed_out.eq(1)).Elif(cap.done,self.busy.eq(0),self.valid.eq(1),self.capture_id.eq(self.capture_id+1)).Else(remaining.eq(remaining-1))))]
  adr=Signal(32);wd=Signal(32);wr=Signal();uptime=Signal(64);self.sync += uptime.eq(uptime+1)
  self.comb += [cap.address.eq(adr[:12]),trace.address.eq(adr[1:12])]
  valid_address=Signal();read_value=Signal(32);writable=Signal();bad_write=Signal()
  status=Cat(self.valid,self.busy,self.link,self.locked,pattern,bank,self.timed_out)
  cases={0:[read_value.eq(0x504d1202)],1:[read_value.eq(0x10001)],2:[read_value.eq(build_id)],3:[read_value.eq(self.scratch),writable.eq(1)],4:[read_value.eq(self.writes)],5:[read_value.eq(uptime[:32])],6:[read_value.eq(uptime[32:])],7:[read_value.eq(40000000)],8:[read_value.eq(320000000)],9:[read_value.eq(15)],
   0x10:[read_value.eq(Cat(Constant(0,1),bank,Constant(0,6),pattern)),writable.eq(1),bad_write.eq((wd&~0x103)!=0)],0x11:[read_value.eq(status)],0x12:[read_value.eq(self.capture_id)],0x13:[read_value.eq(4096)],0x14:[read_value.eq(12)],0x20:[read_value.eq(self.mcu_scratch)],0x21:[read_value.eq(self.mcu_writes)],
   0x100:[read_value.eq(0),writable.eq(1),bad_write.eq((wd&~1)!=0)],0x101:[read_value.eq(trace.count)],0x102:[read_value.eq(trace.active)],0x103:[read_value.eq(trace.elapsed)],0x104:[read_value.eq(trace.lines)],0x105:[read_value.eq(trace.arm_count)]}
  self.comb += [valid_address.eq(1),read_value.eq(0),writable.eq(0),bad_write.eq(0),Case(adr,{**cases,'default':[valid_address.eq(0)]}),
   If((adr>=0x10000)&(adr<0x1c000),valid_address.eq(self.valid&~self.busy),read_value.eq(Array(cap.data)[adr[12:16]])).Elif((adr>=0x2000)&(adr<0x3000),valid_address.eq(~trace.active & (adr[1:12]<trace.count)),read_value.eq(Mux(adr[0],trace.data[32:35],trace.data[:32])))]
  if tdc is not None:
   self.comb += [If(adr==1,read_value.eq(0x10002)),If(adr==9,read_value.eq(31)),tdc.address.eq(adr),tdc.wdata.eq(wd),tdc.write.eq(wr),
    If(tdc.selected,valid_address.eq(~tdc.error),read_value.eq(tdc.rdata),writable.eq(1),bad_write.eq(tdc.error))]
  f=FSM(reset_state='IDLE');self.submodules.fsm=f
  f.act('IDLE',If(self.strobe,NextValue(adr,self.address),NextValue(wd,self.wdata),NextValue(wr,self.write),NextState('MEM_WAIT')))
  f.act('MEM_WAIT',NextState('COMPLETE'))
  fail=~valid_address | (wr & (~writable|bad_write|((adr==0x10)&(self.busy|~self.locked))|((adr==0x100)&trace.active)))
  f.act('COMPLETE',NextValue(self.ack,1),NextValue(self.err,fail),NextValue(self.rdata,read_value),
   If(wr&~fail,NextValue(self.writes,self.writes+1),
    If(adr==3,NextValue(self.scratch,wd)).Elif(adr==0x10,
     NextValue(self.valid,0),NextValue(bank,wd[1]),NextValue(pattern,wd[8]),NextValue(self.ev,wd[1]),
     If(wd[0],NextValue(self.busy,1),NextValue(self.valid,0),NextValue(self.timed_out,0),NextValue(settling,1),NextValue(remaining,settle)))
    .Elif(adr==0x100,NextValue(trace_arm,wd[0]))),NextState('ACK'))
  # IPbus keeps STROBE asserted across burst words; do not wait for it to fall.
  # Bubble after ACK lets the master advance ADDRESS before accepting again.
  if tdc is not None:
   self.comb += tdc.commit.eq(f.ongoing('COMPLETE') & ~fail)
  f.act('ACK',NextValue(self.ack,0),NextValue(self.err,0),NextState('IDLE'))
