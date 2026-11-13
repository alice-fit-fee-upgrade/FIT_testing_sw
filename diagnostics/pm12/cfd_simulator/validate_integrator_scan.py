"""Validate raw ADC evidence, zero/sign tests and retained hardware state offline."""
import argparse,hashlib,json,statistics,struct,sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'ipbus_adc'))
from adc_decode import decode


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--root',type=Path,required=True);p.add_argument('--analysis',type=Path,required=True);a=p.parse_args()
    x=json.loads((a.analysis/'analysis.json').read_text());buffers=0;count=0;generations=[]
    for name in ['probe01','matrix01','sweep01','fine01','validation01','validation02']:
        root=a.root/name;r=json.loads((root/'status.json').read_text());assert r['pass_']
        if r['physical_channel']!=12 or r.get('dac_channels',[0,1])!=[0,1]:raise ValueError('Reference experiment validation is channel12-specific; use a channel-aware validator')
        rows=r.get('disabled_controls',[])+r.get('final_captures',[])+[c for point in r['points'] for c in point['captures']]
        for row in rows:
            words=struct.unpack('<4096H',(root/row['file']).read_bytes());samples,_=decode(list(words),row['bank'])
            assert min(samples)==row['minimum'] and max(samples)==row['maximum'] and len(samples)==row['samples']
            assert abs(statistics.mean(samples)-row['mean'])<1e-9
            buffers+=1;count+=len(samples);generations.append(row['generation'])
    assert len(set(generations))==len(generations),'Duplicate generation across these runs'
    for file,expected in x['source_sha256'].items():
        original=Path(file);path=a.root/original.parent.name/original.name
        assert hashlib.sha256(path.read_bytes()).hexdigest()==expected
    observed={}
    for bank,label in enumerate('AB'):
        target=-.0064 if bank==0 else -.0074
        rows=[r for r in x['points'] if r['run']=='validation02' and r['bank']==bank and abs(r['offset_V']-target)<1e-8]
        assert len(rows)==2 and all(r['buffers']==8 and abs(r['mean_change'])<1 for r in rows)
        sign_points=[r for r in x['points'] if r['run']=='validation01' and r['bank']==bank]
        lo=-.0114 if bank==0 else -.0122;hi=-.0014 if bank==0 else -.0022
        lower=next(r for r in sign_points if abs(r['offset_V']-lo)<1e-8);upper=next(r for r in sign_points if abs(r['offset_V']-hi)<1e-8)
        assert lower['mean_change'] < -10 and upper['mean_change'] > 10
        observed[label]=dict(near_zero_change_codes=statistics.mean(r['mean_change'] for r in rows),negative_offset_change_codes=lower['mean_change'],positive_offset_change_codes=upper['mean_change'])
    final=json.loads((a.root/'validation02/status.json').read_text())
    assert all(abs(v-w)<6e-5 for v,w in zip(final['dac_final'][:2],[2.0446,1.0274]))
    assert final['dac_final'][2:]==final['dac_before'][2:]
    assert final['mcp_final']['18']&0x88==8 and final['mcp_final']['21']&32
    assert final['mcp_final']['0']==final['mcp_before']['0'] and final['mcp_final']['1']==final['mcp_before']['1']
    assert set(final['tca_final'].values())=={0} and final['final_captures'][-1]['bank']==0
    result=dict(pass_=True,raw_buffers=buffers,strobe_decimated_ADC_samples=count,analysis_accepted_buffers=x['retained_buffers'],analysis_rejected_buffers=len(x['rejected_buffers']),observations=observed,amplifiers_enabled=True,direct_ADC_bypass_isolated=True,other_DAC_outputs_unchanged=True,scope='Observed channel12 signed response and effective differential balance; not full board acceptance')
    (a.analysis/'validation.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
if __name__=='__main__':main()
