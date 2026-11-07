#!/usr/bin/env python3
"""Leased station adapters. Called by suite.py, also usable for identity enrollment."""
import argparse
import contextlib
import importlib.util
import json
from pathlib import Path
import re
import shlex
import subprocess
import sys
import time
import uuid
from identity import board_uid, canonical_dna
from lease import acquire

HERE = Path(__file__).resolve().parent
PM = HERE.parent


def load_dependencies(cfg):
    sys.path[:0] = [str(Path(cfg['console_tools'])), str(PM/'ipbus_adc'),
                    str(PM/'cfd_simulator'), str(Path(cfg['kasli_root']))]


@contextlib.contextmanager
def jtag_command(cfg, out):
    if not cfg.get('managed_jtag'):
        yield shlex.split(cfg['vivado_command'])
        return
    settings=cfg['managed_jtag']
    docker=['docker','-H',settings['socket']]
    name='fit-dna-'+uuid.uuid4().hex[:12]
    binary=settings['vivado_bin']
    command=docker+['run','--rm','--name',name,'--init']
    for mount in ['/srv/codex-hil-data','/srv/codex-hil-nvme','/home/codex-hil','/dev/bus/usb']:
        command+=['--mount',f'type=bind,src={mount},dst={mount}']
    command += [settings['image'],binary+'/hw_server','-e','set jtag-port-filter '+cfg['jtag_cable'],
                '-e','set max-ir-length 128']
    with (out/'hw-server.log').open('w') as log:
        server=subprocess.Popen(command,stdout=log,stderr=subprocess.STDOUT)
        try:
            deadline=time.monotonic()+30
            while subprocess.run(docker+['exec',name,'/bin/bash','-c','true </dev/tcp/127.0.0.1/3121'],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL,timeout=3).returncode != 0:
                if server.poll() is not None or time.monotonic()>deadline:
                    raise RuntimeError('Dedicated JTAG server did not start')
                time.sleep(.25)
            yield docker+['exec','-e','LD_PRELOAD=/lib/x86_64-linux-gnu/libudev.so.1',name,binary+'/vivado']
        finally:
            subprocess.run(docker+['stop','--time','5',name],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL,timeout=20)
            server.wait(timeout=20)


def read_dna(cfg, out):
    with jtag_command(cfg,out) as prefix:
        command=prefix+['-mode','batch','-nolog','-nojournal','-notrace','-source',str(HERE/'identity.tcl'),
                        '-tclargs',cfg['jtag_cable'],cfg.get('hw_server','localhost:3121')]
        with (out/'dna-jtag.log').open('w') as log:
            subprocess.run(command,stdout=log,stderr=subprocess.STDOUT,timeout=120,check=True)
    text=(out/'dna-jtag.log').read_text()
    match=re.search(r'^FIT_DNA\s+(?:0[xX])?([0-9a-fA-F]{1,16})\s*$',text,re.M)
    if not match:raise RuntimeError('No valid DNA in JTAG reply; do not substitute IDCODE/cable number')
    return canonical_dna(match[1])


@contextlib.contextmanager
def console(cfg):
    import serial
    u = serial.Serial(port=None, baudrate=115200, timeout=.03, write_timeout=1,
                      rtscts=True, exclusive=True)
    u.dtr = False
    u.rts = True
    u.port = cfg['uart']
    u.open()
    try:
        u.read(4096)
        yield u
    finally:
        u.rts = False
        u.dtr = False
        u.close()


def identify(cfg, out):
    from client import Client
    from pm12_console_regression import capture
    from pm12_power import wait_power_good, require_power_good
    with console(cfg) as u:
        pg = wait_power_good(u, capture)
        serial = capture(u, 'RS')
        match = re.search(r'Board S/N:\s*(\d+)', serial['reply'])
        if not match or (cfg.get('board_serial') is not None and match[1] != str(cfg['board_serial'])):
            raise RuntimeError('Wrong MCU serial: '+repr(serial))
        c = Client()
        try:
            uptime_before = c.read(5, 2)
            fpga = c.read(0, 3)
            if fpga != [0x504d1202, 0x10002, 0xc7c42d28]:
                raise RuntimeError('Unexpected integrated FPGA image: '+repr(fpga))
            dna = read_dna(cfg, out)
            after = c.read(5, 2)
            if after[0]+(after[1]<<32) < uptime_before[0]+(uptime_before[1]<<32):
                raise RuntimeError('SYS reset during identity read')
        finally:
            c.close()
        row = dict(uid=board_uid(dna), fpga_dna=dna, mcu_eeprom_serial=match[1],
                   asset_label=cfg.get('asset_label'), cpu_factory_id=None,
                   cpu_factory_id_status='NOT_READ; do not reset MCU for a PDI signature read',
                   jtag_cable=cfg['jtag_cable'], fpga_ipbus_identity=fpga,
                   pgood=pg, pgood_final=require_power_good(u, capture), mcu_reply=serial,
                   uptime_before=uptime_before, uptime_after=after,
                   observed_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()))
        if cfg.get('board_uid') and cfg['board_uid'] != row['uid']:
            raise RuntimeError('Hardware DNA does not match enrolled board')
        return dict(status='PASS', identity=row)


