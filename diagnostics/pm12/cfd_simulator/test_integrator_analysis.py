import unittest
from integrator_analysis import integration_pair

class Integration(unittest.TestCase):
    def test_capture_phase_does_not_change_sign(self):
        for change in [-10,0,10]:
            template=[250,250+change,80,70]
            for rotation in range(4):
                x=(template*100)[rotation:rotation+396]
                r=integration_pair(x)
                self.assertEqual(r['mean_change'],change)
                self.assertEqual(r['mean_reset_change'],-10)
    def test_clipping_and_flat_trace_are_not_balance(self):
        for x in [[0]*100,[4095]*100,[100]*100,[250,float('nan'),80,70]*25]:
            with self.assertRaises(ValueError):integration_pair(x)

if __name__=='__main__':unittest.main()
