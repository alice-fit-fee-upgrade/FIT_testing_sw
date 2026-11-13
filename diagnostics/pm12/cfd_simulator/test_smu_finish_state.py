"""Software-only post-cleanup validation using retained reference data."""
import copy,json,shutil,tempfile,unittest
from pathlib import Path
from validate_smu_dacs import validate

class PostCleanup(unittest.TestCase):
 def setUp(self):
  self.temp=tempfile.TemporaryDirectory();self.addCleanup(self.temp.cleanup);self.d=Path(self.temp.name)
  fixture=Path(__file__).parent/'evidence-smu-dac-20261110'
  self.report=json.loads((fixture/'scan-report.json').read_text());self.report['finished_utc']='2020-01-01T00:00:00+00:00';self.report['final_tca']={'112':0,'113':8}
  (self.d/'scan-report.json').write_text(json.dumps(self.report));shutil.copy2(fixture/'samples.csv',self.d/'samples.csv')
  self.post=dict(pass_=True,identity=self.report['identity'],connected_modules=self.report['connected_modules'],monitor_GPIOA={str(ch):8 for ch in self.report['connected_modules']},final_tca={'112':0,'113':0},started_utc='2020-01-01T00:01:00+00:00',smu_settings={'OUTP?':'0','OUTP:ON:AUTO?':'0','OUTP:OFF:MODE?':'HIZ','SOUR:FUNC:MODE?':'CURR','SOUR:CURR?':'0','SENS:REM?':'0','SYST:ERR?':'0,"No error"'})
 def write(self,value):(self.d/'post-cleanup.json').write_text(json.dumps(value))
 def test_nonzero_original_mask_requires_verified_later_cleanup(self):
  with self.assertRaises(AssertionError):validate(self.d)
  self.write(self.post);self.assertTrue(validate(self.d)['explicit_post_cleanup'])
 def test_rejects_unsafe_incomplete_stale_or_wrong_instrument_receipt(self):
  variants=[]
  for key,value in [('pass_',False),('identity','other'),('connected_modules',[1,2,3,4]),('monitor_GPIOA',{'12':8}),('final_tca',{'112':0,'113':8}),('started_utc','2019-01-01T00:00:00+00:00')]:
   bad=copy.deepcopy(self.post);bad[key]=value;variants.append(bad)
  for key,value in [('OUTP?','1'),('SOUR:CURR?','1e-6'),('SENS:REM?','1')]:
   bad=copy.deepcopy(self.post);bad['smu_settings'][key]=value;variants.append(bad)
  bad=copy.deepcopy(self.post);bad['monitor_GPIOA']['12']=0;variants.append(bad)
  for bad in variants:
   self.write(bad)
   with self.assertRaises(AssertionError):validate(self.d)
if __name__=='__main__':unittest.main()
