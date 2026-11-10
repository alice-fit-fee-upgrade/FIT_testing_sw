"""Channel12 DAC B/C/D full-span functional curves, restore startup code state.

No DAC-A writes. Stored code computation is not DAC hardware readback; fresh
validated MCU startup and exclusive ownership are the precondition for using it.
"""
import argparse,csv,fcntl,json,math,re,statistics,sys,time
from pathlib import Path
sys.path.insert(0,'/home/codex-hil/FIT_PM_FW_uPC/tools/hardware')
sys.path.insert(0,'/home/codex-hil/lab-instruments')
import serial
from pm12_console_regression import PORT,capture
from pm12_power import wait_power_good,require_power_good
from labinstruments.transport import Transport
from console import ConsoleI2C,Registers
from mcp23017 import MCP23017Monitor,afe_route,report_voltage
from control import SharedMonitorBus,scan
from dmm import DMM7510


class DAC:
    def __init__(self,uart,records):self.uart,self.records=uart,records
    def command(self,command):
        deadline=time.monotonic()+4
        while True:
            row=capture(self.uart,command,limit=2);self.records.append(row);reply=row['reply'].strip()
            if reply=='ERR BUSY' and time.monotonic()<deadline:time.sleep(.25);continue
            return reply
    def stored(self):
        reply=self.command('@DAC 12 S')
        match=re.fullmatch(r'DAC STORED A/B/C/D=([0-9A-F]{4})/([0-9A-F]{4})/([0-9A-F]{4})/([0-9A-F]{4})',reply)
        if not match:raise OSError(reply)
        return dict(zip('ABCD',(int(v,16) for v in match.groups())))
    def set_code(self,output,value):
        if output not in 'BCD' or type(value) is not int or not 0<=value<=65535:raise ValueError('OnlyB/C/D raw16bit codes permitted')
        reply=self.command(f'@DAC 12 W {output} {value:04X}')
        if reply!=f'DAC SENT {output} {value:04X}':raise OSError(reply)


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--out',type=Path,required=True);p.add_argument('--dmm-host',required=True)
    a=p.parse_args();out=a.out.resolve();out.mkdir(parents=True,exist_ok=False)
    report=dict(pass_=False,points_per_dac=65,adc_clock_dac_A='UNCHANGED; phase measurement deferred',scope='B/C/D functional transfer, not exhaustive16bit INL/DNL',records=[],measurements=[],curves={},restoration={})
    uart=None;bus=None;dac=None;original=None;monitor=None;locks=[]
    targets={'B':3,'C':0,'D':1};codes=[round(i*65535/64) for i in range(65)]
    def save():(out/'report.json').write_text(json.dumps(report,indent=2)+'\n')
    try:
        for name in sorted(['atmel-ice-J41800043065','pm12-210249A73E43','dmm7510-04679690']):
            lock=open('/home/codex-hil/.cache/'+name+'.lock','a+');fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB);locks.append(lock)
        uart=serial.Serial(port=None,baudrate=115200,timeout=.03,write_timeout=1,rtscts=True,exclusive=True);uart.dtr=False;uart.rts=True;uart.port=PORT;uart.open();uart.read(4096)
        report['power_ready']=wait_power_good(uart,capture);report['identity']=capture(uart,'RS');assert 'Board S/N: 1803' in report['identity']['reply']
        report['power_recheck']=require_power_good(uart,capture)
        dac=DAC(uart,report['records']);original=dac.stored();report['original_stored_codes']=original;save()
        bus=ConsoleI2C(uart,capture)
        with bus.routed(*afe_route(12)):
            gpio=MCP23017Monitor(Registers(bus));monitor=SharedMonitorBus({'12':gpio.initialize_monitor()})
            try:
                with Transport(dict(kind='tcp',host=a.dmm_host,port=5025,timeout=5)) as io:
                    meter=DMM7510(io);terminal=io.query(':ROUT:TERM?').strip().upper()
                    with (out/'samples.csv').open('w',newline='') as f:
                        columns=['stage','dac','code','board','mux_channel','sample','signal','volts_at_mux','volts','divider_scale'];writer=csv.DictWriter(f,fieldnames=columns);writer.writeheader();f.flush()
                        def emit(stage,output,code,row):
                            row={**row,**report_voltage(row['mux_channel'],row['volts']),**dict(stage=stage,dac=output,code=code)}
                            report['measurements'].append(row);writer.writerow(row);f.flush();save()
                        def endpoints(stage,output,code):
                            monitor.off_all();report.setdefault('dmm_settings',[]).append(meter.configure(terminal,voltage_range=10,nplc=5))
                            scan(monitor,meter,'12',range(8),lambda row:emit(stage,output,code,row),settle_s=.1,repeats=1)
                        endpoints('baseline','',None)
                        try:
                            for output,channel in targets.items():
                                require_power_good(uart,capture);monitor.off_all();dac.set_code(output,0);time.sleep(.1)
                                endpoints('endpoint-min',output,0)
                                monitor.off_all();report['dmm_settings'].append(meter.configure(terminal,voltage_range=1,nplc=5))
                                with monitor.selected('12',channel):
                                    for index,code in enumerate(codes):
                                        dac.set_code(output,code);time.sleep(.1)
                                        for sample in range(3):emit('curve',output,code,dict(board='12',mux_channel=channel,sample=sample,volts=meter.read_dcv()))
                                        if index%16==0:print(f'{output}: {index+1}/65 code={code}',flush=True)
                                endpoints('endpoint-max',output,65535)
                                dac.set_code(output,original[output]);monitor.off_all()
                        finally:
                            # Attempt ALL restores even if one serial transfer fails.
                            errors=[]
                            try:monitor.off_all()
                            except BaseException as error:errors.append(('monitor',repr(error)))
                            for output in targets:
                                try:dac.set_code(output,original[output]);report['restoration'][output]='sent original stored code'
                                except BaseException as error:errors.append((output,repr(error)))
                            if errors:raise RuntimeError('DAC restoration failure: '+repr(errors))
                        endpoints('restored','',None)
                        baseline={r['signal']:r['volts'] for r in report['measurements'] if r['stage']=='baseline'}
                        restored={r['signal']:r['volts'] for r in report['measurements'] if r['stage']=='restored'}
                        report['restored_voltage_deltas']={name:restored[name]-value for name,value in baseline.items()}
                        assert all(abs(delta)<(.02 if name in ('N5V5_PM12','P5V5_PM12') else .001) for name,delta in report['restored_voltage_deltas'].items()),'Voltages failed to return near baseline'
            finally:
                monitor.off_all();report['monitor_final_latch']=gpio.read_latch();assert report['monitor_final_latch']&8
        report['tca_final']={f'{addr:02X}':bus.mux(addr) for addr in (0x70,0x71)}
        for output in targets:
            rows=[r for r in report['measurements'] if r['stage']=='curve' and r['dac']==output]
            means=[statistics.mean(r['volts'] for r in rows if r['code']==code) for code in codes]
            fit=statistics.linear_regression(codes,means);residual=[v-(fit.intercept+fit.slope*c) for c,v in zip(codes,means)]
            expected_slope={'B':-2.048/65536*100/5100,'C':-2.048/65536*100/10000,'D':2.048/65536*5100/9800}[output]
            monotonic=all((b-a)*expected_slope>=0 for a,b in zip(means,means[1:]))
            report['curves'][output]=dict(expected_slope_volts_per_code=expected_slope,gain_error_percent=(fit.slope/expected_slope-1)*100,monotonic_expected_direction=monotonic,signal=rows[0]['signal'],codes=codes,volts=means,min_code_voltage=means[0],max_code_voltage=means[-1],slope_volts_per_code=fit.slope,intercept_volts=fit.intercept,max_abs_fit_residual_volts=max(map(abs,residual)),monotonic_up=all(b>=a for a,b in zip(means,means[1:])),residual_volts=residual)
        report['pass_']=all(row['monotonic_expected_direction'] for row in report['curves'].values());save()
    except BaseException as error:report['error']=repr(error);raise
    finally:
        if bus is not None:report['i2c_records']=bus.records
        if uart is not None:
            uart.rts=False;uart.dtr=False;uart.close()
        save()
    print(json.dumps(report['curves'],indent=2))
    if not report['pass_']:raise SystemExit(1)

if __name__=='__main__':main()
