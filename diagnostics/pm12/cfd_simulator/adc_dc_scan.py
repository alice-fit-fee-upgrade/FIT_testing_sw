"""External differential DAC->MAX4053->AD9236 A/B DC scan, selected PM channel."""
import argparse,contextlib,fcntl,json,math,socket,statistics,struct,sys,time
from pathlib import Path
HERE=Path(__file__).resolve().parent
sys.path[:0]=[str(HERE),str(HERE.parent/'ipbus_adc'),'/home/codex-hil/FIT_PM_FW_uPC/tools/hardware']
from mod_dac28 import DAC,remote_lease,voltage
from console import ConsoleI2C,Registers
from mcp23017 import afe_route
from client import Client
from pm12_console_regression import PORT,capture
from pm12_power import wait_power_good,require_power_good
import serial

class Injection:
 def __init__(self,regs):
  self.r=regs
  a,b=regs.read(10),regs.read(11)
  if a!=b or a&128:raise RuntimeError('MCP BANK0 not verified')
  self.saved={n:regs.read(n) for n in [0,1,0x14,0x15]}
  self.w(0x15,self.saved[0x15]|0x20);self.w(1,self.saved[1]&~0x20) # inhibit first
  self.w(0x14,self.saved[0x14]|0x88);self.w(0,self.saved[0]&~0x8f) # monitor off,T1 high
  self.w(1,self.r.read(1)&~0xc0)
 def w(self,reg,value):
  self.r.write(reg,value)
  if self.r.read(reg)!=value:raise RuntimeError('MCP register readback mismatch')
 def select(self,bank):
  self.inhibit();v=self.r.read(0x15);v=(v&~0xc0)|(0xc0 if bank==0 else 0)
  self.w(0x15,v);self.w(0x15,v&~0x20)
 def inhibit(self):self.w(0x15,self.r.read(0x15)|0x20)
 def snapshot(self):return {str(n):self.r.read(n) for n in [0,1,0x12,0x13,0x14,0x15]}
 def restore(self):
  self.inhibit()
  # Restore directions/latches with mux inhibited during the transition.
  self.w(0x14,self.saved[0x14]|8);self.w(0,self.saved[0])
  self.w(0x15,self.saved[0x15]|0x20);self.w(1,self.saved[1]);self.w(0x15,self.saved[0x15]);self.w(0x14,self.saved[0x14])

