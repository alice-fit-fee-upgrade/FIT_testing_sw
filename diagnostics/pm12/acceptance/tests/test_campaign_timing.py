"""Synthetic timing fixtures only, never physical hardware evidence."""
import collections,copy,json,struct,sys,tempfile,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from campaign_timing_adapter import unwrap,fine_statistics,validate_tdc

class Timing(unittest.TestCase):
 def test_fine_wrap_and_reserved_bits(self):
  hist,mean,spread=fine_statistics([127,0]*64)
  self.assertAlmostEqual(mean,127.5);self.assertAlmostEqual(spread,.5)
  self.assertEqual(unwrap([100,54,8,90,44],128),[100,54,8,-38,-84])
  for bad in [[],[8192]]:
   with self.assertRaises(ValueError):fine_statistics(bad)
 def fixture(self,root):
  report=dict(expected_channels=[12,11,10,9],sample_hz_assumed=40.0787e6*24,captures=[],statistics=[],final=dict(cfd_enabled=0,selected_port=0,pm_build=0xc7c42d28),directions_final={'6':dict(after=[0,0]),'7':dict(after=[0,0])})
  for port,ch in enumerate(report['expected_channels']):
   for suffix,count,phase in [('quiet-before',0,None),('discover',16,24)]+[(f'phase{k:02d}',128,k) for k in range(24,49)]+[('quiet-after',0,None)]:
    label=f'p{port}-'+suffix;directory=root/label;directory.mkdir();fine=(100-(phase or 24)*46)%128;words=[fine]*count
    counts=[0]*12;counts[ch-1]=count;hist=[{} for _ in range(12)];hist[ch-1]={str(fine):count} if count else {}
    row=dict(label=label,counts=counts,status=1,generation=len(report['captures'])+1,fine_histograms=hist,phase_bin=phase)
    report['captures'].append(row);(directory/'summary.json').write_text(json.dumps(row))
    for index in range(12):(directory/f'tdc{index+1:02d}.bin').write_bytes(struct.pack('<'+'H'*count,*words) if index==ch-1 else b'')
    if count==128:
     histogram,mean,spread=fine_statistics(words);report['statistics'].append(dict(label=label,channel=ch,port=port,count=count,phase_bin=phase,delay_ns=(phase-24)/report['sample_hz_assumed']*1e9,fine_mean_circular=mean,fine_std_circular=spread,fine_histogram={str(k):v for k,v in histogram.items()},coarse_histogram={'0':128}))
  return report
 def test_full_counts_statistics_and_safe_outputs(self):
  with tempfile.TemporaryDirectory() as d:
   root=Path(d);r=self.fixture(root);self.assertEqual(validate_tdc(root,r)['phase_events'],12800)
   for mutate in [lambda r:r['final'].update(cfd_enabled=1),lambda r:r['statistics'][0].update(delay_ns=100),lambda r:r['statistics'][0].update(fine_mean_circular=33),lambda r:r['captures'][1]['counts'].__setitem__(0,1)]:
    bad=copy.deepcopy(r);mutate(bad)
    with self.assertRaises(ValueError):validate_tdc(root,bad)
   path=root/'p0-phase24/tdc12.bin';path.write_bytes(struct.pack('<128H',*([8192]*128)))
   with self.assertRaises(ValueError):validate_tdc(root,r)
if __name__=='__main__':unittest.main()
