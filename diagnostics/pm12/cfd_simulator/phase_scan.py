#!/usr/bin/env python3
"""Sweep PM12 DAC-A and capture CFD gate phase with the resident Kasli RPH1.

No programming, reset, EEPROM or configuration writes. DAC hardware has no code
readback: --restore-code is mandatory and must describe the known active state.
"""
import argparse
import contextlib
import csv
import fcntl
import gzip
import json
from pathlib import Path
import re
import sys
import time
from phase_estimator import estimate, scan_codes, wrapped_delta

HERE = Path(__file__).resolve().parent
sys.path.insert(0,str(HERE.parent/'acceptance'))
from lease import acquire as acquire_lease


def run_scan(set_code, acquire, check_power, emit, restore_code, codes,
             lanes, settle_s=.1, repeats=1, sleep=time.sleep, initialize_zero=False, clock_mhz=80):
    """Hardware-independent scan flow; restore after any possibly executed write."""
    changed = False
    previous_mean = {}
    first_mean = {}
    last_start = None
    profile = None

    def measure(stage, code):
        nonlocal last_start, profile
        captures = []
        for repeat in range(repeats):
            capture = acquire()
            # Save BEFORE analysis so invalid signals still have retained raw data.
            emit('raw', dict(stage=stage, code=code, repeat=repeat, capture=capture))
            current_profile = (capture['sample_ps'], capture['period_bins'])
            if profile is not None and current_profile != profile:
                raise RuntimeError('sample clock profile changed during scan')
            profile = current_profile
            starts = {row['start_sample'] for row in capture['channels']}
            if len(starts) != 1:
                raise RuntimeError('lanes do not share a capture start')
            start = starts.pop()
            if last_start is not None and start <= last_start:
                raise RuntimeError('sample counter restarted or capture was reused')
            last_start = start
            rows = {row['logical']: row for row in capture['channels']}
            if set(rows) != set(lanes):
                raise RuntimeError('capture lane map mismatch')
            captures.append(capture)
        estimates = {}
        for lane in lanes:
            rows = [next(row for row in cap['channels'] if row['logical'] == lane) for cap in captures]
            edge_bins=round(1e6/profile[0]/clock_mhz)
            result = estimate(rows, profile[0], profile[1], edge_period_bins=edge_bins)
            if stage == 'sweep':
                unwrapped = result['mean_bin']
                if lane in previous_mean:
                    unwrapped = previous_mean[lane] + wrapped_delta(unwrapped, previous_mean[lane], result['period_bins'])
                previous_mean[lane] = unwrapped
                result['unwrapped_bin'] = unwrapped
                result['unwrapped_ns'] = unwrapped * profile[0] / 1000
                first_mean.setdefault(lane,unwrapped)
                result['relative_ns'] = (unwrapped-first_mean[lane]) * profile[0] / 1000
            result.update(slot=rows[0]['slot'], channel=rows[0]['channel'], logical=lane)
            estimates[lane] = result
        emit('point', dict(stage=stage, code=code, estimates=estimates, utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime())))
        return estimates

    check_power()
    if initialize_zero and restore_code != 0:
        raise ValueError('zero initialization requires restore_code0')
    baseline = None
    result = dict(restore_code=restore_code, restoration_attempted=False,
                  zero_baseline_established=initialize_zero)
    scan_error = None
    try:
        if initialize_zero:
            measure('as-found', None)
            changed = True
            set_code(0)
            sleep(settle_s)
        baseline = measure('baseline', 0 if initialize_zero else None)
        result['baseline'] = baseline
        for index, code in enumerate(codes):
            check_power()
            changed = True  # A failed reply does not prove that the DAC was untouched.
            set_code(code)
            sleep(settle_s)
            measure('sweep', code)
            print(f'{index+1}/{len(codes)} DAC A={code:05d} (0x{code:04X})', flush=True)
    except BaseException as error:
        scan_error = error
        raise
    finally:
        if changed:
            result['restoration_attempted'] = True
            try:
                check_power()
                set_code(restore_code)
                sleep(settle_s)
                restored = measure('restored', restore_code)
                result['restore_command_accepted'] = True
                if baseline is None:
                    result['restored'] = restored
                    result['restore_phase_check'] = 'unavailable: baseline acquisition failed'
                    emit('result', result)
                    if scan_error is None:raise RuntimeError('no baseline for restoration check')
                    raise RuntimeError('scan failed before baseline was established')
                deltas = {lane: wrapped_delta(restored[lane]['mean_bin'], baseline[lane]['mean_bin'],
                                               baseline[lane]['period_bins']) for lane in lanes}
                result.update(restored=restored, restore_phase_deltas_bins=deltas)
                if any(abs(v) > 1 for v in deltas.values()):
                    raise RuntimeError('restored phase differs from baseline by more than one bin')
                result['restore_command_accepted'] = True
                result['restore_phase_check'] = True
            except BaseException as error:
                result['restore_error'] = repr(error)
                emit('result', result)
                raise RuntimeError(f'DAC restoration/verification failed: {error}; scan error: {scan_error!r}') from error
        emit('result', result)
    return result


