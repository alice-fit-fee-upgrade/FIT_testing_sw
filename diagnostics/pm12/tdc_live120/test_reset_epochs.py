"""Regression: SYS reset must clear event-domain capture acknowledgements too."""
import unittest
from migen import *
from migen.sim import run_simulation
from buffers import TdcBuffers

class Tests(unittest.TestCase):
    def run_case(self,reset_all):
        dut=Module()
        for name in ['sys','tdc1','tdc2']:
            setattr(dut.clock_domains,'cd_'+name,ClockDomain(name))
        dut.submodules.buffers=b=TdcBuffers(depth=8,domains=['tdc1','tdc2'])
        if reset_all:
            # Model simultaneous assertion; hardware uses per-domain async
            # assertion/synchronous release (AsyncResetSynchronizer).
            dut.comb += [dut.cd_tdc1.rst.eq(dut.cd_sys.rst),dut.cd_tdc2.rst.eq(dut.cd_sys.rst)]
        def bench():
            for _ in range(20):yield
            self.assertTrue((yield b.ready))
            yield b.arm.eq(1);yield;yield b.arm.eq(0)
            for _ in range(40):
                yield
                if (yield b.started):break
            else:self.fail('no STARTED')
            yield b.stop.eq(1);yield;yield b.stop.eq(0)
            for _ in range(40):
                yield
                if (yield b.valid):break
            else:self.fail('no completed capture')
            self.assertEqual((yield b.capture_id),1)
            yield dut.cd_sys.rst.eq(1)
            for _ in range(5):yield
            yield dut.cd_sys.rst.eq(0)
            for _ in range(30):yield
            self.assertFalse((yield b.valid))
            self.assertEqual((yield b.capture_id),0)
            self.assertEqual(bool((yield b.ready)),reset_all)
            if reset_all:
                yield b.arm.eq(1);yield;yield b.arm.eq(0)
                for _ in range(40):
                    yield
                    if (yield b.started):break
                else:self.fail('cannot rearm after reset')
        run_simulation(dut,bench(),clocks={'sys':10,'tdc1':7,'tdc2':11})
    def test_partial_reset_reproduces_stuck_ready(self):self.run_case(False)
    def test_all_domains_reset_allows_rearm(self):self.run_case(True)

if __name__=='__main__':unittest.main()
