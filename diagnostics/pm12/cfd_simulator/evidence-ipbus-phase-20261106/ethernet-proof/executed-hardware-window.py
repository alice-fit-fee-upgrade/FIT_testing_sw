import sys,json,time,subprocess,hashlib,fcntl,re
from pathlib import Path
sys.path.insert(0,'/home/codex-hil/kasli-phase-tester')
from host.hardware_test import identify
from host.gate_phase_device import GatePhaseDevice
from host.gate_phase_ipbus import GatePhaseIPbusDevice
from host.gate_phase_dio import input_cards
from host.gate_sfp import sfp0_tx
from host.hdmi_check import check_phase_records
ROOT=Path(__file__).parent;OUT=ROOT/'hardware-03';OUT.mkdir(exist_ok=False)
bit=ROOT/'candidate/gate_phase.bit';rollback=Path('/srv/codex-hil-nvme/fit-phase-20261105/kasli/gate_phase.bit')
report={};changed=False;txbefore=None;u=None;n=None

def save():(OUT/'status.json').write_text(json.dumps(report,indent=2)+'\n')
def load(bit,tag):
 base=Path('/home/codex-hil/kasli-diot-bringup/tools');location=Path(identify()['sysfs']).name
 p=subprocess.run([str(base/'openocd/bin/openocd'),'-f',str(base/'board.cfg'),'-c',f'adapter usb location {location}; init; pld load 0 {{{bit}}}; virtex2 read_stat 0; shutdown'],capture_output=True,text=True,timeout=90)
 text=p.stdout+p.stderr;(OUT/(tag+'.log')).write_text(text)
 if p.returncode or '0x13636093' not in text:raise RuntimeError('JTAG load failed: '+tag)

with open('/home/codex-hil/.cache/kasli-diot-00001.lock','a+') as lease:
 fcntl.flock(lease,fcntl.LOCK_EX|fcntl.LOCK_NB)
 try:
  report['usb']=identify();u=GatePhaseDevice();report['before']=u.status();report['dio_inputs']=input_cards(u)
  assert u.clock_profile=='external120' and u.read(0xd0)==0xffffffff,'Unexpected resident image'
  q=json.loads((ROOT/'candidate/qualification-values.json').read_text())
  assert q['wns_ns']>=0 and q['whs_ns']>=0 and q['drc_errors']==0 and q['iserdes_count']==16 and q['differential_output_buffers']==0
  assert hashlib.sha256(rollback.read_bytes()).hexdigest()=='35bc18fff47be14ed493201b42e918a00de60d90f8b6d49a046e638eb7761637'
  report['qualification']=q;report['bit_sha256']=hashlib.sha256(bit.read_bytes()).hexdigest();u.close();u=None
  changed=True;print('Loading qualified RPH1 IPbus candidate',flush=True);load(bit,'load-ipbus');time.sleep(.2)
  u=GatePhaseDevice();assert u.read(0xd0)==0x49504232
  config=sfp0_tx();txbefore=config['before'];report['sfp0']=config;save()
  deadline=time.monotonic()+20
  while not u.read(0xd4)&1:
   if time.monotonic()>deadline:raise TimeoutError('SFP0 1000BASE-X link did not come up')
   time.sleep(.1)
  report['link_status']=u.read(0xd4);print('SFP0 link UP',flush=True)
  report['pings']=[]
  for attempt in range(35):
   p=subprocess.run(['ping','-c','1','-W','1','192.168.2.241'],capture_output=True,text=True,timeout=3)
   report['pings'].append(p.stdout+p.stderr)
   neighbor=subprocess.check_output(['ip','neigh','show','192.168.2.241'],text=True);report['neighbor']=neighbor
   save()
   if '02:00:00:00:12:02' in neighbor.lower():break
   print('Waiting for ARP',attempt+1,flush=True);time.sleep(1)
  else:raise RuntimeError('Endpoint MAC unresolved after bounded ARP wait: '+neighbor)
  n=GatePhaseIPbusDevice();report['network_identity']=dict(mapping=n.mapping,profile=n.clock_profile,sample_ps=n.sample_ps)
  n.write(0x10,1);assert n.read(0x10)==0 and n.status()['command_error'];n.write(0x70,1)
  errors=n.client.transact(1,0x10000,[0xdeadbeef],allow_error=True);assert errors[1]&15
  print('Comparing frozen UART and IPbus buffers',flush=True)
  t=time.monotonic();ticket=u.arm_test(4095);u.trigger();a=u.read_capture(ticket,channels=[8,9]);uart_seconds=time.monotonic()-t
  t=time.monotonic();b=n.read_capture(ticket,channels=[8,9]);ipbus_seconds=time.monotonic()-t
  assert a['channels']==b['channels'],'Frozen capture differs between transports'
  assert a['metadata']['capture_id']==b['metadata']['capture_id']
  count=sum(check_phase_records(r) for r in b['channels'])
  (OUT/'uart-frozen.json').write_text(json.dumps(a)+'\n');(OUT/'ipbus-frozen.json').write_text(json.dumps(b)+'\n')
  report['frozen_comparison']=dict(exact=True,uart_seconds=uart_seconds,ipbus_seconds=ipbus_seconds,speedup=uart_seconds/ipbus_seconds,phase_records_exact=count,raw_bytes=8190)
  report['read_retry_events']=n.client.read_retry_events
  n.stop();report['final']=n.status();report['pass_']=True;print('FROZEN_TRANSPORT_EXACT',report['frozen_comparison'],flush=True)
 except BaseException as exc:
  report['error']=repr(exc);print('ERROR',repr(exc),flush=True)
  for dev in (n,u):
   if dev:
    try:dev.close()
    except Exception:pass
  n=u=None
  if changed:
   try:
    load(rollback,'rollback-rph1');u=GatePhaseDevice();u.stop();report['rollback_status']=u.status();report['rollback_verified']=True
   except Exception as restore_error:report['rollback_error']=repr(restore_error)
  if txbefore is not None:
   try:report['sfp_restored']=sfp0_tx(restore=txbefore)
   except Exception as restore_error:report['sfp_restore_error']=repr(restore_error)
 finally:
  for dev in (n,u):
   if dev:
    try:dev.stop();dev.close()
    except Exception as exc:report['close_error']=repr(exc)
  save()
if not report.get('pass_'):sys.exit(1)
