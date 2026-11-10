#!/usr/bin/env python3
"""Leased PM12 IPbus/ADC qualification. CPLD NV restored on every exit.
--leave-loaded retains the integrated FPGA only on full success, with frozen ADC data.
"""
import argparse,csv,fcntl,hashlib,json,os,re,signal,subprocess,sys,time
from pathlib import Path
import serial
from client import Client,describe,save_capture
ROOT=Path(__file__).resolve().parent
ADC=ROOT.parent/'adc'
assert ADC.is_dir(), 'Run from the FIT_testing_sw diagnostics/pm12 checkout'
sys.path.insert(0,str(ADC.parent));from test_board import payload
sys.path.insert(0,'/home/codex-hil/FIT_PM_FW_uPC/tools/hardware')
from pm12_console_regression import capture,PORT
from pm12_power import wait_power_good,require_power_good
p=argparse.ArgumentParser();p.add_argument('--container',default='9801db3654e2');p.add_argument('--out',required=True,type=Path);p.add_argument('--program-cplds',action='store_true');p.add_argument('--leave-loaded',action='store_true');p.add_argument('--trace-only',action='store_true');a=p.parse_args();
if not a.trace_only and not a.program_cplds:p.error('Real acquisitions require --program-cplds; use --trace-only for a volatile FPGA-only check')
out=a.out.resolve();out.mkdir(parents=True,exist_ok=False)
restore=Path('/home/codex-hil/FIT_PM_FW_uPC/tools/hardware/fpga_analyzer/build/pm12_analyzer.bit');bit=ROOT/'build/pm12_ipbus_adc.bit'
assert hashlib.sha256(restore.read_bytes()).hexdigest()=='e215a8c36572a6ffdd266c1c288f4106c92d3d1550d6c2bfaede08bdd63d15c6'
status={'cpld_jed_sha256':hashlib.sha256((ADC/'cpld/build/design.jed').read_bytes()).hexdigest(),'cpld_program_sha256':hashlib.sha256((ADC/'work/program-vendor.tcl').read_bytes()).hexdigest(),'fpga_sha256':hashlib.sha256(bit.read_bytes()).hexdigest(),'restore_fpga_sha256':hashlib.sha256(restore.read_bytes()).hexdigest(),'mcu_writes':False,'cpld_nv_cycle_requested':not a.trace_only,'cpld_nv_programmed':False,'captures':[],'started_unix':time.time()}
locks=[]
for name in ['atmel-ice-J41800043065','pm12-210249A73E43']:
 f=open('/home/codex-hil/.cache/'+name+'.lock','a+');fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB);locks.append(f)
signal.signal(signal.SIGTERM,lambda *_:(_ for _ in ()).throw(KeyboardInterrupt('SIGTERM')))
base=['docker','-H','unix:///run/user/1001/docker-vivado.sock','exec','-e','LD_PRELOAD=/lib/x86_64-linux-gnu/libudev.so.1',a.container,'timeout','130','/srv/codex-hil-data/toolchains/amd/Xilinx/2025.2/Vivado/bin/vivado','-mode','batch','-nolog','-nojournal','-notrace','-source']
def tcl(path,name,vec='unused',bits=0,marker=None):
 with (out/name).open('w') as log:subprocess.run(base+[str(path),'-tclargs','210249A73E43','localhost:3121',str(vec),str(bits)],stdout=log,stderr=subprocess.STDOUT,check=True,timeout=150)
 text=(out/name).read_text()
 if marker:assert marker in text,(name,'missing '+marker)
 return text
def nv_rows(text):return re.findall(r'^ARRAY (\d+) ([AB]) (\d+) ([a-fA-F0-9]+)$',text,re.M)
def console(commands):
 u=serial.Serial(port=None,baudrate=115200,timeout=.03,write_timeout=1,rtscts=True,exclusive=True);u.dtr=False;u.rts=True;u.port=PORT;u.open();rows=[]
 try:
  u.read(4096);ready=wait_power_good(u,capture);status.setdefault('power_checks',[]).append(ready)
  for cmd in commands:
   if cmd.startswith(('@TEMP','@INA','@FPGATEST')):require_power_good(u,capture)
   for retry in range(5):
    row=capture(u,cmd);rows.append(row)
    if row['reply']!='ERR I2C BUSY\r\n':break
    status.setdefault('transient_i2c_busy',[]).append({'command':cmd,'attempt':retry});time.sleep(.073)
   assert row['reply'] and 'ERR ' not in row['reply'],row
   if cmd=='@PING':assert row['reply']=='PONG\r\n'
   if cmd=='@TEMP':assert 'REG=03 C3\r\n' in row['reply']
   if cmd=='@FPGATEST':assert 'PASS 32 RESTORED' in row['reply']
   if cmd=='RS':assert 'Board power ON, OK' in row['reply'] and 'NORMAL' in row['reply']
  return rows
 finally:u.rts=False;u.dtr=False;u.close()
