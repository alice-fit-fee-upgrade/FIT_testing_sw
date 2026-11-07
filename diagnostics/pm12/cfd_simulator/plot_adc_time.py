"""Plot zero-differential-input ADC buffers versus relative sample time."""
import argparse
import hashlib
import json
from pathlib import Path
import numpy as np
import sys
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'ipbus_adc'))
from adc_decode import decode
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--root', type=Path, required=True)
    p.add_argument('--out', type=Path, required=True)
    args = p.parse_args()
    args.out.mkdir(parents=True, exist_ok=False)
    fs = 80157400.
    fig, axes = plt.subplots(2, 1, figsize=(11, 7), layout='constrained')
    summary = {}
    for bank, color in enumerate(['#1864ab', '#d9480f']):
        data = (args.root/f'mux{bank}-point050-bank{bank}.bin').read_bytes()
        raw = np.frombuffer(data, dtype='<u2')
        decoded,timing = decode([int(w) for w in raw])
        x = np.array(decoded,dtype=float)
        t = np.arange(len(x))/fs
        label = 'ADC '+'AB'[bank]
        axes[0].plot(t*1e6, x, lw=.65, alpha=.8, color=color, label=label)
        axes[1].plot(t[:40]*1e9, x[:40], 'o-', lw=1, ms=4, color=color, label=label)
        summary[label] = dict(strobe_timing=timing,samples=len(x), fs_hz=fs, sample_interval_ns=1e9/fs,
                             first_to_last_sample_us=float(t[-1]*1e6),
                             mean_code=float(x.mean()), min_code=int(x.min()), max_code=int(x.max()),
                             source_sha256=hashlib.sha256(data).hexdigest())
    axes[0].set(title='Complete captured waveform', xlabel='Relative time [µs]', ylabel='ADC code')
    axes[1].set(title='First 40 samples — four-sample pattern', xlabel='Relative time [ns]', ylabel='ADC code')
    for ax in axes:
        ax.grid(alpha=.25)
        ax.legend(loc='upper right')
    fig.suptitle('PM12 channel 12 — ADC waveform versus time\nDAC CH0 = CH1 = 1 V; integrator disabled', fontweight='bold')
    fig.get_layout_engine().set(rect=(0,.09,1,.86))
    fig.text(.08,.02,'One sample per ADC strobe; ADC rate inferred from 2 × 40.0787 MHz reference. Raw ADC codes, no filtering.\nADC A and B were captured sequentially; time zero is local to each capture, not a shared trigger.',fontsize=9)
    for ext in ['png','pdf']:
        fig.savefig(args.out/f'adc-zero-time.{ext}',dpi=180)
    (args.out/'time-summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps(summary,indent=2))

if __name__ == '__main__':
    main()
