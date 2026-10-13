"""Check verdicts against reduced, measured PM12 JTAG logs (not simulation)."""
import gzip
from pathlib import Path
import sys
import unittest
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from test_board import analyze

FIXTURES = Path(__file__).parent / 'fixtures'

class Reports(unittest.TestCase):
    def read(self, name):
        return gzip.decompress((FIXTURES / (name + '.log.gz')).read_bytes()).decode()

    def test_measured_gateware_pass(self):
        report = analyze(self.read('gateware-pass'))
        self.assertTrue(report['passed'])
        self.assertEqual(report['matched'], 168)

    def test_measured_boundary_pass(self):
        self.assertTrue(analyze(self.read('boundary-pass'), boundary=True)['passed'])

    def test_real_backend_fault_is_not_reported_as_success(self):
        report = analyze(self.read('gateware-failure-26-inputs'))
        self.assertFalse(report['passed'])
        self.assertEqual(report['matched'], 142)

    def test_truncated_log_is_rejected(self):
        with self.assertRaisesRegex(ValueError, 'Incomplete discovery'):
            analyze(self.read('gateware-pass').split('VECTOR ONE_100')[0])

    def test_missing_restoration_cannot_pass(self):
        text = self.read('gateware-pass').split('RESTORED_REPORT')[0]
        self.assertFalse(analyze(text)['passed'])

if __name__ == '__main__':
    unittest.main()
