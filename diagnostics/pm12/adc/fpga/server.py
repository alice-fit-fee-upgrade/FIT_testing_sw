from migen import *
from litex.soc.interconnect import stream
from liteeth.common import eth_udp_user_description
class Server(Module):
 def __init__(self,capture,port=None):
  self.port=port or stream.Endpoint(eth_udp_user_description(8))
  # For standalone simulation use named RX and TX endpoints.
  if port is None:
   self.rx=stream.Endpoint(eth_udp_user_description(8));self.tx=stream.Endpoint(eth_udp_user_description(8))
  else:self.rx=port.source;self.tx=port.sink
  rx,tx=self.rx,self.tx
  self.rx_count=Signal(32);self.checked=Signal(32);self.tx_count=Signal(32);
  self.sync += [If(rx.valid & rx.ready & rx.last,self.rx_count.eq(self.rx_count+1)),If(tx.valid & tx.ready & tx.last,self.tx_count.eq(self.tx_count+1))]
  self.ev=Signal();self.capture_id=Signal(32);self.valid=Signal();self.link=Signal();self.locked=Signal()
  count=Signal(4);bad=Signal();req=[Signal(8) for _ in range(8)];reqarr=Array(req)
  remote_ip=Signal(32);remote_port=Signal(16);op,ch,bank,page=req[4:]
  flags=Signal(32);self.comb += flags.eq(Cat(self.valid,self.link,self.locked))
  hdr=Array([Constant(v,8) for v in b'ADC1']+[op|128,ch,bank,page]+[self.capture_id[24:32],self.capture_id[16:24],self.capture_id[8:16],self.capture_id[:8]]+[flags[24:32],flags[16:24],flags[8:16],flags[:8]])
  hi=Signal();word=Signal(16);wordidx=Signal(9);hidx=Signal(4);settle=Signal(11)
  fsm=FSM(reset_state='RX');self.submodules.fsm=fsm
  self.comb += [rx.ready.eq(fsm.ongoing('RX')),tx.valid.eq(0),tx.data.eq(0),tx.first.eq(0),tx.last.eq(0),tx.be.eq(1),tx.error.eq(0),tx.src_port.eq(40000),tx.dst_port.eq(remote_port),tx.ip_address.eq(remote_ip),tx.length.eq(Mux(op==2,1040,16)),capture.arm.eq(0),capture.address.eq(Cat(wordidx,page[:3]))]
  fsm.act('RX',If(rx.valid,
   If(count<8,NextValue(reqarr[count],rx.data)),
   If(count==0,NextValue(remote_ip,rx.ip_address),NextValue(remote_port,rx.src_port)),
   If(rx.error | (count>=8),NextValue(bad,1)),
   If(rx.last,If((count==7)&~bad&~rx.error&(rx.length==8),NextState('CHECK')).Else(NextValue(count,0),NextValue(bad,0))).Else(If(count<9,NextValue(count,count+1)))))
  fsm.act('CHECK',NextValue(self.checked,self.checked+1),NextValue(count,0),NextValue(bad,0),NextValue(hidx,0),NextValue(wordidx,0),
   If((req[0]==65)&(req[1]==68)&(req[2]==67)&(req[3]==49)&(op<=2)&(ch<12)&(bank<2)&(page<8),
    If(op==1,NextValue(self.ev,bank[0]),NextValue(self.valid,0),NextValue(settle,1000),NextState('SETTLE')).Elif((op==2)&(~self.valid|(bank[0]!=self.ev)),NextState('RX')).Else(NextState('HEADER'))).Else(NextState('RX')))
  fsm.act('SETTLE',If(settle==0,capture.arm.eq(1),NextState('CAPTURE')).Else(NextValue(settle,settle-1)))
  fsm.act('CAPTURE',If(capture.done,NextValue(self.valid,1),NextValue(self.capture_id,self.capture_id+1),NextState('HEADER')))
  fsm.act('HEADER',tx.valid.eq(1),tx.data.eq(hdr[hidx]),tx.first.eq(hidx==0),tx.last.eq((op!=2)&(hidx==15)),
   If(tx.ready,If(hidx==15,If(op==2,NextState('MEM_WAIT')).Else(NextState('RX'))).Else(NextValue(hidx,hidx+1))))
  fsm.act('MEM_WAIT',NextState('MEM_LATCH'))
  fsm.act('MEM_LATCH',NextValue(word,Array(capture.data)[ch]),NextState('LOW'))
  fsm.act('LOW',tx.valid.eq(1),tx.data.eq(word[:8]),If(tx.ready,NextState('HIGH')))
  fsm.act('HIGH',tx.valid.eq(1),tx.data.eq(word[8:16]),tx.last.eq(wordidx==511),If(tx.ready,If(wordidx==511,NextState('RX')).Else(NextValue(wordidx,wordidx+1),NextState('MEM_WAIT'))))
