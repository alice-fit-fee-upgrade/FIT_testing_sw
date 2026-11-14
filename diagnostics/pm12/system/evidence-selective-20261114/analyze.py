#!/usr/bin/env python3
"""Offline conservative SYS-decrement analysis of selective HDMI trials."""
import argparse,json,collections
from pathlib import Path
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
p=argparse.ArgumentParser();p.add_argument('--work',type=Path,required=True);p.add_argument('--out',type=Path,required=True);a=p.parse_args();a.out.mkdir(parents=True,exist_ok=True)
s=dict(groups={},incomplete=[],slow=[],criterion='Conservative observed counter decrease only. Earlier executed helpers also used a host-time ratio that can falsely flag a sample following a delayed read; those flags are superseded by this raw recomputation.')
g=collections.defaultdict(lambda:dict(completed=0,restarts=0))
for n in ['hardware','repeat02']:
 r=json.loads((a.work/n/'result.json').read_text())
 for z in r['cases']:
  if 'sys_restart' not in z:s['incomplete'].append(z['label']);continue
  v=[x for x in z['trace'] if 'ticks'in x];reset=any(y['ticks']<x['ticks'] for x,y in zip(v,v[1:]));key=z['group']+(' divider'+str(z['divider']) if 'divider'in z else '')
  g[key]['completed']+=1;g[key]['restarts']+=int(reset)
s['groups']=dict(g)
for n in ['slow-trace','slow-trace-timed']:
 r=json.loads((a.work/n/'result.json').read_text());rows=[]
 for z in r['runs']:
  v=[x for x in z['trace'] if 'ticks'in x];events=[y for x,y in zip(v,v[1:]) if y['ticks']<x['ticks']]
  rows.append(dict(repeat=z['repeat'],address=z['address'],counter_decreases=len(events),nominal_reset_epoch_ms=[1000*(y['t_done']-y['ticks']/40078700-z['start']) for y in events if 't_done'in y]))
 s['slow'].append(dict(series=n,runs=rows,restart_frames=sum(x['counter_decreases']>0 for x in rows),completed=len(rows)))
s['timing_limitation']='Busy sampled before a blocking PM read cannot locate the reset. Timed repeat uses read completion minus fresh uptime as nominal epoch, assuming running SYS clock and small final reply latency. Not a direct reset/SEL latch.'
(a.out/'summary.json').write_text(json.dumps(s,indent=2)+'\n')
r=json.loads((a.work/'slow-trace-timed/result.json').read_text());fig,ax=plt.subplots(figsize=(10,5))
for i,z in enumerate(r['runs']):
 t=z['start'];v=z['trace']
 for x in v:
  ax.plot((x['t']-t)*1000,i+.45*bool(x['state']&2),'.',color='C0',ms=3)
  ax.plot((x['t_done']-t)*1000,i+.45*bool(x['state_after']&2),'.',color='C0',ms=3)
 events=s['slow'][1]['runs'][i]['nominal_reset_epoch_ms']
 for ms in events:ax.plot(ms,i+.2,'rx',ms=9)
ax.axvline(65535*65/120236100*1000,color='gray',ls='--',label='Expected frame completion')
ax.set_yticks(range(9),[f"Read {z['address']}, repeat {z['repeat']+1}" for z in r['runs']]);ax.set_xlim(-2,65);ax.set_xlabel('Host time after command (ms)');ax.set_title('Long SPI reads: sampled busy (blue), nominal restart epoch (red)');ax.legend(loc='upper left');ax.grid(alpha=.2);fig.tight_layout();fig.savefig(a.out/'slow-spi.png',dpi=160);fig.savefig(a.out/'slow-spi.pdf')
