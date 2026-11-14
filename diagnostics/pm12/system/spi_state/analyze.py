#!/usr/bin/env python3
"""Decode raw three-word records and correlate sampled SPI state with resets."""
import argparse,json,collections,csv
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('--result',type=Path,required=True);p.add_argument('--out',type=Path,required=True);a=p.parse_args();a.out.mkdir(exist_ok=True,parents=True);r=json.loads(a.result.read_text());rows=[];events_out=[]
for t in r['trials']:
 if 'raw_words'not in t:continue
 w=t['raw_words'];assert len(w)==3*t['count'];events=[]
 for i in range(0,len(w),3):
  tick,state,detail=w[i:i+3];e=dict(tick=tick,nominal_ms=tick/40078700*1000,fixed_lock=state&1,cap_lock=(state>>1)&1,sys_reset=(state>>2)&1,sel=(state>>3)&1,sck=(state>>4)&1,mosi=(state>>5)&1,miso_data=(state>>6)&1,lock_loss_latched=(state>>7)&1,mmcm_rst=(state>>8)&1,mmcm_powerdown=(state>>9)&1,gt_lock=(state>>10)&1,bit_count=(state>>16)&31,reading=(state>>21)&1,address=(state>>22)&255,spi_stable=bool(state>>31),shift=detail&65535,ref_age=(detail>>16)&255,max_ref_age=(detail>>24)&255)
  assert not events or tick>events[-1]['tick'];events.append(e)
 # Initial8 ticks are explicit ARM/latch settling, not event qualification.
 valid=[x for x in events if x['tick']>8];resets=[];loss=[];last_sel_low=None
 prev=events[0]
 for e in events[1:]:
  if prev['sel']and not e['sel']:last_sel_low=e['tick']
  if e['tick']>8 and e['sys_reset']and not prev['sys_reset']:
   resets.append(dict(**e,since_sel_low_nominal_us=(e['tick']-last_sel_low)/40078700*1e6 if last_sel_low is not None else None))
  if e['tick']>8 and not e['fixed_lock']and prev['fixed_lock']:loss.append(e)
  prev=e
 trigger=any(x['sys_reset']or x['lock_loss_latched']for x in valid)
 assert bool(t['status']&8192)==trigger,(t['label'],'trigger/status mismatch')
 sck_edges=sum(x['sck']!=y['sck']for x,y in zip(events,events[1:]));overflow=t['count']>=511
 if t['address']is not None and not trigger and not overflow:assert sck_edges==64,(t['label'],sck_edges)
 rows.append(dict(label=t['label'],divider=t['divider'],address=t['address'],events=len(events),sck_edges=sck_edges,overflow=overflow,trigger=trigger,sys_reset_edges=len(resets),lock_falls=len(loss),reset_states=resets))
 for e in events:events_out.append(dict(label=t['label'],divider=t['divider'],**e))
summary=dict(completed=r.get('completed',False),restored=r.get('restored',False),captures=len(rows),stimulated=sum(x['address']is not None for x in rows),reset_captures=sum(x['sys_reset_edges']>0 for x in rows),loss_triggered_captures=sum(x['trigger']for x in rows),overflow_captures=sum(x['overflow']for x in rows),rows=rows,adc_validated=r.get('adc_validated'),timing_limit='Nominal running MCLK1 tick scale. Common watch/reference stop is not represented. SPI debug buses are sampled multibit; stable flag is not an atomic CDC guarantee. Ignore first8 ARM-settling ticks.')
(a.out/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
with (a.out/'events.csv').open('w',newline='')as f:
 writer=csv.DictWriter(f,fieldnames=list(events_out[0]),lineterminator='\n');writer.writeheader();writer.writerows(events_out)
print(json.dumps({k:v for k,v in summary.items()if k!='rows'},indent=2))
