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

class ConsoleTransactionTests(unittest.TestCase):
    def test_routing_restored_after_target_nack(self):
        from console import ConsoleI2C
        masks={0x70:2,0x71:4};sent=[]
        def capture(serial,command,limit):
            sent.append(command);parts=command.split();op=parts[1];addr=int(parts[2],16)
            if addr==0x20:return dict(command=command,reply='ERR I2C NACK\r\n')
            if op=='W':
                masks[addr]=int(parts[3],16);reply=f'I2C ADDR={addr:02X} TX={parts[3]} RX='
            else:reply=f'I2C ADDR={addr:02X} TX= RX={masks[addr]:02X}'
            return dict(command=command,reply=reply+'\r\n')
        bus=ConsoleI2C(None,capture)
        with self.assertRaises(OSError):
            with bus.routed(0x71,8):bus.transaction(0x20,[0x14],1)
        self.assertEqual(masks,{0x70:2,0x71:4})
        self.assertIn('@I2C WR 20 01 14',sent)
        with self.assertRaises(ValueError):bus.transaction(0,[0])

class ReportingTests(unittest.TestCase):
    def test_supply_dividers_are_reported_as_physical_rails(self):
        from mcp23017 import report_voltage
        for channel,raw,name in [(5,-3.4,'N5V5_PM12'),(7,3.4,'P5V5_PM12')]:
            row=report_voltage(channel,raw)
            self.assertEqual(row['signal'],name);self.assertEqual(row['volts_at_mux'],raw)
            self.assertAlmostEqual(row['volts'],raw*53/33)
        self.assertEqual(report_voltage(0,1.024)['volts'],1.024)
