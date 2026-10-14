from pathlib import Path
import re
from types import SimpleNamespace
from migen import *
from migen.fhdl import verilog
from litex.build.xilinx.common import xilinx_special_overrides
from litex.soc.cores.clock import S7MMCM
from liteeth.core import LiteEthUDPIPCore
from k7_phy import K7_1000BASEX
from capture import Capture
from server import Server
class Top(Module):
 def __init__(self):
  mp=Signal(name_override='MCLK1_P');mn=Signal(name_override='MCLK1_N');rp=Signal(name_override='MGTCLK_P');rn=Signal(name_override='MGTCLK_N')
  pads=SimpleNamespace(txp=Signal(name_override='TX_P'),txn=Signal(name_override='TX_N'),rxp=Signal(name_override='RX_P'),rxn=Signal(name_override='RX_N'))
  self.ios={mp,mn,rp,rn,pads.txp,pads.txn,pads.rxp,pads.rxn}
  self.clock_domains.cd_sys=ClockDomain('sys');m=Signal();ref=Signal()
  self.specials += [Instance('IBUFDS',p_DIFF_TERM='TRUE',i_I=mp,i_IB=mn,o_O=m),Instance('BUFG',i_I=m,o_O=self.cd_sys.clk),Instance('IBUFDS_GTE2',i_I=rp,i_IB=rn,i_CEB=0,o_O=ref)]
  self.clock_domains.cd_cap=ClockDomain('cap')
  self.submodules.cm=cm=S7MMCM(speedgrade=-3, fractional=False);cm.vco_freq_range=(600e6,1200e6);cm.register_clkin(self.cd_sys.clk,40e6);cm.create_clkout(self.cd_cap,320e6)
  self.submodules.phy=phy=K7_1000BASEX(ref,pads,40e6,with_csr=False)
  self.submodules.core=core=LiteEthUDPIPCore(phy,0x020000001201,'192.168.2.240',40e6,dw=8,with_sys_datapath=True,with_store_and_forward=True)
  inputs=[]
  for n in range(1,13):
   di=Signal(13,name_override=f'DI{n}');st=Signal(name_override=f'STR{n}');self.ios.update({di,st});inputs.append(Cat(di,st))
  self.submodules.capture=cap=Capture(inputs)
  self.submodules.server=srv=Server(cap,core.udp.crossbar.get_port(40000,dw=8,cd='sys'))
  ev=Signal(name_override='EVNT');self.ios.add(ev);self.comb += [ev.eq(srv.ev),srv.link.eq(phy.link_up),srv.locked.eq(cm.locked)]
  tick=Signal(32);self.sync += tick.eq(tick+1)
  report=Signal(512);cmd=Signal(16)
  self.comb += report.eq(Cat(Constant(0x504dad01,32),tick,srv.capture_id,srv.ev,srv.valid,phy.link_up,cm.locked,Constant(0,28),srv.rx_count,srv.checked,srv.tx_count))
  self.specials += Instance('eth_jtag',i_report=report,o_command=cmd)
t=Top();v=verilog.convert(t,ios=t.ios,name='pm12_adc_diag',special_overrides=xilinx_special_overrides)
root=Path(__file__).resolve().parent
source,n=re.subn(r'(reg \[15:0\] adc_trace\d+\[0:4095\];)',r'(* ram_style = "block" *) \1',v.main_source)
assert n==12, n
(root/'pm12_adc_diag.v').write_text(source)
for n,c in v.data_files.items():(root/n).write_text(c)
