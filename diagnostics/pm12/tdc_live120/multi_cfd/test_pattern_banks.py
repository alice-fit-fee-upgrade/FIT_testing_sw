import ast,sys,time
from pathlib import Path
sys.path.insert(0,'/home/codex-hil/kasli-phase-tester')
from host.cfd_pattern import CFDBurstDevice,pattern_words
module=ast.parse((Path(__file__).resolve().parents[1]/'scan_four_cfd.py').read_text());cls=next(n for n in module.body if isinstance(n,ast.ClassDef));ns={'CFDBurstDevice':CFDBurstDevice,'time':time};exec(compile(ast.Module(body=[cls],type_ignores=[]),'tdc-class','exec'),ns);RoutedBurst=ns['RoutedBurst']
class Fake:
 def __init__(self):self.banks=[[0]*4096 for _ in range(2)];self.active=0;self.addr=0;self.port=0;self.enabled=0
 def stop(self):self.enabled=0
 def read(self,a):return {0xfc:0x43464430,0xd8:0x43464434,0xdc:self.port,0xe0:self.enabled,0xe4:1}.get(a,0)
 def write(self,a,v):
  if a==0xe8:self.addr=v
  elif a==0xec:self.banks[1-self.active][self.addr]=v
  elif a==0xf0:self.active=1-self.active;self.length=v
  elif a==0xdc:self.port=v
  elif a==0xe0:self.enabled=v
commits=0
for port in range(4):
 d=Fake();b=RoutedBurst(d,port)
 for phase in [24]+list(range(24,49))+list(range(48,23,-1)):
  pattern=pattern_words(1200,phase,20);b.upload_patch(pattern);commits+=1;assert d.banks[d.active][:len(pattern)]==pattern,(port,phase)
print(f'DOUBLE_BANK_PATTERN_UPDATE_PASS: {commits} commits, all ports, rising/falling phase sweeps byte-exact')

# A legacy caller must not inherit the last port of a four-channel scan.
d=Fake();d.port=3;legacy=CFDBurstDevice(d);assert d.port==0 and d.enabled==0
d.port=3
try:legacy.directions(1)
except RuntimeError:pass
else:raise AssertionError('Legacy direction/route mismatch accepted')
assert d.enabled==0
print('LEGACY_ROUTE_GUARD_PASS: initialize on port0; reject stale route before enabling')
