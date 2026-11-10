from pathlib import Path
from types import SimpleNamespace
import re,hashlib
from migen import *
from migen.fhdl import verilog
from migen.genlib.cdc import MultiReg
from litex.build.xilinx.common import xilinx_special_overrides
from litex.soc.cores.clock import S7MMCM
from liteeth.mac.core import LiteEthMACCore
from k7_phy import K7_1000BASEX
from capture import Capture
from analyzer import Analyzer
from registers import Registers
root=Path(__file__).resolve().parent
build_sources=['generate.py','capture.py','analyzer.py','registers.py','pm12_mcu_spi.vhd','k7_phy.py','eth_jtag.v','pins.xdc','build.tcl']+['ipbus/'+n for n in (root/'ipbus-order.txt').read_text().splitlines()]
build_id=int.from_bytes(hashlib.sha256(b''.join(n.encode()+b'\0'+(root/n).read_bytes() for n in build_sources)).digest()[:4],'big')
class Top(Module):
 def __init__(self):
  mp=Signal(name_override='MCLK1_P');mn=Signal(name_override='MCLK1_N');rp=Signal(name_override='MGTCLK_P');rn=Signal(name_override='MGTCLK_N')
  pads=SimpleNamespace(txp=Signal(name_override='TX_P'),txn=Signal(name_override='TX_N'),rxp=Signal(name_override='RX_P'),rxn=Signal(name_override='RX_N'))
  self.ios={mp,mn,rp,rn,pads.txp,pads.txn,pads.rxp,pads.rxn}
  self.clock_domains.cd_sys=ClockDomain('sys');m=Signal();ref=Signal()
  self.specials += [Instance('IBUFDS',p_DIFF_TERM='TRUE',i_I=mp,i_IB=mn,o_O=m),Instance('BUFG',i_I=m,o_O=self.cd_sys.clk),Instance('IBUFDS_GTE2',i_I=rp,i_IB=rn,i_CEB=0,o_O=ref)]
  self.clock_domains.cd_cap=ClockDomain('cap');self.submodules.cap_cm=cap_cm=S7MMCM(speedgrade=-3,fractional=False);cap_cm.vco_freq_range=(600e6,1200e6);cap_cm.register_clkin(self.cd_sys.clk,40e6);cap_cm.create_clkout(self.cd_cap,320e6)
  self.clock_domains.cd_net=ClockDomain('net');self.submodules.net_cm=net_cm=S7MMCM(speedgrade=-3,fractional=False);net_cm.register_clkin(self.cd_sys.clk,40e6);net_cm.create_clkout(self.cd_net,125e6)
  self.submodules.phy=phy=K7_1000BASEX(ref,pads,40e6,with_csr=False)
  self.submodules.mac=mac=ClockDomainsRenamer({'sys':'net'})(LiteEthMACCore(phy,dw=8,with_sys_datapath=True,with_store_and_forward=True))
  rx,tx=mac.source,mac.sink;first=Signal(reset=1);self.sync.net += If(tx.valid&tx.ready,first.eq(tx.last));self.comb += [rx.ready.eq(1),tx.first.eq(first),tx.be.eq(1)]
  inputs=[]
  for n in range(1,13):
   di=Signal(13,name_override='DI'+str(n));st=Signal(name_override='STR'+str(n));self.ios.update({di,st});inputs.append(Cat(di,st))
  self.submodules.capture=cap=Capture(inputs)
  raw=Signal(3)
  for i,name in enumerate(['I2C_SDA','I2C_SCL','I2C_RESET_N']):
   pad=Signal(name_override=name);self.ios.add(pad);self.specials += Instance('IBUF',i_I=pad,o_O=raw[i])
  command=Signal(16);self.submodules.analyzer=trace=Analyzer(raw,command)
  jtag_report=Signal(512);self.specials += Instance('eth_jtag',i_report=jtag_report,o_command=command)
  self.submodules.registers=regs=Registers(cap,trace,build_id)
  phy_request=Signal();self.specials += MultiReg(command==0x6b52,phy_request)
  startup=Signal(max=2000001,reset=2000000);self.sync += If(startup!=0,startup.eq(startup-1))
  self.comb += phy.reset.eq((startup!=0)|phy_request)
  ev=Signal(name_override='EVNT');self.ios.add(ev);self.comb += ev.eq(regs.ev)
  link=Signal();lock=Signal();netlock=Signal();self.specials += [MultiReg(phy.link_up,link),MultiReg(cap_cm.locked,lock),MultiReg(net_cm.locked,netlock)];self.comb += [regs.link.eq(link),regs.locked.eq(lock)]
  got_ip=Signal()
  self.specials += Instance('rng_ipbus_endpoint',i_mac_clk=ClockSignal('net'),i_rst_macclk=ResetSignal('net'),i_ipb_clk=ClockSignal('sys'),i_rst_ipb=~netlock,
   i_mac_rx_data=rx.data,i_mac_rx_valid=rx.valid,i_mac_rx_last=rx.last&rx.valid,i_mac_rx_error=rx.error&rx.valid,
   o_mac_tx_data=tx.data,o_mac_tx_valid=tx.valid,o_mac_tx_last=tx.last,o_mac_tx_error=tx.error,i_mac_tx_ready=tx.ready,
   i_mac_addr=0x020000001201,i_ip_addr=0xc0a802f0,o_got_ip=got_ip,o_ipb_addr=regs.address,o_ipb_wdata=regs.wdata,o_ipb_strobe=regs.strobe,o_ipb_write=regs.write,i_ipb_rdata=regs.rdata,i_ipb_ack=regs.ack,i_ipb_err=regs.err)
  rx_bytes=Signal(32);rx_frames=Signal(32);tx_bytes=Signal(32);tx_frames=Signal(32);rx_errors=Signal(16);ipb_count=Signal(32);net_tick=Signal(32)
  self.sync.net += [net_tick.eq(net_tick+1),If(rx.valid,rx_bytes.eq(rx_bytes+1),If(rx.last,rx_frames.eq(rx_frames+1)),If(rx.error,rx_errors.eq(rx_errors+1))),If(tx.valid&tx.ready,tx_bytes.eq(tx_bytes+1),If(tx.last,tx_frames.eq(tx_frames+1)))]
  self.sync += If(regs.strobe,ipb_count.eq(ipb_count+1))
  debug=Cat(Constant(0x504d4442,32),link,lock,netlock,got_ip,ResetSignal('net'),phy.pll.lock,phy.tx_init.done,phy.rx_init.done,phy.tx_mmcm.locked,phy.rx_mmcm.locked,phy_request,(startup!=0),Constant(0,20),rx_frames,tx_frames,rx_bytes,tx_bytes,rx_errors,Constant(0,16),ipb_count,net_tick,command)
  # Upper JTAG report is read-only network diagnostics; original lower208 bits retained.
  self.comb += jtag_report.eq(Cat(trace.report[:208],debug))
  sp=SimpleNamespace(sck=Signal(name_override='SCK'),mosi=Signal(name_override='MOSI'),miso=Signal(name_override='MISO'),cs=Signal(name_override='CS'));self.ios.update({sp.sck,sp.mosi,sp.miso,sp.cs});mi=Signal();scratch=Signal(16);writes=Signal(16)
  self.specials += [Instance('pm12_mcu_spi',i_SCKI=sp.sck,i_SPI_CS=sp.cs,i_MOSII=sp.mosi,o_MISOI=mi,o_scratch_out=scratch,o_writes_out=writes),Instance('OBUFT',i_I=mi,i_T=sp.cs,o_O=sp.miso),MultiReg(scratch,regs.mcu_scratch),MultiReg(writes,regs.mcu_writes)]
top=Top();v=verilog.convert(top,ios=top.ios,name='pm12_ipbus_adc',special_overrides=xilinx_special_overrides)
text,n=re.subn(r'(reg \[15:0\] adc_trace\d+\[0:4095\];)',r'(* ram_style = "block" *) \1',v.main_source);assert n==12,n
(root/'pm12_ipbus_adc.v').write_text(text)
for name,data in v.data_files.items():(root/name).write_text(data)
(root/'build-id.txt').write_text(f'{build_id:08x}\n')
print(f'Generated PM12 IPbus ADC build{build_id:08x}')
