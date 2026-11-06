import contextlib
import gzip
import io
import json
from pathlib import Path
import unittest
from phase_estimator import histogram_centroid, estimate, scan_codes, wrapped_delta
from phase_scan import run_scan, ConsoleDAC


def capture_at(start, phase=0, words=192):
    # Actual80MHz clock sampled at960MS/s, HIGH8/LOW4 as on this setup.
    bits=[int((start+i-phase)%12<8) for i in range(words*8)]
    data=[sum(bits[j+b]<<b for b in range(8)) for j in range(0,len(bits),8)]
    row=dict(logical=8,slot=7,channel=1,start_sample=start,
             previous=int((start-1-phase)%12<8),words=data)
    return dict(sample_ps=1e12/960e6,period_bins=24,channels=[row])


class EstimatorTests(unittest.TestCase):
    def test_codes_exact_endpoints_101_points(self):
        codes=scan_codes()
        self.assertEqual((len(codes),codes[0],codes[-1]),(101,0,65535))
        self.assertEqual(set(b-a for a,b in zip(codes,codes[1:])),{655,656})

    def test_weighted_adjacent_bins(self):
        result=histogram_centroid({4:75,5:25},12)
        self.assertEqual(result['mean_bin'],4.25)

    def test_wrap_weighted_mean_and_unwrap(self):
        result=histogram_centroid({11:75,0:25},12)
        self.assertEqual(result['mean_bin'],11.25)
        self.assertAlmostEqual(wrapped_delta(.25,11.75,12),.5)

    def test_two_edges_per_reference_do_not_cancel(self):
        result=estimate(capture_at(120000)['channels'],1e12/960e6)
        self.assertEqual(result['mean_bin'],0)
        self.assertEqual(set(result['reference_histogram']),{0,12})
        self.assertEqual(result['rising_edges'],128)

    def test_bad_signal_rejected(self):
        data=capture_at(0)
        data['channels'][0]['words']=[0]*192
        with self.assertRaisesRegex(ValueError,'no rising edges'):
            estimate(data['channels'],1e12/960e6)

    def test_recorded_hardware(self):
        files=Path('/home/codex-hil/kasli-phase-tester/evidence/gate-phase-20261105')
        if not files.exists():self.skipTest('local hardware evidence not installed')
        for path in files.glob('capture-*.json.gz'):
            with gzip.open(path,'rt') as stream:data=json.load(stream)
            lane=next(r for r in data['channels'] if r['logical']==8)
            self.assertEqual(estimate([lane],data['sample_ps'])['mean_bin'],0)
            lane=next(r for r in data['channels'] if r['logical']==9)
            result=estimate([lane],data['sample_ps'])
            self.assertTrue(11<=result['mean_bin']<12)


class FlowTests(unittest.TestCase):
    def run_flow(self, failure=None):
        writes=[];events=[];start=0
        def set_code(code):
            writes.append(code)
            if failure=='write' and len(writes)==2:raise OSError('lost reply')
        def acquire():
            nonlocal start
            if failure=='capture' and len(writes)==2:raise TimeoutError('capture')
            if failure=='interrupt' and len(writes)==2:raise KeyboardInterrupt()
            if failure=='baseline':raise TimeoutError('no baseline')
            if failure!='epoch' or not start:start+=10000
            return capture_at(start)
        def emit(kind,value):
            if failure=='file' and kind=='point' and value['stage']=='sweep':raise OSError('disk')
            events.append((kind,value))
        with contextlib.redirect_stdout(io.StringIO()):
            try:return run_scan(set_code,acquire,lambda:None,emit,1234,[0,65535],[8],sleep=lambda s:None),writes,events
            finally:self.writes=writes;self.events=events

    def test_success_restores_and_saves_baseline(self):
        result,writes,events=self.run_flow()
        self.assertEqual(writes,[0,65535,1234])
        self.assertTrue(result['restore_phase_check'])
        self.assertEqual([v['stage'] for k,v in events if k=='point'],['baseline','sweep','sweep','restored'])

    def test_restore_after_capture_and_write_and_file_failure(self):
        for fault in ('capture','write','file'):
            with self.subTest(fault=fault):
                with self.assertRaises((OSError,TimeoutError)):self.run_flow(fault)
                self.assertEqual(self.writes[-1],1234)

    def test_ctrl_c_restores(self):
        with self.assertRaises(KeyboardInterrupt):self.run_flow('interrupt')
        self.assertEqual(self.writes[-1],1234)

    def test_missing_baseline_does_not_write_dac(self):
        with self.assertRaises(TimeoutError):self.run_flow('baseline')
        self.assertEqual(self.writes,[])

    def test_explicit_zero_initialization_before_baseline(self):
        writes=[];events=[];counter=0
        def acquire():
            nonlocal counter
            counter+=10000
            return capture_at(counter)
        with contextlib.redirect_stdout(io.StringIO()):
            result=run_scan(writes.append,acquire,lambda:None,
                            lambda k,v:events.append((k,v)),0,[0,65535],[8],
                            sleep=lambda s:None,initialize_zero=True)
        self.assertEqual(writes,[0,0,65535,0])
        self.assertEqual([v['stage'] for k,v in events if k=='point'],
                         ['as-found','baseline','sweep','sweep','restored'])
        self.assertTrue(result['restore_phase_check'])

    def test_counter_reuse_rejected_and_restore_attempted(self):
        with self.assertRaisesRegex(RuntimeError,'restoration/verification failed'):
            self.run_flow('epoch')
        self.assertEqual(self.writes[-1],1234)

    def test_console_targets_selected_afe_and_dac_A(self):
        commands=[]
        def transfer(port,command,limit):
            commands.append(command)
            return dict(reply='DAC SENT A FFFF')
        ConsoleDAC(None,3,transfer,lambda row:None).set_code(65535)
        self.assertEqual(commands,['@DAC 3 W A FFFF'])

if __name__=='__main__':unittest.main()
