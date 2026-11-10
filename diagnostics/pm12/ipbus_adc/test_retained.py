#!/usr/bin/env python3
"""Leased readout/recovery check of an already qualified resident PM12 image.
No CPLD, MCU or flash programming. Three volatile PHY resets preserve captures.
"""
import argparse,fcntl,hashlib,json,os,re,subprocess,sys,time
from pathlib import Path
from client import Client
ROOT=Path(__file__).resolve().parent
p=argparse.ArgumentParser();p.add_argument('--out',type=Path,required=True);p.add_argument('--capture-root',type=Path,required=True);a=p.parse_args();a.out.mkdir(parents=True,exist_ok=False)
locks=[]
for name in ['atmel-ice-J41800043065','pm12-210249A73E43']:
 f=open('/home/codex-hil/.cache/'+name+'.lock','a+');fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB);locks.append(f)
ADC=ROOT.parent/'adc'
if not ADC.exists():ADC=Path('/home/codex-hil/fit-testing-publish/diagnostics/pm12/adc')
base=['docker','-H','unix:///run/user/1001/docker-vivado.sock','exec','-e','LD_PRELOAD=/lib/x86_64-linux-gnu/libudev.so.1','9801db3654e2','timeout','130','/srv/codex-hil-data/toolchains/amd/Xilinx/2025.2/Vivado/bin/vivado','-mode','batch','-nolog','-nojournal','-notrace','-source']
def tcl(body,name):
 path=a.out/(name+'.tcl');path.write_text('source '+str(ADC/'tools/common.tcl')+'\npm12_open\n'+body+'\npm12_close\nexit\n')
 with (a.out/(name+'.log')).open('w') as f:subprocess.run(base+[str(path),'-tclargs','210249A73E43','localhost:3121','unused','0'],stdout=f,stderr=subprocess.STDOUT,check=True,timeout=145)
 text=(a.out/(name+'.log')).read_text();return [int(x,16) for x in re.findall(r'REPORT ([0-9a-fA-F]+)',text)]
