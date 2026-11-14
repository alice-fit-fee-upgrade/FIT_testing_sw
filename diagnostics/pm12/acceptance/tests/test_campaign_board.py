"""Synthetic INA raw-register conversion and completeness tests."""
import sys,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from campaign_board_adapter import ina_rows
class Board(unittest.TestCase):
 def test_signed_shunts_and_owner_fitted_r15(self):
  records=[]
  for route in [4,5,6]:
   lines=[]
   for ch in [1,2,3]:
    shunt='0270' if (route,ch)==(5,1) else 'FFF8' if (route,ch)==(4,1) else '0008'
    lines.append(f'INA {route} CH={ch} RAW={shunt}/03E8 MV=1000 MA=NA STATUS=RETAINED_TEST_TEXT\r\n')
   records.append(dict(command=f'@INA {route}',reply=''.join(lines)))
  rows=ina_rows(records);self.assertEqual(len(rows),8)
  self.assertAlmostEqual(next(r['current_A'] for r in rows if r['rail']=='P3V8'),3.12)
  self.assertAlmostEqual(next(r['current_A'] for r in rows if r['rail']=='P1V0_LDO'),-.004)
  with self.assertRaises(ValueError):ina_rows(records[:-1])
if __name__=='__main__':unittest.main()
