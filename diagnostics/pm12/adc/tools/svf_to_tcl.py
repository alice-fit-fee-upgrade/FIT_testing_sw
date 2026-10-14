"""Strict ISE SVF subset for the verified 12 XC2C128 + Kintex PM12 chain.
Preserves scan end states, header/trailer lengths and sticky MASK/SMASK.
Never executes input as Tcl; rejects unsupported commands and opcodes.
"""
import re,argparse
from pathlib import Path
ALLOWED={1,255,232,237,240,192,234,238}
def convert(text):
 text=re.sub(r'//[^\n]*','',text)
 end={'SIR':'IDLE','SDR':'IDLE'};runstate='IDLE';patterns={};out=[];scans=0;physical=False
 def pattern(kind,n,body):
  old=patterns.get(kind)
  if old is None or old['n']!=n:old=dict(n=n,tdi=0,mask=(1<<n)-1,smask=(1<<n)-1)
  fields={k:int(re.sub(r'\s','',v),16) for k,v in re.findall(r'(TDI|TDO|MASK|SMASK)\s*\(([\da-fA-F\s]+)\)',body)}
  assert not re.sub(r'(TDI|TDO|MASK|SMASK)\s*\([\da-fA-F\s]+\)','',body).strip(),body
  for k,v in fields.items():assert v.bit_length()<=n,(kind,n,k)
  for k in ['MASK','SMASK']:
   if k in fields:old[k.lower()]=fields[k]
  if 'TDI' in fields:old['tdi']=(old['tdi']&~old['smask'])|(fields['TDI']&old['smask'])
  old['tdo']=fields.get('TDO');patterns[kind]=old;return old
 for cmd in text.split(';'):
  cmd=cmd.strip()
  if not cmd:continue
  tok=cmd.split();kind=tok[0]
  if kind=='TRST':assert tok==['TRST','OFF'];continue
  if kind=='FREQUENCY':assert len(tok)==3 and float(tok[1])==1e6 and tok[2]=='HZ';continue
  if kind in ['ENDIR','ENDDR']:
   assert len(tok)==2 and tok[1] in ['IDLE','IRPAUSE','DRPAUSE'];end['SIR' if kind=='ENDIR' else 'SDR']=tok[1];continue
  if kind in ['HIR','TIR','HDR','TDR','SIR','SDR']:
   m=re.fullmatch(r'\w+\s+(\d+)(.*)',cmd,re.S);assert m,cmd
   p=pattern(kind,int(m[1]),m[2])
   if kind[0]!='S':continue
   ir=kind=='SIR';h=patterns.get('HIR' if ir else 'HDR',dict(n=0,tdi=0,tdo=None,mask=0));t=patterns.get('TIR' if ir else 'TDR',dict(n=0,tdi=0,tdo=None,mask=0))
   if ir:physical=p['n']==102
   if physical:h=t=dict(n=0,tdi=0,tdo=None,mask=0)
   bits=h['n']+p['n']+t['n'];value=h['tdi']|(p['tdi']<<h['n'])|(t['tdi']<<(h['n']+p['n']))
   if ir:
    assert bits==102,(bits,p)
    if physical:
     assert value&63==63
     ops=[(value>>(6+8*i))&255 for i in range(12)]
     assert all(op in ALLOWED for op in ops) and sum(op!=255 for op in ops)<=1,ops
    else:
     assert p['n']==8 and p['tdi'] in ALLOWED
     assert h['tdi']==(1<<h['n'])-1 and t['tdi']==(1<<t['n'])-1
   else:
    if physical:assert bits in [13,19,44,764,771],bits
    else:assert h['n']+t['n']==12 and p['n'] in [7,32,752,759],(bits,p)
   out.append(f'set_property ENDSTATE_{"IR" if ir else "DR"} {end[kind]} $current_hw_jtag')
   line=f'scan_{"ir" if ir else "dr"}_hw_jtag {bits} -tdi {value:x}'
   if p['tdo'] is not None:
    expected=p['tdo']<<h['n'];mask=p['mask']<<h['n']
    for extra,offset in [(h,0),(t,h['n']+p['n'])]:
     if extra['tdo'] is not None:expected|=extra['tdo']<<offset;mask|=extra['mask']<<offset
    line+=f' -tdo {expected&mask:x} -mask {mask:x}'
   out.append(line);scans+=1;continue
  if kind=='STATE':
   states=tok[1:];assert states[-1] in ['IDLE','RESET','IRPAUSE','DRPAUSE']
   assert all(x in ['IDLE','RESET','IRPAUSE','DRPAUSE','IREXIT2','IRUPDATE','DRSELECT','DRCAPTURE','DREXIT1','DRUPDATE'] for x in states)
   if states==['IREXIT2','IRUPDATE','DRSELECT','DRCAPTURE','DREXIT1','DRUPDATE','IDLE']:
    # Vivado rejects this otherwise valid zero-shift Capture->Update path.
    # Insert a one-clock stable DRPAUSE, then update; no DR data is shifted.
    out.append('run_state_hw_jtag -state {IREXIT2 IRUPDATE DRSELECT DRCAPTURE DREXIT1 DRPAUSE} DRPAUSE')
    out.append('run_state_hw_jtag -state {DREXIT2 DRUPDATE IDLE} IDLE')
   else:out.append('run_state_hw_jtag '+(states[0] if len(states)==1 else '-state {'+' '.join(states)+'} '+states[-1]))
   continue
  if kind=='RUNTEST':
   if tok[1] in ['IDLE','DRPAUSE','IRPAUSE','RESET']:runstate=tok.pop(1)
   assert len(tok)==3 and tok[2]=='TCK' and tok[1].isdigit(),tok
   out.append(f'runtest_hw_jtag -wait_state {runstate} -end_state {runstate} -tck {int(tok[1])}');continue
  raise ValueError('Unsupported SVF command '+kind)
 return '\n'.join(out)+'\n',scans
if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('input',type=Path);p.add_argument('output',type=Path);a=p.parse_args();text,scans=convert(a.input.read_text());a.output.write_text(text);print('Converted',scans,'exact-length scans')