def identify(c,phase):
 for retry in range(10):
  try:ids=c.read(0,10);break
  except TimeoutError:
   print('IPBUS_IDENTITY_TIMEOUT',phase,retry,flush=True)
   probe=(out/'network-report.tcl');probe.write_text('source '+str(ADC/'tools/common.tcl')+'\npm12_open\nscan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffc2\nputs \"NETWORK_REPORT [scan_dr_hw_jtag 524 -tdi 0]\"\npm12_close\nexit\n')
   text=tcl(probe,f'{phase}-network-{retry}.log',marker='NETWORK_REPORT');raw=int(re.search(r'NETWORK_REPORT ([0-9a-fA-F]+)',text)[1],16)>>208
   print('NETWORK_DEBUG',hex(raw),flush=True)
   status.setdefault('network_debug',[]).append({'phase':phase,'report':hex(raw)})
   flags=(raw>>32)&0xffffffff
   print('PHY_FLAGS',hex(flags),'link',flags&1,'CPLL',(flags>>5)&1,'TX_done',(flags>>6)&1,'RX_done',(flags>>7)&1,'TX_MMCM',(flags>>8)&1,'RX_MMCM',(flags>>9)&1,flush=True)
   if retry in [0,3] and not(flags&1):
    oldcmd=(raw>>288)&65535;hi=0x6b52;lo=oldcmd
    reset_script=out/'restart-phy.tcl';reset_script.write_text(('source '+str(ADC/'tools/common.tcl')+'\npm12_open\nscan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffc3\nscan_dr_hw_jtag 28 -tdi {hi:07x}\nafter 100\nscan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffc3\nscan_dr_hw_jtag 28 -tdi {lo:07x}\nafter 1000\nputs PHY_RESTARTED\npm12_close\nexit\n').format(hi=hi,lo=lo))
    tcl(reset_script,f'{phase}-restart-phy-{retry}.log',marker='PHY_RESTARTED')
    status.setdefault('manual_phy_restarts',[]).append({'phase':phase,'retry':retry,'oldcmd':oldcmd})

 else:raise TimeoutError('No IPbus identity after ten attempts')
 return ids
