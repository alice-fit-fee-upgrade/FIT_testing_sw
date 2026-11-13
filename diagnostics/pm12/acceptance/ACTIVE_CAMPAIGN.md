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

Both analog USB cables currently terminate on **channel10 only**, after the owner confirmed the move from11:

| MOD-DAC-28 outputs | CFD_SIM input | Measurement |
|---|---|---|
|0/1|J8, direct ADC|ADC transfer and adjacent-bit exercise|
|2/3|J6, integrator|Balance and signed ramp response|

Next move both cables together to9 only after the owner confirms the move.
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
At the end of that SMU scan both USB cables were still declared on12.
The subsequent confirmed move to11 and its analog measurements are recorded below. See[evidence](evidence-campaign-smu-20261113/README.md).

## Completed analog tests on channel11

The owner confirmed moving both pairs to11:0/1→J8 ADC,2/3→J6 integrator.
Routing receipt and the previous station map are retained. Preflight confirmed
MCU1803, FPGAc7c42d28, stable PGOOD and TCA masks0; all four monitor muxes,
integrator amps and direct-ADC muxes were initially inhibited before parking
DAC2/3 at the frozen ADC-test bias2.048/1.024V. Probe A/B responses and the
full257-point scans passed. ADC gains are−1783.31/−1776.86codes/V; phase-template
residual RMS0.539/0.512codes (total RMS61.46/59.54 includes periodic structure).
Adjacent-bit tests PASS for both ADC banks.

Integrator balance: A at DAC2/3=1.0260/2.0460V, B at1.0288/2.0432V. Fine-scan
gains−2558.7/−2553.3codes/V. Four candidate revisits per bank and±5mV sign checks
PASS. A/B balance separation is about5.70mV in the differential coordinate;
a common setting does not null both. Final shared park2/3=1.0274/2.0446V;
0/1=1/1V, other DAC outputs unchanged. Channel11 integrator amps enabled,
direct ADC injection isolated, all monitor muxes inhibited, TCA masks0, ADC A
last. Other fitted channels' amps/bypass were disabled at preflight.
No firmware/gateware/clock changes. Hardware leases released after acquisition.

The channel11 ADC imports used the exact frozen ADC-v1 normalizer, materialized
at `staging/method-tools/adc-v1/` in the live campaign. Its5source files match
the channel12 sealed analysis snapshots byte-for-byte. Native acquisition and
integrator analysis dependencies also matched their frozen per-method versions;
all three new cases imported without changing comparison contracts.

Analog ADC/integrator coverage is now11and12;9and10 still await confirmed USB
moves. All four internal DAC B/C/D tests remain covered.

## Completed analog tests on channel10

Owner confirmed both USB pairs moved11→10, with RJ45 mapping unchanged.
Preflight MCU1803/FPGAc7c42d28/PGOOD/TCA masks0 and selected A/B voltage probes
PASS. Both257-point ADC transfer and adjacent-bit cases PASS. Gains are
−1777.67/−1778.27code/V; residual RMS after phase-template removal0.513/0.508code.

Integrator fine26points and four candidate revisits per ADC with±5mV controls
PASS. A pair2/3=1.0251/2.0469V, B=1.0284/2.0436V. Mean near-balance changes
−0.234/+0.191code. A/B differential balance separation6.766mV. The coarse
waveform high-pair assignment produced an additional positive-going crossing
near+40mV; it was not used as balance. Fine acquisition followed the central
negative-going crossing, confirmed independently. Both controller versions and
all original coarse data remain archived; the measurement source/settings
contracts were unchanged. Of552buffers analyzed,512were retained:28clipped
coarse,4ambiguous coarse and8ambiguous auxiliary validation buffers excluded.
Required candidate returns and positive/negative response controls passed.

Final external DAC0/1=1/1V,2/3=1.0268/2.0452V; other outputs unchanged.
Channel10 amps enabled, direct ADC injection isolated, all monitor muxes
inhibited, both TCA masks0, ADC A last. Other fitted channels' amps/bypass
remain disabled from preflight. No MCU/CPLD/FPGA/flash/clock/SMU changes.
Analog coverage now10,11,12;9 awaits the next confirmed USB move. Earlier
results remain selected for their own physical channels. See
[evidence](evidence-campaign-ch10-20261113/README.md).
