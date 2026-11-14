# First measured channel in the four-CFD campaign

Physical channel12; fitting9–12;2026-11-13; boardPM12-K7-3A17A1B402212223,
MCU1803. CFD labels are provisional. Only channel12 has analog coverage here.

[PDF](report.pdf), editable[LaTeX](report.tex)/[content](content.tex),
[coverage](coverage.json), complete[raw campaign archive](campaign-raw.tar.gz).
Extract the archive to a NEW directory and use campaign_report.py to regenerate.
Figures are regenerated from sealed raw/result inputs; missing tests remain NM.

ADC A/B:257 points each, requested Vdiff−1.2..+1.2V, Vcm1V. Fitted gains
−1784.21/−1784.27codes/V in±0.8V. All12 bits exercised at0/1; all44
adjacent-pair states supported per ADC. This functional test is not an electrical
short, bit-order or calibrated DNL/INL certification. At differential zero,
total RMS56.23/64.41codes includes a four-phase periodic pattern; residual RMS
after removing that pattern is0.593/0.563codes. It is not intrinsic ADC noise.

Integrator DAC2/3 require reverse polarity relative to the preceding DAC0/1
experiment. Working coordinate: DAC2=1.024V+δ/2,DAC3=2.048V−δ/2.
A/B near-balance pairs:1.0270/2.0450V and1.0277/2.0443V. Four independent
visits per candidate,8buffers each; mean signed changes0.130/0.112codes.
Fine-scan gains−2530.4/−2448.0codes/V.±5mV controls reverse the slope.
552buffers analyzed,525retained/27clipped excluded; additional disabled/final
controls and initial rejected-polarity probes are archived. Balance uses the
observed high adjacent sample pair, not an independently timestamped gate.

Final hardware: DAC0/1=1/1V; DAC2/3=1.0274/2.0446V; integrator amps enabled,
direct ADC mux inhibited, all monitor muxes inhibited, both TCA masks0, ADC A
last. Original20MHz gates retained. SRAM diagnostic restored after power cycle;
no clock profile, MCU/CPLD firmware or flash changes.

The raw archive includes executed sources, commands, negative probes and sealed
manifests. Per-method sources are frozen: the ADC normalizer predates the signed
crossing fix needed for reverse-polarity integration. For later ADC cases use
its retained executed normalizer and analysis helpers, materialized into the
same acceptance/cfd_simulator/ipbus_adc layout; do not silently replace its
source hash with the newer integrator version. The native acquisition source
and settings must also match the frozen per-test contract.
