"""Synthetic monitor reference vectors, not hardware evidence."""
import sys,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from campaign_monitor_adapter import voltage_checks
class Monitors(unittest.TestCase):
 def test_nominal_and_rejects_stuck_wrong_divider_and_similar_input_swaps(self):
  good=[1.034,.005,1.024,1.044,1.536,-5.5,1.3,5.5];self.assertTrue(all(voltage_checks(good)))
  self.assertFalse(all(voltage_checks([1.024]*8)))
  for a,b in [(0,2),(0,3),(5,7)]:
   bad=good.copy();bad[a],bad[b]=bad[b],bad[a];self.assertFalse(all(voltage_checks(bad)))
  bad=good.copy();bad[5]*=33/53;self.assertFalse(all(voltage_checks(bad)))
if __name__=='__main__':unittest.main()
