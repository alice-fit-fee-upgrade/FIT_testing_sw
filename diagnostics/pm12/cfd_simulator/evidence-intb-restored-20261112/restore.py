"""Restore known original CPLD12 gate image; leave analog routing unchanged."""
import contextlib,hashlib,json,re,subprocess,sys,tarfile,time
from pathlib import Path
P=Path('/home/codex-hil/fit-testing-publish/diagnostics/pm12')
sys.path[:0]=[str(P/'acceptance'),str(P/'ipbus_adc'),'/home/codex-hil/FIT_PM_FW_uPC/tools/hardware','/home/codex-hil/kasli-phase-tester']
from lease import acquire
from station import console,jtag_command,read_dna
from pm12_power import wait_power_good,require_power_good
from pm12_console_regression import capture
from host.gate_phase_ipbus import GatePhaseIPbusDevice
from host.hdmi_check import check_phase_records
out=Path(__file__).parent
# Keep client working files and cs_server extraction off the full SATA overlay.
import station as station_module
original_jtag_command=jtag_command
@contextlib.contextmanager
def nvme_jtag_command(cfg,output):
 for name in ['home','tmp']:(out/name).mkdir(exist_ok=True)
 with original_jtag_command(cfg,output) as command:
  assert command[3]=='exec'
  command[4:4]=['-w',str(out),'-e','HOME='+str(out/'home'),'-e','TMPDIR='+str(out/'tmp')]
  yield command
jtag_command=nvme_jtag_command
station_module.jtag_command=nvme_jtag_command
cfg=json.loads(Path('/srv/codex-hil-nvme/pm12-acceptance-20261107/post-restore-probe-run/station.json').read_text())
v=Path('/srv/codex-hil-nvme/pm12-intb-off-20261108');r={'pass_':False,'target_channel':12,'requested_mode':'Original INTA and INTB gates enabled','analog_controls_changed':False}
def save():(out/'status.json').write_text(json.dumps(r,indent=2)+'\n')
def arrays(text):
 x=re.findall(r'^ARRAY (\d+) ([AB]) (\d+) ([0-9a-fA-F]+)$',text,re.M)
 a={(int(c),int(n)):int(w,16) for c,p,n,w in x if p=='A'};b={(int(c),int(n)):int(w,16) for c,p,n,w in x if p=='B'}
 assert len(x)==1968 and len(a)==984 and a==b,'Twice-read arrays mismatch'
 return a
original=arrays((v/'hardware/before-nv.log').read_text());experimental=arrays((v/'hardware/after-nv.log').read_text())
with tarfile.open(P/'cfd_simulator/evidence-intb-off-20261108/cpld-build-vectors.tar.gz') as t:
 assert t.extractfile('restore.tcl').read()==(v/'restore.tcl').read_bytes(),'Vector differs from archived verified source'
text=(v/'restore.tcl').read_text();targets=set()
for value in re.findall(r'scan_ir_hw_jtag 102 -tdi ([0-9a-fA-F]+)',text):
 value=int(value,16);assert value&63==63,'FPGA not in BYPASS'
 for ch in range(1,13):
  if (value>>(6+8*(12-ch)))&255!=255:targets.add(ch)
assert targets=={12},targets
r['restore_vector_sha256']=hashlib.sha256((v/'restore.tcl').read_bytes()).hexdigest();save()
def execute(prefix,source,tag,payload='unused',marker='CPLD_READ_PASS'):
 with (out/(tag+'.log')).open('w') as f:
  subprocess.run(prefix+['-mode','batch','-nolog','-nojournal','-notrace','-source',str(source),'-tclargs',cfg['jtag_cable'],cfg['hw_server'],str(payload),'0'],stdout=f,stderr=subprocess.STDOUT,timeout=300,check=True)
 text=(out/(tag+'.log')).read_text();assert marker in text,tag;return text

def gates(stage):
 d=GatePhaseIPbusDevice()
 try:
  data=d.capture(4095,channels=[8,9]);(out/(stage+'-gates.json')).write_text(json.dumps(data)+'\n');summary={}
  for row in data['channels']:
   check_phase_records(row);bits=[(w>>i)&1 for w in row['words'] for i in range(8)]
   summary[str(row['logical'])]={'rising_edges':sum(not a and b for a,b in zip(bits,bits[1:])),'high_samples':sum(bits),'samples':len(bits)}
  return summary
 finally:d.stop();d.close()

with contextlib.ExitStack() as stack:
 for name in sorted(['atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001']):stack.enter_context(acquire(Path.home()/'.cache'/(name+'.lock')))
 u=stack.enter_context(console(cfg))
 try:
  r['pgood_before']=wait_power_good(u,capture);r['mcu']=capture(u,'RS');assert 'Board S/N: 1803' in r['mcu']['reply']
  r['dna']=read_dna(cfg,out);assert r['dna']=='3A17A1B402212223';save();print('Identity and PGOOD verified',flush=True)
  try:r['gates_before']=gates('before')
  except Exception as e:r['gate_capture_before_error']=repr(e)
  with jtag_command(cfg,out) as prefix:
   before=arrays(execute(prefix,P/'adc/tools/read_cplds.tcl','before-nv'))
   assert all(before[k]==original[k] for k in before if k[0]!=12),'Unexpected contents on CPLD1..11'
   assert before==original or before==experimental,'Unknown CPLD12 image; refusing programming'
   r['was_intb_off']=before!=original;save();print('CPLD baseline known; INTB-off='+str(r['was_intb_off']),flush=True)
   if before!=original:
    require_power_good(u,capture)
    execute(prefix,P/'adc/tools/execute_native.tcl','restore-cpld12',v/'restore.tcl','NATIVE_EXECUTE_PASS');r['programmed_cpld12']=True;save()
   else:r['programmed_cpld12']=False
   execute(prefix,P/'adc/tools/execute_native.tcl','verify-all-original',v/'verify-original.tcl','NATIVE_EXECUTE_PASS');r['vendor_verify_all_original']=True;save()
   after=arrays(execute(prefix,P/'adc/tools/read_cplds.tcl','after-nv'))
   assert after==original,'Final original arrays mismatch'
   r['changed_channels']=sorted({ch for ch,row in before if before[ch,row]!=after[ch,row]});assert r['changed_channels'] in ([],[12]);r['cpld1_to_11_unchanged']=True;r['original_gate_mode_verified']=True;save()
  r['pgood_after']=require_power_good(u,capture)
  try:
   r['gates_after']=gates('after');r['gate_pulses_verified']=all(r['gates_after'][str(lane)]['rising_edges']>=600 for lane in [8,9])
   assert r['gate_pulses_verified'],'Gate pulses absent after restored original image'
  except Exception as e:r['gate_capture_after_error']=repr(e)
  r['pass_']=r['original_gate_mode_verified'];save();print(json.dumps({k:v for k,v in r.items() if k not in ['pgood_before','pgood_after','mcu']},indent=2),flush=True)
 except BaseException as e:r['error']=repr(e);save();raise
 finally:save()
