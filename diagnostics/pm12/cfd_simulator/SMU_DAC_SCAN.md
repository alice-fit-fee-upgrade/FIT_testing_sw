# CFD DAC voltage scans with Keysight SMU2

Instrument identity is B2910BL **MY63320299**, last observed at
192.168.2.19:5025. Verify serial, not IP alone. The source/voltmeter handoff is
[lab-instruments](https://github.com/codex-hil/lab-instruments/blob/docs%2Fb2910bl-second/docs/b2910bl-smu2.md).

On 2026-11-10 the owner confirmed that the monitor cable connects to **Force
HI/LO, with Sense unconnected**, and explicitly authorized current source **0 A,
OUTP ON** to operate as a voltmeter. Use local sensing (SENS:REM OFF), not remote
Sense. Auto-output-on stays OFF. Never configure a 0 V voltage source: it would
load/clamp the shared analog monitor. With OUTP OFF, fresh acquisition did not
produce usable measurements; FETC alone can return stale data.

All four simulators on physical PM channels **12,10,8,6** share the monitor wire.
The script inhibits every mux first and between DAC curves, and verifies MCP
register/pin readbacks. It enables one monitor at a time with break-before-make.
The complete connected inventory must be updated if more simulators are added.
Registers unrelated to the low four monitor pins are preserved. Existing PM12,
MCU, Kasli and SMU leases are held over configure/acquire/cleanup.

```sh
/home/codex-hil/kasli-diot-bringup/.venv/bin/python \
  diagnostics/pm12/cfd_simulator/smu_dac_sweep.py \
  --out /absolute/new/run-directory --confirm-force-voltmeter \
  --channels 10 8 6
```

101 integer codes span 0..65535. Each point has 100 ms settling followed by
three fresh READ? samples at 1 PLC, voltage range20V, source range1uA,
voltage compliance6V. B→monitor3 (DRV_OFFSET), C→monitor0 (CFD_OFFSET),
D→monitor1 (CFD_CMP_OFFSET). Phase DAC A is unchanged. **Every exercised B/C/D
output is explicitly set to 0000 on exit**; original active codes are unknown,
and STORED firmware parameters are not active DAC readback. Monitor muxes are
inhibited and SMU output is set OFF/HIZ. Do not unplug/reset devices mid-scan.

Status validation uses the manufacturer's [SCPI reference, Table1-2](https://www.keysight.com.cn/cn/zh/assets/9921-01285/programming-guides/B2900B-BL-Series-Precision-Source-Measure-Unit-SCPI-Command-Reference.pdf):
bit0 must indicate current-source mode; bits1..5 and13 reject compliance,
protection or overflow. Unspecified bits are ignored. For example1729 is not
an error. Raw status and instrument timestamp accompany each voltage sample.

Regenerate English plots, summary and editable LaTeX:

```sh
/srv/codex-hil-nvme/tool-venvs/fit-measurements/bin/python \
  diagnostics/pm12/cfd_simulator/plot_smu_dacs.py /absolute/run-directory
python3 diagnostics/pm12/cfd_simulator/report_smu_dacs.py /absolute/run-directory
/srv/codex-hil-nvme/pm12-acceptance-20261107/toolchain/tectonic \
  --outdir /absolute/run-directory /absolute/run-directory/report.tex
```

This is a functional transfer scan, not exhaustive16-bit INL/DNL or an accuracy
certificate. Validate wiring and fresh measurements on known monitor levels
before scanning. No firmware/FPGA/CPLD programming, flash changes or DAC A writes
are needed. The preflight's 1.3V rail check confirms plausible live readings,
not traceable calibration.

## Measured 2026-11-10

[Editable PDF report](evidence-smu-dac-20261110/report.pdf),
[LaTeX](evidence-smu-dac-20261110/report.tex),
[raw samples](evidence-smu-dac-20261110/samples.csv),
[comparison plot](evidence-smu-dac-20261110/dac-transfer.png).

| Physical PM channel | DAC B code0→65535 (V) | DAC C code0→65535 (V) | DAC D code0→65535 (V) |
|---|---|---|---|
| 10 | 1.044730 → 1.004507 | 1.034757 → 1.014360 | 0.004743 → 1.069480 |
| 8 | 1.044680 → 1.004540 | 1.034793 → 1.014350 | 0.005847 → 1.066383 |
| 6 | 1.045580 → 1.005527 | 1.035827 → 1.015247 | 0.005947 → 1.066433 |

All9 sampled curves are monotonic. Interior gain deviations from nominal
schematic scaling are within0.62%; DAC D zero-code departure from an interior
5--95% fit is1.4--6.3mV. These are full-chain observations, not raw DAC INL/DNL.
The B/C spans near40/20mV are expected from resistor scaling, not a1V clamp.

Acquisition/status/restoration validation:9 curves,101 codes,3 repeats,
**2727 valid samples**. Software:38 tests passed. Final readbacks confirm
SMU OFF/HIZ, auto-ON OFF, source0A, local sensing, fixed1uA source range,
no SCPI errors; four muxes inhibited, both TCA masks0, all9 exercised DACs
restored to raw0000. Phase DAC A and unrelated GPIO were preserved.
