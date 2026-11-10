from migen import *
class Server(Module):
 def __init__(self,port):
  rx,tx=port.source,port.sink
  self.low=Signal(3);self.lines=Signal(3);self.link=Signal()
  count=Signal(4);bad=Signal();req=[Signal(8) for _ in range(8)];arr=Array(req)
  ip=Signal(32);peer=Signal(16);idx=Signal(4);timer=Signal(26);sample=Signal(8)
  self.sync += If(timer!=0,timer.eq(timer-1)).Else(self.low.eq(0))
  hdr=Array([Constant(x,8) for x in b'I2C1']+[req[4]|128,req[5],sample,self.low]+req[6:8]+[Constant(0,8) for _ in range(6)])
  self.submodules.fsm=f=FSM(reset_state='RX')
  self.comb += [rx.ready.eq(f.ongoing('RX')),tx.valid.eq(0),tx.data.eq(0),tx.first.eq(0),tx.last.eq(0),tx.be.eq(1),tx.error.eq(0),tx.src_port.eq(40000),tx.dst_port.eq(peer),tx.ip_address.eq(ip),tx.length.eq(16)]
  f.act('RX',If(rx.valid,
   If(count<8,NextValue(arr[count],rx.data)),
   If(count==0,NextValue(ip,rx.ip_address),NextValue(peer,rx.src_port)),
   If(rx.error|(count>=8),NextValue(bad,1)),
   If(rx.last,If((count==7)&~bad&~rx.error&(rx.length==8),NextState('CHECK')).Else(NextValue(count,0),NextValue(bad,0))).Else(If(count<9,NextValue(count,count+1)))))
  f.act('CHECK',NextValue(count,0),NextValue(bad,0),NextValue(idx,0),
   If((req[0]==73)&(req[1]==50)&(req[2]==67)&(req[3]==49)&(req[4]<=1)&(req[5]<8),
    If(req[4]==1,NextValue(self.low,req[5][:3]),NextValue(timer,40000000)),NextState('WAIT')).Else(NextState('RX')))
  wait=Signal(8)
  f.act('WAIT',NextValue(wait,200),NextState('SETTLE'))
  f.act('SETTLE',If(wait==0,NextValue(sample,Cat(self.lines,self.link)),NextState('TX')).Else(NextValue(wait,wait-1)))
  f.act('TX',tx.valid.eq(1),tx.data.eq(hdr[idx]),tx.first.eq(idx==0),tx.last.eq(idx==15),If(tx.ready,If(idx==15,NextState('RX')).Else(NextValue(idx,idx+1))))
