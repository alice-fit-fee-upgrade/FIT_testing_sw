"""Compare physical ADC A/B before/after disabling CPLD12 INTB; leased hardware.

Requires verified Dell-built vectors: program.tcl, restore.tcl, verify-original.tcl.
Only CPLD12 NV is changed; MCU and FPGA images remain untouched.
"""
import argparse,contextlib,json,sys,re,time,subprocess,hashlib,struct
from pathlib import Path
PM=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--vectors',type=Path,required=True)
p.add_argument('--station',type=Path,required=True)
p.add_argument('--out',type=Path,required=True)
a=p.parse_args();ROOT=a.vectors.resolve()
# Refuse programming vectors targeting any device except physical CPLD12.
for name in ('program','restore'):
 text=(ROOT/(name+'.tcl')).read_text();targets=set()
 for value in re.findall(r'scan_ir_hw_jtag 102 -tdi ([0-9a-f]+)',text):
  value=int(value,16)
  assert value&63==63,'FPGA must remain in BYPASS'
  for ch in range(1,13):
   if (value>>(6+8*(12-ch)))&255!=255:targets.add(ch)
 if targets!={12}:raise RuntimeError('Vector targets are not solely CPLD12: '+repr(targets))
sys.path[:0]=[str(PM/'acceptance'),str(PM/'cfd_simulator'),str(PM/'ipbus_adc'),'/home/codex-hil/FIT_PM_FW_uPC/tools/hardware','/home/codex-hil/kasli-phase-tester']
from lease import acquire as lease
from station import jtag_command,console,read_dna
from client import Client
from adc_dc_scan import acquire
from console import ConsoleI2C,Registers
from mcp23017 import afe_route
from pm12_console_regression import capture
from pm12_power import wait_power_good,require_power_good
from mod_dac28 import DAC,remote_lease
from host.gate_phase_ipbus import GatePhaseIPbusDevice
from host.hdmi_check import check_phase_records
CFG=json.loads(a.station.read_text())
OUT=a.out.resolve();OUT.mkdir(parents=True,exist_ok=False)
report={'pass_':False,'channel':12,'change':'CPLD12 INTB/P54 held low; INTA/P53 and divider retained; CPLD1..11 unchanged','captures':[]}
def save(): (OUT/'status.json').write_text(json.dumps(report,indent=2)+'\n')
def rows(text):
 a=re.findall(r'^ARRAY (\d+) ([AB]) (\d+) ([0-9a-fA-F]+)$',text,re.M)
 p={(int(c),int(r)):int(v,16) for c,s,r,v in a if s=='A'};q={(int(c),int(r)):int(v,16) for c,s,r,v in a if s=='B'}
 assert len(a)==1968 and len(p)==984 and p==q,'CPLD read mismatch'
 return p
def tcl(prefix,file,tag,payload='unused',marker='NATIVE_EXECUTE_PASS'):
 with (OUT/(tag+'.log')).open('w') as log:
  subprocess.run(prefix+['-mode','batch','-nolog','-nojournal','-notrace','-source',str(file),'-tclargs',CFG['jtag_cable'],CFG['hw_server'],str(payload),'0'],stdout=log,stderr=subprocess.STDOUT,timeout=300,check=True)
 text=(OUT/(tag+'.log')).read_text();assert marker in text,tag
 return text
def gate(d,stage):
 data=d.capture(4095,channels=[8,9]);(OUT/(stage+'-gate.json')).write_text(json.dumps(data)+'\n')
 summary={}
 for r in data['channels']:
  check_phase_records(r)
  bits=[(w>>i)&1 for w in r['words'] for i in range(8)]
  edges=sum(not x and y for x,y in zip(bits,bits[1:]))
  if r['logical']==8 or stage=='original':assert edges>=680,'Expected gate pulses absent'
  else:assert sum(bits)==0,'INTB still active'
  summary[str(r['logical'])]={'rising_edges':edges,'high_samples':sum(bits),'records':len(r.get('phase_records',[]))}
 return summary
