#!/usr/bin/env python3
"""Reload the SAME PM FPGA SRAM image; no CPLD EXTEST or NV/MCU writes."""
import argparse,contextlib,json,struct,subprocess,sys,time
from pathlib import Path
from station import load_dependencies,identify,jtag_command,console
from lease import acquire
from suite import sha,write
HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE.parent))
from test_board import payload


def main():
    p=argparse.ArgumentParser();p.add_argument('--station',required=True,type=Path);p.add_argument('--out',required=True,type=Path);p.add_argument('--reloads',type=int,default=2);a=p.parse_args()
    if not 1<=a.reloads<=5:p.error('reloads must be1..5')
    cfg=json.loads(a.station.read_text());load_dependencies(cfg)
    from client import Client
    from adc_decode import decode
    from host.gate_phase_ipbus import GatePhaseIPbusDevice
    from pm12_console_regression import capture
    from pm12_power import require_power_good
    bit=Path(cfg['boundary']['restore_bit']);assert sha(bit)==cfg['measurement_configuration']['pm_bit_sha256']
    a.out.mkdir(parents=True,exist_ok=False);result=dict(status='ERROR',bit_sha256=sha(bit),rows=[],cpld_extest=False,nonvolatile_writes=False)
    with contextlib.ExitStack() as st:
        for n in sorted(cfg['identity_leases']):st.enter_context(acquire(Path.home()/'.cache'/(n+'.lock')))
        result['identity']=identify(cfg,a.out)['identity']
        u=st.enter_context(console(cfg));c=Client();st.callback(lambda:c.close())
        def measure(stage):
            for bank in [0,1]:
                for repeat in range(3):
                    gen,state=c.acquire(bank,False)
                    for channel in range(1,13):
                        raw=c.block(0x10000+(channel-1)*0x1000,4096)
                        name=f'{stage}-b{bank}-r{repeat}-ch{channel:02d}.bin';(a.out/name).write_bytes(struct.pack('<4096H',*raw))
                        samples,timing=decode(raw,bank)
                        result['rows'].append(dict(stage=stage,bank=bank,repeat=repeat,channel=channel,generation=gen,raw=name,**timing))
                    assert c.read(0x12)==[gen]
            write(a.out/'result.json',result)
            print(stage,'PASS',[(x['channel'],x['status']) for x in result['rows'] if x['stage']==stage and x['repeat']==0 and x['bank']==0],flush=True)
        def reconnect():
            d=GatePhaseIPbusDevice()
            try:d.write(0x100,0x100);time.sleep(.05);d.write(0x100,0);d.write(0x120,1)
            finally:d.close()
            deadline=time.monotonic()+15
            while True:
                try:
                    ids=c.read(0,3);assert ids==[0x504d1202,0x10002,0xc7c42d28];return
                except TimeoutError:
                    if time.monotonic()>deadline:raise
                    time.sleep(.2)
        try:
            measure('before')
            bits=payload(bit,a.out/'image.hex')
            source=(HERE.parent/'adc/tools/load_fpga.tcl').read_text().replace('source [file join [file dirname [info script]] common.tcl]','source '+str(HERE.parent/'adc/tools/common.tcl')).replace('0x504dad01','0x504d5a04')
            (a.out/'reload.tcl').write_text(source)
            with jtag_command(cfg,a.out) as prefix:
                for i in range(a.reloads):
                    require_power_good(u,capture)
                    command=prefix+['-mode','batch','-nolog','-nojournal','-notrace','-source',str(a.out/'reload.tcl'),'-tclargs',cfg['jtag_cable'],cfg.get('hw_server','localhost:3121'),str(a.out/'image.hex'),str(bits)]
                    with (a.out/f'reload{i}.log').open('w') as log:subprocess.run(command,stdout=log,stderr=subprocess.STDOUT,check=True,timeout=300)
                    assert 'LOAD_PASS' in (a.out/f'reload{i}.log').read_text()
                    reconnect();measure('reload'+str(i))
            result['status']='PASS'
        finally:
            (a.out/'image.hex').unlink(missing_ok=True)
            try:c.acquire(0,False);result['pgood_final']=require_power_good(u,capture)
            finally:write(a.out/'result.json',result)

if __name__=='__main__':main()
