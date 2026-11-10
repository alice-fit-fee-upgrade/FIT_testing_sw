#!/usr/bin/env python3
"""Summarize recorded A/B/A samples; no hardware access."""
import argparse,csv,json,struct
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('root',type=Path);a=p.parse_args()
with (a.root/'adc-comparison.csv').open('w') as f:
 w=csv.writer(f);w.writerow(['channel','A_first_min','A_first_max','B_min','B_max','A_repeat_min','A_repeat_max','A_changed_samples','A_clock_nominal_Hz','B_clock_nominal_Hz'])
 summaries=[json.loads((a.root/n/'summary.json').read_text()) for n in ['physical-0-bank0','physical-1-bank1','physical-2-bank0']]
 for ch in range(12):
  codes=[[v&4095 for v in struct.unpack('<4096H',(a.root/n/f'ch{ch+1:02d}.bin').read_bytes())] for n in ['physical-0-bank0','physical-1-bank1','physical-2-bank0']]
  w.writerow([ch+1,*[x for v in codes for x in [min(v),max(v)]],sum(x!=y for x,y in zip(codes[0],codes[2])),summaries[0]['channels'][ch]['clock_hz_nominal'],summaries[1]['channels'][ch]['clock_hz_nominal']])
print(a.root/'adc-comparison.csv')
