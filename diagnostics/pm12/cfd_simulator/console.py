"""Bounded UART frontend for generic @I2C transactions on PM12 diagnostic firmware."""
import re,time
from contextlib import contextmanager


class ConsoleI2C:
    def __init__(self,serial,capture):self.serial,self.capture=serial,capture;self.records=[]

    def transaction(self,address,tx=(),count=0):
        tx=tuple(tx)
        if type(address) is not int or not 8<=address<=0x77 or len(tx)>8 or not 0<=count<=8 or not(tx or count) or any(type(b) is not int or not 0<=b<=255 for b in tx):raise ValueError('Invalid I2C transaction')
        data=' '.join(f'{b:02X}' for b in tx)
        if tx and count:command=f'@I2C WR {address:02X} {count:02X} {data}'
        elif tx:command=f'@I2C W {address:02X} {data}'
        else:command=f'@I2C R {address:02X} {count:02X}'
        deadline=time.monotonic()+4
        while True:
            row=self.capture(self.serial,command,limit=2);self.records.append(row)
            reply=row['reply'].strip()
            if reply=='ERR I2C BUSY' and time.monotonic()<deadline:time.sleep(.25);continue
            expected=f'I2C ADDR={address:02X} TX='+''.join(f'{b:02X}' for b in tx)+' RX='
            if not reply.startswith(expected):raise OSError(reply or 'Empty UART I2C response')
            result=bytes.fromhex(reply[len(expected):])
            if len(result)!=count:raise OSError('Short I2C read')
            return result

    def mux(self,address,value=None):
        if value is not None:self.transaction(address,[value])
        actual=self.transaction(address,count=1)[0]
        if value is not None and value!=actual:raise OSError('TCA mask readback mismatch')
        return actual

    @contextmanager
    def routed(self,address,mask):
        if address not in (0x70,0x71) or mask not in [1<<i for i in range(8)]:raise ValueError('Single TCA branch required')
        saved={}
        try:
            for a in (0x70,0x71):saved[a]=self.mux(a)
            for a in (0x70,0x71):self.mux(a,0)
            self.mux(address,mask)
            yield
        finally:
            errors=[]
            # Disconnect both before restoring a possibly shared previous state.
            for a in saved:
                try:self.mux(a,0)
                except BaseException as e:errors.append((a,e))
            for a,value in saved.items():
                try:self.mux(a,value)
                except BaseException as e:errors.append((a,e))
            if errors:raise RuntimeError('TCA restoration failure: '+repr(errors))


class Registers:
    def __init__(self,bus,address=0x20):self.bus,self.address=bus,address
    def read(self,reg):return self.bus.transaction(self.address,[reg],1)[0]
    def write(self,reg,value):self.bus.transaction(self.address,[reg,value])
