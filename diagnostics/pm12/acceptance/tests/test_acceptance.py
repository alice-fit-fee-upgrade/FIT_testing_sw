import contextlib
import io
import json
import os
from pathlib import Path
import subprocess
import sys
import tarfile
import tempfile
import unittest
from unittest.mock import patch
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from identity import board_uid,canonical_dna,register
from lease import acquire,ENV
from suite import verdict,execute_step,write,files_manifest
from report import verify,gather,tex,compose,connection_table
from plots import extract

class Acceptance(unittest.TestCase):
    def setUp(self):
        self.temp=tempfile.TemporaryDirectory();self.addCleanup(self.temp.cleanup);self.root=Path(self.temp.name)

    def test_dna_normalization_and_blank_rejection(self):
        self.assertEqual(board_uid('0x123'),'PM12-K7-0000000000000123')
        for value in ['0','FFFFFFFFFFFFFFFF','../foo','1'*17]:
            with self.assertRaises(ValueError):canonical_dna(value)

    def test_registry_refuses_alias_collision(self):
        r=self.root/'boards.json'
        register(r,dict(uid=board_uid('123'),fpga_dna='123',asset_label='PM001'))
        with self.assertRaisesRegex(ValueError,'already belongs'):
            register(r,dict(uid=board_uid('456'),fpga_dna='456',asset_label='PM001'))
        self.assertEqual(len(json.loads(r.read_text())['boards']),1)

    def test_zero_exit_does_not_override_failing_measurement(self):
        check=[dict(file='result.json',key='pass',equals=True)]
        step=dict(id='test',title='test',command=[sys.executable,'-c',"import json;json.dump({'pass':False},open('PLACE/result.json','w'))".replace('PLACE',str(self.root/'step'))],checks=check,procedure='test',limits='test')
        row=execute_step(step,self.root/'step',{},())
        self.assertEqual(row['returncode'],0);self.assertEqual(row['status'],'FAIL')

    def test_missing_or_wrong_type_verdict_is_not_pass(self):
        write(self.root/'result.json',{'pass':1})
        self.assertEqual(verdict(self.root,[dict(file='result.json',key='pass',equals=True)])[0],'FAIL')
        with self.assertRaises(ValueError):verdict(self.root,[])
        with self.assertRaises(ValueError):verdict(self.root,[dict(file='../outside',key='pass',equals=True)])

    def test_hash_tamper_detected(self):
        write(self.root/'run.json',dict(mode='LIVE'))
        write(self.root/'files.sha256.json',files_manifest(self.root));verify(self.root)
        write(self.root/'run.json',dict(mode='HISTORICAL'))
        with self.assertRaisesRegex(ValueError,'integrity'):verify(self.root)

    def batch(self,name,uid='PM12-K7-0000000000000123',channel=12,configuration=None,source='abc'):
        p=self.root/name;p.mkdir()
        write(p/'run.json',dict(board_uid=uid,mode='LIVE',configuration=configuration or {},source_fingerprint=source,steps=[dict(id='gate-phase',channel=channel,status='NOT_RUN')]))
        write(p/'files.sha256.json',files_manifest(p));return p

    def test_batch_merge_checks_identity_configuration_source_and_duplicates(self):
        a=self.batch('a',channel=1);b=self.batch('b',channel=2);self.assertEqual(len(gather([a,b])[0]),2)
        for name,kwargs in [('wrong-board',dict(uid='other')),('wrong-clock',dict(configuration={'clock':120})),('wrong-source',dict(source='def')),('duplicate',dict(channel=1))]:
            other=self.batch(name,**kwargs)
            with self.assertRaises(ValueError):gather([a,other])

    def test_inherited_lease_is_real_and_still_excludes_other_process(self):
        p=self.root/'board.lock'
        with acquire(p) as parent:
            env=dict(os.environ,**{ENV:json.dumps({str(p):parent.fileno()})})
            script="from lease import acquire;from pathlib import Path;f=acquire(Path("+repr(str(p))+"));print('OK')"
            env['PYTHONPATH']=str(Path(__file__).resolve().parents[1])
            r=subprocess.run([sys.executable,'-c',script],env=env,pass_fds=(parent.fileno(),),capture_output=True,text=True)
            self.assertEqual(r.returncode,0,r.stderr)
            env.pop(ENV)
            r=subprocess.run([sys.executable,'-c',script],env=env,capture_output=True,text=True)
            self.assertNotEqual(r.returncode,0)
        with acquire(p):pass

    def test_inherited_lease_inode_must_match(self):
        a=self.root/'a';b=self.root/'b';b.touch()
        with acquire(a) as f,patch.dict(os.environ,{ENV:json.dumps({str(b):f.fileno()})}):
            with self.assertRaisesRegex(RuntimeError,'inode'):acquire(b)

    def test_archive_cannot_escape(self):
        path=self.root/'bad.tar.gz'
        with tarfile.open(path,'w:gz') as tar:
            member=tarfile.TarInfo('../escaped');member.size=3;tar.addfile(member,io.BytesIO(b'bad'))
        with self.assertRaises(ValueError):extract(path,self.root/'raw')
        self.assertFalse((self.root/'escaped').exists())


    def test_edited_chapters_are_preserved_but_raw_changes_still_rejected(self):
        chapter=self.root/'chapter';chapter.mkdir()
        raw=chapter/'inputs';raw.mkdir()
        batch=raw/'batch';batch.mkdir()
        write(batch/'run.json',dict(board_uid='PM12-K7-0000000000000123',mode='LIVE',status='INCOMPLETE',steps=[],configuration={},source_fingerprint='abc'))
        write(batch/'files.sha256.json',files_manifest(batch))
        write(chapter/'chapter.json',dict(name='cfd',input_runs=['inputs/batch']))
        (chapter/'content.tex').write_text('Original chapter')
        write(chapter/'files.sha256.json',files_manifest(chapter))
        (chapter/'content.tex').write_text('Edited chapter retained')
        with self.assertRaises(ValueError):compose([chapter],self.root/'refused')
        compose([chapter],self.root/'assembled',allow_edited_tex=True)
        self.assertEqual((self.root/'assembled/chapters/00/content.tex').read_text(),'Edited chapter retained')
        self.assertEqual(len(json.loads((self.root/'assembled/editorial-changes.json').read_text())),1)
        write(batch/'run.json',dict(mode='FAKE'))
        with self.assertRaises(ValueError):compose([chapter],self.root/'raw-refused',allow_edited_tex=True)

    def test_connection_table_keeps_all_measured_nets_and_failure_results(self):
        import copy,gzip
        pm=Path(__file__).resolve().parents[2]
        sys.path.insert(0,str(pm))
        from test_board import analyze
        gate=analyze(gzip.decompress((pm/'tests/fixtures/gateware-pass.log.gz').read_bytes()).decode())
        boundary=analyze(gzip.decompress((pm/'tests/fixtures/boundary-pass.log.gz').read_bytes()).decode(),boundary=True)
        pinmap=json.loads((pm/'pinmap.json').read_text())
        rendered=connection_table(gate,boundary,pinmap)
        for row in gate['connections']:self.assertEqual(rendered.count('{'+row['signal']+'} & '),1)
        self.assertEqual(rendered.count('{PASS}'),336)
        broken=copy.deepcopy(gate);broken['connections'][0].update(passed=False,cpld_channel=None,cpld_pin=None)
        rendered=connection_table(broken,boundary,pinmap)
        self.assertIn('{Unresolved}',rendered);self.assertEqual(rendered.count('{FAIL}'),1)
        with self.assertRaises(ValueError):connection_table(dict(gate,connections=gate['connections'][:-1]),boundary,pinmap)

    def test_latex_text_is_escaped(self):
        escaped=tex('D0_D1 & 50% {test} \\input')
        for expected in [r'D0\_D1',r'\&',r'50\%',r'\{test\}',r'\textbackslash{}input']:self.assertIn(expected,escaped)

if __name__=='__main__':unittest.main()
