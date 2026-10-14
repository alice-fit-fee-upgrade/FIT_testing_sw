from pathlib import Path
import argparse, socket, struct
parser=argparse.ArgumentParser(description="Generate fixed diagnostic UDP frames for a chosen host")
parser.add_argument("--host-ip",default="192.168.2.107")
parser.add_argument("--host-mac",default="6c:2b:59:f4:76:e8")
args=parser.parse_args()
assert len(bytes.fromhex(args.host_mac.replace(":","")))==6
from migen.fhdl.structure import _Assign
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
  ports={'RXPOLARITY':cmd[9],'TXPOLARITY':cmd[10],'LOOPBACK':cmd[:3],'TXPRBSSEL':Mux(cmd[4],1,0),'RXPRBSSEL':Mux(cmd[5],2,Mux(cmd[4],1,0)),'RXPRBSERR':prbs_err,'CPLLREFCLKLOST':ref_lost}
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
  # Valid fixed IPv4/UDP diagnostic frame, not a general IP/ARP stack.
  # Source address is from the RFC2544 laboratory benchmark range.
  def checksum(b):
   if len(b)%2:b+=b'\0'
   total=sum(struct.unpack('!'+str(len(b)//2)+'H',b))
   while total>>16:total=(total&65535)+(total>>16)
   return (~total)&65535
  source=bytes([198,18,0,12]); destination=socket.inet_aton(args.host_ip)
  payload=b'PM12-SFP-UDP-TEST!'; assert len(payload)==18
  ip=struct.pack('!BBHHHBBH4s4s',0x45,0,46,0x504d,0x4000,64,17,0,source,destination)
  ip=ip[:10]+struct.pack('!H',checksum(ip))+ip[12:]
  udp=struct.pack('!HHHH',49154,49155,26,0)+payload
  c=checksum(source+destination+b'\0\x11'+struct.pack('!H',26)+udp) or 65535
  udp=udp[:6]+struct.pack('!H',c)+udp[8:]
  frame=list(bytes.fromhex(args.host_mac.replace(':',''))+bytes.fromhex('0200000000020800')+ip+udp)
  assert len(frame)==60
  data=Array(Constant(x,8) for x in frame)
  self.comb += [mac.sink.valid.eq((gap==0)&~cmd[4]&~cmd[8]),mac.sink.data.eq(data[txi] ^ Mux(cmd[6] & (txi==59),1,0)),mac.sink.last.eq(txi==59),mac.sink.be.eq(1),mac.sink.error.eq(0),mac.source.ready.eq(1)]
  self.sync += [If(gap!=0,gap.eq(gap-1)).Elif(mac.sink.valid&mac.sink.ready,If(txi==59,txi.eq(0),gap.eq(60000),txcount.eq(txcount+1)).Else(txi.eq(txi+1))),If(mac.source.valid,rxbytes.eq(rxbytes+1),If(mac.source.data!=data[rxi],bad.eq(1)),If(mac.source.error,bad.eq(1)),If(mac.source.last,rxcount.eq(rxcount+1),If(bad|(rxi!=59)|(mac.source.data!=data[rxi])|mac.source.error,badcount.eq(badcount+1)),rxi.eq(0),bad.eq(0)).Else(If(rxi<59,rxi.eq(rxi+1)).Else(bad.eq(1))))]
  # Laboratory fixed-rate mode: suppress Clause 37 config transmission and
  # accept a link only after receiving valid idle/config code groups.
  fixed_mode=Signal(); self.specials += MultiReg(cmd[11],fixed_mode,'eth_tx')
  fixed_up=Signal(); idle_age=Signal(20)
  self.sync.eth_tx += If(phy.pcs.seen_valid_ci.o,idle_age.eq(0),fixed_up.eq(1)).Elif(idle_age<750000,idle_age.eq(idle_age+1)).Else(fixed_up.eq(0))
  # Gate the actual FSM assignments; parent combinational overrides would
  # be overwritten by the finalized FSM fragment.
  def gate_actions(actions):
   for a in actions:
    if isinstance(a,_Assign) and (a.l is phy.pcs.tx.config_valid or a.l is phy.pcs.restart): a.r=a.r & ~fixed_mode
    elif isinstance(a,If): gate_actions(a.t); gate_actions(a.f)
  for actions in phy.pcs.fsm.actions.values(): gate_actions(actions)
  link=Signal(); self.comb += link.eq(Mux(fixed_mode,fixed_up,phy.link_up))
  ci_count=Signal(32); cfg_count=Signal(32); invalid_count=Signal(32); rx_mac_errors=Signal(32)
  self.sync.eth_rx += [If(phy.pcs.rx.seen_valid_ci,ci_count.eq(ci_count+1)),If(phy.pcs.rx.seen_config_reg,cfg_count.eq(cfg_count+1)),If(phy.pcs.rx.decoder.invalid,invalid_count.eq(invalid_count+1))]
  self.sync += If(mac.source.valid & mac.source.last & mac.source.error,rx_mac_errors.eq(rx_mac_errors+1))
  raw=Signal(32); self.comb += raw.eq(Cat(phy.pcs.tbi_rx,phy.pcs.rx.decoder.d,phy.pcs.rx.decoder.k,phy.pcs.rx.decoder.invalid,phy.pcs.is_sgmii,phy.pcs.linkdown,fixed_up,fixed_mode))
  partner=Signal(32); self.comb += partner.eq(Cat(phy.pcs.lp_abi.o,phy.pcs.rx.config_reg))
  flags=Signal(32); self.comb += flags.eq(Cat(phy.pll.lock,phy.tx_init.done,phy.rx_init.done,phy.tx_mmcm.locked,phy.rx_mmcm.locked,link,ref_lost,errsync,txresetdone,rxresetdone))
  report=Signal(512); self.comb += report.eq(Cat(Constant(0x504de701,32),tick,flags,cmd,Constant(0,16),refsync,txcount,rxcount,badcount,prbscount,rxbytes,raw,partner,ci_count,cfg_count,invalid_count,rx_mac_errors))
  self.specials += Instance('eth_jtag',i_report=report,o_command=cmd_async)

top=Top()
output=verilog.convert(top,ios=top.ios,name='pm12_eth_diag',special_overrides=xilinx_special_overrides)
Path(__file__).with_name('pm12_eth_diag.v').write_text(output.main_source)
for name,content in output.data_files.items():
 Path(__file__).with_name(name).write_text(content)