report='scan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffc2\nputs "REPORT [scan_dr_hw_jtag 524 -tdi 0]"'
c=Client();status={'mcu_writes':False,'cpld_writes':False,'flash_writes':False,'started_unix':time.time()}
try:
 assert c.read(0)==[0x504d1202] and c.read(2)==[int((ROOT/'build-id.txt').read_text(),16)]
 cap=c.read(0x12)[0];flags=c.read(0x11)[0];assert flags&15==13 and not(flags&16)
 trace_count=c.read(0x101)[0];trace_elapsed=c.read(0x103)[0];assert c.read(0x102)==[0]
 trace=c.block(0x2000,trace_count*2)
 sdk=Path(os.environ.get('IPBUS_SDK_ROOT','/srv/codex-hil-data/workspaces/rng-rpi'));env=os.environ.copy();env['LD_LIBRARY_PATH']=':'.join(str(sdk/n) for n in ['experiments/upstream/ipbus-software/uhal/uhal/lib','experiments/upstream/ipbus-software/uhal/log/lib','experiments/upstream/ipbus-software/uhal/grammars/lib','build/uhal-deps/usr/lib/x86_64-linux-gnu'])
 with (a.out/'uhal-physical.json').open('w') as f:subprocess.run([str(ROOT/'uhal_dump'),'ipbusudp-2.0://192.168.2.240:50001','file://'+str(ROOT/'addresses.xml'),str(a.out/'uhal-data')],stdout=f,stderr=subprocess.STDOUT,env=env,check=True,timeout=60)
 for ch in range(1,13):assert (a.out/'uhal-data'/f'ch{ch:02d}.bin').read_bytes()==(a.capture_root/f'ch{ch:02d}.bin').read_bytes()
 status['official_uhal_physical']=json.loads((a.out/'uhal-physical.json').read_text());status['official_native_byte_comparison']='PASS 12x4096u16'
 initial=tcl(report,'initial-report')[0];cmd=(initial>>496)&65535;assert cmd!=0x6b52
 status['initial_command']=cmd;status['phy_cycles']=[]
 for i in range(3):
  body=f'scan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffc3\nscan_dr_hw_jtag 28 -tdi {0x6b52:07x}\nafter 100\nscan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffc3\nscan_dr_hw_jtag 28 -tdi {cmd:07x}\nafter 1000\n'+report
  start=time.monotonic();raw=tcl(body,f'phy-cycle-{i}')[0]
  for _ in range(10):
   try:
    if c.read(0)==[0x504d1202] and c.read(0x11)[0]&4:break
   except TimeoutError:pass
   time.sleep(.1)
  else:raise RuntimeError('PHY did not recover')
  assert c.read(0x12)==[cap] and c.read(0x11)==[flags]
  assert c.read(0x102)==[0] and c.read(0x101)==[trace_count] and c.read(0x103)==[trace_elapsed]
  assert c.block(0x2000,trace_count*2)==trace
  assert ((raw>>496)&65535)==cmd and ((raw>>72)&65535)==trace_count and not((raw>>88)&1)
  for ch,words in enumerate(c.download(cap),1):
   import struct
   assert struct.pack('<4096H',*words)==(a.capture_root/f'ch{ch:02d}.bin').read_bytes()
  status['phy_cycles'].append({'cycle':i,'result':'PASS','host_wrapper_s':round(time.monotonic()-start,3),'jtag_report':hex(raw)});print('PHY_CAPTURE_TRACE_HOLD_PASS',i,flush=True)
 # Explicit second IPbus ARM; USER2 is read-cursor only.
 old_trace_id=c.read(0x105)[0];c.write(0x100,[1])
 body='after 3500\n'+report+"""
 scan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffc2
 set header [expr {("0x[scan_dr_hw_jtag 524 -tdi 0]")+0}]
 set n [expr {($header>>72)&65535}]
 if {($header>>88)&1} {error "Rearmed trace active unexpectedly"}
 for {set i 0} {$i<$n} {incr i} {
  scan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffc3
  scan_dr_hw_jtag 28 -tdi [format %07x [expr {32768|$i}]]
  runtest_hw_jtag -tck 10
  scan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffc2
  set r [expr {("0x[scan_dr_hw_jtag 524 -tdi 0]")+0}]
  puts "REARM_EVENT $i [expr {($r>>128)&0xffffffff}] [expr {($r>>160)&7}]"
 }
 """
 raw=tcl(body,'explicit-rearm')[0];new_count=(raw>>72)&65535;new_elapsed=(raw>>96)&0xffffffff
 assert new_count>1 and not((raw>>88)&1) and c.read(0x105)==[old_trace_id+1]
 events=[tuple(map(int,x)) for x in re.findall(r'^REARM_EVENT (\d+) (\d+) (\d+)$',(a.out/'explicit-rearm.log').read_text(),re.M)]
 assert len(events)==new_count
 assert c.read(0x102)==[0] and c.read(0x101)==[new_count] and c.read(0x103)==[new_elapsed]
 words=c.block(0x2000,new_count*2)
 for i,ts,lines in events:assert words[2*i:2*i+2]==[ts,lines]
 (a.out/'rearmed-events.json').write_text(json.dumps(events)+'\n')
 assert c.read(0x12)==[cap] and c.read(0x11)==[flags]
 status['explicit_subsequent_ipbus_rearm']={'result':'PASS','events':new_count,'elapsed':new_elapsed,'post_close_ipbus_data_match':True}
 status['read_retry_events']=c.read_retry_events
 status['result']='PASS';status['capture_id']=cap;status['trace_events']=trace_count
except BaseException as e:status['result']='FAIL';status['error']=repr(e);raise
finally:
 c.close();status['finished_unix']=time.time();(a.out/'retained.json').write_text(json.dumps(status,indent=2)+'\n')
print('RETAINED_HARDWARE_PASS',flush=True)
