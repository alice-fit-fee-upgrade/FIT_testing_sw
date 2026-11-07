"""Existing MOD-DAC-28 SCPI entities, with a FIT-side3.3V per-output limit."""
import contextlib,math,select,shlex,socket,subprocess
EXPECTED='MODULIQ,MOD-DAC-28,FIT-CTRL-6825DD4C49E4,1.0'
WORDS=('ZERO','ONE','TWO','THR','FOUR','FIVE','SIX','SEV')

def voltage(value):
    if isinstance(value,bool) or not math.isfinite(float(value)) or not 0<=float(value)<=3.3:
        raise ValueError('FIT DAC output must stay within0..3.3V')
    return float(value)

@contextlib.contextmanager
def remote_lease():
    code='''import contextlib,fcntl,socket,sys
assert socket.gethostname()=='codex-hil-debug-station2'
with contextlib.ExitStack() as st:
 for n in ['esp32-6825dd4c49e4','lattice-VER00001']:
  f=st.enter_context(open('/home/codex-hil/.cache/'+n+'.lock','a+'));fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB)
 print('FIT_DAC_LOCKED',flush=True)
 sys.stdin.readline()
'''
    p=subprocess.Popen(['ssh','-i','/home/codex-hil/.ssh/debug_station2','-o','IdentitiesOnly=yes','-o','BatchMode=yes','-o','ServerAliveInterval=5','-o','ServerAliveCountMax=2','codex-hil@codex-hil-debug-station2.local','python3 -u -c '+shlex.quote(code)],stdin=subprocess.PIPE,stdout=subprocess.PIPE,stderr=subprocess.PIPE,text=True)
    try:
        if not select.select([p.stdout],[],[],10)[0] or p.stdout.readline().strip()!='FIT_DAC_LOCKED':
            raise RuntimeError('Station2 DAC leases unavailable')
        yield p
    finally:
        if p.poll() is None:
            try:p.stdin.write('RELEASE\n');p.stdin.flush();p.stdin.close();p.wait(timeout=10)
            except (BrokenPipeError,subprocess.TimeoutExpired):p.terminate();p.wait(timeout=5)

class DAC:
    def __init__(self,lease,host='fit-mod-dac-28.local',channels=(0,1)):
        if len(channels)!=2 or any(type(c) is not int or c not in range(8) for c in channels) or channels[0]==channels[1]:raise ValueError('Two distinct DAC channels0..7 required')
        self.channels=tuple(channels)
        self.lease=lease;self.host=host;self.s=None;self.f=None;self.records=[];self.connect()
    def connect(self):
        self.close();self.s=socket.create_connection((self.host,5025),timeout=3);self.s.settimeout(3);self.f=self.s.makefile('rb')
        if self.query('*IDN?')!=EXPECTED:raise RuntimeError('Wrong MODULIQ instrument')
        if float(self.query('STAT:READ?'))!=1 or int(self.query('SYST:PROJ?'))!=28 or int(self.query('SYST:REV?'))!=16:raise RuntimeError('DAC setup/identity mismatch')
    def send(self,command):
        if self.lease.poll() is not None:raise RuntimeError('Remote DAC lease lost')
        self.s.sendall((command+'\n').encode('ascii'));self.records.append(dict(command=command))
    def query(self,command):
        self.send(command);v=self.f.readline(4096).decode('ascii').strip()
        if not v:raise RuntimeError('SCPI connection closed')
        self.records[-1]['reply']=v;return v
    def snapshot(self):return [float(self.query('SOUR:'+w+':VOLT?')) for w in WORDS]
    def pair(self,positive,negative):
        # Validate BOTH before either channel can be changed.
        positive,negative=voltage(positive),voltage(negative)
        for ch,value in zip(getattr(self,'channels',(0,1)),(positive,negative)):
            self.send(f'SOUR:{WORDS[ch]}:VOLT {value:.4f}')
            if abs(float(self.query(f'SOUR:{WORDS[ch]}:VOLT?'))-value)>.00006:raise RuntimeError('SCPI entity readback mismatch')
        if self.query('SYST:ERR?')!='0,"No error"':raise RuntimeError('SCPI error')
    def park(self,positive,negative):
        # Idempotent bounded recovery after idle/disconnected TCP.
        try:self.pair(positive,negative)
        except (OSError,RuntimeError):self.connect();self.pair(positive,negative)
    def baseline(self):self.park(1,1)
    def zero(self):self.park(0,0)
    def close(self):
        if self.f:self.f.close();self.f=None
        if self.s:self.s.close();self.s=None