# Known chain; both old/new images retain the original USER1 analyzer identity.
s=(ADC/'tools/load_fpga.tcl').read_text().replace('source [file join [file dirname [info script]] common.tcl]','source '+str(ADC/'tools/common.tcl')).replace('0x504dad01','0x504d5a03')
(out/'restore-load.tcl').write_text(s);(out/'load.tcl').write_text(s.replace('0x504d5a03','0x504d5a04'));bits=payload(bit,out/'candidate.hex');oldbits=payload(restore,out/'restore.hex')
attempted=False;touched=False;success=False;baseline=None;baseline_sram=None;c=None
try:
 print('CONSOLE_BASELINE',flush=True);status['console_before']=console(['@PING','@HW','@TEMP','@INA 4','@INA 5','@INA 6','RS','@FPGATEST'])
 print('VERIFY_CPLD_BASELINE',flush=True);before=tcl(ADC/'tools/read_cplds.tcl','nv-before.log',marker='CPLD_READ_PASS');baseline=nv_rows(before);assert len(baseline)==1968 and all(int(x[3],16)==(1<<752)-1 for x in baseline),'Unknown CPLD NV, do not alter'
 before_sram=tcl(ADC/'tools/read_sram.tcl','sram-before.log',marker='CPLD_SRAM_READ_PASS');baseline_sram=nv_rows(before_sram);assert len(baseline_sram)==1968 and all(int(x[3],16)==(1<<752)-1 for x in baseline_sram),'Unknown CPLD SRAM, do not alter'
 print('LOAD_INTEGRATED_FPGA',flush=True);attempted=True;tcl(out/'load.tcl','load.log',out/'candidate.hex',bits,'LOAD_PASS');time.sleep(3)
 c=Client()
 ids=identify(c,'startup')
 assert ids[0]==0x504d1202 and ids[2]==int((ROOT/'build-id.txt').read_text(),16),ids;status['identity']=ids
 print('IPBUS_SELFTEST',flush=True);scratch=c.read(3)[0]
 for i in range(64):
  v=(1<<(i&31)) if i<32 else ((~(1<<(i&31)))&0xffffffff);c.write(3,[v]);assert c.read(3)==[v]
 assert c.read(3,32,False)==[v]*32
 c.write(3,[0x12345678]);assert c.transact(4,3,[0xffff00ff,0xab00])==[0x12345678];assert c.read(3)==[0x1234ab78]
 assert c.transact(5,3,[7])==[0x1234ab78];assert c.read(3)==[0x1234ab7f]
 for kind,addr,values in [(0,0xdeadbeef,None),(1,0,[0]),(0,0x10000,None),(1,0x10,[0x80000001])]:
  r=c.transact(kind,addr,values,allow_error=True);assert r[1]&15
 c.write(3,[scratch]);little=Client(order='<');assert little.read(0)==[0x504d1202];little.close()
 status['ipbus_native']='PASS walking bits/nonincrementing/RMW/errors/recovery/both endian modes'
 for bank in [1,0]:
  ident,flags=c.acquire(bank,True);data=c.download(ident);summary=save_capture(out/f'pattern-bank{bank}',data,bank,True,ident,flags);status['captures'].append(summary);print('PATTERN_PASS',bank,flush=True)
 rng=Path('/srv/codex-hil-data/workspaces/rng-rpi');env=os.environ.copy();env['LD_LIBRARY_PATH']=':'.join(str(rng/n) for n in ['experiments/upstream/ipbus-software/uhal/uhal/lib','experiments/upstream/ipbus-software/uhal/log/lib','experiments/upstream/ipbus-software/uhal/grammars/lib','build/uhal-deps/usr/lib/x86_64-linux-gnu'])
 with (out/'uhal-result.json').open('w') as log:subprocess.run([str(ROOT/'uhal_probe'),'ipbusudp-2.0://192.168.2.240:50001','file://'+str(ROOT/'addresses.xml')],stdout=log,stderr=subprocess.STDOUT,env=env,check=True,timeout=60)
 status['official_uhal']=json.loads((out/'uhal-result.json').read_text());print('OFFICIAL_UHAL_PASS',flush=True)
 if not a.trace_only:
  print('PROGRAM12_CPLDS',flush=True);touched=True;status['cpld_nv_programmed']=True;tcl(ADC/'tools/execute_native.tcl','program-cplds.log',ADC/'work/program-vendor.tcl',0,'NATIVE_EXECUTE_PASS');programmed=nv_rows(tcl(ADC/'tools/read_sram.tcl','read-sram.log',marker='CPLD_SRAM_READ_PASS'));assert len(programmed)==1968
  vectors=[[v for ch,ps,row,v in programmed if int(ch)==n and ps==side] for n in range(1,13) for side in ['A','B']];assert all(v==vectors[0] for v in vectors) and any(int(v,16)!=(1<<752)-1 for v in vectors[0]);status['cpld_sram_programmed_consistently']=True
  status['post_cpld_identity']=identify(c,'post-cpld')
  for index,bank in enumerate([0,1,0]):
   ident,flags=c.acquire(bank,False);data=c.download(ident);summary=save_capture(out/f'physical-{index}-bank{bank}',data,bank,False,ident,flags);status['captures'].append(summary);print('PHYSICAL_CAPTURE_PASS',index,bank,flush=True)
 # Capture MCU I2C traffic while preserving original JTAG control/report access.
 trace=ROOT/'capture.tcl';marker=out/'trace-armed'
 console([])
 with (out/'jtag-trace.log').open('w') as log:
  child=subprocess.Popen(base+[str(trace),'-tclargs','210249A73E43','localhost:3121',str(marker),'0'],stdout=log,stderr=subprocess.STDOUT)
  try:
   deadline=time.monotonic()+25
   while not marker.exists():
    if child.poll() is not None or time.monotonic()>deadline:raise RuntimeError('JTAG trace failed to arm')
    time.sleep(.05)
   old_trace_id=c.read(0x105)[0];c.write(0x100,[1]);status['trace_capture_id']=old_trace_id+1
   status['console_during_trace']=console(['@INA 4','@TEMP','@HW'])
   child.wait(timeout=100);assert child.returncode==0
  finally:
   if child.poll() is None:child.terminate();child.wait(timeout=5)
 text=(out/'jtag-trace.log').read_text();assert 'CAPTURE_PASS' in text
 events=[tuple(map(int,m)) for m in re.findall(r'^EVENT (\d+) (\d+) (\d+)$',text,re.M)];assert events
 trace_state={'capture_id':c.read(0x105),'active':c.read(0x102),'count':c.read(0x101),'expected_count':len(events),'elapsed':c.read(0x103),'events':events};status['trace_state']=trace_state;print('TRACE_STATE',str({k:v for k,v in trace_state.items() if k!='events'}),flush=True)
 assert trace_state['capture_id']==[old_trace_id+1] and trace_state['active']==[0] and trace_state['count']==[len(events)],{k:v for k,v in trace_state.items() if k!='events'}
 words=c.block(0x2000,len(events)*2)
 (out/'ipbus-trace-words.json').write_text(json.dumps(words)+'\n')
 for i,ts,lines in events:assert words[2*i]==ts and words[2*i+1]==lines,('Trace mismatch',i,ts,lines,words[2*i:2*i+2])
 with (out/'i2c-trace.csv').open('w') as f:
  w=csv.writer(f);w.writerow(['event','cycles','SDA','SCL','RESET_N'])
  for i,ts,v in events:w.writerow([i,ts,v&1,(v>>1)&1,(v>>2)&1])
 status['analyzer_jtag_ipbus_comparison']={'result':'PASS','events':len(events)}
 status['console_after']=console(['@PING','@TEMP','@INA 4','@INA 5','@INA 6','RS','@FPGATEST'])
 success=True;status['result']='PASS'
