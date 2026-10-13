#!/usr/bin/env python3
"""PM12 SRAM diagnostic loading and measured JTAG connectivity tests."""
import argparse
import csv
import datetime
import fcntl
import hashlib
import json
import os
from pathlib import Path
import re
import shlex
import subprocess
import sys

HERE = Path(__file__).resolve().parent
PINMAP = json.loads((HERE / 'pinmap.json').read_text())
PIN_MASK = (1 << 168) - 1


def payload(bitstream, output):
    data = bitstream.read_bytes()
    pos = 2 + int.from_bytes(data[:2], 'big')
    if data[pos:pos + 3] != b'\x00\x01a':
        raise ValueError('Invalid Xilinx .bit header')
    pos += 2
    fields = {}
    while pos < len(data) and data[pos:pos + 1] != b'e':
        key = data[pos:pos + 1].decode('ascii')
        count = int.from_bytes(data[pos + 1:pos + 3], 'big')
        fields[key] = data[pos + 3:pos + 3 + count].rstrip(b'\0').decode('ascii')
        pos += 3 + count
    if data[pos:pos + 1] != b'e':
        raise ValueError('Missing configuration payload')
    count = int.from_bytes(data[pos + 1:pos + 5], 'big')
    raw = data[pos + 5:]
    if len(raw) != count or b'\xaa\x99\x55\x66' not in raw:
        raise ValueError('Invalid configuration payload length/sync')
    if not re.fullmatch(r'(?:xc)?7k160t-?ffg676(?:-3)?', fields.get('b', '')):
        raise ValueError(f"Unexpected FPGA part: {fields.get('b')}")
    reverse = bytes(int(f'{i:08b}'[::-1], 2) for i in range(256))
    value = int.from_bytes(raw.translate(reverse), 'little')
    bits = len(raw) * 8 + 12  # FPGA nearest TDO; twelve CPLD bypass bits trail.
    output.write_text(f'{value:0{(bits + 3) // 4}x}')
    return bits


def analyze(text, boundary=False):
    rows = {name: int(value, 16) for name, value in
            re.findall(r'^VECTOR (\S+) ([0-9a-fA-F]+)$', text, re.M)}
    expected_names = {'ZERO', 'ONES'} | {f'{p}_{i}' for p in ('ONE', 'ZERO') for i in range(168)}
    if set(rows) != expected_names:
        raise ValueError(f'Incomplete discovery: {len(rows)}/338 vectors')
    if not boundary and any((v & 0xffffffff) != 0x504d1201 for v in rows.values()):
        raise ValueError('Diagnostic signature changed during discovery')
    result = []
    for signal, pin in PINMAP['fpga'].items():
        if signal.startswith('DI'):
            channel, bit = map(int, re.fullmatch(r'DI(\d+)\[(\d+)\]', signal).groups())
        else:
            channel, bit = int(signal[3:]), 13
        expected = (12 - channel) * 14 + bit
        cell = pin['boundary_cell'] if boundary else 1568 + (channel - 1) * 14 + bit
        high = [i for i in range(168) if (rows[f'ONE_{i}'] >> cell) & 1]
        low = [i for i in range(168) if not ((rows[f'ZERO_{i}'] >> cell) & 1)]
        source = high[0] if len(high) == 1 and high == low else None
        zero_ok = not ((rows['ZERO'] >> cell) & 1)
        one_ok = bool((rows['ONES'] >> cell) & 1)
        result.append(dict(signal=signal, fpga_ball=pin['ball'], expected_source=expected,
                           discovered_source=source, sources_high=high, sources_low=low,
                           cpld_channel=12 - source // 14 if source is not None else None,
                           cpld_pin=PINMAP['cpld'][source % 14]['pin'] if source is not None else None,
                           passed=source == expected and zero_ok and one_ok))
    return dict(passed=all(r['passed'] for r in result) and 'RESTORED_REPORT' in text,
                matched=sum(r['passed'] for r in result), total=168, vectors=338,
                restored='RESTORED_REPORT' in text, connections=result)


def controls(text):
    rows = {name: (int(t), int(value, 16)) for name, t, value in
            re.findall(r'^CONTROL (\S+) (\d+) ([a-fA-F0-9]+)$', text, re.M)}
    expected = {f'{kind}_{i}{suffix}' for i in range(3)
                for kind, suffix in [('RUN', '_A'), ('RUN', '_B'), ('FREEZE', '_A'),
                                     ('FREEZE', '_B'), ('RESUME', ''), ('RESET', '')]}
    if set(rows) != expected or 'CONTROL_PASS' not in text:
        raise ValueError('Incomplete or failed monitor control test')
    rates = []
    for i in range(3):
        t, a = rows[f'RUN_{i}_A']; u, b = rows[f'RUN_{i}_B']
        if u <= t:
            raise ValueError('Invalid host time interval')
        rates.append((((b >> 32) - (a >> 32)) & 0xffffffff) * 1000 / (u - t))
    return dict(passed=True, repeats=3, approximate_host_timed_clock_hz=rates)


