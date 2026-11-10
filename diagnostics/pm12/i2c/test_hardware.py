import sys,fcntl,subprocess,json,time,hashlib,argparse
from pathlib import Path
sys.path.insert(0,'/home/codex-hil/fit-testing-publish/diagnostics/pm12')
from test_board import payload
from client import run
root=Path(__file__).resolve().parent
parser=argparse.ArgumentParser();parser.add_argument('--measure',action='store_true');parser.add_argument('--container',default='e11a7123de2e');args=parser.parse_args()
out=root/'evidence'/time.strftime('%Y%m%d-%H%M%S');out.mkdir(parents=True)
def tcl(name,vec,bits):
 log=out/(name+'.log')
 cmd=['docker','-H','unix:///run/user/1001/docker-vivado.sock','exec',args.container,'timeout','130','/srv/codex-hil-data/toolchains/amd/Xilinx/2025.2/Vivado/bin/vivado','-mode','batch','-nolog','-nojournal','-notrace','-source',str(root/name),'-tclargs','210249A73E43','localhost:3121',str(vec),str(bits)]
 with log.open('w') as f:subprocess.run(cmd,check=True,stdout=f,stderr=subprocess.STDOUT,timeout=150)
 assert 'LOAD_PASS' in log.read_text(),log
with open('/home/codex-hil/.cache/pm12-210249A73E43.lock','a+') as lease:
 fcntl.flock(lease,fcntl.LOCK_EX|fcntl.LOCK_NB)
 bit=root/'build/pm12_i2c_diag.bit';restore=Path('/home/codex-hil/fit-bringup/gateware/pm12_link_diag/build/pm12_link_diag.bit')
 assert hashlib.sha256(restore.read_bytes()).hexdigest()=='c9fbd02768ce12750dc68b8bb24c34403027a65f9e002661e29bb3d2e2df7a1a'
 diag=out/'diag.hex';db=payload(bit,diag);old=out/'restore.hex';ob=payload(restore,old)
 status={'serial':'210249A73E43','nonvolatile_writes':False,'fpga_sha256':hashlib.sha256(bit.read_bytes()).hexdigest()}
 try:
  print('LOAD',out,flush=True);tcl('load_fpga.tcl',diag,db);time.sleep(3)
  if args.measure:
   from measure import run as measure_run
   status['telemetry']=measure_run()
   status['digital_pass']=len(status['telemetry']['monitors'])==3
  else:
   status['i2c']=run()
   r=status['i2c'];monitors=[x for x in r.get('routes',[]) if 'ina3221' in x]
   status['digital_pass']=r.get('reset_pass',False) and len(r.get('routes',[]))==16 and len(monitors)==3
  if not status['digital_pass']:raise RuntimeError('I2C expected topology/reset checks failed')
 except Exception as e:status['error']=repr(e);raise
 finally:
  try:
   print('RESTORE',flush=True);tcl('restore_fpga.tcl',old,ob);status['restored']=True
  except Exception as e:status['restore_error']=repr(e);status['restored']=False;raise
  finally:(out/'hardware.json').write_text(json.dumps(status,indent=2)+'\n')
 print('I2C_TEST_COMPLETE',out,flush=True)
