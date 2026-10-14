"""Regressions for the concrete ISE/Vivado incompatibilities found on PM12."""
import unittest
from svf_to_tcl import convert
class Conversion(unittest.TestCase):
 def test_mixed_physical_and_scoped(self):
  # HIR remains declared when iMPACT emits an already combined SIR102.
  source='HIR 94 TDI (3fffffffffffffffffffffff); HDR 12 TDI (000); SIR 8 TDI (01); SDR 32 TDI (0) TDO (f6d8f093) MASK (0fff8fff); ENDIR IRPAUSE; SIR 102 TDI (3abfffffffffffffffffffffff); SDR 771 TDI (123000);'
  s,n=convert(source)
  self.assertIn('scan_ir_hw_jtag 102 -tdi 3abfffffffffffffffffffffff',s)
  self.assertIn('scan_dr_hw_jtag 771 -tdi 123000',s)
  self.assertIn('-tdo 6d88093000 -mask fff8fff000',s)
  self.assertIn('set_property ENDSTATE_IR IRPAUSE',s)
  self.assertEqual(n,4)
 def test_capture_update_has_stable_pause(self):
  s,_=convert('STATE IREXIT2 IRUPDATE DRSELECT DRCAPTURE DREXIT1 DRUPDATE IDLE;')
  self.assertEqual(s,'run_state_hw_jtag -state {IREXIT2 IRUPDATE DRSELECT DRCAPTURE DREXIT1 DRPAUSE} DRPAUSE\nrun_state_hw_jtag -state {DREXIT2 DRUPDATE IDLE} IDLE\n')
 def test_refuses_wrong_chain_or_opcode(self):
  for source in ['SIR 8 TDI (ea);','HIR 94 TDI (3fffffffffffffffffffffff); SIR 8 TDI (11);']:
   with self.assertRaises(AssertionError):convert(source)
if __name__=='__main__':unittest.main()
