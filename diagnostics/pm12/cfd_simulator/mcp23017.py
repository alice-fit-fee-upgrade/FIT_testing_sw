"""Schematic-specific monitor adapter. regs.read/write are routed byte operations.

No raw bus/console proxy is assumed. The transport must exclusively select one
AFE branch and restore both upstream TCA9548 masks even on transaction failure.
"""
from control import MonitorMux,MuxPins

MONITOR_PINS=MuxPins((2,1,0),3)
MONITOR_NAMES=('CFD_OFFSET','CFD_CMP_OFFSET','BUFFER_OFFSET','DRV_OFFSET',
               'DRV_VOCM','N5V5_PM12_DIV','P1V3','P5V5_PM12_DIV')
ADDRESS=0x20


def afe_route(channel):
    if type(channel) is not int or not 1<=channel<=12:raise ValueError('Physical AFE channel1..12 required')
    return (0x70,1<<(channel-1)) if channel<=8 else (0x71,1<<(channel-9))


class MCP23017Monitor:
    def __init__(self,regs):
        self.regs=regs;self.initialized=False

    def _write_checked(self,reg,value):
        self.regs.write(reg,value)
        if self.regs.read(reg)!=value:raise OSError('MCP register readback mismatch')

    def initialize_monitor(self):
        self.initialized=False
        # BANK0 register map; independent byte transactions support SEQOP=0/1.
        a,b=self.regs.read(0x0a),self.regs.read(0x0b)
        if a!=b or a&0x80:raise RuntimeError('MCP BANK0 not established')
        direction=self.regs.read(0x00)
        original=self.regs.read(0x14)
        # Preload INH HIGH before changing directions; readback must succeed.
        # A BANK1 device aliases0x14 to an unimplemented register and fails this
        # check before the direction register can be modified.
        self._write_checked(0x14,original|8)
        self._write_checked(0x00,direction&0xf0)
        self.initialized=True
        return MonitorMux(self,MONITOR_PINS)

    def read_latch(self):
        if not self.initialized:raise RuntimeError('Initialize inhibited monitor first')
        return self.regs.read(0x14)|(self.regs.read(0x15)<<8)

    def write_latch(self,value):
        old=self.read_latch()
        if type(value) is not int or not 0<=value<=65535 or (old^value)&~0xf:
            raise ValueError('Monitor cannot modify integrator, ADC mux, range or strobe pins')
        self._write_checked(0x14,value&255)
