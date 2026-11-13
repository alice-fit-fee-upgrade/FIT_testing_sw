import sys, contextlib, json, time, csv, math, statistics, datetime, signal, os
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
from channel_settings import connected_channels,require_serial_reply,snapshot_sources
import argparse
a = argparse.ArgumentParser(description='Four-CFD shared-monitor DAC scan with B2910BL as 0-A, 2-wire voltmeter. Force HI/LO connected.')
a.add_argument('--out', type=Path, required=True)
a.add_argument('--board-serial',default='1803')
a.add_argument('--connected',nargs=4,type=int,choices=range(1,13),required=True,help='Every fitted CFD sharing the monitor wire')
a.add_argument('--channels',nargs='+',type=int,choices=range(1,13),help='Subset to scan; defaults to all connected')
a.add_argument('--confirm-force-voltmeter', action='store_true', required=True)
args = a.parse_args()
try:args.connected,args.channels=connected_channels(args.connected,args.channels)
except ValueError as error:a.error(str(error))
r = args.out.resolve()
r.mkdir(parents=True, exist_ok=False)
sources=snapshot_sources(r,['__main__','channel_settings','smu_voltage','console','mcp23017','control','lease','station','pm12_console_regression','pm12_power','labinstruments.transport','labinstruments.drivers'])
def terminated(signum, frame):
    raise KeyboardInterrupt('Termination signal '+str(signum))
signal.signal(signal.SIGTERM, terminated)
report = {'started_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'executed_sources':sources,'commands': [], 'measurements': [], 'connected_modules': args.connected, 'scanned_modules': args.channels, 'source_current_A': 0, 'sense': 'local Force HI/LO', 'final_dac_codes': 'Each exercised DAC B/C/D explicitly restored to 0000; DAC-A unchanged'}
def checkpoint():
    temporary=r/'scan-report.json.tmp'
    temporary.write_text(json.dumps(report,indent=2)+'\n')
    os.replace(temporary,r/'scan-report.json')
with contextlib.ExitStack() as st:
    for n in sorted(['atmel-ice-J41800043065', 'pm12-210249A73E43', 'kasli-diot-00001', 'b2910bl-MY63320299']):
        st.enter_context(acquire(Path.home() / '.cache' / (n + '.lock')))
    u = st.enter_context(console({'uart': '/dev/serial/by-id/usb-Prolific_Technology_Inc._USB-Serial_Controller-if00-port0'}))
    report['pg'] = wait_power_good(u, capture)
    report['mcu_identity']=capture(u,'RS');require_serial_reply(report['mcu_identity']['reply'],args.board_serial)
    bus = ConsoleI2C(u, capture)

    def off_all():
        for ch in args.connected:
            with bus.routed(*afe_route(ch)):
                regs = Registers(bus)
                MCP23017Monitor(regs).initialize_monitor().off()
                assert regs.read(18) & 8
    # Recover the identified meter to OFF before touching shared monitor routes.
    with Transport(dict(kind='tcp',host='192.168.2.19',port=5025,timeout=8,delay=.01)) as initial_io:
        initial_meter=Driver(initial_io,'b2910bl','MY63320299')
        report['recovery_identity']=initial_meter.identify();initial_meter.off()
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
            # Fresh known-rail readings verify the shared monitor connection.
            report['preflight_1v3'] = []
            for ch in args.connected:
                off_all()
                with bus.routed(*afe_route(ch)):
                    regs = Registers(bus)
                    mux = MCP23017Monitor(regs).initialize_monitor()
                    try:
                        mux.select(6)
                        time.sleep(0.1)
                        values = [parse_voltage(query('READ?')) for _ in range(3)]
                        report['preflight_1v3'].append(dict(pm_channel=ch, samples=values))
                        if not all(0.9 < v < 1.6 for v, _, _ in values):
                            raise RuntimeError('Shared monitor wiring/1.3V rail check failed on channel'+str(ch))
                    finally:
                        mux.off()
            off_all()
            checkpoint()
            codes = [round(i * 65535 / 100) for i in range(101)]
            with (r / 'samples.csv').open('w', newline='') as f:
                writer = csv.DictWriter(f, fieldnames=['pm_channel', 'dac', 'code', 'mux_channel', 'sample', 'volts', 'instrument_time', 'status'])
                writer.writeheader()
                for ch in args.channels:
                    for dac, channel in [('B', 3), ('C', 0), ('D', 1)]:
                        # Initial off_all and each preceding mux.off are checked.
                        # The shared board lease prevents concurrent monitor writes.
                        checkpoint()
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
                                    assert query('OUTP?') == '1' and query('OUTP:ON:AUTO?') == '0'
                                    for sample in range(3):
                                        v, t, status = parse_voltage(query('READ?'))
                                        row = dict(pm_channel=ch, dac=dac, code=code, mux_channel=channel, sample=sample, volts=v, instrument_time=t, status=int(status))
                                        report['measurements'].append(row)
                                        writer.writerow(row)
                                    f.flush()
                                    if index % 20 == 0:checkpoint()
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
                        checkpoint()
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
                report['finished_utc'] = datetime.datetime.now(datetime.timezone.utc).isoformat()
                checkpoint()
print('SCAN_COMPLETE', flush=True)
