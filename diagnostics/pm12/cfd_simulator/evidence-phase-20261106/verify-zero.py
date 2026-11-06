import sys,contextlib,fcntl,json,gzip
from pathlib import Path
sys.path.insert(0,'/home/codex-hil/kasli-phase-tester')
sys.path.insert(0,'/home/codex-hil/FIT_PM_FW_uPC/tools/hardware')
sys.path.insert(0,'/home/codex-hil/fit-testing-publish/diagnostics/pm12/cfd_simulator')
from host.gate_phase_device import GatePhaseDevice
from host.hardware_test import identify
from host.hdmi_check import check_phase_records
from phase_estimator import estimate
from pm12_console_regression import PORT,capture
from pm12_power import wait_power_good,require_power_good
import serial
out=Path(__file__).parent;report={'dac_writes':False,'captures':[]}
with contextlib.ExitStack() as stack:
 for name in sorted(('atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001')):
  lock=stack.enter_context(open('/home/codex-hil/.cache/'+name+'.lock','a+'));fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
 report['kasli_usb']=identify()
 s=serial.Serial(port=None,baudrate=115200,timeout=.03,write_timeout=1,rtscts=True,exclusive=True);s.dtr=False;s.rts=True;s.port=PORT;s.open();stack.callback(s.close);s.read(4096)
 report['power_ready']=wait_power_good(s,capture);report['identity']=capture(s,'RS');assert 'Board S/N: 1803' in report['identity']['reply']
 d=GatePhaseDevice();stack.callback(d.close)
 try:
  for i in range(3):
   data=d.capture(768,channels=[8,9])
   with gzip.open(out/f'zero-followup-{i}.json.gz','wt') as f:json.dump(data,f)
   check=sum(check_phase_records(r) for r in data['channels'])
   result={r['logical']:estimate([r],data['sample_ps'],data['period_bins']) for r in data['channels']}
   report['captures'].append(dict(trial=i,phase_records_exact=check,estimates=result));print(i,{k:v['mean_ns'] for k,v in result.items()},flush=True)
  report['pg_final']=require_power_good(s,capture)
 finally:
  d.stop();report['final_status']=d.status();(out/'zero-followup.json').write_text(json.dumps(report,indent=2)+'\n')
