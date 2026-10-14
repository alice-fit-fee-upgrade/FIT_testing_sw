#!/usr/bin/env python3
"""Bounded PM12 ADC diagnostic: lease, exact identity, test, restore, verify NVM."""
import argparse,fcntl,sys,subprocess,json,re,hashlib,time
from pathlib import Path
from udp_client import run
sys.path.insert(0,str(Path(__file__).resolve().parents[2]))
if not (Path(__file__).resolve().parents[2]/'test_board.py').exists():
 sys.path.insert(0,'/home/codex-hil/fit-testing-publish/diagnostics/pm12')
from test_board import payload
ROOT=Path(__file__).resolve().parents[1]
RESTORE=ROOT.parent/'gateware/build/pm12_link_diag.bit'
if not RESTORE.exists():RESTORE=Path('/home/codex-hil/fit-bringup/gateware/pm12_link_diag/build/pm12_link_diag.bit')
p=argparse.ArgumentParser();p.add_argument('--container',required=True);p.add_argument('--cpld-jed',type=Path,default=ROOT/'cpld/build/design.jed');p.add_argument('--cpld-program',type=Path,default=ROOT/'work/program-vendor.tcl');p.add_argument('--out',type=Path,required=True);p.add_argument('--restore-bitstream',type=Path,default=RESTORE);args=p.parse_args();args.out.mkdir(parents=True,exist_ok=False)
def tcl(name,vector='unused',bits=0,marker=None,timeout=130,tag=None):
 cmd=['docker','-H','unix:///run/user/1001/docker-vivado.sock','exec',args.container,'timeout',str(timeout),'/srv/codex-hil-data/toolchains/amd/Xilinx/2025.2/Vivado/bin/vivado','-mode','batch','-nolog','-nojournal','-notrace','-source',str(ROOT/'tools'/name),'-tclargs','210249A73E43','localhost:3121',str(vector),str(bits)]
 path=args.out/((tag or name)+'.log')
 with path.open('w') as f:subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT,check=True,timeout=timeout+20)
 s=path.read_text()
 if marker and marker not in s:raise RuntimeError(f'Missing {marker} in {path}')
 return s
with open('/home/codex-hil/.cache/pm12-210249A73E43.lock','a+') as lease:
 fcntl.flock(lease,fcntl.LOCK_EX|fcntl.LOCK_NB)
 before=tcl('read_cplds.tcl',marker='CPLD_READ_PASS',tag='read-before')
 def array(text):return re.findall(r'^ARRAY (\d+) ([AB]) (\d+) ([a-fA-F0-9]+)$',text,re.M)
 before_rows=array(before);assert len(before_rows)==1968
 assert all(int(v,16)==(1<<752)-1 for ch,ps,row,v in before_rows),'Baseline no longer blank: preserve original state before testing'
 diag=args.out/'diag-payload.hex';dbits=payload(ROOT/'fpga/build/pm12_adc_diag.bit',diag)
 old=args.out/'restore-payload.hex';obits=payload(args.restore_bitstream,old)
 status={'cpld_jed_sha256':hashlib.sha256(args.cpld_jed.read_bytes()).hexdigest(),'fpga_bit_sha256':hashlib.sha256((ROOT/'fpga/build/pm12_adc_diag.bit').read_bytes()).hexdigest(),'serial':'210249A73E43','nonvolatile_writes':True,'started':time.time()};restore_errors=[]
 try:
  print('Loading FPGA SRAM',flush=True)
  tcl('load_fpga.tcl',diag,dbits,marker='LOAD_PASS')
  print('Programming diagnostic CPLD NV after FPGA',flush=True)
  tcl('execute_native.tcl',args.cpld_program,marker='NATIVE_EXECUTE_PASS')
  tcl('read_sram.tcl',marker='CPLD_SRAM_READ_PASS')
  print('Testing Ethernet/ADC',flush=True);time.sleep(3)
  status['adc']=run(args.out/'captures')
  if not status['adc']['digital_path_pass']:raise AssertionError('ADC clock/selector functional test failed')
  tcl('read_status.tcl',marker='STATUS_PASS')
 except Exception as e:
  status['test_error']=repr(e)
  try:tcl('read_status.tcl',marker='STATUS_PASS')
  except Exception as debug_error:status['debug_error']=repr(debug_error)
  raise
 finally:
  print('Restoring CPLDs and FPGA',flush=True)
  for name,vec,bits,marker in [('erase_restore_cplds.tcl','unused',0,'ALL_CPLD_ERASED_RESTORED'),('restore_fpga.tcl',old,obits,'LOAD_PASS')]:
   try:tcl(name,vec,bits,marker)
   except Exception as e:restore_errors.append(str(e))
  try:
   after=tcl('read_cplds.tcl',marker='CPLD_READ_PASS',tag='read-after');status['nv_unchanged']=array(after)==before_rows
  except Exception as e:restore_errors.append(str(e))
  status['restoration_errors']=restore_errors;status['restored']=not restore_errors and status.get('nv_unchanged',False)
  status['finished']=time.time();(args.out/'hardware.json').write_text(json.dumps(status,indent=2)+'\n')
  if not status['restored']:raise RuntimeError('Restoration failed: '+repr(restore_errors or ['NV readback changed']))
 print('HARDWARE_COMPLETE',json.dumps({k:v for k,v in status.items() if k!='adc'}),flush=True)