class ConsoleDAC:
    def __init__(self, uart, channel, capture, record):
        self.uart, self.channel, self.capture, self.record = uart, channel, capture, record

    def set_code(self, code):
        if type(code) is not int or not 0 <= code <= 65535:
            raise ValueError('invalid16bit DAC code')
        deadline = time.monotonic() + 4
        while True:
            reply = self.capture(self.uart, f'@DAC {self.channel} W A {code:04X}', limit=2)
            self.record(reply)
            text = reply['reply'].strip()
            if text == 'ERR BUSY' and time.monotonic() < deadline:
                time.sleep(.25)
                continue
            if text != f'DAC SENT A {code:04X}':
                raise OSError(text)
            break


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--afe', type=int, required=True, help='PM12 physical channel1..12')
    parser.add_argument('--lanes', required=True, help='Kasli logical RX lanes, e.g.8,9 for slot7 channels1,3')
    parser.add_argument('--restore-code', required=True, help='Known active DAC-A raw code, hexadecimal; NOT STORED parameter')
    parser.add_argument('--out', type=Path, required=True)
    parser.add_argument('--initialize-zero', action='store_true', help='Explicitly establish DAC A=0 before baseline, finish at0; prior code is not restored')
    parser.add_argument('--intervals', type=int, default=100)
    parser.add_argument('--transport',choices=('uart','ipbus'),default='uart')
    parser.add_argument('--ipbus-host',default='192.168.2.241')
    parser.add_argument('--clock-mhz',type=int,choices=(20,40,80),default=80,help='Measured gate frequency; original CPLD uses20MHz')
    parser.add_argument('--words', type=int, default=4095)
    parser.add_argument('--repeats', type=int, default=1)
    parser.add_argument('--settle', type=float, default=.1)
    parser.add_argument('--kasli-root', type=Path, default=Path('/home/codex-hil/kasli-phase-tester'))
    parser.add_argument('--console-tools', type=Path, default=Path('/home/codex-hil/FIT_PM_FW_uPC/tools/hardware'))
    parser.add_argument('--board-serial', default='1803')
    args = parser.parse_args()
    try:
        restore = int(args.restore_code,16)
        lanes = [int(v) for v in args.lanes.split(',')]
        codes = scan_codes(args.intervals)
        assert 1 <= args.afe <= 12 and 0 <= restore <= 65535
        assert not args.initialize_zero or restore == 0
        assert lanes and len(set(lanes)) == len(lanes) and all(0 <= v < 16 for v in lanes)
        assert 150 <= args.words <= 4095 and args.words % 3 == 0
        assert 1 <= args.repeats <= 100 and 0 <= args.settle <= 60
    except (ValueError, AssertionError):
        parser.error('invalid channel, lanes, restore-code, words (multiple3,150..4095), repeats or settling')
    sys.path.insert(0,str(args.kasli_root));sys.path.insert(0,str(args.console_tools))
    import serial
    from pm12_console_regression import PORT, capture
    from pm12_power import wait_power_good, require_power_good
    from host.gate_phase_device import GatePhaseDevice
    from host.gate_phase_dio import input_cards
    from host.hdmi_check import check_phase_records

    out = args.out.resolve();out.mkdir(parents=True,exist_ok=False)
    report = dict(pass_=False,transport=f'Kasli {args.transport}, PM12 console115200',
                  args={k:str(v) if isinstance(v,Path) else v for k,v in vars(args).items()},
                  codes=codes,scope=f'{args.clock_mhz}MHz gate phase; weighted sampled centroid, not calibrated fine delay',
                  unwrapping=f'Nearest continuation; assumes adjacent DAC steps change delay by less than{500/args.clock_mhz}ns',
                  restore_warning='Explicit code is sent; no DAC hardware readback. Phase check is corroboration only.')
    def save():
        temp = out/'report.tmp'
        temp.write_text(json.dumps(report,indent=2)+'\n');temp.replace(out/'report.json')
    save()
    with contextlib.ExitStack() as stack:
        for name in sorted(('atmel-ice-J41800043065','pm12-210249A73E43','kasli-diot-00001')):
            lock = stack.enter_context(acquire_lease(Path.home()/'.cache'/(name+'.lock')))
        uart = serial.Serial(port=None,baudrate=115200,timeout=.03,write_timeout=1,rtscts=True,exclusive=True)
        uart.dtr=False;uart.rts=True;uart.port=PORT;uart.open();stack.callback(uart.close);uart.read(4096)
        if args.transport=='ipbus':
            from host.gate_phase_ipbus import GatePhaseIPbusDevice
            device=GatePhaseIPbusDevice(args.ipbus_host)
        else:device=GatePhaseDevice()
        stack.callback(device.close)
        events = stack.enter_context((out/'events.jsonl').open('w'))
        csvfile = stack.enter_context((out/'phase.csv').open('w',newline=''))
        columns = ['stage','code','logical','slot','channel','mean_ns','unwrapped_ns','relative_ns','spread_bins','rising_edges','occupied_span_bins']
        writer = csv.DictWriter(csvfile,fieldnames=columns);writer.writeheader();csvfile.flush()
        def emit(kind, value):
            if kind == 'raw':
                code = 'initial' if value['code'] is None else str(value['code'])
                with gzip.open(out/f"{value['stage']}-{code}-{value['repeat']}.json.gz",'wt') as stream:
                    json.dump(value['capture'],stream)
                for row in value['capture']['channels']:check_phase_records(row)
            else:
                events.write(json.dumps(dict(kind=kind,**value))+'\n');events.flush()
                if kind == 'point':
                    for row in value['estimates'].values():
                        writer.writerow({key:dict(stage=value['stage'],code=value['code'],**row).get(key,'') for key in columns})
                    csvfile.flush()
                if kind == 'result':report['result']=value;save()
        try:
            report['power_ready'] = wait_power_good(uart,capture)
            report['identity'] = capture(uart,'RS')
            if not re.search(r'Board S/N:\s*'+re.escape(args.board_serial)+r'\b', report['identity']['reply']):
                raise RuntimeError('Wrong PM12 MCU board identity')
            report['directions'] = input_cards(device);report['kasli_mapping']=device.mapping
            report['initial_status'] = device.status();save()
            if not report['initial_status']['ready']:
                raise RuntimeError('Kasli sampling clocks are not ready')
            def acquire():
                start=time.monotonic()
                data=device.capture(args.words,channels=lanes)
                report.setdefault('capture_download_seconds',[]).append(time.monotonic()-start)
                return data
            dac = ConsoleDAC(uart,args.afe,capture,lambda row:emit('console',row))
            run_scan(dac.set_code,acquire,lambda:require_power_good(uart,capture),emit,
                     restore,codes,lanes,args.settle,args.repeats,initialize_zero=args.initialize_zero,clock_mhz=args.clock_mhz)
            report['pass_']=True
        except BaseException as error:
            report['error']=repr(error)
            raise
        finally:
            try:device.stop();report['final_status']=device.status()
            finally:save()
    print(f'Saved {len(codes)} points to {out}/phase.csv')

if __name__=='__main__':main()
