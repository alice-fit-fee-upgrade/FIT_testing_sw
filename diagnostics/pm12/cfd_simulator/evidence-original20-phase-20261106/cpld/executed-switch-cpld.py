import sys,contextlib,fcntl,subprocess,json,time,re,hashlib
from pathlib import Path
sys.path.insert(0,'/home/codex-hil/kasli-phase-tester');sys.path.insert(0,'/home/codex-hil/FIT_PM_FW_uPC/tools/hardware');sys.path.insert(0,'/home/codex-hil/fit-testing-publish/diagnostics/pm12/cfd_simulator')
from host.gate_phase_device import GatePhaseDevice
from host.gate_phase_dio import input_cards
from host.hardware_test import identify
from host.hdmi_check import check_phase_records
from phase_estimator import estimate
from pm12_console_regression import PORT,capture
from pm12_power import wait_power_good,require_power_good
import serial
ROOT=Path(__file__).parent;OUT=ROOT/'hardware';OUT.mkdir(exist_ok=False)
TOOLS=Path('/home/codex-hil/fit-testing-publish/diagnostics/pm12/adc/tools');docker=['docker','-H','unix:///run/user/1001/docker-vivado.sock'];name='pm12-original-gates-20261106';viv='/srv/codex-hil-data/toolchains/amd/Xilinx/2025.2/Vivado/bin/'
old=Path('/srv/codex-hil-nvme/fit-phase-20261105/cpld/work/program-vendor.tcl');report={};server=False;changed=False

def save():(OUT/'status.json').write_text(json.dumps(report,indent=2)+'\n')
def tcl(file,marker,vector='unused',tag=None,timeout=300):
 file=Path(file);file=file if file.is_absolute() else TOOLS/file
 path=OUT/((tag or file.name)+'.log')
 with path.open('w') as log:
  p=subprocess.run(docker+['exec',name,'timeout',str(timeout),viv+'vivado','-mode','batch','-nolog','-nojournal','-notrace','-source',str(file),'-tclargs','210249A73E43','localhost:3121',str(vector),'0'],stdout=log,stderr=subprocess.STDOUT,timeout=timeout+20)
 text=path.read_text()
 if p.returncode or marker not in text:raise RuntimeError('JTAG failed '+str(path))
 return text

def check_rows(text):
 rows=re.findall(r'^ARRAY (\d+) ([AB]) (\d+) ([0-9a-fA-F]+)$',text,re.M)
 assert len(rows)==1968
 a={(int(ch),int(row)):int(v,16) for ch,ps,row,v in rows if ps=='A'}
 b={(int(ch),int(row)):int(v,16) for ch,ps,row,v in rows if ps=='B'}
 assert a==b and len(a)==984,'CPLD two-pass read mismatch'
 return hashlib.sha256(json.dumps(sorted((ch,row,str(v)) for (ch,row),v in a.items())).encode()).hexdigest()

with contextlib.ExitStack() as stack:
 for lock in sorted(('atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001')):
  f=stack.enter_context(open('/home/codex-hil/.cache/'+lock+'.lock','a+'));fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB)
 uart=serial.Serial(port=None,baudrate=115200,timeout=.03,write_timeout=1,rtscts=True,exclusive=True);uart.dtr=False;uart.rts=True;uart.port=PORT;uart.open();stack.callback(uart.close);uart.read(4096)
 report['power_ready']=wait_power_good(uart,capture);report['mcu_identity']=capture(uart,'RS');assert 'Board S/N: 1803' in report['mcu_identity']['reply']
 report['kasli_usb']=identify();d=GatePhaseDevice();stack.callback(d.close);report['dio_inputs']=input_cards(d)
 try:
  assert old.exists() and (ROOT/'old-verify.tcl').exists()
  p=subprocess.run(docker+['run','-d','--rm','--name',name,'--init','--mount','type=bind,src=/srv/codex-hil-data,dst=/srv/codex-hil-data','--mount','type=bind,src=/srv/codex-hil-nvme,dst=/srv/codex-hil-nvme','--mount','type=bind,src=/home/codex-hil,dst=/home/codex-hil','--mount','type=bind,src=/dev/bus/usb,dst=/dev/bus/usb','codex-vivado-runtime:ubuntu22.04',viv+'hw_server','-e','set jtag-port-filter 210249A73E43','-e','set max-ir-length 128'],capture_output=True,text=True,timeout=90)
  if p.returncode:raise RuntimeError(p.stderr)
  server=True;time.sleep(2)
  print('Reading nonblank CPLD baseline and verifying against known previous JEDEC',flush=True)
  report['before_nv_hash']=check_rows(tcl('read_cplds.tcl','CPLD_READ_PASS',tag='before-nv'))
  tcl('execute_native.tcl','NATIVE_EXECUTE_PASS',ROOT/'old-verify.tcl',tag='verify-old')
  report['known_old_image_verified']=True;save()
  require_power_good(uart,capture)
  print('Programming original gate divider on all12 CPLDs',flush=True)
  changed=True;tcl('execute_native.tcl','NATIVE_EXECUTE_PASS',ROOT/'work/program-vendor.tcl',tag='program-original')
  report['new_jed_sha256']=hashlib.sha256((ROOT/'cpld/build/design.jed').read_bytes()).hexdigest()
  report['after_nv_hash']=check_rows(tcl('read_cplds.tcl','CPLD_READ_PASS',tag='after-nv'))
  tcl('/srv/codex-hil-nvme/fit-phase-20261105/passive_status.tcl','PASSIVE_STATUS_PASS',tag='passive-fpga')
  time.sleep(.2);data=d.capture(768,channels=[8,9]);(OUT/'gate20-capture.json').write_text(json.dumps(data)+'\n')
  report['phase_records_exact']=sum(check_phase_records(r) for r in data['channels'])
  report['gate20']={r['logical']:estimate([r],data['sample_ps'],data['period_bins'],edge_period_bins=48) for r in data['channels']}
  report['pg_final']=require_power_good(uart,capture);report['pass_']=True;print('ORIGINAL_GATE20_VERIFIED',flush=True)
 except BaseException as error:
  report['error']=repr(error);print('ERROR',repr(error),flush=True)
  if changed:
   try:
    tcl('execute_native.tcl','NATIVE_EXECUTE_PASS',old,tag='rollback-old');report['rollback_nv_hash']=check_rows(tcl('read_cplds.tcl','CPLD_READ_PASS',tag='rollback-read'));assert report['rollback_nv_hash']==report['before_nv_hash'];report['rollback_verified']=True
   except BaseException as restore_error:report['rollback_error']=repr(restore_error)
 finally:
  try:d.stop();report['final_kasli']=d.status()
  finally:
   if server:subprocess.run(docker+['stop',name],capture_output=True,timeout=30)
   save()
if not report.get('pass_'):sys.exit(1)
