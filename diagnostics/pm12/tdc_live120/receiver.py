"""12 original TDCCHAN receivers wired directly to their event-clock buffers.

This is a frontend integration component, not a board-level clock generator.
The caller must provide the three original coarse/reference clock subsystems.
"""
from migen import *
from buffers import TdcBuffers
from ipbus import TdcWindow


class TdcAcquisition(Module):
    def __init__(self, depth=4096, timeout=40000000):
        self.submodules.buffers = b = TdcBuffers(depth=depth)
        self.submodules.window = w = TdcWindow(b, timeout=timeout)
        self.cfd = [Signal(name='cfd%d' % i) for i in range(12)]
        self.rstr = [Signal(name='rstr%d' % i) for i in range(12)]
        self.rdata = [Signal(name='rdata%d' % i) for i in range(12)]
        self.clk300 = [Signal(name='clk300_%d' % i) for i in range(3)]
        self.clk600 = [Signal(name='clk600_%d' % i) for i in range(3)]
        self.clk600_90 = [Signal(name='clk600_90_%d' % i) for i in range(3)]
        self.coarse_count = [Signal(4, name='coarse_count%d' % i) for i in range(3)]
        self.bc_time = [Signal(7, name='bc_time%d' % i) for i in range(3)]
        self.receiver_reset = Signal(3)
        # Already synchronized into sys by the board frontend. Must qualify
        # reference/result clock presence, MMCM lock AND autophase completion.
        self.frontend_ready = Signal()
        self.comb += w.frontend_ready.eq(self.frontend_ready)
        for ch in range(12):
            group = ch // 4
            self.specials += Instance('TDCCHAN', name='TDC%d_CH%s' % (group+1, 'ABCD'[ch%4]),
                i_pin_in=self.cfd[ch],
                i_clk300=self.clk300[group], i_clk600=self.clk600[group],
                i_clk600_90=self.clk600_90[group], i_reset=self.receiver_reset[group],
                i_tdcclk=ClockSignal('tdc%d' % (group + 1)),
                i_rstr=self.rstr[ch], i_rdata=self.rdata[ch],
                i_tdc_count=self.coarse_count[group], i_bc_time=self.bc_time[group],
                i_tdc_raw_lock=0, o_tdc_raw=b.raw[ch], o_diag_raw_valid=b.events[ch])
