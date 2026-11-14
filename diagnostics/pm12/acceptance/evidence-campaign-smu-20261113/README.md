# CFD DAC scans, fitting9–12 — 2026-11-13

BoardPM12-K7-3A17A1B402212223, MCU1803. Keysight B2910BL MY63320299,
0A/local sensing on Force HI/LO, range20V/1PLC. Four shared monitor outputs;
only one selected at a time. Fresh1.3V monitor readings checked on every module.

[Campaign PDF](report.pdf), [editable LaTeX](report.tex)/[content](content.tex),
[DAC transfer overlays](dac-transfer.png), [channel differences](dac-channel-differences.png),
[summary CSV](summary.csv), [validation](validation.json),
[complete portable raw campaign](campaign-raw.tar.gz).
Extract to a NEW directory; campaign_report.py regenerates the full report.

|Physical PM channel|DAC B, code0→65535(V)|DAC C(V)|DAC D(V)|
|---|---|---|---|
|9|1.044727 → 1.004613|1.034957 → 1.014397|0.005400 → 1.063060|
|10|1.044370 → 1.004380|1.034677 → 1.014143|0.004547 → 1.069293|
|11|1.044667 → 1.004610|1.034903 → 1.014387|0.004850 → 1.063633|
|12|1.044630 → 1.004427|1.034807 → 1.014433|0.004980 → 1.063210|

12curves,101codes each,3fresh readings per point:3636voltage samples.
The first attempt was interrupted before final metadata and remains INCOMPLETE;
the independent second acquisition supplies selected coverage.
B/C resistor scaling produces about40/20mV spans; D about1.06V.
Pass/fail and per-channel electrical criteria are retained in sealed receipts,
not inferred from report folder presence. Functional limits: span within5% of
nominal scaling, reversal <=0.2mV, repeat standard deviation <=1mV. No traceable
calibration or exhaustive16-bit DNL/INL is claimed.

Final state: all four monitor muxes inhibited, TCA masks0, B/C/D explicitly0000,
phase DAC-A unchanged, SMU OFF/HIZ with automatic output-on disabled. External
MOD-DAC-28 settings and the two USB cable destinations were not changed.
The report retains earlier ADC/integrator channel12 measurements; it does not
claim their analog tests were repeated on9–11. Remaining cases stay NOT_MEASURED.

The acquired scan restored its initial TCA masks(0,8), inherited from the
interrupted attempt. A separately leased post-cleanup receipt retains this
observation, confirms all monitor inhibit pins and SMU OFF/HIZ/0A, and explicitly
clears both TCA masks to0. Raw scan metadata is unmodified. Both the correction
and its independently checked source are in the portable archive.
