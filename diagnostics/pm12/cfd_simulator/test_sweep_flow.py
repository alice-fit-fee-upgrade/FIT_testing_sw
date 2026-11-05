"""No hardware: verify restored voltage reads occur while the mux is selected."""
import contextlib,importlib,io,json,tempfile,types,unittest
from pathlib import Path
from unittest.mock import patch

class SweepFlowTest(unittest.TestCase):
    def test_curve_only_reads_selected_output_and_restores_codes(self):
        with patch.dict('sys.modules',{'serial':types.SimpleNamespace()}):
            sweep=importlib.import_module('dac_sweep')
        state={'selected':None,'codes':dict(A=123,B=0,C=0,D=0),'writes':[]}
        class UART:
            def open(self):pass
            def close(self):pass
            def read(self,n):return b''
        class Bus:
            def __init__(self,*args):self.records=[]
            @contextlib.contextmanager
            def routed(self,*args):yield
            def mux(self,addr):return 0
        class Mux:
            def off(self):state['selected']=None
            def select(self,ch):state['selected']=ch
        class GPIO:
            def __init__(self,*args):pass
            def initialize_monitor(self):return Mux()
            def read_latch(self):return 8
        class DAC:
            def __init__(self,*args):pass
            def stored(self):return dict(A=123,B=47381,C=34734,D=62621)
            def set_code(self,output,value):state['codes'][output]=value;state['writes'].append(output)
        class Transport:
            def __init__(self,*args):pass
            def __enter__(self):return self
            def __exit__(self,*args):pass
            def query(self,command):return 'FRON'
        class Meter:
            def __init__(self,*args):pass
            def configure(self,*args,**kwargs):return dict(configured=True)
            def read_dcv(self):
                channel=state['selected']
                if channel is None:raise AssertionError('DMM read after monitor inhibit')
                output={0:'C',1:'D',3:'B'}[channel]
                return 1+state['codes'][output]*(-1e-6 if output!='D' else 1e-6)
        real_open=open
        def guarded_open(path,*args,**kwargs):
            if str(path).startswith('/home/codex-hil/.cache/'):return io.StringIO()
            return real_open(path,*args,**kwargs)
        with tempfile.TemporaryDirectory() as directory,contextlib.ExitStack() as stack:
            dest=Path(directory)/'result'
            for name,obj in dict(ConsoleI2C=Bus,MCP23017Monitor=GPIO,DAC=DAC,Transport=Transport,DMM7510=Meter,
                wait_power_good=lambda *a:[],require_power_good=lambda *a:{},
                capture=lambda *a:dict(reply='Board S/N: 1803'),serial=types.SimpleNamespace(Serial=lambda **kwargs:UART()),open=guarded_open).items():
                stack.enter_context(patch.object(sweep,name,obj,create=True))
            stack.enter_context(patch.object(sweep.fcntl,'flock'))
            stack.enter_context(patch.object(sweep.time,'sleep'))
            stack.enter_context(patch('sys.argv',['dac_sweep','--out',str(dest),'--dmm-host','fake','--restore-codes','B=0000','C=0000','D=0000','--low-codes','--curve-only']))
            with contextlib.redirect_stdout(io.StringIO()):sweep.main()
            result=json.loads((dest/'report.json').read_text())
            self.assertTrue(result['pass_']);self.assertEqual(result['stored_parameter_codes']['B'],47381)
            self.assertEqual(result['restore_codes'],dict(B=0,C=0,D=0))
            self.assertEqual(result['target_restore_deltas'],dict(B=0,C=0,D=0))
            self.assertEqual(state['codes'],dict(A=123,B=0,C=0,D=0));self.assertNotIn('A',state['writes'])
            self.assertIsNone(state['selected'])
