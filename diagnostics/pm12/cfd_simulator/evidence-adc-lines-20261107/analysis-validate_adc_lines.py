"""Independently rebuild each selected-bank ADC histogram from retained raw data."""
import argparse
from collections import Counter
import json
from pathlib import Path
import struct


def validate(directory):
    report=json.loads((directory/'status.json').read_text())
    if not report['pass']:raise ValueError('Acquisition did not complete cleanly')
    indices={0:0,1:0};previous=None
    for row in report['measurements']:
        bank=row['bank']
        if bank!=row['injection_bank']:raise ValueError('Selected-bank line scans only')
        path=directory/f'mux{bank}-point{indices[bank]:03d}-bank{bank}.bin';indices[bank]+=1
        raw=[w[0] for w in struct.iter_unpack('<H',path.read_bytes())]
        if len(raw)!=4096 or not all(w<16384 and ((w>>12)&1)==bank for w in raw):raise ValueError('Raw size/tag/reserved-bit error')
        edges=[i for i in range(1,len(raw)) if not raw[i-1]&8192 and raw[i]&8192]
        if len(edges)<900 or any(b-a!=4 for a,b in zip(edges,edges[1:])):raise ValueError('Strobe error')
        histogram=Counter(raw[i-1]&4095 for i in edges[1:])
        if dict(histogram)!={int(k):v for k,v in row['histogram'].items()}:raise ValueError('Raw/histogram mismatch')
        if previous is not None and row['generation']!=(previous+1)&0xffffffff:raise ValueError('Capture generation discontinuity')
        previous=row['generation']
    count=sum(indices.values())
    if not count:raise ValueError('No raw buffers')
    return {'pass':True,'captures':count,'raw_words':count*4096,'histograms_exact':True,
            'ev_tags_exact':True,'all_strobe_periods':4,'generations_contiguous':True}


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('directory',type=Path);p.add_argument('--out',type=Path,required=True);a=p.parse_args()
    result=validate(a.directory);a.out.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result))

if __name__=='__main__':main()
