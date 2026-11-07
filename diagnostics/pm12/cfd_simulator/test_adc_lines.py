import unittest
from collections import Counter
from adc_line_test import analyze


def sweep(transform=lambda x:x):
    return [dict(diff_setpoint_v=-1.2+2.4*start/4032,histogram=dict(Counter(transform(x) for x in range(start,start+64) for _ in range(4)))) for start in range(0,4096,64)]

class Tests(unittest.TestCase):
    def test_healthy_ramp_exercises_every_adjacent_state(self):
        result=analyze(sweep())
        self.assertTrue(result['pass_']);self.assertEqual(result['visited_codes'],4096)
        self.assertTrue(all(p['status']=='PASS' for p in result['adjacent_pairs']))
    def test_each_adjacent_hard_bridge_is_found(self):
        for bit in range(11):
            for dominant in [bit,bit+1]:
                def bridge(x):
                    value=(x>>dominant)&1
                    return (x&~(3<<bit))|(3*value<<bit)
                result=analyze(sweep(bridge))
                self.assertFalse(result['pass_'])
                self.assertEqual(result['adjacent_pairs'][bit]['status'],'SUSPECT_EQUAL_NEIGHBORS')
    def test_stuck_bits_detected_even_when_rails_are_reached(self):
        for bit in range(12):
            for value in [0,1]:
                result=analyze(sweep(lambda x:(x&~(1<<bit))|(value<<bit)))
                self.assertFalse(result['pass_'])
                self.assertEqual(result['bits'][bit]['status'],'SUSPECT_STUCK_BIT')
    def test_rare_glitches_do_not_clear_a_nearly_tied_pair(self):
        def intermittent(x):
            if x%31==0:return x
            return (x&~3)|(3*((x>>1)&1))
        result=analyze(sweep(intermittent),min_per_setting=1)
        self.assertFalse(result['pass_'])
        self.assertEqual(result['adjacent_pairs'][0]['status'],'SUSPECT_NEAR_EQUAL_NEIGHBORS')
    def test_rails_or_one_setting_cannot_pass(self):
        result=analyze([dict(diff_setpoint_v=i,histogram={'0':1000,'4095':1000}) for i in range(20)])
        self.assertFalse(result['pass_']);self.assertFalse(result['stimulus_adequate'])
        points=sweep()
        for p in points:p['diff_setpoint_v']=0
        self.assertFalse(analyze(points)['pass_'])
    def test_missing_codes_alone_are_not_a_short(self):
        points=sweep(lambda x:x if x!=123 else 124)
        result=analyze(points)
        self.assertTrue(result['pass_']);self.assertIn(123,result['missing_codes'])

if __name__=='__main__':unittest.main()
