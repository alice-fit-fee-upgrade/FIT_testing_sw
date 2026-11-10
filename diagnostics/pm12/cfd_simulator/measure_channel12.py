"""Physical DC scan of the single fitted channel12 simulator, J9 shared DMM.

Owner confirmed the fitted simulator and MCXJ9 connection. Hold both PM12/ICE
leases plus the DMM serial lease; never invoke alongside another bus master.
"""
import argparse,fcntl,json,sys,csv
from pathlib import Path
sys.path.insert(0,'/home/codex-hil/FIT_PM_FW_uPC/tools/hardware')
sys.path.insert(0,'/home/codex-hil/lab-instruments')
import serial
from pm12_console_regression import PORT,capture
from pm12_power import wait_power_good,require_power_good
from labinstruments.transport import Transport
from console import ConsoleI2C,Registers
from mcp23017 import MCP23017Monitor,afe_route,MONITOR_NAMES,report_voltage
from control import SharedMonitorBus,scan
from dmm import DMM7510


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--out',type=Path,required=True);p.add_argument('--dmm-host',required=True)
    p.add_argument('--channels',type=int,nargs='+',choices=range(8),default=list(range(8)))
    p.add_argument('--voltage-range',type=float,choices=[.1,1,10],default=10)
    p.add_argument('--dac-restore',nargs=3,help='Explicit known B/C/D codes in that order, hexadecimal')
    p.add_argument('--baseline-report',type=Path)
    a=p.parse_args()
    if a.dac_restore:
        try:
            a.dac_restore=[int(v,16) for v in a.dac_restore];assert all(0<=v<=65535 for v in a.dac_restore)
        except (ValueError,AssertionError):p.error('Restore codes must be16bit hex')
    out=a.out.resolve();out.mkdir(parents=True,exist_ok=False)
    locks=[];uart=None;bus=None;report=dict(pass_=False,firmware_programming=False,simulator_inventory=[12],mcx='J9 owner-confirmed',measurements=[])
    def save():(out/'report.json').write_text(json.dumps(report,indent=2)+'\n')
    try:
        for name in sorted(['atmel-ice-J41800043065','pm12-210249A73E43','dmm7510-04679690']):
            f=open('/home/codex-hil/.cache/'+name+'.lock','a+');fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB);locks.append(f)
        uart=serial.Serial(port=None,baudrate=115200,timeout=.03,write_timeout=1,rtscts=True,exclusive=True);uart.dtr=False;uart.rts=True;uart.port=PORT;uart.open();uart.read(4096)
        report['power_ready']=wait_power_good(uart,capture)
        report['identity']=capture(uart,'RS');assert 'Board S/N: 1803' in report['identity']['reply']
        report['power_recheck']=require_power_good(uart,capture)
        if a.dac_restore:
            from dac_sweep import DAC
            report['dac_restore_commands']=[];dac=DAC(uart,report['dac_restore_commands'])
            errors=[]
            for output,code in zip('BCD',a.dac_restore):
                try:dac.set_code(output,code)
                except BaseException as error:errors.append((output,repr(error)))
            if errors:raise RuntimeError('DAC restore failure: '+repr(errors))
            report['dac_restore_codes']=dict(zip('BCD',a.dac_restore))
        bus=ConsoleI2C(uart,capture)
        with bus.routed(*afe_route(12)):
            gpio=MCP23017Monitor(Registers(bus));mux=gpio.initialize_monitor();monitor=SharedMonitorBus({'12':mux})
            try:
                monitor.off_all()
                with Transport(dict(kind='tcp',host=a.dmm_host,port=5025,timeout=5)) as io:
                    meter=DMM7510(io);terminals=io.query(':ROUT:TERM?').strip().upper()
                    report['dmm']=meter.configure(terminals,voltage_range=a.voltage_range,nplc=5);save()
                    with (out/'dc.csv').open('w',newline='') as f:
                        writer=csv.DictWriter(f,fieldnames=['board','mux_channel','signal','sample','volts_at_mux','volts','divider_scale']);writer.writeheader();f.flush()
                        def emit(row):
                            row.update(report_voltage(row['mux_channel'],row['volts']));report['measurements'].append(row);writer.writerow(row);f.flush();save()
                        scan(monitor,meter,'12',a.channels,emit,settle_s=.25,repeats=3)
            finally:
                monitor.off_all();report['monitor_final_latch']=gpio.read_latch();assert report['monitor_final_latch']&8
        report['tca_final']={f'{a:02X}':bus.mux(a) for a in (0x70,0x71)}
        report['after_hw']=capture(uart,'@HW');report['pass_']=True
        if a.baseline_report:
            baseline=json.loads(a.baseline_report.read_text())
            measured_names={r['signal'] for r in report['measurements']}
            before={row['signal']:row['volts'] for row in baseline['measurements'] if row.get('stage')=='baseline' and row['signal'] in measured_names}
            from statistics import mean
            after={name:mean(row['volts'] for row in report['measurements'] if row['signal']==name) for name in before}
            report['baseline_voltage_deltas']={name:after[name]-value for name,value in before.items()}
            assert all(abs(v)<(.02 if name in ('N5V5_PM12','P5V5_PM12') else .001) for name,v in report['baseline_voltage_deltas'].items()),'Analog baseline not restored'
    except BaseException as e:report['error']=repr(e);raise
    finally:
        if bus is not None:report['uart']=bus.records
        if uart is not None:
            uart.rts=False;uart.dtr=False;uart.close()
        save()
    print(json.dumps({k:v for k,v in report.items() if k!='uart'},indent=2))

if __name__=='__main__':main()
