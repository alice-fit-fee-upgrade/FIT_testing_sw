"""DCV adapter using the existing labinstruments transport/model driver.

Commands verified against local DMM7510 reference manual, section11.
No instrument reset or language-switch command. Own the shared DMM lease.
"""
import math
from labinstruments.drivers import Driver


class DMM7510:
    def __init__(self,transport,serial='04679690'):
        self.io=transport
        self.driver=Driver(transport,'dmm7510',serial=serial)
        self.configured=False

    def configure(self,terminals,voltage_range=10,nplc=5):
        self.configured=False
        if terminals not in ('FRON','REAR'):raise ValueError('Physical terminals must be explicit')
        if voltage_range not in (.1,1,10) or not math.isfinite(nplc) or not .01<=nplc<=10:raise ValueError('Invalid high-impedance DCV settings')
        identity=self.driver.identify()
        if self.io.query(':ROUT:TERM?').strip().upper() not in (terminals,terminals+'T' if terminals=='FRON' else terminals):
            raise RuntimeError('DMM terminal selector does not match wiring')
        for command in [':ABOR',':SENS:FUNC "VOLT:DC"',':SENS:VOLT:DC:RANG:AUTO OFF',
                        f':SENS:VOLT:DC:RANG {voltage_range}',f':SENS:VOLT:DC:NPLC {nplc}',
                        ':SENS:VOLT:DC:INP AUTO',':SENS:VOLT:DC:AZER ON',
                        ':SENS:VOLT:DC:AVER:STAT OFF',':SENS:COUN 1']:
            self.io.write(command)
        actual={key:self.io.query(query).strip() for key,query in dict(function=':SENS:FUNC?',range=':SENS:VOLT:DC:RANG?',nplc=':SENS:VOLT:DC:NPLC?',impedance=':SENS:VOLT:DC:INP?',autozero=':SENS:VOLT:DC:AZER?',filter=':SENS:VOLT:DC:AVER:STAT?',autorange=':SENS:VOLT:DC:RANG:AUTO?').items()}
        if actual['function'].strip('"').upper() not in ('VOLT','VOLT:DC'):raise RuntimeError(actual)
        if not math.isclose(float(actual['range']),voltage_range) or not math.isclose(float(actual['nplc']),nplc):raise RuntimeError(actual)
        if actual['impedance'].upper()!='AUTO' or actual['autozero'].upper() not in ('1','ON') or actual['filter'].upper() not in ('0','OFF') or actual['autorange'].upper() not in ('0','OFF'):raise RuntimeError(actual)
        error=self.io.query(':SYST:ERR?')
        if int(error.split(',')[0])!=0:raise RuntimeError('DMM SCPI error: '+error)
        self.configured=True
        return dict(identity=identity,terminals=terminals,settings=actual)

    def read_dcv(self):
        if not self.configured:raise RuntimeError('Explicit DCV configuration/readback required')
        if self.io.query(':SENS:FUNC?').strip().strip(chr(34)).upper() not in ('VOLT','VOLT:DC'):
            raise RuntimeError('DMM function changed during acquisition')
        value=float(self.io.query(':READ?'))
        if not math.isfinite(value) or abs(value)>1e30:raise ValueError('DMM overrange/invalid result')
        return value
