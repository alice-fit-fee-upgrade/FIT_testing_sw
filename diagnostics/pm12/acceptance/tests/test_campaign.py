"""Synthetic software fixtures only; never hardware evidence."""
import copy
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from campaign import Campaign, initialize, write, read, utc

UID='PM12-K7-0000000000000123'

class CampaignTests(unittest.TestCase):
    def setUp(self):
        self.temp=tempfile.TemporaryDirectory();self.addCleanup(self.temp.cleanup)
        self.base=Path(self.temp.name);self.root=self.base/'campaign'
        spec=read(Path(__file__).resolve().parents[1]/'profiles/campaign-four-cfd.json')
        spec['tests']=[t for t in spec['tests'] if t['id']=='integrator']
        p=self.base/'protocol.json';write(p,spec)
        initialize(self.root,UID,'1803',p);self.c=Campaign(self.root)

    def fitting(self,start=1):
        b=self.c.prepare(start);p=self.base/(b['id']+'-identity.json')
        write(p,dict(status='PASS',identity=dict(uid=UID,mcu_eeprom_serial='1803',observed_utc=utc())))
        self.c.bind_identity(b['id'],p,'Synthetic fixture mapping for software test')
        return b

    def source(self,batch,ch,status='PASS',mutate=None):
        d=self.base/('input-'+str(len(list(self.base.glob('input-*')))));d.mkdir()
        (d/'driver.py').write_text('# same frozen executed source\n')
        write(d/'validation.json',dict(pass_=status=='PASS',physical_channel=ch))
        result=dict(mode='LIVE',test='integrator',board_uid=UID,channel=ch,
                    fixture_id=batch['assignments'][str(ch)],measured_utc=utc(),status=status,
                    protocol=dict(method='signed-pair-v1',reference_hz=40078700,hardware_configuration=dict(pm_build='synthetic',kasli_build='synthetic',clock_profile='synthetic',cpld_gate_mode='synthetic')),source_files=['driver.py'],
                    connections=dict(usb_input='J6',stimulus_channel=ch),
                    validation=[dict(file='validation.json',key='pass_',equals=True)],
                    channel_checks=[dict(file='validation.json',key='physical_channel')],
                    metrics=[dict(name='balance_delta',bank=bank,value=ch*.001,unit='V') for bank in 'AB'],
                    curves=[dict(name='ramp_response',bank=bank,x=[-.01,.01],y=[-10,10],x_unit='V',y_unit='code') for bank in 'AB'])
        if mutate:mutate(result)
        write(d/'campaign-result.json',result)
        return d

    def test_three_fittings_merge_all_twelve_channels(self):
        for start in [1,5,9]:
            b=self.fitting(start)
            for ch in b['channels']:self.c.record(b['id'],self.source(b,ch))
        s=self.c.summary();self.assertEqual(s['status'],'COMPLETE_SELECTED_PROTOCOL')
        self.assertEqual(len(s['records']),12)
        self.assertEqual({r['channel'] for r in s['cases']},set(range(1,13)))
        self.assertEqual(s['retained_results'],12)
        from campaign_report import generate
        rendered=generate(self.root,self.base/'complete-report')
        self.assertEqual(rendered['cases'],s['cases'])
        self.assertEqual(len(list((self.base/'complete-report/figures').glob('*.pdf'))),4)

    def test_missing_channels_and_banks_remain_explicit(self):
        b=self.fitting();self.c.record(b['id'],self.source(b,1));s=self.c.summary()
        self.assertEqual(s['status'],'INCOMPLETE')
        self.assertEqual(sum(r['status']=='NOT_MEASURED' for r in s['cases']),11)
        d=self.source(b,2,mutate=lambda r:r.update(curves=r['curves'][:1]))
        with self.assertRaisesRegex(ValueError,'observable'):self.c.record(b['id'],d)

    def test_only_expected_groups_and_unique_mapping(self):
        for start in [0,2,4,6,10]:
            with self.assertRaises(ValueError):self.c.prepare(start)
        with self.assertRaises(ValueError):self.c.prepare(1,{'1':'CFD01','2':'CFD01','3':'CFD03','4':'CFD04'})
        b=self.fitting(5);self.assertEqual(b['connections']['5']['phase_lanes'],[8,9])
        self.assertEqual(b['connections']['8']['phase_lanes'],[14,15])

    def test_discovered_reverse_mapping_is_bound_once_and_original_retained(self):
        b=self.c.prepare(9);identity=self.base/'identity-map.json'
        write(identity,dict(status='PASS',identity=dict(uid=UID,mcu_eeprom_serial='1803',observed_utc=utc())))
        mapping={str(ch):f'CFD{13-ch:02d}' for ch in range(9,13)}
        self.c.bind_identity(b['id'],identity,'Synthetic discovered reverse routing',mapping)
        directory,bound=self.c.batch(b['id'])
        self.assertEqual(bound['assignments'],mapping)
        self.assertEqual(bound['connections']['12']['phase_lanes'],[8,9])
        self.assertEqual(read(directory/'mapping-declared.json')['assignments'],b['assignments'])
        self.assertEqual(self.c.summary()['status'],'INCOMPLETE')
        with self.assertRaisesRegex(ValueError,'immutable'):
            self.c.bind_identity(b['id'],identity,'second change',b['assignments'])

    def test_identity_must_be_current_and_same_board(self):
        b=self.c.prepare(1);d=self.source(b,1)
        with self.assertRaisesRegex(ValueError,'identity'):self.c.record(b['id'],d)
        p=self.base/'wrong.json'
        for uid,time in [('PM12-K7-0000000000000456',utc()),(UID,'2000-01-01T00:00:00Z')]:
            write(p,dict(status='PASS',identity=dict(uid=uid,mcu_eeprom_serial='1803',observed_utc=time)))
            with self.assertRaises(ValueError):self.c.bind_identity(b['id'],p,'synthetic')

    def test_raw_channel_cannot_be_relabelled(self):
        b=self.fitting();d=self.source(b,1)
        write(d/'validation.json',dict(pass_=True,physical_channel=12))
        with self.assertRaisesRegex(ValueError,'different channel'):self.c.record(b['id'],d)

    def test_reruns_are_retained_and_require_explicit_selection(self):
        b=self.fitting();first=self.c.record(b['id'],self.source(b,1,status='FAIL'))
        second=self.c.record(b['id'],self.source(b,1))
        self.assertFalse(second['selected']);s=self.c.summary()
        self.assertEqual(s['records']['integrator:1']['id'],first['id'])
        self.c.select(second['id']);s=self.c.summary()
        self.assertEqual(s['retained_results'],2)
        self.assertEqual(s['records']['integrator:1']['id'],second['id'])
        another=self.c.prepare(1);self.assertNotEqual(another['id'],b['id'])

    def test_protocol_code_units_and_board_mismatches_are_rejected(self):
        b=self.fitting();self.c.record(b['id'],self.source(b,1))
        mutations=[lambda r:r.update(board_uid='other'),lambda r:r.update(protocol={'different':1}),
                   lambda r:r['metrics'][0].update(unit='mV'),lambda r:r.update(mode='HISTORICAL'),
                   lambda r:r.update(measured_utc='2000-01-01T00:00:00Z'),
                   lambda r:r['connections'].update(usb_input='J8')]
        for mutate in mutations:
            d=self.source(b,2,mutate=mutate)
            with self.assertRaises(ValueError):self.c.record(b['id'],d)
        d=self.source(b,2);(d/'driver.py').write_text('# changed source\n')
        with self.assertRaisesRegex(ValueError,'source'):self.c.record(b['id'],d)

    def test_tampered_archived_data_and_mapping_are_rejected(self):
        b=self.fitting();r=self.c.record(b['id'],self.source(b,1))
        data=read(self.root/'campaign.json');p=self.root/data['results'][0]['path']/'raw/validation.json'
        p.write_text('{}')
        with self.assertRaisesRegex(ValueError,'integrity'):self.c.summary()

    def test_false_pass_and_symlink_are_rejected(self):
        b=self.fitting();d=self.source(b,1);write(d/'validation.json',{'pass_':False,'physical_channel':1})
        with self.assertRaisesRegex(ValueError,'validation'):self.c.record(b['id'],d)
        d=self.source(b,1);(d/'link').symlink_to(d/'validation.json')
        with self.assertRaisesRegex(ValueError,'symlink'):self.c.record(b['id'],d)

    def test_report_contains_twelve_channels_and_does_not_touch_hardware(self):
        from campaign_report import generate
        b=self.fitting();self.c.record(b['id'],self.source(b,1))
        s=generate(self.root,self.base/'report')
        self.assertEqual(s['status'],'INCOMPLETE')
        self.assertTrue((self.base/'report/report.tex').exists())
        self.assertEqual(Campaign(self.base/'report/inputs').summary()['cases'],s['cases'])
        self.assertIn('NM', (self.base/'report/content.tex').read_text())

    def test_unknown_configuration_failure_does_not_freeze_success_contract(self):
        b=self.fitting()
        failed=self.source(b,1,status='ERROR',mutate=lambda r:r.update(protocol={'phase':'startup failed'}))
        self.c.record(b['id'],failed)
        passed=self.c.record(b['id'],self.source(b,1))
        self.assertFalse(passed['selected'])
        self.c.select(passed['id'])
        self.assertEqual(self.c.summary()['records']['integrator:1']['result']['status'],'PASS')

    def test_nested_raw_manifest_is_part_of_sealed_evidence(self):
        b=self.fitting();source=self.source(b,1);write(source/'files.sha256.json',{'native':'manifest'})
        self.c.record(b['id'],source)
        row=read(self.root/'campaign.json')['results'][0]
        target=self.root/row['path']/'raw/files.sha256.json';target.write_text('{}')
        with self.assertRaisesRegex(ValueError,'integrity'):self.c.summary()

    def test_channel_boolean_is_not_channel_one(self):
        b=self.fitting();d=self.source(b,1);write(d/'validation.json',{'pass_':True,'physical_channel':[True]})
        with self.assertRaisesRegex(ValueError,'different channel'):self.c.record(b['id'],d)

    def test_exact_acquisition_is_not_counted_as_another_repeat(self):
        b=self.fitting();source=self.source(b,1)
        self.c.record(b['id'],source)
        with self.assertRaisesRegex(ValueError,'already imported'):self.c.record(b['id'],source)
        self.assertEqual(self.c.summary()['retained_results'],1)

if __name__=='__main__':unittest.main()