def save_connections(path, result):
    with path.open('w', newline='') as stream:
        writer = csv.writer(stream)
        writer.writerow(['signal', 'fpga_ball', 'cpld_channel', 'cpld_pin', 'passed'])
        for row in result['connections']:
            writer.writerow([row[k] for k in ('signal', 'fpga_ball', 'cpld_channel', 'cpld_pin', 'passed')])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--serial', required=True, help='Exact PM12 JTAG cable serial')
    parser.add_argument('--server', default='localhost:3121')
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument('--bitstream', type=Path, help='Load diagnostic into FPGA SRAM before testing')
    mode.add_argument('--skip-program', action='store_true', help='Use already loaded diagnostic; signature checked')
    parser.add_argument('--vivado-command', default='vivado', help='Executable and arguments, split with shlex; no shell')
    parser.add_argument('--output', type=Path)
    parser.add_argument('--lock', type=Path, help='Override shared board lock path')
    parser.add_argument('--step-timeout', type=int, default=240)
    args = parser.parse_args()
    if not re.fullmatch(r'[A-Za-z0-9_-]+', args.serial):
        parser.error('Serial must contain only letters, digits, underscore or hyphen')
    timestamp = datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ')
    output = (args.output or HERE / 'results' / timestamp).resolve()
    output.mkdir(parents=True, exist_ok=False)
    lock = args.lock or Path.home() / '.cache' / f'pm12-{args.serial}.lock'
    lock.parent.mkdir(parents=True, exist_ok=True)
    command = shlex.split(args.vivado_command)
    if not command:
        parser.error('Empty Vivado command')
    env = dict(os.environ, PM12_SERIAL=args.serial, PM12_SERVER=args.server)
    summary = dict(status='FAIL', serial=args.serial, server=args.server,
                   time_utc=timestamp, nonvolatile_programming=False,
                   schematic_sha256=PINMAP['schematic_sha256'],
                   limits=['Static data/strobe connectivity; acquisition, ADC and analog paths untested',
                           'Clock rate uses approximate host/JTAG timing'])

    def run(name):
        logfile = output / f'{name}.log'
        with logfile.open('w') as stream:
            subprocess.run(command + ['-mode', 'batch', '-nolog', '-nojournal', '-notrace',
                                      '-source', str(HERE / 'tcl' / f'{name}.tcl'), '-tclargs',
                                      args.serial, args.server, env.get('PM12_PAYLOAD', ''),
                                      env.get('PM12_PAYLOAD_BITS', '0')],
                           cwd=output, env=env, stdout=stream, stderr=subprocess.STDOUT,
                           timeout=args.step_timeout, check=True)
        return logfile.read_text()

    with lock.open('a+') as lease:
        try:
            fcntl.flock(lease, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            summary['error'] = f'Board busy: {lock}'
            (output / 'report.json').write_text(json.dumps(summary, indent=2) + '\n')
            print(summary['error'], file=sys.stderr)
            return 1
        try:
            if args.bitstream:
                bitstream = args.bitstream.resolve()
                env['PM12_PAYLOAD_BITS'] = str(payload(bitstream, output / 'payload.hex'))
                env['PM12_PAYLOAD'] = str(output / 'payload.hex')
                summary['bitstream_sha256'] = hashlib.sha256(bitstream.read_bytes()).hexdigest()
                print('Loading diagnostic into FPGA SRAM...', flush=True)
                run('load')
            print('Discovering 168 links through gateware...', flush=True)
            summary['gateware'] = analyze(run('discover'))
            print('Checking links independently through FPGA boundary scan...', flush=True)
            summary['boundary'] = analyze(run('boundary'), boundary=True)
            print('Testing monitor reset, freeze and resume...', flush=True)
            summary['controls'] = controls(run('control'))
            save_connections(output / 'connections.csv', summary['gateware'])
            if all(summary[k]['passed'] for k in ('gateware', 'boundary', 'controls')):
                summary['status'] = 'PASS'
        except (Exception, KeyboardInterrupt) as exc:
            summary['error'] = str(exc) or type(exc).__name__
        finally:
            # Keep the hardware lease through cleanup, including failed/aborted tests.
            try:
                summary['restored'] = 'RESTORE_PASS' in run('restore')
            except (Exception, KeyboardInterrupt) as exc:
                summary['restored'] = False
                summary['restore_error'] = str(exc)
            if not summary['restored']:
                summary['status'] = 'FAIL'
            (output / 'payload.hex').unlink(missing_ok=True)
            (output / 'report.json').write_text(json.dumps(summary, indent=2) + '\n')
    print(f"{summary['status']}: {output / 'report.json'}")
    return 0 if summary['status'] == 'PASS' else 1


if __name__ == '__main__':
    sys.exit(main())
