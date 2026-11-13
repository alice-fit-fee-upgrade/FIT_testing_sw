# Active PM12 campaign — 2026-11-13

Board **PM12-K7-3A17A1B402212223**, MCU1803. Fresh JTAG DNA and MCU identity
were confirmed for the current fitting, `ch09-12-attempt001`.

Live registry on Optiplex NVMe:

`/srv/codex-hil-nvme/pm12-campaigns/PM12-K7-3A17A1B402212223/four-cfd-20261113/`

Active pointer: `/srv/codex-hil-nvme/pm12-campaigns/active.json`.
Read the registry for current measurement/selection status. Reports are snapshots.

## Current fitting and wiring

Four emulators are fitted on physical PM channels **9,10,11,12**.
Fresh pulse discovery established this reverse port mapping; every stimulated
port produced16 TDC events only on its expected channel, with quiet controls.

| PM channel | Provisional CFD label | Slot7 RJ45 port | Phase lanes |
|---|---|---|---|
|12|CFD01|0|8/9|
|11|CFD02|1|10/11|
|10|CFD03|2|12/13|
|9|CFD04|3|14/15|

Labels identify bench port assignments, not verified factory serial numbers.
The initial ascending declaration is preserved in `mapping-declared.json`.

Both analog USB cables currently terminate on **channel12 only**:

| MOD-DAC-28 outputs | CFD_SIM input | Measurement |
|---|---|---|
|0/1|J8, direct ADC|ADC transfer and adjacent-bit exercise|
|2/3|J6, integrator|Balance and signed ramp response|

Move both cables together to11,10,9 only after the owner confirms each move.
Other fitted channels are not implicitly analog-connected. Update that receipt
before acquiring them; never infer the analog destination from an RJ45 route.

## Acquisition order and preservation

1. Confirm fitting/identity, PGOOD and route map. Original CPLD A/B gates remain
   enabled, nominal20MHz; ADC sampling is nominal80MHz.
2. Direct ADC: disable integrator amplifiers, select only the measured A/B bypass
   input, inhibit all shared monitor muxes;257 points per ADC, Vcm1V and
   requested Vdiff−1.2..+1.2V. DAC0/1 remain within0.4..1.6V. DAC2/3 were parked
   at2.048/1.024V for this first ADC dataset. Retain that condition for comparisons.
3. Integrator: isolate direct ADC injection before enabling amplifiers. Keep
   DAC0/1=1/1V. **This cable pair needs DAC2=1.024V+δ/2,
   DAC3=2.048V−δ/2**, opposite to the earlier single-pair experiment.
   The initial opposite-polarity saturated scan is retained and excluded from
   balance fits. Coarse13 points, fine26 points at0.4mV, independent revisits
   and±5mV sign checks. No clipped trace counts as balance.
4. Archive raw buffers, executed source snapshots, SCPI/UART receipts and
   normalized test result. Compare all12 channels on common plots only after
   selecting valid independently acquired results.
5. Repeat for the next confirmed analog destination. Generate a report snapshot
   after each fitted group; incomplete coverage remains explicit.

On the first preflight the PM SRAM image had been lost during mounting/power
cycling. The same qualified diagnostic image `c7c42d28` was restored via JTAG
and the existing Kasli private bridge re-enabled. No PLL profile, CPU firmware,
CPLD image, power protection or flash was changed.

Expected station input `station-base.json` requires the four-port Kasli CFD4
image, not the older single-port profile. Per-method executed sources/settings
are frozen when a successful result is first imported. A software change that
alters a frozen dependency requires a reviewed new protocol/campaign version;
do not bypass the mismatch or silently merge different versions.

[Campaign procedure and CLI](CAMPAIGN.md). Earlier preliminary channel12 and
12/10/8/6 measurements were not imported as new campaign data.

## Completed SMU scans on the current fitting

Internal DAC B/C/D transfer tests now PASS on9,10,11,12:12curves,
101codes/curve and3fresh READ? samples per point. Keysight B2910BL
MY63320299, Force HI/LO local sensing,0A,20V/1PLC. First attempt is retained
as INCOMPLETE after process termination without final metadata. Second attempt
is selected explicitly after raw validation and independent post-cleanup.
The original restored TCA masks(0,8) are retained in raw metadata; post-cleanup
explicitly cleared both to0. All monitor muxes inhibited, SMU OFF/HIZ, exercised
B/C/D sent0000; phase DAC-A and external MOD-DAC-28 were not written.
No USB cable move was announced: both remain declared on12. ADC/integrator
coverage for9–11 is still missing. See[evidence](evidence-campaign-smu-20261113/README.md).
