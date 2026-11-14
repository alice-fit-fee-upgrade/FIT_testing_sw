#!/usr/bin/env python3
"""HDMI diagnostic with Kasli SPI outputs held driven after the test.

Runs under PM12/MCU/Kasli leases. Does not use legacy run()/input_cards(),
which disable FPGA output buffers. Leaves slot6 directions at the verified
HDMI mask, SEL/SCK/MOSI at idle, and restores only the I2C service routing.
No programming, persistent writes, arbitrary SPI or clock changes.
"""
import argparse,contextlib,datetime,hashlib,json,sys,time
from pathlib import Path
BASE=Path('/home/codex-hil/fit-testing-publish/diagnostics/pm12')
sys.path[:0]=[str(BASE/'acceptance'),str(BASE/'ipbus_adc'),'/home/codex-hil/kasli-phase-tester','/home/codex-hil/FIT_PM_FW_uPC/tools/hardware']
from lease import acquire
from station import console
from pm12_console_regression import capture
from pm12_power import wait_power_good,require_power_good
from host import pm_system_test as system
from host.lvds8_dio import I2cController,usb

class HeldAdapter(system.HDMIAdapter):
    def stop(self):
        # A stop request must never change OE or buffer direction here.
        if self.d.read(0x144)!=1 or self.d.read(0x150)&0xf!=9:
            raise RuntimeError('Held HDMI transmitter is not enabled and idle')

@contextlib.contextmanager
def hold_directions(device,mask):
    if mask!=device.mask:raise ValueError('Wrong HDMI mask')
    matches=[]
    for p in Path('/sys/bus/usb/devices').iterdir():
        try:
            if (p/'serial').read_text().strip()=='00001' and (p/'product').read_text().strip()=='Artix-7 DIOT System Board':
                matches.append((int((p/'busnum').read_text()),int((p/'devnum').read_text())))
        except (OSError,ValueError):pass
    if len(matches)!=1:raise RuntimeError('Kasli identity missing/ambiguous')
    dev=usb.core.find(idVendor=0x0403,idProduct=0x6011,bus=matches[0][0],address=matches[0][1])
    ctl=I2cController();saved=None;old_mux=None;gpio=None
    try:
        ctl.configure(dev,interface=2,frequency=50000,direction=0x60,initial=0x40)
        gpio=ctl.get_gpio();gpio.set_direction(0x60,0x60);gpio.write(0x40)
        old_mux=ctl.read(0x70,1)[0];ctl.write(0x70,b'\x08')
        def rd(reg):return ctl.exchange(0x76,bytes([reg]),1)[0]
        def wr(reg,v):ctl.write(0x76,bytes([reg,v]))
        saved=[rd(i) for i in range(8)];base=(saved[3]&0x1f)|0x20
        wr(3,base|0x80);wr(7,saved[7]&0x1f)
        wr(2,1<<[0,2,3,1,4,7,6,5][device.slot-1]);wr(6,0);wr(3,base|0x40)
        ctl.write(0x70,b'\x48')
        before=ctl.read(0x3e,1)[0]|(ctl.read(0x3f,1)[0]<<8)
        if before not in (0,mask):raise RuntimeError('Unexpected pre-existing slot6 direction mask')
        # Establish stable FPGA idle BEFORE enabling external LVDS drivers.
        device.directions(mask);device.stop()
        ctl.write(0x3e,bytes([mask&255]));ctl.write(0x3f,bytes([mask>>8]))
        actual=ctl.read(0x3e,1)[0]|(ctl.read(0x3f,1)[0]<<8)
        if actual!=mask:raise RuntimeError('Direction mismatch')
        yield dict(before=before,held=actual,slot=device.slot)
    finally:
        # Intentionally retain PCF direction latches and FPGA output enable.
        try:
            if saved is not None:
                ctl.write(0x70,b'\x08');wr(3,base|0x80);wr(6,255)
                wr(2,saved[2]);wr(7,saved[7]);wr(6,saved[6]);wr(3,saved[3])
            if old_mux is not None:ctl.write(0x70,bytes([old_mux]))
        finally:
            if gpio is not None:gpio.write(0)
            ctl.terminate()

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--out',type=Path,required=True);p.add_argument('--repeat',type=int,default=3);a=p.parse_args()
    if not 1<=a.repeat<=10:raise ValueError('repeat1..10')
    a.out.mkdir(parents=True,exist_ok=False)
    source=Path(__file__);(a.out/'executed-hold_spi.py').write_bytes(source.read_bytes())
    r=dict(started_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),pass_=False,trace=[],runs=[])
    def save():(a.out/'result.json').write_text(json.dumps(r,indent=2)+'\n')
    with contextlib.ExitStack() as st:
        for name in sorted(['atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001']):st.enter_context(acquire(Path.home()/'.cache'/(name+'.lock')))
        u=st.enter_context(console(dict(uart='/dev/serial/by-id/usb-Prolific_Technology_Inc._USB-Serial_Controller-if00-port0')))
        r['pgood_before']=wait_power_good(u,capture);r['mcu']=capture(u,'RS');assert 'Board S/N: 1803' in r['mcu']['reply']
        d=system.GatePhaseIPbusDevice();st.callback(d.close);c=system.Client();st.callback(c.close)
        r['identity']=c.read(0,3);assert r['identity']==[0x504d1202,0x10002,0xc7c42d28]
        assert d.read(0xd8)==0x43464434 and d.read(0x13c)==0x42524731 and d.read(0x120)&1
        def snap(label):
            row=dict(label=label,monotonic=time.monotonic(),uptime=c.read(5,2),pm_scratch=c.read(3,2),kasli_enable=d.read(0x144),kasli_state=d.read(0x150));r['trace'].append(row);save();print(row,flush=True)
        # test_hdmi's legacy context and stop are replaced explicitly for this
        # experiment; source measurement helpers stay unchanged for campaign contracts.
        old_adapter,old_context=system.HDMIAdapter,system.dio_directions
        system.HDMIAdapter=HeldAdapter;system.dio_directions=hold_directions
        try:
            snap('before hold')
            for n in range(a.repeat):
                dest=a.out/f'run{n+1:02d}';dest.mkdir()
                snap(f'before run{n+1}')
                r['runs'].append(system.test_hdmi(d,c,dest));snap(f'after run{n+1}')
                time.sleep(.25)
            snap('before stable dwell');time.sleep(2);snap('after stable dwell')
            r['pgood_after']=require_power_good(u,capture)
            # Valid physical ADC buffer; no Kasli stop/direction writes.
            gen,status=c.acquire(0,False);data=c.download(gen)
            from client import save_capture
            r['adc']=save_capture(a.out/'adc-final',data,0,False,gen,status)
            snap('final')
            ticks=[x['uptime'][0]+(x['uptime'][1]<<32) for x in r['trace']]
            r['pm_sys_counter_restarted']=any(y<x for x,y in zip(ticks,ticks[1:]))
            r['pass_']=all(x['pass'] for x in r['runs']) and not r['pm_sys_counter_restarted'] and d.read(0x144)==1 and d.read(0x150)&15==9
        finally:
            system.HDMIAdapter,system.dio_directions=old_adapter,old_context
            r['finished_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat();save()
    if not r['pass_']:raise SystemExit(1)
if __name__=='__main__':main()
