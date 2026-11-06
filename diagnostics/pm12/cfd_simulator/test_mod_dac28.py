import unittest
from mod_dac28 import DAC,voltage
class TestLimits(unittest.TestCase):
 def test_valid_endpoints(self):
  for v in [0,1,1.5,3.3]:self.assertEqual(voltage(v),v)
 def test_invalid_levels(self):
  for v in [-.0001,3.3001,5,float('nan'),float('inf'),True]:
   with self.subTest(v=v),self.assertRaises(ValueError):voltage(v)
 def test_second_leg_checked_before_first_write(self):
  d=object.__new__(DAC);calls=[];d.send=lambda c:calls.append(c)
  with self.assertRaises(ValueError):d.pair(1,5)
  self.assertEqual(calls,[])
