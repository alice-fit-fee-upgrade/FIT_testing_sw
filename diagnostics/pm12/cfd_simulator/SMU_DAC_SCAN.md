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
  --connected 12 10 8 6 --channels 10 8 6
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

For new1–4/5–8/9–12 fittings, use the [campaign workflow](../acceptance/CAMPAIGN.md). The 10November SMU report are historical examples; `report_smu_dacs.py` refuses other fitted/scanned channel sets instead of mislabeling them. New batch reports use `campaign_report.py`.

## Four-channel campaign fitting9–12

The currently connected monitor instrument is again Keysight B2910BL,
MY63320299; identify it before use even if it is called "Keithley" verbally.
The previous Force HI/LO,0A/local-sense authorization and connection apply.
All four physical monitor outputs share the wire; inhibit9/10/11/12 before
selecting any one. USB ADC/integrator injection remains separately on12 and
is not needed for these internal DAC voltage scans.

```sh
/home/codex-hil/kasli-diot-bringup/.venv/bin/python \
 diagnostics/pm12/cfd_simulator/smu_dac_sweep.py \
 --connected 9 10 11 12 --channels 9 10 11 12 \
 --confirm-force-voltmeter --out /absolute/NEW-SMU-SCAN
```

The runner first checks three fresh readings of the1.3V monitor on each fitted
module (plausibility0.9..1.6V), with all other monitor outputs inhibited.
It then acquires12curves/3636samples:101codes and3reads for B/C/D per module.
Phase DAC-A is untouched. B/C/D finish at0000, monitor outputs inhibited,
SMU OFF/HIZ. External MOD-DAC-28 outputs are not changed by this script.

`campaign_smu_adapter.py` independently checks native completeness/status,
CSV against JSON, fresh READ? receipts, producer source hashes and every
reference check. It creates one receipt per physical channel with B/C/D
curves. Explicit functional limits: span within5% of nominal schematic
scaling, reverse step at most0.2mV, repeat standard deviation at most1mV.
These are assembly screening limits, not a metrology certificate.

```sh
python3 diagnostics/pm12/cfd_simulator/validate_smu_dacs.py /absolute/SCAN
/srv/codex-hil-nvme/tool-venvs/fit-measurements/bin/python \
 diagnostics/pm12/cfd_simulator/plot_smu_dacs.py /absolute/SCAN
python3 diagnostics/pm12/acceptance/campaign_smu_adapter.py \
 --source /absolute/SCAN --out /absolute/NEW-NORMALIZED \
 --root /absolute/CAMPAIGN --batch ch09-12-attempt001
```

Import each generated ch09..ch12 folder with `campaign.py record`. Generate
one new campaign report after all four imports; matching DAC curves overlay
all measured physical channels. Preserve the previous report as a snapshot.

The runner now atomically checkpoints metadata at curve boundaries and every20
points, flushes raw CSV at every point, and routes SIGTERM through cleanup.
The identified SMU is brought to OFF/HIZ before touching shared monitor routes.
Between curves only the previously selected mux needs disabling: all other
muxes remain inhibited from initialization under the exclusive board lease;
no unrelated GPIO is written. Output-state/auto-on checks run per point, with
three fresh READ? acquisitions retained. Initial and final full-inventory mux
inhibition/readbacks remain in place. The0.1s settling,1PLC and three-sample
protocol are unchanged.

The first9–12 attempt retained all CSV rows but was terminated before writing
its final metadata; it is explicitly INCOMPLETE. The independent second scan
supplies selected coverage, with the first attempt retained in report history.

Before importing the new campaign method, run explicit post-scan verification:

```sh
/home/codex-hil/kasli-diot-bringup/.venv/bin/python \
 diagnostics/pm12/cfd_simulator/smu_finish_state.py \
 --directory /absolute/SCAN --connected 9 10 11 12
```

This separately records the identified meter's OFF/HIZ/0A/local-sense state,
checks every monitor inhibit pin and explicitly clears both upstream TCA masks.
It never rewrites the acquisition receipt. If the scan restored an initially
nonzero TCA mask, validation retains that original observation and requires the
later verified correction. Use a new scan directory on repeats; do not overwrite
an existing post-cleanup receipt. After a previously interrupted session, clear
and verify incoming TCA masks before the next acquisition.

Latest [four-channel measured report and raw campaign](../acceptance/evidence-campaign-smu-20261113/README.md).
