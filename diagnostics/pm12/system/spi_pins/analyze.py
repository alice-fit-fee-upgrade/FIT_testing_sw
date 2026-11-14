#!/usr/bin/env python3
"""Offline pin-control readback, MCU mapping and SYS restart summary."""
import argparse,json,collections
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('--result',type=Path,required=True);p.add_argument('--out',type=Path,required=True);a=p.parse_args();r=json.loads(a.result.read_text());g=collections.defaultdict(lambda:dict(trials=0,cycles=0,counter_decreases=0))
assert r.get('completed') and r.get('restored')
for m in r['pin_mapping']:assert m['expected_delta']==m['actual_delta']
for x in r['cases']:
 key='MOSI-selected' if x['label'].startswith('MOSI-selected') else x['label'].split('-')[0];v=[y for y in x['trace'] if 'ticks'in y];n=sum(z['ticks']<y['ticks'] for y,z in zip(v,v[1:]));assert n==x['counter_decreases']
 for row in x['trace']:
  assert row['enable']==1 and row['state']&15==9
  assert row['pin_control']>>16==0x5350 and ((row['pin_control']>>8)&255) in [8|x['low'],8|x['high']]
 g[key]['trials']+=1;g[key]['cycles']+=x['cycles'];g[key]['counter_decreases']+=n
controls={}
for key in ['spi_control_before','spi_control_after']:
 rows=r[key];assert len(rows)==12
 assert all(x['value']==[0x4844,0x4d49,1][x['address']] for x in rows)
 controls[key]=dict(frames=len(rows),counter_decreases=sum(x['counter_decrease'] for x in rows),counter_read_timeouts=sum(x.get('transport_timeout',False) for x in rows))
assert r['pm_after']==[0x504d1202,0x10002,0xc7531465] and r['tdc_frontend']==0xfff and r['held_enable']==1 and r['held_state']&15==9
s=dict(groups=dict(g),controls=controls,physical_mapping_pass=True,raw_cases_validated=True,normal_spi_reproduces_both_sides=all(x['counter_decreases']>0 for x in controls.values()),restored=True,scope='Stable DC pin mapping verified by MCU; raw trials contain no complete SPI frames. Counter decreases are a conservative reset observation, not continuous MMCM/OE monitoring.')
a.out.write_text(json.dumps(s,indent=2)+'\n');print(json.dumps(s,indent=2))
