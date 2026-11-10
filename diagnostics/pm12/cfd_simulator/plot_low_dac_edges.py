"""Retain only in-selection curve data; independent final check is mandatory.

The archived fine-run guard sampled after mux inhibit. Those target-restored
rows are invalid and are NEVER used here. The host ordering is now corrected.
"""
import argparse,json,statistics
from pathlib import Path
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
p=argparse.ArgumentParser();p.add_argument('report',type=Path);p.add_argument('--final-check',type=Path,required=True);p.add_argument('--out',type=Path,required=True)
a=p.parse_args();source=json.loads(a.report.read_text());final=json.loads(a.final_check.read_text());assert final['pass_'] and final['monitor_final_latch']&8 and all(v==0 for v in final['tca_final'].values())
a.out.mkdir(parents=True,exist_ok=True);fig,axes=plt.subplots(1,3,figsize=(12,4),layout='constrained');result=dict(curve_data_complete=True,source_controller_pass=source['pass_'],source_controller_error=source.get('error'),excluded_stage='target-restored: measurement occurred after mux inhibit; corrected in current runner',independent_final_voltage_check=final['baseline_voltage_deltas'],curves={})
for output,ax in zip('BCD',axes):
    rows=[r for r in source['measurements'] if r['stage']=='curve' and r['dac']==output]
    codes=sorted(set(r['code'] for r in rows));assert len(codes)==13 and codes[0]==0 and codes[-1]==1024
    assert all(sum(r['code']==c for r in rows)==3 for c in codes)
    volts=[statistics.mean(r['volts'] for r in rows if r['code']==c) for c in codes];deltas=[(v-volts[0])*1e6 for v in volts]
    result['curves'][output]=dict(signal=rows[0]['signal'],codes=codes,volts=volts,delta_from_zero_microvolts=deltas,zero_code_voltage=volts[0],highest_tested_code_within_10_microvolts_of_zero=max(c for c,d in zip(codes,deltas) if abs(d)<=10))
    ax.plot(codes,deltas,'o-');ax.set_xscale('symlog',linthresh=1);ax.grid(alpha=.3);ax.set_title(f"DAC {output}: {rows[0]['signal']}");ax.set_xlabel('DAC code (symlog)');ax.set_ylabel('Change from code0 (µV)')
fig.suptitle('PM12 channel12 — lower-edge refinement,3 readings/code\nWhole-chain response; small changes include noise/rounding, no DNL claim',fontsize=11)
for extension in ('png','svg'):fig.savefig(a.out/f'dac-low-edge.{extension}',dpi=180)
(a.out/'low-edge-analysis.json').write_text(json.dumps(result,indent=2)+'\n')
for output,row in result['curves'].items():print(output,'within10uV through tested code',row['highest_tested_code_within_10_microvolts_of_zero'])