with contextlib.ExitStack() as st:
 for n in sorted(['atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001','esp32-6825dd4c49e4','lattice-VER00001']): st.enter_context(lease(Path.home()/'.cache'/(n+'.lock')))
 remote=st.enter_context(remote_lease());dac=DAC(remote);st.callback(dac.close)
 report['dac_setpoints_before']=dac.snapshot();assert report['dac_setpoints_before'][:2]==[1.,1.],report['dac_setpoints_before']
 u=st.enter_context(console(CFG));report['pgood_before']=wait_power_good(u,capture)
 report['mcu']=capture(u,'RS');assert 'Board S/N: 1803' in report['mcu']['reply']
 c=Client();st.callback(c.close);assert c.read(0,3)==[0x504d1202,0x10002,0xc7c42d28]
 d=GatePhaseIPbusDevice();st.callback(d.close)
 bus=ConsoleI2C(u,capture)
 changed=False;regs=None;original=None
 try:
  report['dna']=read_dna(CFG,OUT);assert report['dna']=='3A17A1B402212223'
  with jtag_command(CFG,OUT) as prefix:
   tools=PM/'adc/tools'
   before=rows(tcl(prefix,tools/'read_cplds.tcl','before-nv',marker='CPLD_READ_PASS'))
   tcl(prefix,tools/'execute_native.tcl','verify-original',ROOT/'verify-original.tcl')
   with bus.routed(*afe_route(12)):
    regs=Registers(bus);original={r:regs.read(r) for r in [0,1,0x14,0x15]}
    report['gpio_before']=original
    assert regs.read(10)==regs.read(11) and not regs.read(10)&128
    assert original[0x14]&0x88==0x88 and not original[0]&0x88,'Integrator/monitor state differs'
    assert original[1]&0xe0==0 and original[0x15]&0xe0==0xc0,'Expected external ADC A selector'
    def select(bank):
     base=regs.read(0x15);regs.write(0x15,base|0x20)
     wanted=(base&~0xe0)|(0xc0 if bank==0 else 0)
     regs.write(0x15,wanted|0x20);regs.write(0x15,wanted)
     assert regs.read(0x15)==wanted;time.sleep(.05)
    def collect(stage):
     report[stage+'-gates']=gate(d,stage)
     for bank in (0,1):
      select(bank)
      for n in range(8):
       require_power_good(u,capture)
       label=f'{stage}-adc{"AB"[bank]}-{n:02d}'
       row=acquire(c,bank,OUT,label,12);row.update(stage=stage,label=label)
       report['captures'].append(row);save()
       print(label,'mean',round(row['raw_mean'],4),'rms',round(row['raw_std'],4),flush=True)
     select(0)
    collect('original')
    require_power_good(u,capture);changed=True;save()
    tcl(prefix,tools/'execute_native.tcl','program-intb-off',ROOT/'program.tcl')
    after=rows(tcl(prefix,tools/'read_cplds.tcl','after-nv',marker='CPLD_READ_PASS'))
    altered=sorted({ch for ch,r in before if before[ch,r]!=after[ch,r]});assert altered==[12],altered
    report['changed_cpld_channels']=altered;report['program_verified']=True;time.sleep(.2)
    collect('intb-off')
    dac.connect() # reconnect after bounded measurement; queries only, no DAC writes
    report['dac_setpoints_after']=dac.snapshot()
    assert report['dac_setpoints_after']==report['dac_setpoints_before'],'DAC setpoints changed'
    report['pgood_final']=require_power_good(u,capture)
    select(0);report['gpio_final']={r:regs.read(r) for r in original};assert report['gpio_final']==original
    report['final_adc']=acquire(c,0,OUT,'final-adcA',12)
    report['pass_']=True
 except BaseException as e:
  report['error']=repr(e);save()
  if changed:
   try:
    with jtag_command(CFG,OUT) as prefix:
     tcl(prefix,PM/'adc/tools/execute_native.tcl','rollback',ROOT/'restore.tcl')
     restored=rows(tcl(prefix,PM/'adc/tools/read_cplds.tcl','rollback-nv',marker='CPLD_READ_PASS'))
     assert restored==before;report['rollback_verified']=True
   except BaseException as err: report['rollback_error']=repr(err)
  raise
 finally:
  if regs and original:
   try:
    with bus.routed(*afe_route(12)):
     regs.write(0x15,original[0x15]|0x20);regs.write(0x15,original[0x15]);assert regs.read(0x15)==original[0x15]
   except BaseException as err:report['gpio_cleanup_error']=repr(err)
  try:d.stop()
  except BaseException as err:report['kasli_cleanup_error']=repr(err)
  report['i2c_records']=bus.records;save()
print('EXPERIMENT_PASS',flush=True)
