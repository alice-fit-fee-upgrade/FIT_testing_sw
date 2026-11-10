from migen import *
from migen.sim import run_simulation
from gateware.cfd_tx import CFDBurst

def check(ports):
 bus=Record([('address',16),('write_data',32),('read_data',32),('write',1)])
 ready=Signal(reset=1);dut=CFDBurst(bus,ready,depth=16,ports=ports)
 def process():
  def wr(addr,value):
   yield bus.address.eq(addr);yield bus.write_data.eq(value);yield bus.write.eq(1);yield;yield bus.write.eq(0);yield;yield
  assert (yield dut.enabled)==0 and (yield dut.port)==0
  for port in range(ports):
   yield from wr(0xdc,port)
   assert (yield dut.port)==port and not (yield dut.error)
  yield from wr(0xe0,1);assert (yield dut.enabled)
  yield from wr(0xdc,0);assert (yield dut.error) and (yield dut.port)==ports-1
  yield from wr(0xe0,0);assert not (yield dut.enabled) and not (yield dut.running)
  yield from wr(0xe0,1);assert (yield dut.enabled)
  yield ready.eq(0);yield;yield;assert not (yield dut.enabled)
 run_simulation(dut,process())
for ports in (1,4):check(ports)
print('CFD_PORT_SELECTOR_SIM_PASS: default off; all ports; live switch rejected; STOP/reference-loss release')
