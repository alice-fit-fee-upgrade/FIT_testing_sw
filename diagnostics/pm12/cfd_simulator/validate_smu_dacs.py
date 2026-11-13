"""Validate completeness, sample status, DAC restore receipts and safe final state."""
import argparse
import csv
import datetime
import json
from pathlib import Path
from smu_voltage import parse_voltage


def validate(directory):
    report = json.loads((directory / 'scan-report.json').read_text())
    with (directory/'samples.csv').open() as stream:
        rows=list(csv.DictReader(stream))
    assert report.get('scan_complete') and not report.get('error'), 'Scan did not finish'
    assert len(rows) == len(report['scanned_modules']) * 3 * 101 * 3
    assert len(rows) == len(report['measurements'])
    codes = [round(i * 65535 / 100) for i in range(101)]
    for ch in report['scanned_modules']:
        for dac, mux in [('B',3),('C',0),('D',1)]:
            selected = [r for r in rows if int(r['pm_channel']) == ch and r['dac'] == dac]
            assert sorted({int(r['code']) for r in selected}) == codes
            for code in codes:
                assert sorted(int(r['sample']) for r in selected if int(r['code']) == code) == [0,1,2]
            assert all(int(r['mux_channel']) == mux for r in selected)
    for r in rows:
        parse_voltage(','.join(r[k] for k in ('volts','instrument_time','status')))
    assert report['final'] == {'OUTP?':'0','OUTP:ON:AUTO?':'0','OUTP:OFF:MODE?':'HIZ'}
    post_path=directory/'post-cleanup.json'
    post=None
    if post_path.exists():
        post=json.loads(post_path.read_text())
        assert post['pass_'] is True
        assert post['identity']==report['identity']
        assert set(post['connected_modules'])==set(report['connected_modules'])
        assert set(post['monitor_GPIOA'])=={str(ch) for ch in report['connected_modules']}
        assert all(type(v) is int and v&8 for v in post['monitor_GPIOA'].values())
        assert set(post['final_tca'].values())=={0}
        settings=post['smu_settings']
        assert settings['OUTP?']=='0' and settings['OUTP:ON:AUTO?']=='0' and settings['OUTP:OFF:MODE?']=='HIZ'
        assert settings['SOUR:FUNC:MODE?']=='CURR' and float(settings['SOUR:CURR?'])==0 and settings['SENS:REM?']=='0'
        assert int(settings['SYST:ERR?'].split(',')[0])==0
        assert datetime.datetime.fromisoformat(post['started_utc'])>=datetime.datetime.fromisoformat(report['finished_utc'])
    else:
        assert set(report['final_tca'].values()) == {0}

    restores = [r['reply'].strip() for r in report['restoration']]
    assert len(restores) == len(report['scanned_modules']) * 3
    assert all(restores.count(f'DAC SENT {d} 0000') == len(report['scanned_modules']) for d in 'BCD')
    for ch in report['scanned_modules']:
        for dac in 'BCD':
            matches=[r for r in report['restoration'] if r['command']==f'@DAC {ch} W {dac} 0000']
            assert len(matches)==1 and matches[0]['reply'].strip()==f'DAC SENT {dac} 0000'
    return dict(pass_=True, samples=len(rows), transfer_curves=len(report['scanned_modules'])*3,
                points_per_curve=101, samples_per_point=3, safe_final_state=True,
                explicit_post_cleanup=post is not None, original_tca_masks=report['final_tca'],
                scope='Acquisition completeness/status/restore checks; no calibrated analog acceptance limits')


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('directory',type=Path);d=p.parse_args().directory
    result=validate(d);(d/'validation.json').write_text(json.dumps(result,indent=2)+'\n');print(result)

if __name__=='__main__':main()
