import sys, contextlib, json, time, csv, math, statistics
from pathlib import Path
P = Path(__file__).resolve().parents[1]
sys.path[:0] = [str(P / 'acceptance'), str(P / 'cfd_simulator'), '/home/codex-hil/FIT_PM_FW_uPC/tools/hardware', '/home/codex-hil/lab-instruments']
from lease import acquire
from station import console
from console import ConsoleI2C, Registers
from mcp23017 import MCP23017Monitor, afe_route
from pm12_power import wait_power_good, require_power_good
from pm12_console_regression import capture
from labinstruments.transport import Transport
from labinstruments.drivers import Driver
from smu_voltage import parse_voltage
import argparse
a = argparse.ArgumentParser(description='Four-CFD shared-monitor DAC scan with B2910BL as 0-A, 2-wire voltmeter. Force HI/LO connected.')
a.add_argument('--out', type=Path, required=True)
a.add_argument('--channels', nargs='+', type=int, choices=[12, 10, 8, 6], default=[10, 8, 6])
a.add_argument('--confirm-force-voltmeter', action='store_true', required=True)
args = a.parse_args()
r = args.out.resolve()
r.mkdir(parents=True, exist_ok=False)
report = {'commands': [], 'measurements': [], 'connected_modules': [12, 10, 8, 6], 'scanned_modules': args.channels, 'source_current_A': 0, 'sense': 'local Force HI/LO', 'final_dac_codes': 'Each exercised DAC B/C/D explicitly restored to 0000; DAC-A unchanged'}
with contextlib.ExitStack() as st:
    for n in sorted(['atmel-ice-J41800043065', 'pm12-210249A73E43', 'kasli-diot-00001', 'b2910bl-MY63320299']):
        st.enter_context(acquire(Path.home() / '.cache' / (n + '.lock')))
    u = st.enter_context(console({'uart': '/dev/serial/by-id/usb-Prolific_Technology_Inc._USB-Serial_Controller-if00-port0'}))
    report['pg'] = wait_power_good(u, capture)
    assert 'Board S/N: 1803' in capture(u, 'RS')['reply']
    bus = ConsoleI2C(u, capture)

    def off_all():
        for ch in [12, 10, 8, 6]:
            with bus.routed(*afe_route(ch)):
                regs = Registers(bus)
                MCP23017Monitor(regs).initialize_monitor().off()
                assert regs.read(18) & 8
    off_all()
    with Transport(dict(kind='tcp', host='192.168.2.19', port=5025, timeout=8, delay=0.01)) as io:

        def query(q):
            a = io.query(q)
            report['commands'].append({'query': q, 'reply': a})
            return a

        def write(w):
            io.write(w)
            report['commands'].append({'write': w})
        d = Driver(io, 'b2910bl', 'MY63320299')
        report['identity'] = d.identify()
        d.off()
        write('ABOR')
        write('OUTP:ON:AUTO OFF')
        try:
            report['initial_errors'] = []
            for _ in range(10):
                e = query('SYST:ERR?')
                report['initial_errors'].append(e)
                if int(e.split(',')[0]) == 0:
                    break
            for w in ['SOUR:FUNC:MODE CURR', 'SOUR:CURR:MODE FIX', 'SOUR:CURR 0', 'SOUR:CURR:RANG 1e-6', 'SENS:VOLT:PROT 6', 'SENS:REM OFF', 'SENS:FUNC "VOLT"', 'SENS:VOLT:RANG:AUTO OFF', 'SENS:VOLT:RANG 20', 'SENS:VOLT:NPLC 1', 'TRIG:ACQ:SOUR AINT', 'TRIG:ACQ:COUN 1', 'FORM:ELEM:SENS VOLT,TIME,STAT']:
                write(w)
                e = query('SYST:ERR?')
                if int(e.split(',')[0]) != 0:
                    raise RuntimeError('Configuration error ' + w + ' ' + e)
            report['settings'] = {q: query(q) for q in ['OUTP?', 'OUTP:ON:AUTO?', 'OUTP:OFF:MODE?', 'SOUR:FUNC:MODE?', 'SOUR:CURR?', 'SENS:REM?', 'SENS:FUNC?', 'SENS:VOLT:RANG?', 'SENS:VOLT:NPLC?']}
            assert report['settings']['OUTP?'] == '0' and report['settings']['OUTP:ON:AUTO?'] == '0' and (report['settings']['SENS:REM?'] == '0') and (report['settings']['SOUR:FUNC:MODE?'] == 'CURR') and (float(report['settings']['SOUR:CURR?']) == 0)
            write('OUTP ON')
            assert query('OUTP?') == '1'
            codes = [round(i * 65535 / 100) for i in range(101)]
            with (r / 'samples.csv').open('w', newline='') as f:
                writer = csv.DictWriter(f, fieldnames=['pm_channel', 'dac', 'code', 'mux_channel', 'sample', 'volts', 'instrument_time', 'status'])
                writer.writeheader()
                for ch in args.channels:
                    for dac, channel in [('B', 3), ('C', 0), ('D', 1)]:
                        off_all()
                        require_power_good(u, capture)
                        with bus.routed(*afe_route(ch)):
                            regs = Registers(bus)
                            mux = MCP23017Monitor(regs).initialize_monitor()
                            mux.select(channel)
                            try:
                                for index, code in enumerate(codes):
                                    reply = capture(u, f'@DAC {ch} W {dac} {code:04X}')
                                    report['commands'].append(reply)
                                    if reply['reply'].strip() != f'DAC SENT {dac} {code:04X}':
                                        raise RuntimeError(str(reply))
                                    time.sleep(0.1)
                                    for sample in range(3):
                                        assert query('OUTP?') == '1' and query('OUTP:ON:AUTO?') == '0'
                                        v, t, status = parse_voltage(query('READ?'))
                                        row = dict(pm_channel=ch, dac=dac, code=code, mux_channel=channel, sample=sample, volts=v, instrument_time=t, status=int(status))
                                        report['measurements'].append(row)
                                        writer.writerow(row)
                                    f.flush()
                                    if index % 20 == 0:
                                        print(f'PM{ch} DAC{dac}: {index + 1}/101 V={v:.6f}', flush=True)
                            finally:
                                try:
                                    reply = capture(u, f'@DAC {ch} W {dac} 0000')
                                    report.setdefault('restoration', []).append(reply)
                                    if reply['reply'].strip() != f'DAC SENT {dac} 0000':
                                        raise RuntimeError(str(reply))
                                finally:
                                    mux.off()
                        off_all()
            report['scan_complete'] = True
        except BaseException as e:
            report['error'] = repr(e)
            raise
        finally:
            try:
                write('ABOR')
                d.off()
                off_all()
                report['final'] = {q: query(q) for q in ['OUTP?', 'OUTP:ON:AUTO?', 'OUTP:OFF:MODE?']}
                report['final_tca'] = {str(x): bus.mux(x) for x in (112, 113)}
                report['i2c_records'] = bus.records
            finally:
                (r / 'scan-report.json').write_text(json.dumps(report, indent=2) + '\n')
print('SCAN_COMPLETE', flush=True)
