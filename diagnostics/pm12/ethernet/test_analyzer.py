"""Regression checks against physical PM12 measurements, including counter wrap."""
import copy
import json
from pathlib import Path
import unittest
from analyze import analyze

class PhysicalEvidenceTests(unittest.TestCase):
 def setUp(self):
  self.samples=json.loads(Path(__file__).with_name('validation-2026-10-13.json').read_text())['samples']
 def test_measured_windows_and_wrap_pass(self):
  self.assertEqual(analyze(self.samples)['status'],'PASS')
 def test_new_frame_error_fails(self):
  s=copy.deepcopy(self.samples); next(x for x in s if x['name']=='MAC_B')['badframes']+=1
  self.assertFalse(analyze(s)['checks']['initial_mac'])
 def test_new_prbs_error_fails(self):
  s=copy.deepcopy(self.samples); next(x for x in s if x['name']=='PRBS_B')['prbs_error_samples']+=1
  self.assertFalse(analyze(s)['checks']['prbs'])
 def test_inactive_negative_control_fails(self):
  s=copy.deepcopy(self.samples)
  next(x for x in s if x['name']=='MISMATCH')['prbs_error_samples']=next(x for x in s if x['name']=='PRBS_B')['prbs_error_samples']
  self.assertFalse(analyze(s)['checks']['prbs_negative_control'])
 def test_wrong_reference_clock_fails(self):
  s=copy.deepcopy(self.samples); a=next(x for x in s if x['name']=='MAC_A'); b=next(x for x in s if x['name']=='MAC_B'); b['refcount']=a['refcount']+100000000
  self.assertFalse(analyze(s)['checks']['initial_mac_clocks'])

if __name__=='__main__': unittest.main()
