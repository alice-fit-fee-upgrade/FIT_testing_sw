"""Analyze retained full-span samples after independent voltage restoration.

Raw controller receipt is preserved, including the rejected stored-code
restoration. Never turn that process exit into a claimed end-to-end PASS.
"""
import argparse,json,statistics
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('report',type=Path);p.add_argument('--restoration',type=Path,required=True);p.add_argument('--out',type=Path,required=True)
a=p.parse_args();source=json.loads(a.report.read_text());restored=json.loads(a.restoration.read_text());assert restored['pass_'] and restored['dac_restore_codes']==dict(B=0,C=0,D=0)
expected={'B':-2.048/65536*100/5100,'C':-2.048/65536*100/10000,'D':2.048/65536*5100/9800}
result=dict(pass_=False,curves={},physical_board_serial=1803,points_per_dac=65,replicates_per_point=3,dac_A='Not swept',restoration='B/C/D explicit raw0000; independently checked against initial voltages',restored_voltage_deltas=restored['baseline_voltage_deltas'],monitor_inhibited=bool(restored['monitor_final_latch']&8),tca_final=restored['tca_final'],controller_initial_pass=source['pass_'],controller_initial_error=source.get('error'),state_correction='Stored parameter codes are not active DAC readback. The first restoration to computed STORED codes was rejected by the voltage guard. Separate raw-zero restoration reproduced the initial analog state; future runner requires explicit known restore codes.',limits=['65 full-span points, not exhaustive65536-code INL/DNL','Measured complete DAC/resistor/amplifier/mux/DMM chain','Initial physical baseline is recovered in voltage; original active DAC register contents were not readable'])
for output in 'BCD':
    rows=[r for r in source['measurements'] if r['stage']=='curve' and r['dac']==output]
    codes=sorted(set(r['code'] for r in rows));assert len(codes)==65 and codes[0]==0 and codes[-1]==65535
    assert all(sum(r['code']==c for r in rows)==3 for c in codes)
    means=[statistics.mean(r['volts'] for r in rows if r['code']==c) for c in codes]
    fit=statistics.linear_regression(codes,means);residual=[v-fit.intercept-fit.slope*c for c,v in zip(codes,means)]
    interior=[i for i,c in enumerate(codes) if .05*65535<=c<=.95*65535]
    core=statistics.linear_regression([codes[i] for i in interior],[means[i] for i in interior]);core_res=[means[i]-core.intercept-core.slope*codes[i] for i in interior]
    result['curves'][output]=dict(signal=rows[0]['signal'],codes=codes,volts=means,min_code_voltage=means[0],max_code_voltage=means[-1],slope_volts_per_code=fit.slope,intercept_volts=fit.intercept,expected_slope_volts_per_code=expected[output],gain_error_percent=(fit.slope/expected[output]-1)*100,monotonic_expected_direction=all((b-a)*expected[output]>=0 for a,b in zip(means,means[1:])),residual_volts=residual,max_abs_fit_residual_volts=max(map(abs,residual)),interior_slope_volts_per_code=core.slope,interior_gain_error_percent=(core.slope/expected[output]-1)*100,interior_intercept_volts=core.intercept,interior_max_abs_residual_volts=max(map(abs,core_res)),zero_code_residual_from_interior_fit_volts=means[0]-core.intercept)
result['pass_']=all(r['monotonic_expected_direction'] for r in result['curves'].values()) and result['monitor_inhibited'] and all(v==0 for v in result['tca_final'].values())
result['supply_baseline_volts']={r['signal']:r['volts'] for r in source['measurements'] if r['stage']=='baseline' and r['signal'] in ('N5V5_PM12','P5V5_PM12')}
a.out.parent.mkdir(parents=True,exist_ok=True);a.out.write_text(json.dumps(result,indent=2)+'\n')
for output,r in result['curves'].items():print(output,r['min_code_voltage'],r['max_code_voltage'],'gain error%',r['interior_gain_error_percent'],'zero residual uV',r['zero_code_residual_from_interior_fit_volts']*1e6)
if not result['pass_']:raise SystemExit(1)
