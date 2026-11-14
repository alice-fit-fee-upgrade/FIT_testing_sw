#!/usr/bin/env python3
import argparse,json,collections
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('--result',type=Path,required=True);p.add_argument('--out',type=Path,required=True);a=p.parse_args();r=json.loads(a.result.read_text());groups=collections.defaultdict(lambda:dict(frames=0,counter_decreases=0,timeouts=0,frames_with_timeouts=0));blocks=[]
assert r.get('completed') and r.get('restored')
for b in r['blocks']:
 assert b['hold_after']==0x53520000|b['held']
 count=0;timeouts=0
 for f in b['frames']:
  expected=0 if b['held'] else [0x4844,0x4d49,1,0][f['address']];assert f['readback']==expected
  v=[x for x in f['trace']if'ticks'in x];n=sum(y['ticks']<x['ticks']for x,y in zip(v,v[1:]));assert n==f['counter_decreases']
  assert all(x['enable']==1 and x['state']&15==9 for x in f['trace'])
  key=('matched-zero'if b['label'].startswith('matched-zero')else'signatures')+('-held'if b['held']else'-normal')
  g=groups[key];g['frames']+=1;g['counter_decreases']+=n;g['timeouts']+=f['timeouts'];g['frames_with_timeouts']+=int(f['timeouts']>0);count+=n;timeouts+=f['timeouts']
 blocks.append(dict(label=b['label'],held=b['held'],frames=len(b['frames']),counter_decreases=count,timeouts=timeouts))
g=dict(groups);normal=g['matched-zero-normal']['counter_decreases'];held=g['matched-zero-held']['counter_decreases']
if held:conclusion='SYS restarts observed with parser held in reset; parser state transitions are not necessary in this tested setup.'
elif normal:conclusion='Matched normal frames reproduced SYS restarts; none observed in held frames. Suppression observed, not proof of a unique root cause; examine timeouts and per-block controls.'
else:conclusion='Matched normal zero-data frames did not reproduce the restart; this comparison cannot establish suppression by reset.'
s=dict(groups=g,blocks=blocks,conclusion=conclusion,hold_verified_after_each_block=True,restored=r['restored'],adc_validated=r.get('adc_validated'),scope='Conservative counter decreases. Timeouts remain unknown outcomes. Logical zero MISO matching is source/protocol based, not continuous electrical observation.')
a.out.write_text(json.dumps(s,indent=2)+'\n');print(json.dumps(s,indent=2))
