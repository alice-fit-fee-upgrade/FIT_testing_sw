from migen import *
from litex.soc.interconnect import stream
from liteeth.common import eth_udp_user_description
from server import Server
from types import SimpleNamespace
p=SimpleNamespace(source=stream.Endpoint(eth_udp_user_description(8)),sink=stream.Endpoint(eth_udp_user_description(8)))
d=Server(p)
def test():
 yield d.lines.eq(7);yield d.link.eq(1);yield p.sink.ready.eq(0)
 for op,mask,seq in [(0,0,1),(1,3,2),(1,0,3)]:
  packet=b'I2C1'+bytes([op,mask,0,seq])
  for i,v in enumerate(packet):
   yield p.source.valid.eq(1);yield p.source.data.eq(v);yield p.source.last.eq(i==7);yield p.source.length.eq(8);yield p.source.src_port.eq(45678);yield p.source.ip_address.eq(0xc0a8026b)
   yield
   while not (yield p.source.ready):yield
  yield p.source.valid.eq(0);yield
  for _ in range(300):yield
  assert (yield p.sink.valid)
  first=(yield p.sink.data)
  for _ in range(5):
   yield
   assert (yield p.sink.data)==first
  out=[];yield p.sink.ready.eq(1);yield
  while True:
   if (yield p.sink.valid):
    out.append((yield p.sink.data));last=(yield p.sink.last)
    yield
    if last:break
   else:yield
  yield p.sink.ready.eq(0)
  assert bytes(out[:6])==b'I2C1'+bytes([op|128,mask]),out
  assert out[6]==15 and out[7]==mask and out[8:10]==[0,seq],out
  assert (yield d.low)==mask
 print('SERVER_SIM_PASS')
run_simulation(d,test())
