"""PM12 channel12 integrator probe. USB at J6/DRV output, not J8 ADC bypass."""
import argparse,contextlib,json,math,statistics,struct,sys,time
from pathlib import Path
P=Path(__file__).resolve().parents[1];sys.path[:0]=[str(P/'acceptance'),str(P/'cfd_simulator'),str(P/'ipbus_adc'),'/home/codex-hil/FIT_PM_FW_uPC/tools/hardware']
from lease import acquire as lease
from station import console
from pm12_power import wait_power_good,require_power_good
from pm12_console_regression import capture
from client import Client
from adc_decode import decode
from console import ConsoleI2C,Registers
from mcp23017 import afe_route
from mod_dac28 import DAC,remote_lease,voltage
ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--out',type=Path,required=True);ap.add_argument('--offsets',type=float,nargs='+',default=[-.02,-.01,0,.01,.02]);ap.add_argument('--repeats',type=int,default=4);ap.add_argument('--park',type=float,nargs=2);ap.add_argument('--base',type=float,nargs=2,default=[2.048,1.024]);ap.add_argument('--pairs',nargs='+',help='Explicit CH0:CH1 voltages');args=ap.parse_args()
points=[tuple(map(float,p.split(':'))) for p in args.pairs] if args.pairs else [(round(args.base[0]+d/2,4),round(args.base[1]-d/2,4)) for d in args.offsets]
for pair in points:
 assert len(pair)==2
 for value in pair:voltage(value)
if args.park:
 for value in args.park:voltage(value)
for off in args.offsets:voltage(args.base[0]+off/2);voltage(args.base[1]-off/2)
assert 1<=args.repeats<=32
out=args.out;out.mkdir(exist_ok=False,parents=True);(out/'executed-scan.py').write_text(Path(__file__).read_text())
r={'pass_':False,'physical_channel':12,'reference_nominal_V':args.base,'offset_definition':'CH0=base0+offset/2; CH1=base1-offset/2; physical Vdiff=base0-base1+offset','ADC_rate_assumed_Hz':80157400,'points':[],'changes':'GPA7 LOW enables PM integrator amps; GPB5 HIGH disconnects direct-ADC injection; monitor INH HIGH'}
def save():(out/'status.json').write_text(json.dumps(r,indent=2)+'\n')
def get_adc(c,bank,label):
 ident,status=c.acquire(bank,False);words=c.block(0x10000+11*0x1000,4096);assert c.read(0x12)==[ident]
 (out/(label+'.bin')).write_bytes(struct.pack('<4096H',*words));samples,timing=decode(words,bank)
 n=len(samples)//4*4;x=samples[:n];phases=[statistics.mean(x[i::4]) for i in range(4)]
 return dict(file=label+'.bin',generation=ident,status=status,bank=bank,samples=len(samples),mean=statistics.mean(samples),std=statistics.pstdev(samples),minimum=min(samples),maximum=max(samples),clipped_fraction=sum(v in (0,4095) for v in samples)/len(samples),phase_means=phases,phase_std=[statistics.pstdev(x[i::4]) for i in range(4)],timing=timing)
with contextlib.ExitStack() as st:
 for name in sorted(['atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001','esp32-6825dd4c49e4','lattice-VER00001']):st.enter_context(lease(Path.home()/'.cache'/(name+'.lock')))
 remote=st.enter_context(remote_lease());dac=DAC(remote);st.callback(dac.close)
 u=st.enter_context(console({'uart':'/dev/serial/by-id/usb-Prolific_Technology_Inc._USB-Serial_Controller-if00-port0'}));bus=ConsoleI2C(u,capture);c=Client();st.callback(c.close);changed=False;regs=None
 try:
  r['pgood']=wait_power_good(u,capture);r['mcu']=capture(u,'RS');assert 'Board S/N: 1803' in r['mcu']['reply'];r['fpga']=c.read(0,3);assert r['fpga']==[0x504d1202,0x10002,0xc7c42d28]
  r['dac_before']=dac.snapshot()
  with bus.routed(*afe_route(12)):
   require_power_good(u,capture);regs=Registers(bus);assert regs.read(10)==regs.read(11) and not regs.read(10)&128
   r['mcp_before']={str(i):regs.read(i) for i in [0,1,0x12,0x13,0x14,0x15]};save()
   def w(reg,value):
    regs.write(reg,value)
    if regs.read(reg)!=value:raise RuntimeError('MCP register readback mismatch')
   # Disconnect bypass before enabling PM integrator outputs.
   w(0x15,regs.read(0x15)|0x20);w(1,regs.read(1)&~0x20)
   w(0x14,regs.read(0x14)|0x88);w(0,regs.read(0)&~0x88);changed=True
   dac.park(*args.base)
   for bank in [0,1]:r.setdefault('disabled_controls',[]).append(get_adc(c,bank,f'disabled-bank{bank}'))
   require_power_good(u,capture);w(0x14,(regs.read(0x14)&~0x80)|8);assert regs.read(0x12)&0x88==8;time.sleep(.1)
   r['enabled_gpio']={str(i):regs.read(i) for i in [0,1,0x12,0x13,0x14,0x15]};save()
   for index,(vp,vn) in enumerate(points):
    off=vp-vn-(args.base[0]-args.base[1])
    require_power_good(u,capture);dac.park(vp,vn);time.sleep(.05)
    point={'index':index,'offset_V':off,'setpoints_V':[vp,vn],'actual_requested_offset_V':vp-vn-(args.base[0]-args.base[1]),'captures':[]};r['points'].append(point)
    for bank in [0,1]:
     for repeat in range(args.repeats):
      row=get_adc(c,bank,f'point{index:03d}-bank{bank}-{repeat:02d}');point['captures'].append(row);save()
     print('offset',off,'bank',bank,'mean',round(row['mean'],2),'phases',[round(v,2) for v in row['phase_means']],'clip',round(row['clipped_fraction'],3),flush=True)
   dac.park(*(args.park or args.base));r['dac_final']=dac.snapshot();r['mcp_final']={str(i):regs.read(i) for i in [0,1,0x12,0x13,0x14,0x15]};assert r['mcp_final']['18']&0x88==8 and r['mcp_final']['21']&0x20
   assert r['dac_final'][2:]==r['dac_before'][2:];r['pgood_final']=require_power_good(u,capture)
   r['final_captures']=[get_adc(c,b,f'final-bank{b}') for b in [1,0]]
  r['tca_final']={str(a):bus.mux(a) for a in [0x70,0x71]};r['pass_']=True
 except BaseException as e:
  r['error']=repr(e)
  if changed:
   try:
    with bus.routed(*afe_route(12)):
     regs.write(0x14,regs.read(0x14)|0x88);regs.write(0x15,regs.read(0x15)|0x20)
    r['fault_amplifiers_disabled']=True
   except Exception as e:r['fault_gpio_error']=repr(e)
   try:dac.park(*args.base)
   except Exception as e:r['fault_dac_error']=repr(e)
  raise
 finally:r['i2c']=bus.records;r['scpi']=dac.records;save()
print('INTEGRATOR_PROBE_COMPLETE',flush=True)
