"""Evaluate settled windows, negative controls and approximate physical clocks."""
def delta(a,b,key): return (b[key]-a[key]) & 0xffffffff

def analyze(entries):
 s={e['name']:e for e in entries}; checks={}; windows={}
 for name,left,right in [('initial_mac','MAC_A','MAC_B'),('payload_recovery','PAYLOAD_RECOVERY_A','PAYLOAD_RECOVERY_B'),('prbs','PRBS_A','PRBS_B'),('prbs_recovery','RECOVERY_A','RECOVERY_B'),('final_mac','MAC_RECOVERY_A','MAC_RECOVERY_B')]:
  a,b=s[left],s[right]; dt=(b['time_ms']-a['time_ms'])/1000
  w={k:delta(a,b,k) for k in ('tick','refcount','txframes','rxframes','badframes','prbs_error_samples','rxbytes')}
  w.update(sys_mhz=w['tick']/dt/1e6,reference_mhz=2*w['refcount']/dt/1e6,seconds=dt); windows[name]=w
  checks[name+'_clocks']=118<w['sys_mhz']<122 and 198<w['reference_mhz']<202
  if 'mac' in name or name=='payload_recovery':
   checks[name]=(a['flags']&0x37f)==0x33f and (b['flags']&0x37f)==0x33f and w['rxframes']>1000 and abs(w['rxframes']-w['txframes'])<=4 and w['badframes']==0 and abs(w['rxbytes']-60*w['rxframes'])<=120
  else:
   checks[name]=(a['flags']&0x35f)==0x31f and (b['flags']&0x35f)==0x31f and w['prbs_error_samples']==0
 checks['payload_negative_control']=delta(s['MAC_B'],s['BAD_PAYLOAD'],'badframes')>1000
 checks['prbs_negative_control']=delta(s['PRBS_B'],s['MISMATCH'],'prbs_error_samples')>1000000 and bool(s['MISMATCH']['flags']&0x80)
 return {'checks':checks,'windows':windows,'status':'PASS' if all(checks.values()) else 'FAIL'}
