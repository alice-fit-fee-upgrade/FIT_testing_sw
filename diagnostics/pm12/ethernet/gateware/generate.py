from pathlib import Path
from types import SimpleNamespace
from migen import *
from migen.fhdl import verilog
from migen.genlib.cdc import MultiReg
from litex.build.xilinx.common import xilinx_special_overrides
from liteeth.phy.serial.basex.wrappers.k7_gtx import K7_1000BASEX
from liteeth.mac.core import LiteEthMACCore

class Top(Module):
 def __init__(self):
  self.mclk_p=Signal(name_override='MCLK1_P'); self.mclk_n=Signal(name_override='MCLK1_N')
  self.ref_p=Signal(name_override='MGTCLK_P'); self.ref_n=Signal(name_override='MGTCLK_N')
  pads=SimpleNamespace(txp=Signal(name_override='TX_P'),txn=Signal(name_override='TX_N'),rxp=Signal(name_override='RX_P'),rxn=Signal(name_override='RX_N'))
  self.ios={self.mclk_p,self.mclk_n,self.ref_p,self.ref_n,pads.txp,pads.txn,pads.rxp,pads.rxn}
  self.clock_domains.cd_sys=ClockDomain('sys')
  mclk=Signal(); self.specials += [Instance('IBUFDS',i_I=self.mclk_p,i_IB=self.mclk_n,o_O=mclk),Instance('BUFG',i_I=mclk,o_O=self.cd_sys.clk)]
  ref=Signal(); refdiv=Signal(); self.specials += Instance('IBUFDS_GTE2',i_I=self.ref_p,i_IB=self.ref_n,i_CEB=0,o_O=ref,o_ODIV2=refdiv)
  self.clock_domains.cd_refmon=ClockDomain('refmon',reset_less=True)
  self.specials += Instance('BUFG',i_I=refdiv,o_O=self.cd_refmon.clk)
  self.submodules.phy=phy=K7_1000BASEX(ref,pads,120e6,with_csr=False)
  self.submodules.mac=mac=LiteEthMACCore(phy,8,with_sys_datapath=True,with_store_and_forward=True)
  cmd=Signal(16,reset=2); cmd_async=Signal(16,reset=2); self.specials += MultiReg(cmd_async,cmd)
  prbs_err=Signal(); ref_lost=Signal(); rxresetdone=Signal(); txresetdone=Signal()
  gtx=next(s for s in phy.pma._fragment.specials if isinstance(s,Instance) and s.of=='GTXE2_CHANNEL')
  ports={'LOOPBACK':cmd[:3],'TXPRBSSEL':Mux(cmd[4],1,0),'RXPRBSSEL':Mux(cmd[5],2,Mux(cmd[4],1,0)),'RXPRBSERR':prbs_err,'CPLLREFCLKLOST':ref_lost}
  for item in gtx.items:
   if item.name in ports: item.expr=ports[item.name]
   if item.name=='RXRESETDONE': rxresetdone=item.expr
   if item.name=='TXRESETDONE': txresetdone=item.expr
  self.comb += phy.reset.eq(cmd[8])
  tick=Signal(32); refcount=Signal(32); refsync=Signal(32); self.sync += tick.eq(tick+1); self.sync.refmon += refcount.eq(refcount+1); self.specials += MultiReg(refcount,refsync)
  errsync=Signal(); self.specials += MultiReg(prbs_err,errsync)
  prbscount=Signal(32); self.sync += If(errsync & cmd[4],prbscount.eq(prbscount+1))
  txcount=Signal(32); rxcount=Signal(32); badcount=Signal(32); rxbytes=Signal(32)
  txi=Signal(6); rxi=Signal(6); gap=Signal(16,reset=1000); bad=Signal()
  # Exactly 60 bytes before FCS: local MAC addresses, private EtherType, patterned payload.
  frame=[0x02,0,0,0,0,1,0x02,0,0,0,0,2,0x88,0xb5]+list(range(46))
  data=Array(Constant(x,8) for x in frame)
  self.comb += [mac.sink.valid.eq((gap==0)&~cmd[4]&~cmd[8]),mac.sink.data.eq(data[txi] ^ Mux(cmd[6] & (txi==59),1,0)),mac.sink.last.eq(txi==59),mac.sink.be.eq(1),mac.sink.error.eq(0),mac.source.ready.eq(1)]
  self.sync += [If(gap!=0,gap.eq(gap-1)).Elif(mac.sink.valid&mac.sink.ready,If(txi==59,txi.eq(0),gap.eq(4000),txcount.eq(txcount+1)).Else(txi.eq(txi+1))),If(mac.source.valid,rxbytes.eq(rxbytes+1),If(mac.source.data!=data[rxi],bad.eq(1)),If(mac.source.error,bad.eq(1)),If(mac.source.last,rxcount.eq(rxcount+1),If(bad|(rxi!=59)|(mac.source.data!=data[rxi])|mac.source.error,badcount.eq(badcount+1)),rxi.eq(0),bad.eq(0)).Else(If(rxi<59,rxi.eq(rxi+1)).Else(bad.eq(1))))]
  flags=Signal(32); self.comb += flags.eq(Cat(phy.pll.lock,phy.tx_init.done,phy.rx_init.done,phy.tx_mmcm.locked,phy.rx_mmcm.locked,phy.link_up,ref_lost,errsync,txresetdone,rxresetdone))
  report=Signal(512); self.comb += report.eq(Cat(Constant(0x504de701,32),tick,flags,cmd,Constant(0,16),refsync,txcount,rxcount,badcount,prbscount,rxbytes))
  self.specials += Instance('eth_jtag',i_report=report,o_command=cmd_async)

top=Top()
output=verilog.convert(top,ios=top.ios,name='pm12_eth_diag',special_overrides=xilinx_special_overrides)
Path(__file__).with_name('pm12_eth_diag.v').write_text(output.main_source)
for name,content in output.data_files.items():
 Path(__file__).with_name(name).write_text(content)
