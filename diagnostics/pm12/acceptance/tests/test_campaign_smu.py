"""Synthetic transfer fixtures only; no instruments."""
import sys,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from campaign_smu_adapter import analyze_curve,EXPECTED_SPAN

class SMUAdapter(unittest.TestCase):
    def curve(self,dac,scale=1):
        return [dict(code=round(i*65535/100),sample=r,volts=1+EXPECTED_SPAN[dac]*scale*round(i*65535/100)/65536,instrument_time=.1,status=1729) for i in range(101) for r in range(3)]
    def test_both_transfer_directions_and_missing_points(self):
        for dac in 'BCD':
            self.assertTrue(analyze_curve(self.curve(dac),dac)['pass_'])
            for scale in (0,-1,1.2):self.assertFalse(analyze_curve(self.curve(dac,scale),dac)['pass_'])
            with self.assertRaises(ValueError):analyze_curve(self.curve(dac)[:-1],dac)
    def test_local_reversal_and_bad_sample_status(self):
        rows=self.curve('B');rows[150]['volts']+=.02
        self.assertFalse(analyze_curve(rows,'B')['pass_'])
        rows=self.curve('D');rows[0]['status']=0
        with self.assertRaises(ValueError):analyze_curve(rows,'D')
if __name__=='__main__':unittest.main()
