"""CFD simulator measurement engine; physical pin map/MCU adapter required.

No pin assignment, bus address or DAC route is inferred from assembly artwork.
The supplied GPIO adapter must initialize its directions with muxes inhibited
before use; writes must preserve unrelated integrator/input-selection controls.
"""
from contextlib import contextmanager
from dataclasses import dataclass
import math
import time


@dataclass(frozen=True)
class MuxPins:
    address_bits: tuple
    inhibit_bit: int

    def __post_init__(self):
        pins=(*self.address_bits,self.inhibit_bit)
        if len(self.address_bits)!=3 or len(set(pins))!=4 or any(type(p) is not int or not 0<=p<16 for p in pins):
            raise ValueError('Three distinct address bits and one inhibit bit required')


class MonitorMux:
    """MAX4051 positive-logic inhibit; adapter read/write methods use 16-bit OLAT.

    Call only after the verified board initialization established GPIO outputs.
    Readback proves the latch value, not analog isolation or physical wiring.
    """
    def __init__(self,gpio,pins):
        self.gpio,self.pins=gpio,pins

    def _update(self,mask,value):
        old=self.gpio.read_latch()
        wanted=(old&~mask)|(value&mask)
        self.gpio.write_latch(wanted)
        actual=self.gpio.read_latch()
        if actual!=wanted:raise OSError('GPIO latch readback mismatch')

    def off(self):
        bit=1<<self.pins.inhibit_bit
        self._update(bit,bit)

    def select(self,channel):
        if type(channel) is not int or not 0<=channel<8:raise ValueError('Mux channel must be0..7')
        self.off()  # Break before address change.
        mask=sum(1<<p for p in self.pins.address_bits)
        value=sum(((channel>>i)&1)<<p for i,p in enumerate(self.pins.address_bits))
        try:
            self._update(mask,value)
            self._update(1<<self.pins.inhibit_bit,0)
        except BaseException:
            self.off()
            raise


class SharedMonitorBus:
    """Inventory must contain EVERY simulator connected to the shared DMM wire."""
    def __init__(self,boards):
        if not boards:raise ValueError('Complete simulator inventory required')
        self.boards=dict(boards)

    def off_all(self):
        errors=[]
        for name,mux in self.boards.items():
            try:mux.off()
            except BaseException as error:errors.append((name,error))
        if errors:raise RuntimeError('Mux isolation unconfirmed: '+repr(errors))

    @contextmanager
    def selected(self,board,channel):
        if board not in self.boards:raise ValueError('Unknown simulator')
        try:
            self.off_all()
            self.boards[board].select(channel)
            yield
        finally:self.off_all()


def scan(bus,meter,board,channels,emit,settle_s=.1,repeats=3):
    channels=list(channels)
    if not channels or any(type(ch) is not int or not 0<=ch<8 for ch in channels):raise ValueError('Invalid channels')
    if not math.isfinite(settle_s) or settle_s<0 or type(repeats) is not int or repeats<1:raise ValueError('Invalid acquisition settings')
    try:
        bus.off_all()
        for channel in channels:
            with bus.selected(board,channel):
                time.sleep(settle_s)
                for sample in range(repeats):
                    value=meter.read_dcv()
                    if not math.isfinite(value) or abs(value)>1e30:raise ValueError('Invalid/overrange DMM result')
                    emit(dict(board=board,mux_channel=channel,sample=sample,volts=value))
    finally:bus.off_all()


def sweep_dac(bus,meter,dac,board,channels,codes,emit,**settings):
    """DAC backend must return a restorable state BEFORE any set-code operation.

    Backend provides restore(state), set_code(code). No power/reset commands.
    Acquisition failures still restore the original DAC state and inhibit muxes.
    """
    codes=list(codes)
    if not codes or any(type(c) is not int or not 0<=c<=65535 for c in codes):raise ValueError('Invalid16-bit DAC codes')
    state=None;have_state=False
    try:
        bus.off_all()
        state=dac.snapshot();have_state=True
        for code in codes:
            bus.off_all();dac.set_code(code)
            scan(bus,meter,board,channels,lambda row:emit(dict(row,dac_code=code)),**settings)
    finally:
        try:bus.off_all()
        finally:
            if have_state:
                try:dac.restore(state)
                finally:bus.off_all()
