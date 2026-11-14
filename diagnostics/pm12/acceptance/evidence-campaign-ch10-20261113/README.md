# Physical channel10 analog tests — fitting9–12,2026-11-13

BoardPM12-K7-3A17A1B402212223, MCU1803. Owner confirmed moving both USB pairs
onto10: MOD-DAC-28 outputs0/1→J8 direct ADC and2/3→J6 integrator. RJ45 routing
unchanged. Fresh preflight checks and owner route receipt are retained.

[Combined PDF](report.pdf), editable[LaTeX](report.tex)/[content](content.tex),
[complete portable campaign](campaign-raw.tar.gz),[coverage](coverage.json).
Extract the archive to a NEW directory and regenerate with campaign_report.py.
All acquired physical channels share comparison plots; missing cases stay NM.

## ADC A/B: PASS

257points per bank, requested Vdiff−1.2..+1.2V,Vcm1V; DAC0/1 stay0.4..1.6V.
Integrator amps disabled and DAC2/3 parked2.048/1.024V, matching the frozen
channel12 method. Gain fit uses unclipped±0.8V. Both banks exercise all12bits
at0/1 and all44adjacent-pair states. This is a functional stepped sweep, not
an electrical short/bit-order proof or calibrated ADC INL/DNL.

|ADC|Gain(code/V)|Mean at zero(code)|Total RMS(code)|Phase-template residual RMS(code)|
|---|---|---|---|---|
|A|-1777.67|2159.386|52.467|0.513|
|B|-1778.27|2165.930|59.049|0.508|

Total RMS includes periodic structure; phase-template removal produces a
residual statistic, not intrinsic ADC noise or aperture jitter. FFT/time traces
are retained; the time scale assumes the declared80.1574MS/s.

## Integrators: PASS

13coarse and26fine points at0.4mV, then four candidate revisits per bank with
8buffers each and±5mV controls. Coordinate DAC2=1.024V+δ/2,DAC3=2.048V−δ/2;
DAC0/1=1/1V. Separate A/B balance settings are measured, not preassigned.

|ADC|Tested DAC2/DAC3(V)|Mean late−early change(code)|Gain(code/V)|
|---|---|---|---|
|A|1.0251/2.0469|-0.234|-2581.7|
|B|1.0284/2.0436|+0.191|-2528.7|

552buffers analyzed;512retained. Exclusions: 12 Ambiguous integration/reset template; 28 Clipped ADC samples cannot establish balance.

A/B balance separation is6.766mV in the differential coordinate.
The shared park is a compromise, not a simultaneous zero of both integrators.
Waveform-based integration-pair assignment is not an independently timestamped
gate; fitted gains include the complete DAC/cable/integrator/ADC chain.

Final: DAC0/1=1.0000/1.0000V,DAC2/3=1.0268/2.0452V.
Channel10 amps enabled, direct ADC injection isolated, monitor muxes inhibited,
TCA masks0, ADC A last. Other DAC outputs unchanged; other fitted channels'
amps/bypass disabled at preflight. No firmware/gateware/clock or SMU commands.
Both USB cables remain declared on10 until the next owner-confirmed move.

Native acquisition and all three result imports matched the frozen per-method
source/settings contracts. ADC normalization used the exact retained ADC-v1
layout, integrator normalization its separately frozen version. Earlier channel
results and selected attempts were not overwritten.

Measurement note: The coarse waveform assignment produces an additional positive-going sign crossing near +40mV. It was not accepted as balance. Fine acquisition used the central negative-going crossing for this reversed input coordinate, then confirmed it with independent candidate revisits and +/-5mV controls. The original coarse data and both controller versions remain archived.
