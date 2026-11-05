import unittest
from control import MonitorMux,MuxPins,SharedMonitorBus,scan,sweep_dac

class GPIO:
    def __init__(self):self.latch=0x8000;self.writes=[]
    def read_latch(self):return self.latch
    def write_latch(self,value):self.writes.append(value);self.latch=value

class Meter:
    def read_dcv(self):return 1.024

class SafetyTests(unittest.TestCase):
    def setUp(self):
        self.a,self.b=GPIO(),GPIO()
        self.bus=SharedMonitorBus({'12':MonitorMux(self.a,MuxPins((0,1,2),3)),'other':MonitorMux(self.b,MuxPins((0,1,2),3))})
    def test_break_before_make_and_preserved_controls(self):
        with self.bus.selected('12',5):
            self.assertEqual(self.a.latch,0x8005);self.assertEqual(self.b.latch,0x8008)
            self.assertEqual(self.a.writes[-3:],[0x8008,0x800d,0x8005])
        self.assertEqual(self.a.latch,0x800d);self.assertEqual(self.b.latch,0x8008)
    def test_all_eight_channels_and_off_after_exception(self):
        rows=[];scan(self.bus,Meter(),'12',range(8),rows.append,settle_s=0,repeats=1)
        self.assertEqual([r['mux_channel'] for r in rows],list(range(8)))
        class FailedMeter:
            def read_dcv(self):raise TimeoutError('DMM disconnected')
        with self.assertRaises(TimeoutError):scan(self.bus,FailedMeter(),'12',[0],rows.append,settle_s=0)
        self.assertTrue(self.a.latch&8 and self.b.latch&8)
    def test_isolation_failure_attempts_other_boards(self):
        self.a.write_latch=lambda value:(_ for _ in ()).throw(OSError('I2C NACK'))
        with self.assertRaises(RuntimeError):self.bus.off_all()
        self.assertTrue(self.b.latch&8)
    def test_dac_restored_after_dmm_failure(self):
        class DAC:
            value=123
            def snapshot(self):return self.value
            def set_code(self,code):self.value=code
            def restore(self,value):self.value=value
        dac=DAC()
        def failed_emit(row):raise OSError('disk full')
        with self.assertRaises(OSError):sweep_dac(self.bus,Meter(),dac,'12',[0],[0,65535],failed_emit,settle_s=0)
        self.assertEqual(dac.value,123);self.assertTrue(self.a.latch&8 and self.b.latch&8)
    def test_no_write_before_restorable_dac_state(self):
        class DAC:
            writes=0
            def snapshot(self):raise RuntimeError('No original DAC code known')
            def set_code(self,code):self.writes+=1
        dac=DAC()
        with self.assertRaises(RuntimeError):sweep_dac(self.bus,Meter(),dac,'12',[0],[0],lambda row:None)
        self.assertEqual(dac.writes,0)

if __name__=='__main__':unittest.main()

class SchematicMapTests(unittest.TestCase):
    def test_reversed_address_bits_and_preserved_analog_controls(self):
        from mcp23017 import MCP23017Monitor,afe_route
        class Regs:
            def __init__(self):self.r={0x0a:0,0x0b:0,0:0xff,0x14:0xa0,0x15:0xe0};self.w=[]
            def read(self,r):return self.r[r]
            def write(self,r,v):self.w.append((r,v));self.r[r]=v
        regs=Regs();gpio=MCP23017Monitor(regs);mux=gpio.initialize_monitor()
        self.assertEqual(regs.w[:2],[(0x14,0xa8),(0,0xf0)])
        for channel in range(8):
            mux.select(channel)
            expected=((channel&1)<<2)|(channel&2)|((channel>>2)&1)
            self.assertEqual(regs.r[0x14],0xa0|expected)
        self.assertEqual(regs.r[0x15],0xe0)
        with self.assertRaises(ValueError):gpio.write_latch(gpio.read_latch()^0x80)
        self.assertEqual(afe_route(12),(0x71,8))
    def test_bad_bank_or_inhibit_readback_cannot_enable_outputs(self):
        from mcp23017 import MCP23017Monitor
        class Regs:
            def __init__(self,bank):self.bank=bank;self.w=[]
            def read(self,r):return self.bank if r in (0xa,0xb) else 0
            def write(self,r,v):self.w.append((r,v))
        for bank in [0,128]:
            regs=Regs(bank)
            with self.assertRaises((RuntimeError,OSError)):MCP23017Monitor(regs).initialize_monitor()
            self.assertFalse(any(r==0 for r,v in regs.w))
