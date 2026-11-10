from pathlib import Path
import re
from types import SimpleNamespace
from migen import *
from migen.fhdl import verilog
from migen.genlib.cdc import MultiReg
from litex.build.xilinx.common import xilinx_special_overrides
from litex.soc.cores.clock import S7MMCM
from liteeth.core import LiteEthUDPIPCore
from k7_phy import K7_1000BASEX
from server import Server
class Top(Module):
 def __init__(self):
  mp=Signal(name_override='MCLK1_P');mn=Signal(name_override='MCLK1_N');rp=Signal(name_override='MGTCLK_P');rn=Signal(name_override='MGTCLK_N')
  pads=SimpleNamespace(txp=Signal(name_override='TX_P'),txn=Signal(name_override='TX_N'),rxp=Signal(name_override='RX_P'),rxn=Signal(name_override='RX_N'))
  self.ios={mp,mn,rp,rn,pads.txp,pads.txn,pads.rxp,pads.rxn}
  self.clock_domains.cd_sys=ClockDomain('sys');m=Signal();ref=Signal()
  self.specials += [Instance('IBUFDS',p_DIFF_TERM='TRUE',i_I=mp,i_IB=mn,o_O=m),Instance('BUFG',i_I=m,o_O=self.cd_sys.clk),Instance('IBUFDS_GTE2',i_I=rp,i_IB=rn,i_CEB=0,o_O=ref)]
  self.submodules.phy=phy=K7_1000BASEX(ref,pads,40e6,with_csr=False)
  self.submodules.core=core=LiteEthUDPIPCore(phy,0x020000001201,'192.168.2.240',40e6,dw=8,with_sys_datapath=True,with_store_and_forward=True)
  self.submodules.server=srv=Server(core.udp.crossbar.get_port(40000,dw=8,cd='sys'))
  raw=Signal(3);self.specials += MultiReg(raw,srv.lines)
  for n,name in enumerate(['I2C_SDA','I2C_SCL','I2C_RESET_N']):
   pad=Signal(name_override=name);self.ios.add(pad)
   self.specials += Instance('IOBUF',i_I=0,i_T=~srv.low[n],o_O=raw[n],io_IO=pad)
  self.comb += srv.link.eq(phy.link_up)
  tick=Signal(32);self.sync += tick.eq(tick+1)
  report=Signal(512);cmd=Signal(16)
  self.comb += report.eq(Cat(Constant(0x504d1c01,32),tick,srv.lines,srv.low,phy.link_up))
  self.specials += Instance('eth_jtag',i_report=report,o_command=cmd)
t=Top();v=verilog.convert(t,ios=t.ios,name='pm12_i2c_diag',special_overrides=xilinx_special_overrides)
root=Path(__file__).resolve().parent
(root/'pm12_i2c_diag.v').write_text(v.main_source)
for n,c in v.data_files.items():(root/n).write_text(c)
