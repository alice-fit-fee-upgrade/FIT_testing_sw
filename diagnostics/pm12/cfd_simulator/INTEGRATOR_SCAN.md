# Integrator balance and signed ramp response

Measured on physical **PM12 channel12**, 2026-11-13. The owner moved the
MOD-DAC-28 USB pair from CFD_SIM **J8 (ADC bypass)** to **J6 (DRV/integrator
stimulus)**. This procedure uses that wiring, not the direct-ADC DC scan setup.
Original A/B gates remain enabled in CPLD12; see the [restoration receipt](evidence-intb-restored-20261112/status.json).

## Measured result

[PDF report](evidence-integrator-20261113/report.pdf),
[editable LaTeX](evidence-integrator-20261113/report.tex),
[signed response](evidence-integrator-20261113/integrator-balance.png),
[waveforms](evidence-integrator-20261113/integrator-waveforms.png),
[CSV](evidence-integrator-20261113/ramp-points.csv),
[validation](evidence-integrator-20261113/validation.json).

The working coordinate system is CH0=2.048V+δ/2, CH1=1.024V−δ/2.
The initial reverse order saturated both ADCs; the empirical channel mapping
and all rejected probes are retained. These are commanded settings, not
independently measured DAC voltages or internal reference measurements.

| ADC | Tested near-balance CH0 / CH1 (V) | Mean late−early change (codes) | Fine-scan gain (codes / V of δ) |
|---|---|---:|---:|
| A | 2.0448 / 1.0272 | −0.281 | 2599.6 |
| B | 2.0443 / 1.0277 | +0.329 | 2520.0 |

Each candidate was visited twice, eight buffers per visit, about4080cycles per
ADC/candidate. Negative/positive5mV offsets produce approximately−13/+13codes.
A/B differ in balance point, so the shared pair cannot null both exactly.
The final compromise is CH0/CH1=**2.0446/1.0274V**: amplifiers enabled, direct
ADC injection isolated, monitor inhibited, both upstream TCA masks0, ADC A last.
Other DAC outputs were unchanged. No gateware/firmware/clock changes were made.

## Analysis

The integrators run at nominal20MHz and ADCs at nominal80MHz. Each buffer
contains four ADC sample phases per integration/reset cycle. Capture start is
not phase-tagged, so `integrator_analysis.py` aligns each buffer to the highest
adjacent pair of a separated four-phase waveform. Its strong signed voltage
response identifies the observed integration pair; there is no independent
absolute gate timestamp in the ADC buffer. Clipped and ambiguous traces are
rejected, not interpreted as zero slope. The balance is zero **change between
selected integration samples**; reset steps remain in the waveform.

A coarse13-point scan and fine26-point scan established zero crossings. Independent
validation revisited candidates and both signs of offset. All688raw buffers
passed strobe/coherency and metadata checks;703824decoded ADC samples are retained.
520buffers entered the main analysis,32clipped coarse buffers were excluded;
initial mapping probes and enabled/disabled controls are archived separately.
Software suite:40tests passed, including phase rotation, sign, clipping and
ambiguous-template cases. PASS is scoped to this channel and fixture, not
complete board acceptance or intrinsic opamp characterization.

The time axis assumes80.1574MS/s from the stated40.0787MHz reference, not a
frequency-counter measurement. The fit gains include the complete DAC/cable/
integrator/ADC chain. Two integration samples do not resolve ramp curvature.

## Repeat acquisition

Use the existing pinned station environment, shared local/remote leases,
correctly identified PM12 MCU1803/FPGA c7c42d28 and MOD-DAC-28 instrument. No
instrument access is performed by plotting/report generation. Acquisition
checks physical PGOOD, FPGA/MCU identity and every DAC setpoint against0..3.3V.
Only the selected DAC pair and channel12 MCP are controlled; this initial runner
is channel12-specific and requires the documented fixture.

```sh
/home/codex-hil/kasli-phase-tester/run-python \
  diagnostics/pm12/cfd_simulator/integrator_scan.py \
  --out /absolute/NEW-RUN --base 2.048 1.024 \
  --offsets -0.02 -0.01 0 0.01 0.02 --repeats 4 \
  --park 2.0446 1.0274
```

GPA7 LOW releases the PM integrator shutdown; GPB5 HIGH disconnects the direct
ADC mux, GPA3 HIGH inhibits the shared DC monitor. Success leaves amplifiers
enabled and parks the pair at `--park` (or `--base` if omitted). On failure the
runner attempts amplifier shutdown and bypass inhibition, then parks at base.
The JSON `pass_` field records acquisition completion; it does not establish
analog balance. Offline analysis must reject clipped traces and verify a signed
zero crossing before any balance claim. `--pairs CH0:CH1 ...` supports explicit
candidate voltages. Never use firmware STORED parameters as active DAC readback.

## Regenerate the archived report offline

Extract [raw-runs.tar.gz](evidence-integrator-20261113/raw-runs.tar.gz) into a new
measurement root. It supplies `probe01`, `matrix01`, `sweep01`, `fine01`,
`validation01` and `validation02`, including raw buffers and command receipts.

```sh
/srv/codex-hil-nvme/tool-venvs/fit-measurements/bin/python \
  diagnostics/pm12/cfd_simulator/plot_integrator_scan.py \
  --root /absolute/EXTRACTED --out /absolute/ANALYSIS \
  --runs sweep01 fine01 validation01 validation02
python3 diagnostics/pm12/cfd_simulator/validate_integrator_scan.py \
  --root /absolute/EXTRACTED --analysis /absolute/ANALYSIS
python3 diagnostics/pm12/cfd_simulator/report_integrator_scan.py \
  --root /absolute/EXTRACTED --analysis /absolute/ANALYSIS
/path/to/tectonic --outdir /absolute/ANALYSIS /absolute/ANALYSIS/report.tex
```

The general [acceptance report workflow](../acceptance/README.md) remains the
entry point for batch dossiers. This integrator chapter has a standalone
editable LaTeX generator; it is not yet an automatic resident-plan stage.
