# Channel11 analog tests — fitting9–12,2026-11-13

BoardPM12-K7-3A17A1B402212223, MCU1803. The owner confirmed moving both USB
pairs from12to11: MOD-DAC-28 outputs0/1→J8 direct ADC and2/3→J6 integrator.
RJ45 port routing stayed unchanged. All four monitor muxes are inhibited.

[Combined28-page campaign PDF](report.pdf), editable[LaTeX](report.tex)/[content](content.tex),
[complete portable raw campaign](campaign-raw.tar.gz),[coverage](coverage.json).
Extract the archive to a NEW directory; campaign_report.py regenerates the
figures from sealed inputs. Common plots compare physical channels11and12;
internal DAC B/C/D coverage on9–12 is retained. Missing cases remain explicit.

## ADC A/B

Both257-point scans and adjacent-bit exercise PASS. Requested Vdiff−1.2..+1.2V,
Vcm1V, DAC0/1 within0.4..1.6V; integrator amps disabled, DAC2/3 parked at the
same2.048/1.024V condition used for channel12. Gain fit uses unclipped±0.8V.

|ADC|Gain(code/V)|Mean at zero(code)|Total RMS(code)|Four-phase-removed RMS(code)|
|---|---|---|---|---|
|A|-1783.31|2163.592|61.456|0.539|
|B|-1776.86|2158.098|59.537|0.512|

All12bits exercised at0/1 and all44adjacent-pair states supported per ADC.
Total RMS includes periodic gate-related structure; phase-template subtraction
produces a residual statistic, not an intrinsic ADC noise specification.
FFT and time traces are retained. This stepped functional test does not certify
bit order, electrical continuity, calibrated INL/DNL or aperture jitter.

## Integrators

Coarse13points, fine26points at0.4mV, four candidate revisits per ADC with8buffers
each, and±5mV sign controls PASS. Working coordinate DAC2=1.024V+δ/2,
DAC3=2.048V−δ/2; DAC0/1 remain1/1V. No reversed-polarity probe was needed.

|ADC|Tested DAC2/DAC3(V)|Mean late−early change(code)|Gain(code/V)|
|---|---|---|---|
|A|1.0260/2.0460|-0.136|-2558.7|
|B|1.0288/2.0432|+0.112|-2553.3|

552buffers analyzed;516retained. Excluded coarse buffers:28clipped and8with
ambiguous integration/reset templates. All fine and validation points were
usable. Waveform-based phase assignment is not an independently timestamped
gate epoch; gain includes the complete DAC/cable/integrator/ADC chain.
A/B balance separation is about5.70mV in the differential coordinate. The
shared park is a compromise and does not null both integrators simultaneously.

Final state: DAC0/1=1/1V, DAC2/3=1.0274/2.0446V; channel11 amps enabled,
direct ADC bypass isolated, monitor inhibited, both TCA masks0, ADC A last.
Other DAC outputs unchanged. Other fitted channels' amps/bypass were disabled
at preflight. No firmware, gateware or clock changes and no SMU commands.

Native acquisition dependencies matched the frozen channel12 versions. ADC
normalization used its exact retained ADC-v1 source layout; integrator
normalization used its separately frozen reverse-polarity-capable version.
All three new results imported against unchanged per-test comparison contracts.
The earlier successful channel12 observations were not overwritten.
