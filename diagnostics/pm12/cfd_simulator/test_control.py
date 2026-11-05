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