except BaseException as e:
 status['error']=repr(e);print('FAILED',repr(e),flush=True)
 if attempted:
  try:
   debug=out/'failure-report.tcl';debug.write_text('source '+str(ADC/'tools/common.tcl')+'\npm12_open\nscan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffc2\nputs \"FAILURE_REPORT [scan_dr_hw_jtag 524 -tdi 0]\"\npm12_close\nexit\n')
   status['failure_jtag']=tcl(debug,'failure-report.log',marker='FAILURE_REPORT')
  except Exception as diag:status['failure_jtag_error']=repr(diag)
 raise
finally:
 errors=[]
 if touched:
  try:
   print('RESTORE_CPLD_BLANK',flush=True);tcl(ADC/'tools/erase_restore_cplds.tcl','erase-cplds.log',marker='ALL_CPLD_ERASED_RESTORED')
   final=tcl(ADC/'tools/read_cplds.tcl','nv-after.log',marker='CPLD_READ_PASS');status['cpld_nv_restored']=nv_rows(final)==baseline;assert status['cpld_nv_restored']
   final_sram=tcl(ADC/'tools/read_sram.tcl','sram-after.log',marker='CPLD_SRAM_READ_PASS');status['cpld_sram_restored']=nv_rows(final_sram)==baseline_sram;assert status['cpld_sram_restored']
  except Exception as e:errors.append('CPLD restore:'+repr(e))
 if c and success and not errors and a.leave_loaded:
  try:
   assert identify(c,'post-restore')[0]==0x504d1202 and c.read(0x11)[0]&1
   status['retained_capture_id']=c.read(0x12)[0]
  except Exception as e:errors.append('Retained ADC data:'+repr(e))
 if attempted and (not success or errors or not a.leave_loaded):
  try:
   print('RESTORE_ANALYZER',flush=True);tcl(out/'restore-load.tcl','restore-analyzer.log',out/'restore.hex',oldbits,'LOAD_PASS');status['original_analyzer_restored']=True
  except Exception as e:errors.append('FPGA restore:'+repr(e))
 elif attempted:status['integrated_image_left_loaded']=True
 if c:status['read_retry_events']=c.read_retry_events;c.close()
 status['result']='PASS' if success and not errors else 'FAIL'
 status['cleanup_errors']=errors;status['finished_unix']=time.time();(out/'hardware.json').write_text(json.dumps(status,indent=2)+'\n')
 if errors:raise RuntimeError('Cleanup/retained-state failure:'+repr(errors))
print('IPBUS_ADC_HARDWARE_PASS',out,flush=True)
