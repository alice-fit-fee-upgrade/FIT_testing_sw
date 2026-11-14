# TDC and gate-phase tests on physical PM channels9–12 —2026-11-13

BoardPM12-K7-3A17A1B402212223, MCU1803, existing PMc7c42d28/Kasli CFD4 images.
Slot7 RJ45 ports0/1/2/3 map to physical PM12/11/10/9. Logical phase-return
lanes8/9,10/11,12/13,14/15 correspond to A/B on those channels. USB stimulus
stayed on10; no MOD-DAC-28 or SMU access was required.

[Combined39-page PDF](report.pdf), editable[LaTeX](report.tex)/[content](content.tex),
[raw campaign](campaign-raw.tar.gz),[coverage](coverage.json).
Extract to a NEW directory; campaign_report.py rebuilds the cumulative report.
[Gate curves](gate-phase-four.png),[TDC curves](tdc-phase-four.png),
[gate CSV](gate-phase.csv),[TDC CSV](tdc-phase.csv),[summary](summary.json).

## Measured results

|Physical PM channel|TDC slope(fine codes/ns)|Gate A observed excursion(ns)|Gate B(ns)|
|---|---|---|---|
|9|-46.17114|20.792|20.792|
|10|-46.17427|21.832|20.792|
|11|-46.17508|20.905|20.792|
|12|-46.17587|19.753|19.753|

All four TDC and four A/B phase-response cases PASS their functional checks.
TDC:25phase positions per channel,128events/point;12800scan events plus64
port-discovery events. All other channels have zero records; eight quiet
windows are empty. All13raw bits are retained; raw lengths/histograms/circular
means/spreads/coarse fields/generations were independently checked. Functional
response screen: slope−60..−20fine codes/ns,max residual10fine codes.
Observed maximum residual is1.73fine codes; slopes agree within about0.011%.
This is a relative response check, not absolute TDC calibration or throughput.

Gate phase: internal DAC A swept0..65535 in101points per module,404captures.
All eight A/B return lanes have localized periodic edges at every capture.
105880320raw sampled bits and4411680hardware phase records were checked against
raw ISERDES samples, then estimators rebuilt independently. Every selected A/B
curve has101valid points and>5ns excursion. No adjacent step exceeds two sampler
bins in this repeat. The range flattens near the upper DAC settings.

The stated40.0787MHz reference gives961.8888MS/s, approximately1.0396ns bins.
TDC stimulus spans one24.9509ns LHC period; gate edge period is two LHC periods,
49.9018ns. Gate plots use nearest-continuation relative phase; fine TDC plots
unwrap modulo128. Occupancy centroids are not calibrated sub-bin resolution,
and correlated edges do not justify a sqrt(N) jitter error bar. Times were not
independently frequency-counter calibrated. DAC writes are acknowledged by MCU,
not actual DAC code readback.

Final postflight: fresh MCU/FPGA identity, PGOOD and all12TDC frontends ready;
extra quiet capture has zero counts on all12channels. DAC A sent0000 on9–12,
CFD TX enable0/selector0, both DIO cards inputs, PM private bridge enabled,
all monitor muxes inhibited, TCA masks0. Other integrator/injection GPIO were
preserved. No FPGA/CPLD/MCU programming, PLL profile or flash writes. Leases
released. Prior analog channel10–12 results remain historical observations at
their acquisition settings, not newly repeated after this phase sweep.

Acquisition sources now retain UTC start/end times and local dependency
snapshots. Per-channel campaign timing receipts freeze source/settings versions;
new adapters validate native buffers before import. Software:35acceptance and
46CFD tests PASS; full physical data validation PASS. All missing board/channel
cases remain explicit; these measurements do not certify the whole board.