def acquire(c,bank,out,label,channel=12):
 ident,state=c.acquire(bank,False);raw=c.block(0x10000+((channel-1)<<12),4096)
 assert c.read(0x12)==[ident] and all(((w>>12)&1)==bank and w<16384 for w in raw)
 (out/(label+'.bin')).write_bytes(struct.pack('<4096H',*raw))
 edges=[i for i in range(1,len(raw)) if not raw[i-1]&8192 and raw[i]&8192]
 if len(edges)<900 or any(b-a!=4 for a,b in zip(edges,edges[1:])):raise RuntimeError('Missing or irregular ADC strobe clock')
 samples=[raw[i-1]&4095 for i in edges[1:]]
 signed=[n if n<2048 else n-4096 for n in samples]
 return dict(generation=ident,status=state,bank=bank,samples=len(samples),
  centered_mean=statistics.mean(samples)-2048,raw_mean=statistics.mean(samples),raw_median=statistics.median(samples),raw_std=statistics.pstdev(samples),
  signed_mean=statistics.mean(signed),signed_median=statistics.median(signed),signed_std=statistics.pstdev(signed),
  minimum=min(samples),maximum=max(samples),histogram={str(n):samples.count(n) for n in set(samples)},
  strobe_period_samples=statistics.median(b-a for a,b in zip(edges,edges[1:])))

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--out',type=Path,required=True);p.add_argument('--afe',type=int,choices=range(1,13),default=12);p.add_argument('--probe',action='store_true');p.add_argument('--differences',type=float,nargs='+');a=p.parse_args()
 if a.probe and a.differences:p.error('--probe and --differences are exclusive')
 differences=a.differences if a.differences else ([-.02,-.01,0,.01,.02] if a.probe else [round(-1+i*.02,4) for i in range(101)])
 for v in differences:
  try:voltage(1+v/2);voltage(1-v/2)
  except (ValueError,TypeError):p.error('Both differential legs must remain within0..3.3V')
 a.out.mkdir(parents=True,exist_ok=False);report=dict(pass_=False,channel=a.afe,common_mode_v=1.0,max_pin_voltage_v=3.3,measurements=[])
 def save():(a.out/'status.json').write_text(json.dumps(report,indent=2)+'\n')
 with contextlib.ExitStack() as st:
  for n in sorted(['atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001','esp32-6825dd4c49e4','lattice-VER00001']):
   f=st.enter_context(open('/home/codex-hil/.cache/'+n+'.lock','a+'));fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB)
  remote=st.enter_context(remote_lease());dac=c=u=bus=inj=None;success=False
  try:
   dac=DAC(remote);report['dac_initial_setpoints']=dac.snapshot()
   u=serial.Serial(port=None,baudrate=115200,timeout=.03,write_timeout=1,rtscts=True,exclusive=True);u.dtr=False;u.rts=True;u.port=PORT;u.open();u.read(4096)
   report['pgood']=wait_power_good(u,capture);report['identity']=capture(u,'RS');assert 'Board S/N: 1803' in report['identity']['reply']
   c=Client();report['fpga_identity']=c.read(0,3)
   assert report['fpga_identity'][:2]==[0x504d1202,0x10002] and report['fpga_identity'][2] in (0xa27baa3e,0xc7c42d28)
   assert c.read(0x13,2)==[4096,12]
   bus=ConsoleI2C(u,capture)
   with bus.routed(*afe_route(a.afe)):
    require_power_good(u,capture);inj=Injection(Registers(bus));report['mcp_original']=inj.saved
    dac.baseline();report['baseline_setpoints']=dac.snapshot()
    for bank in [0,1]:
     inj.inhibit();dac.pair(1,1);inj.select(bank);time.sleep(.05)
     for index,diff in enumerate(differences):
      require_power_good(u,capture);vp,vn=1+diff/2,1-diff/2;dac.pair(vp,vn);time.sleep(.03)
      banks=[0,1] if a.probe else [bank]
      for read_bank in banks:
       row=acquire(c,read_bank,a.out,f'mux{bank}-point{index:03d}-bank{read_bank}',a.afe)
       row.update(injection_bank=bank,diff_setpoint_v=diff,ch0_setpoint_v=vp,ch1_setpoint_v=vn)
       report['measurements'].append(row);save()
       print('MUX',bank,'READ',read_bank,'DIFF',diff,'RAW',round(row['raw_mean'],3),'RMS',round(row['raw_std'],3),flush=True)
    dac.baseline();inj.select(0);time.sleep(.05);report['final_zero_capture']=acquire(c,0,a.out,'final-zero-bank0',a.afe);report['mcp_final']=inj.snapshot();report['dac_final_setpoints']=dac.snapshot()
    assert report['mcp_final']['18']&128 and not report['mcp_final']['21']&32
    report['pgood_final']=require_power_good(u,capture);success=True
   report['tca_final']={str(n):bus.mux(n) for n in [0x70,0x71]};report['pass_']=True
  except BaseException as e:
   report['error']=repr(e);raise
  finally:
   # Routing context may already be closed: reacquire it for GPIO cleanup.
   if not success:
    # Mute DAC independently of I2C/GPIO cleanup, also on PM power loss.
    if dac is not None:
     try:dac.zero();report['dac_fault_park_v']=[0,0]
     except Exception as e:report['dac_shutdown_error']=repr(e)
    if inj is not None:
     try:
      with bus.routed(*afe_route(a.afe)):inj.inhibit();inj.restore()
      report['gpio_restored']=True
     except Exception as e:report['cleanup_error']=repr(e)
   if c:c.close()
   if u:u.rts=False;u.dtr=False;u.close()
   if bus:report['i2c_commands']=bus.records
   if dac:report['scpi_commands']=dac.records;dac.close()
   report['pass']=report.pop('pass_');save()
if __name__=='__main__':main()
