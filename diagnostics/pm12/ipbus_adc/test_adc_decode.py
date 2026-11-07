import unittest
from adc_decode import decode


def clock():return [100|(((i//2)&1)<<13) for i in range(4096)]

class Decode(unittest.TestCase):
    def test_client_can_be_loaded_by_path_without_sys_path_setup(self):
        import subprocess,sys,tempfile
        from pathlib import Path
        path=Path(__file__).with_name('client.py').resolve()
        code="import importlib.util;s=importlib.util.spec_from_file_location('isolated_client',"+repr(str(path))+");m=importlib.util.module_from_spec(s);s.loader.exec_module(m)"
        with tempfile.TemporaryDirectory() as d:
            result=subprocess.run([sys.executable,'-c',code],cwd=d,capture_output=True,text=True)
        self.assertEqual(result.returncode,0,result.stderr)

    def test_original_rejected_hardware_buffers(self):
        from pathlib import Path
        import struct
        fixtures=Path(__file__).with_name('fixtures')
        for name,expected in [('str-quantized-first.bin',{3:6,4:1011,5:6}),('str-quantized-repeat.bin',{3:12,4:1000,5:11})]:
            words=list(struct.unpack('<4096H',(fixtures/name).read_bytes()))
            samples,timing=decode(words,0)
            self.assertEqual(timing['interval_counts'],expected)
            self.assertEqual(timing['status'],'EDGE_QUANTIZED')
            self.assertTrue(timing['selected_words_stable'])
            self.assertEqual(len(samples),1023)
            with self.assertRaisesRegex(ValueError,'Strict'):decode(words,0,strict_edges=True)

    def test_aligned(self):
        x,t=decode(clock(),0);self.assertEqual(t['status'],'ALIGNED');self.assertEqual(x,[100]*1023)
    def test_one_bin_uncertainty_is_bounded_not_cumulative(self):
        w=clock();w[6]&=~8192
        x,t=decode(w,0);self.assertEqual(t['status'],'EDGE_QUANTIZED');self.assertEqual(t['rising_phase_span_samples'],1)
        self.assertEqual(t['interval_counts'][3],1);self.assertEqual(t['interval_counts'][5],1)
        with self.assertRaisesRegex(ValueError,'Strict'):decode(w,0,strict_edges=True)
    def test_missing_pulse_rejected(self):
        w=clock();w[6]&=~8192;w[7]&=~8192
        with self.assertRaises(ValueError):decode(w)
    def test_accumulating_drift_rejected(self):
        w=[100|(((i//2)%3==1)<<13) for i in range(4096)]
        with self.assertRaises(ValueError):decode(w)
    def test_small_intervals_with_two_bin_cumulative_wander_rejected(self):
        w=[100]*4096
        for n in range(1024):
            delay=1 if 100<=n<200 or 300<=n<400 else (2 if 200<=n<300 else 0)
            edge=2+4*n+delay
            for i in (edge,edge+1):
                if i<len(w):w[i]|=8192
        with self.assertRaisesRegex(ValueError,'cumulative'):decode(w)

    def test_unstable_selected_adc_word_rejected(self):
        w=clock();w[5]=101|(w[5]&8192)
        with self.assertRaisesRegex(ValueError,'two-sample'):decode(w)
    def test_tags_reserved_bits_and_truncation_rejected(self):
        for w in [clock()[:-1],[x|0x4000 for x in clock()],[x|0x1000 for x in clock()]]:
            with self.assertRaises(ValueError):decode(w,0)

if __name__=='__main__':unittest.main()
