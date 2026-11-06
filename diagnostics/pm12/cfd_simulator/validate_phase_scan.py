#!/usr/bin/env python3
"""Recheck every retained raw/phase record and point estimate, no hardware I/O."""
import argparse
import csv
import gzip
import json
from pathlib import Path
import sys
from phase_estimator import estimate


def validate(directory, kasli_root, data_only=False):
    sys.path.insert(0,str(kasli_root))
    from host.hdmi_check import check_phase_records
    report=json.loads((directory/'report.json').read_text())
    restored = report.get('pass_',False) and report['result'].get('restore_phase_check') is True
    if not restored and not data_only:
        raise ValueError('scan did not restore phase; use --data-only to verify retained data without accepting restoration')
    if report['final_status']['output_mask'] or report['final_status']['enabled']:
        raise ValueError('Kasli outputs not released')
    points=[row for row in map(json.loads,(directory/'events.jsonl').read_text().splitlines()) if row['kind']=='point']
    grid=[p['code'] for p in points if p['stage']=='sweep']
    if grid!=report['codes']:raise ValueError('retained DAC code grid mismatch')
    with (directory/'phase.csv').open() as f:
        csvrows=list(csv.DictReader(f))
    csvindex={(r['stage'],r['code'],int(r['logical'])):r for r in csvrows}
    expected_rows=sum(len(p['estimates']) for p in points)
    if len(csvrows)!=expected_rows or len(csvindex)!=expected_rows:raise ValueError('missing/duplicate CSV rows')
    records=0;captures=0;edges=0
    for point in points:
        code='initial' if point['code'] is None else str(point['code'])
        pools={int(lane):[] for lane in point['estimates']}
        for repeat in range(report['args']['repeats']):
            with gzip.open(directory/f"{point['stage']}-{code}-{repeat}.json.gz",'rt') as f:data=json.load(f)
            captures+=1
            if {r['logical'] for r in data['channels']}!=set(pools):raise ValueError('raw lane map mismatch')
            for row in data['channels']:
                records+=check_phase_records(row);pools[row['logical']].append(row)
        for lane,rows in pools.items():
            result=estimate(rows,data['sample_ps'],data['period_bins']);old=point['estimates'][str(lane)]
            for key in ('mean_bin','spread_bins','rising_edges'):
                if abs(result[key]-old[key])>1e-12:raise ValueError('raw/estimate mismatch')
            csvcode='' if point['code'] is None else str(point['code'])
            if abs(float(csvindex[point['stage'],csvcode,lane]['mean_ns'])-result['mean_ns'])>1e-12:
                raise ValueError('raw/CSV mismatch')
            edges+=result['rising_edges']
    return dict(pass_=restored,raw_data_pass=True,restore_phase_pass=restored,
                restore_command_accepted=report['result'].get('restore_command_accepted',False),sweep_points=len(grid),captures=captures,phase_records_exact=records,
                rising_edges_analyzed=edges,estimates_exact=expected_rows,dac_final_code=report['result']['restore_code'],
                restore_phase_deltas_bins=report['result']['restore_phase_deltas_bins'])


def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('directory',type=Path)
    parser.add_argument('--kasli-root',type=Path,default=Path('/home/codex-hil/kasli-phase-tester'))
    parser.add_argument('--data-only',action='store_true',help='Verify raw data while preserving a failed phase-restoration result')
    args=parser.parse_args();result=validate(args.directory,args.kasli_root,args.data_only)
    (args.directory/'validation.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))

if __name__=='__main__':main()
