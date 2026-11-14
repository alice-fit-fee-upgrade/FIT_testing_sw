#!/usr/bin/env python3
"""Held-SPI CLI for the current clock40 diagnostic; known SPI reset remains FAIL.

Retains the historical measurement helper byte-for-byte for cohort consistency.
"""
import sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'system'))
from hold_spi import *

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--out',type=Path,required=True);p.add_argument('--repeat',type=int,default=3);p.add_argument('--expected-build',type=lambda s:int(s,16),default=int(json.loads((BASE/'system/current_image.json').read_text())['build_id'],16));a=p.parse_args()
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
        r['identity']=c.read(0,3);assert r['identity']==[0x504d1202,0x10002,a.expected_build]
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
