import unittest
from smu_voltage import parse_voltage, FAULT_MASK

class Samples(unittest.TestCase):

    def test_real_sample_and_reserved_bits(self):
        self.assertEqual(parse_voltage('+1.320360E+00,+6.233000E-03,+1.729000E+03'), (1.32036, 0.006233, 1729))

    def test_every_fault_bit(self):
        for bit in range(14):
            if FAULT_MASK & 1 << bit:
                with self.subTest(bit=bit), self.assertRaises(ValueError):
                    parse_voltage(f'1.3,0.1,{1 | 1 << bit}')

    def test_invalid_data(self):
        for reply in ['9.91e37,0,1', 'nan,0,1', '1,0,nan', '1,0,1.5', '1,-1,1', '1,0,0', '1,0']:
            with self.subTest(reply=reply), self.assertRaises(ValueError):
                parse_voltage(reply)
if __name__ == '__main__':
    unittest.main()
