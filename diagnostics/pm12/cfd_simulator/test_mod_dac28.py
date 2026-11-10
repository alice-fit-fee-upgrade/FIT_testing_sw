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

class TestPairRouting(unittest.TestCase):
 def test_all_pairs_use_named_entities_and_do_not_touch_other_channels(self):
  from mod_dac28 import WORDS
  for a in range(8):
   for b in range(8):
    if a==b:continue
    d=object.__new__(DAC);d.channels=(a,b);calls=[];d.send=calls.append
    def query(command):
     if command=='SYST:ERR?':return '0,"No error"'
     return '1.2' if command=='SOUR:'+WORDS[a]+':VOLT?' else '.8'
    d.query=query;d.pair(1.2,.8)
    self.assertEqual(calls,[f'SOUR:{WORDS[a]}:VOLT 1.2000',f'SOUR:{WORDS[b]}:VOLT 0.8000'])
 def test_invalid_pair_rejected_before_connection(self):
  from unittest.mock import patch
  with patch.object(DAC,'connect',side_effect=AssertionError('must not connect')):
   for pair in [(0,0),(-1,1),(0,8),(True,1),(0,)]:
    with self.subTest(pair=pair),self.assertRaises(ValueError):DAC(None,channels=pair)
