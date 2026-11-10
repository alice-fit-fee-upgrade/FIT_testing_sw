"""Regenerate four-CFD SMU DAC figures and summary from raw CSV."""
import argparse, csv, json
from pathlib import Path
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('directory', type=Path)
    a = p.parse_args()
    d = a.directory
    rows = list(csv.DictReader((d / 'samples.csv').open()))
    summary = []
    curves = {}
    fig, axes = plt.subplots(1, 3, figsize=(14, 4.5), constrained_layout=True)
    for ax, dac in zip(axes, 'BCD'):
        for ch in sorted({int(r['pm_channel']) for r in rows}, reverse=True):
            data = [r for r in rows if r['dac'] == dac and int(r['pm_channel']) == ch]
            if not data:
                continue
            codes = sorted({int(r['code']) for r in data})
            vv = [np.array([float(r['volts']) for r in data if int(r['code']) == c]) for c in codes]
            means = np.array([v.mean() for v in vv])
            sd = np.array([v.std(ddof=1) for v in vv])
            curves[(dac,ch)]=(codes,means)
            ax.plot(codes, means, '.-', markersize=3, label=f'PM channel {ch}')
            slope, offset = np.polyfit(codes, means, 1)
            res = means - (slope * np.array(codes) + offset)
            expected = {'B': -2.048 / 65536 * 100 / 5100, 'C': -2.048 / 65536 * 100 / 10000, 'D': 2.048 / 65536 * 5100 / 9800}[dac]
            core = (np.array(codes) >= 0.05 * 65535) & (np.array(codes) <= 0.95 * 65535)
            core_slope, core_offset = np.polyfit(np.array(codes)[core], means[core], 1)
            summary.append(dict(pm_channel=ch, dac=dac, points=len(codes), samples=len(data), min_code_V=float(means[0]), max_code_V=float(means[-1]), span_V=float(means[-1] - means[0]), max_repeatability_std_uV=float(sd.max() * 1000000.0), linear_fit_residual_peak_mV=float(abs(res).max() * 1000.0), interior_gain_error_percent=float((core_slope / expected - 1) * 100), zero_code_residual_mV=float((means[0] - core_offset) * 1000.0), largest_reverse_step_mV=float(max(0, -(np.diff(means) * np.sign(expected)).min()) * 1000.0)))
        ax.set(title=f'DAC {dac}', xlabel='DAC code', ylabel='Monitor voltage (V)')
        ax.grid(alpha=0.3)
        ax.legend()
    fig.suptitle('CFD simulator DAC transfer — Keysight B2910BL, 0 A, local sensing')
    for ext in ['png', 'pdf', 'svg']:
        fig.savefig(d / f'dac-transfer.{ext}', dpi=180)
    diff_fig,diff_axes=plt.subplots(1,3,figsize=(14,4.5),constrained_layout=True)
    reference=max(ch for _,ch in curves)
    for ax,dac in zip(diff_axes,'BCD'):
        base_codes,base=curves[(dac,reference)]
        for (output,ch),(codes,means) in curves.items():
            if output==dac:
                if codes!=base_codes:raise ValueError('Inconsistent DAC grids')
                ax.plot(codes,(means-base)*1000,'.-',markersize=3,label=f'PM channel {ch}')
        ax.set(title=f'DAC {dac}',xlabel='DAC code',ylabel=f'Difference vs PM {reference} (mV)');ax.grid(alpha=.3);ax.legend()
    diff_fig.suptitle('CFD simulator — channel differences, same scan and instrument')
    for ext in ['png','pdf','svg']:diff_fig.savefig(d/f'dac-channel-differences.{ext}',dpi=180)
    (d / 'summary.json').write_text(json.dumps(summary, indent=2) + '\n')
    with (d / 'summary.csv').open('w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=summary[0].keys())
        w.writeheader()
        w.writerows(summary)
    print(json.dumps(summary, indent=2))
if __name__ == '__main__':
    main()
