from pathlib import Path
import json,statistics
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
root=Path(__file__).parent;out=root/'analysis';out.mkdir(exist_ok=True);summary=[];hz=40.0787e6
for file in sorted((root/'hardware').glob('trace*.json')):
 t=json.loads(file.read_text());e=t['events'];real=[x for x in e if x['tick']>8];prev=3;edges=[];bad=[];sel_end=None;drop=None;relock=None;sys_release=None
 for row in real:
  s=row['state']
  if (s^prev)&16:edges.append(row)
  if prev&8 and not s&8:sel_end=row['tick']
  if not s&1 and drop is None:drop=row['tick']
  if drop is not None and s&1 and relock is None:relock=row['tick']
  if relock is not None and not s&4 and sys_release is None:sys_release=row['tick']
  if s&4 and (s&1):pass
  prev=s
 deltas=[b['tick']-a['tick'] for a,b in zip(edges,edges[1:])]
 row=dict(trace=file.name,address=t['address'],status=t['status'],hreset=bool(t['status']&8192),sck_edges=len(edges),sck_half_period_ticks=sorted(set(deltas)),max_ref_heartbeat_age_ticks=max(x['max_ref_age'] for x in e),fixed_lock_fall_tick=drop,fixed_lock_rise_tick=relock)
 if drop is not None:
  row.update(delay_from_sel_low_ticks=drop-sel_end,delay_us_nominal=(drop-sel_end)/hz*1e6,lock_low_watch_ticks=relock-drop,lock_low_us_nominal=(relock-drop)/hz*1e6,sys_release_after_lock_ticks=sys_release-relock)
  fig,axes=plt.subplots(2,1,figsize=(11,7),layout='constrained')
  for ax,zoom in zip(axes,[False,True]):
   times=[(x['tick']-sel_end)/hz*1e6 for x in real];states=[x['state'] for x in real]
   for n,(bit,label) in enumerate([(3,'HSEL'),(4,'HSCK'),(5,'HMOSI'),(0,'SYS MMCM LOCK'),(1,'CAP MMCM LOCK'),(2,'SYS reset'),(6,'Loss latch')]):
    ax.step(times,[n*1.5+((s>>bit)&1) for s in states],where='post',label=label)
   ax.set_yticks([n*1.5+.5 for n in range(7)],['HSEL','HSCK','HMOSI','SYS MMCM LOCK','CAP MMCM LOCK','SYS reset','Loss latch']);ax.grid(alpha=.2)
   if zoom:ax.set_xlim(row['delay_us_nominal']-3,row['delay_us_nominal']+row['lock_low_us_nominal']+3)
   ax.set_xlabel('Time from HSEL deassertion (us; nominal 40.0787 MHz watch clock)')
  axes[0].set_title(f"PM12 SPI read {t['address']}: complete SPI frame, followed by MMCM lock loss")
  axes[1].set_title('Lock-loss detail: sampled states; sub-sample glitches can be missed')
  for ext in ['png','pdf']:fig.savefig(out/(file.stem+'.'+ext),dpi=160,bbox_inches='tight')
  plt.close(fig)
 summary.append(row)
(out/'summary.json').write_text(json.dumps({'watch_hz_nominal_inferred':hz,'clock_warning':'CSR383 declares120236100 but watch/SYS ratio and SCK spacing imply watch about40.0787MHz. This is not a calibrated frequency-counter measurement.','trials':summary},indent=2)+'\n')
print(json.dumps(summary,indent=2))
