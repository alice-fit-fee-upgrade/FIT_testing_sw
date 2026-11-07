#!/usr/bin/env python3
"""Run established static/JTAG tests, always restore qualified integrated SRAM.
No CPLD programming, configuration flash write or MCU reset command.
"""
import argparse
import contextlib
import json
import os
from pathlib import Path
import shlex
import subprocess
import sys
import time
from lease import acquire,ENV
from suite import sha,write
from station import load_dependencies,identify,jtag_command
HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE.parent))
from test_board import payload


def run(cfg,out):
    diag=Path(cfg['boundary']['diagnostic_bit'])
    restore=Path(cfg['boundary']['restore_bit'])
    for path,expected in [(diag,cfg['boundary']['diagnostic_sha256']),
                          (restore,cfg['measurement_configuration']['pm_bit_sha256'])]:
        if sha(path)!=expected:raise ValueError('Bitstream checksum mismatch: '+str(path))
    # Validate both payloads before even the first programming attempt.
    payload(diag,out/'validate.hex');payload(restore,out/'validate.hex');(out/'validate.hex').unlink()
    result=dict(status='ERROR',persistent_writes=False,diagnostic_sha256=sha(diag),restore_sha256=sha(restore))
    with jtag_command(cfg,out) as prefix:
        attempted=False
        try:
            attempted=True
            command=[sys.executable,str(HERE.parent/'test_board.py'),'--serial',cfg['jtag_cable'],
                     '--bitstream',str(diag),'--output',str(out/'diagnostic'),
                     '--vivado-command',shlex.join(prefix),'--step-timeout','300']
            inherited=json.loads(os.environ.get(ENV,'{}'))
            with (out/'boundary-console.log').open('w') as log:
                subprocess.run(command,stdout=log,stderr=subprocess.STDOUT,check=True,timeout=1500,
                               pass_fds=tuple(int(f) for f in inherited.values()))
            result['measurement']=json.loads((out/'diagnostic/report.json').read_text())
            if result['measurement']['status']!='PASS':raise RuntimeError('Static link test failed')
            result['status']='PASS'
        finally:
            # Reconfigure even after a failed test or interrupted load. Never leave
            # the static diagnostic installed in place of the integrated image.
            if attempted:
                bits=payload(restore,out/'restore.hex')
                source=(HERE.parent/'adc/tools/load_fpga.tcl').read_text()
                source=source.replace('source [file join [file dirname [info script]] common.tcl]',
                                      'source '+str(HERE.parent/'adc/tools/common.tcl'))
                source=source.replace('0x504dad01','0x504d5a04')
                (out/'restore.tcl').write_text(source)
                with (out/'restore.log').open('w') as log:
                    subprocess.run(prefix+['-mode','batch','-nolog','-nojournal','-notrace','-source',str(out/'restore.tcl'),
                                  '-tclargs',cfg['jtag_cable'],cfg.get('hw_server','localhost:3121'),str(out/'restore.hex'),str(bits)],
                                   stdout=log,stderr=subprocess.STDOUT,check=True,timeout=300)
                (out/'restore.hex').unlink(missing_ok=True)
                if 'LOAD_PASS' not in (out/'restore.log').read_text():raise RuntimeError('No restore signature')
                from host.gate_phase_ipbus import GatePhaseIPbusDevice
                from client import Client
                d=GatePhaseIPbusDevice()
                try:
                    d.write(0x100,0x100);time.sleep(.05);d.write(0x100,0);d.write(0x120,1)
                finally:d.close()
                c=Client()
                try:
                    for _ in range(10):
                        try:
                            ids=c.read(0,3)
                            if ids!=[0x504d1202,0x10002,0xc7c42d28]:raise RuntimeError('Restored build identity mismatch')
                            break
                        except TimeoutError:time.sleep(.5)
                    else:raise RuntimeError('Private link failed to recover')
                finally:c.close()
                result['restoration']='PASS';result['restored_identity']=ids
                from station import integrated
                check=out/'post-restore';check.mkdir()
                post=integrated(cfg,check);write(check/'result.json',post)
                result['post_restore_functional_status']=post['status']
                if post['status']!='PASS':raise RuntimeError('Post-restoration integrated functional test failed')
                write(out/'restoration-result.json',result)
    return result


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--station',type=Path,required=True);p.add_argument('--out',type=Path,required=True);a=p.parse_args()
    cfg=json.loads(a.station.read_text());load_dependencies(cfg)
    a.out.mkdir(parents=True,exist_ok=False);result=dict(status='ERROR',restoration='UNKNOWN')
    try:
        with contextlib.ExitStack() as st:
            # When called standalone, inherit these actual descriptors into legacy runner.
            locks={}
            for n in sorted(cfg['identity_leases']):
                path=Path.home()/'.cache'/(n+'.lock');f=st.enter_context(acquire(path));locks[str(path.resolve())]=f.fileno()
            old=os.environ.get(ENV);os.environ[ENV]=json.dumps(locks)
            st.callback(lambda:os.environ.pop(ENV,None) if old is None else os.environ.__setitem__(ENV,old))
            identity=identify(cfg,a.out)['identity']
            result=run(cfg,a.out);result['identity']=identity
    except BaseException as e:
        result=__import__('json').loads((a.out/'restoration-result.json').read_text()) if (a.out/'restoration-result.json').exists() else result
        result['status']='ERROR';result['error']=repr(e);raise
    finally:write(a.out/'result.json',result)
    return 0 if result['status']=='PASS' else 1

if __name__=='__main__':raise SystemExit(main())