def mcu(cfg, out):
    from pm12_console_regression import capture
    from pm12_power import wait_power_good, require_power_good
    rows = []
    result = dict(status='FAIL', records=rows, scope='MCU UART, chip IDs, scratch SPI and sensor observations; no power transition/flash reset')
    try:
        with console(cfg) as u:
            result['pgood'] = wait_power_good(u, capture)
            for command in ['@PING', 'RS', '@HW', '@PGTIME', '@TEMP', '@TDC 0 83', '@TDC 1 83',
                            '@TDC 2 83', '@PLL', '@FPGA', '@FPGATEST', '@INA 4', '@INA 5', '@INA 6', '@POWER']:
                if command.startswith(('@TEMP', '@INA', '@POWER', '@TDC', '@PLL', '@FPGA')):
                    result.setdefault('power_checks', []).append(require_power_good(u, capture))
                row = capture(u, command)
                rows.append(row)
                reply = row['reply']
                if not reply or 'ERR ' in reply:
                    raise RuntimeError('MCU command failed: '+repr(row))
                if command == '@PING' and reply != 'PONG\r\n':
                    raise RuntimeError('PING mismatch')
                if command == 'RS' and (not re.search(r'Board S/N:\s*'+re.escape(str(cfg['board_serial']))+r'\b', reply)
                                       or 'Board power ON, OK' not in reply):
                    raise RuntimeError('Wrong board or power state')
                if command == '@FPGATEST' and reply != 'FPGA TEST PASS 32 RESTORED\r\n':
                    raise RuntimeError('MCU-FPGA walking patterns/restoration failed')
                if command.startswith('@TDC') and '8010' not in reply:
                    raise RuntimeError('Unexpected TDC ID')
                if command == '@TEMP' and not re.search(r'REG=03\s+C3', reply):
                    raise RuntimeError('Unexpected temperature sensor ID')
            result['status'] = 'PASS'
            result['pg_timing_acceptance'] = 'NOT_RUN: static PGOOD does not validate EN-to-PG timeout protection'
            result['p3v8_current_acceptance'] = 'NOT_APPLICABLE: shunt not fitted; voltage only'
    finally:
        (out/'result.json').write_text(json.dumps(result, indent=2)+'\n')
    return result


def integrated(cfg, out):
    from host.pm_system_test import run
    from host.gate_phase_ipbus import GatePhaseIPbusDevice
    from client import Client
    from pm12_console_regression import capture
    from pm12_power import wait_power_good, require_power_good
    with contextlib.ExitStack() as st:
        u = st.enter_context(console(cfg))
        pg = wait_power_good(u, capture)
        d = GatePhaseIPbusDevice()
        st.callback(d.close)
        c = Client()
        st.callback(c.close)
        try:
            result = run(d, c, out, ('hdmi','adc','tdc'), cfg['stimulated_channel'])
            result['pgood'] = pg
            result['pgood_final'] = require_power_good(u, capture)
            result['status'] = 'PASS' if result['pass'] else 'FAIL'
            return result
        finally:
            # Preserve all existing adapter cleanup, including release of shared SPI.
            try: d.write(0x144, 0)
            finally:
                try: d.write(0xe0, 0)
                finally: d.stop()


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('kind', choices=['identity', 'mcu', 'integrated'])
    p.add_argument('--station', type=Path, required=True)
    p.add_argument('--out', type=Path, required=True)
    a = p.parse_args()
    cfg = json.loads(a.station.read_text())
    load_dependencies(cfg)
    a.out.mkdir(parents=True, exist_ok=False)
    result = dict(status='ERROR')
    try:
        with contextlib.ExitStack() as st:
            for name in sorted(cfg['identity_leases']):
                st.enter_context(acquire(Path.home()/'.cache'/(name+'.lock')))
            # Verify the physical board under these same leases before every adapter.
            pre = identify(cfg, a.out)
            if a.kind == 'identity': result = pre
            elif a.kind == 'mcu': result = mcu(cfg, a.out)
            else: result = integrated(cfg, a.out)
            result['identity'] = pre['identity']
    except BaseException as e:
        result['status'] = 'ERROR'
        result['error'] = repr(e)
        raise
    finally:
        (a.out/'result.json').write_text(json.dumps(result, indent=2)+'\n')
    return 0 if result['status'] == 'PASS' else 1

if __name__ == '__main__':
    raise SystemExit(main())
