"""Offline FFT of strobe-decimated PM12 ADC buffers; no hardware access."""
import argparse
import hashlib
import json
from pathlib import Path
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt


def analyze(path, fs):
    data = path.read_bytes()
    raw = np.frombuffer(data, dtype='<u2')
    edges = np.flatnonzero(((raw[:-1] & 8192) == 0) & ((raw[1:] & 8192) != 0)) + 1
    assert len(edges) > 100 and np.all(np.diff(edges) == 4), 'Unexpected ADC strobe spacing'
    samples = (raw[edges[1:] - 1] & 4095).astype(float)
    # Retain complete four-sample periods for coherent Fs/4 and Fs/2 estimates.
    x = samples[:len(samples) // 4 * 4]
    n = len(x)
    centered = x - x.mean()
    template = np.array([x[k::4].mean() for k in range(4)])
    residual = x - template[np.arange(n) % 4]
    f = np.fft.rfftfreq(n, 1 / fs)
    window = np.hanning(n)
    def psd(v):
        power = abs(np.fft.rfft((v-v.mean()) * window))**2 / (fs * sum(window**2))
        power[1:-1] *= 2
        return power
    # Parseval power per bin: Nyquist has no negative-frequency counterpart.
    power = abs(np.fft.rfft(centered))**2 / n**2
    power[1:-1] *= 2
    stats = dict(input_sha256=hashlib.sha256(data).hexdigest(), raw_records=len(raw),
                 adc_samples_available=len(samples), fft_samples=n, fs_hz=fs,
                 bin_spacing_hz=fs/n, mean_code=float(x.mean()),
                 raw_rms_codes=float(centered.std()), residual_rms_codes=float(residual.std()),
                 fs_over_4_rms_codes=float(np.sqrt(power[n//4])),
                 fs_over_2_rms_codes=float(np.sqrt(power[n//2])),
                 parseval_error_codes_squared=float(abs(power.sum()-centered.var())))
    return f, psd(centered), psd(residual), stats


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--root', type=Path, required=True)
    p.add_argument('--out', type=Path, required=True)
    p.add_argument('--fs-hz', type=float, default=80157400., help='ADC clock; default 2 x stated LHC 40.0787 MHz')
    args = p.parse_args()
    args.out.mkdir(parents=True, exist_ok=False)
    fig, axes = plt.subplots(2, 1, figsize=(11, 7), layout='constrained', sharex=True)
    summary = {}
    full_scale_sine_rms_squared = 2048**2/2
    for bank, color in enumerate(['#1864ab', '#d9480f']):
        path = args.root / f'mux{bank}-point050-bank{bank}.bin'
        f, raw, residual, stats = analyze(path, args.fs_hz)
        summary['AB'[bank]] = stats
        for ax, spectrum in zip(axes, [raw, residual]):
            ax.plot(f[1:]/1e6, 10*np.log10(np.maximum(spectrum[1:]/full_scale_sine_rms_squared, 1e-30)),
                    lw=1, color=color, label='ADC '+'AB'[bank])
    for ax in axes:
        for frequency in [args.fs_hz/4, args.fs_hz/2]:
            ax.axvline(frequency/1e6, color='grey', linestyle=':', lw=1)
        ax.set(ylabel='PSD [dBFS/Hz]', xlim=(0,args.fs_hz/2e6), ylim=(-165,-80))
        ax.legend(); ax.grid(alpha=.2)
    axes[0].set_title('Raw ADC samples — DC removed, Hann window')
    axes[1].set_title('After subtraction of the four-sample template — Hann window')
    axes[1].set_xlabel('Frequency [MHz]')
    fig.suptitle('PM12 channel 12 — zero-input ADC buffer FFT\nDAC CH0 = CH1 = 1 V; integrator disabled', fontweight='bold')
    fig.get_layout_engine().set(rect=(0,.09,1,.86))
    fig.text(.08,.02,'ADC rate: 80.1574 MS/s, inferred from stated 40.0787 MHz reference; not frequency-counter verified.\nOne sample per ADC strobe. 0 dBFS = RMS power of a full-scale 12-bit sine. Template subtraction is software only.',fontsize=9)
    for ext in ['png','pdf']:
        fig.savefig(args.out/f'adc-zero-fft.{ext}',dpi=180)
    (args.out/'fft-summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps(summary,indent=2))

if __name__ == '__main__':
    main()
