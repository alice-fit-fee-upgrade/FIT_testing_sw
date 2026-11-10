"""Optional TDC register window; frontend_ready must include PLL/autophase lock.

Timeout is fail-closed until FPGA reset: never reset only one CDC participant.
"""
from migen import *


class TdcWindow(Module):
    def __init__(self, buffers, timeout=40000000):
        if len(buffers.data) != 12 or len(buffers.address) > 12:
            raise ValueError('IPbus map requires 12 banks, depth <=4096')
        if timeout < 1:
            raise ValueError('positive timeout required')
        self.address = Signal(32)
        self.wdata = Signal(32)
        self.write = Signal()
        self.commit = Signal()
        self.selected = Signal()
        self.error = Signal()
        self.rdata = Signal(32)
        self.frontend_ready = Signal()
        self.frontend_status = Signal(32)
        self.fault = Signal()
        self.valid = Signal()
        self.arm = Signal()
        self.stop = Signal()
        elapsed = Signal(max=timeout + 1)
        pending = Signal()
        arm_ok = buffers.ready & self.frontend_ready & ~self.fault & ~pending
        stop_ok = buffers.started & ~self.fault & ~pending
        command_ok = ((self.wdata == 1) & arm_ok) | ((self.wdata == 2) & stop_ok)
        channel = self.address[12:16]
        index = self.address[:12]
        memory = (self.address >= 0x20000) & (self.address < 0x2c000)
        counts = (self.address >= 0x220) & (self.address < 0x22c)
        control = self.address == 0x200
        known = control | (self.address == 0x201) | (self.address == 0x202) | (self.address == 0x203) | (self.address == 0x204) | (self.address == 0x205) | counts | memory
        self.comb += [
            self.selected.eq(known),
            self.valid.eq(buffers.valid & ~self.fault),
            self.error.eq((self.write & (~control | ~command_ok)) |
                          (~self.write & memory & (~self.valid | (index >= Array(buffers.counts)[channel])))),
            buffers.address.eq(index), buffers.arm.eq(self.arm), buffers.stop.eq(self.stop),
            self.rdata.eq(0),
            Case(self.address, {
                0x201: self.rdata.eq(Cat(self.valid, buffers.busy, buffers.started,
                                        arm_ok, self.frontend_ready, self.fault)),
                0x205: self.rdata.eq(self.frontend_status),
                0x202: self.rdata.eq(buffers.capture_id),
                0x203: self.rdata.eq(1 << len(buffers.address)),
                0x204: self.rdata.eq(len(buffers.data)),
            }),
            If(counts, self.rdata.eq(Mux(self.valid, Array(buffers.counts)[self.address[:4]], 0))),
            If(memory, self.rdata.eq(Array(buffers.data)[channel])),
        ]
        self.sync += [
            self.arm.eq(0), self.stop.eq(0), pending.eq(0),
            If(buffers.busy,
               If(~self.frontend_ready | (elapsed == timeout), self.fault.eq(1))
               .Else(elapsed.eq(elapsed + 1))).Else(elapsed.eq(0)),
            If(self.commit & self.write & self.selected & ~self.error,
               pending.eq(1),
               If(self.wdata == 1, self.arm.eq(1)).Else(self.stop.eq(1))),
        ]
