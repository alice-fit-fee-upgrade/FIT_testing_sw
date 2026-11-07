# ADC STR false-failure diagnosis — 2026-11-07

**Resolved as an invalid test criterion for asynchronous 4× sampling.** The
forwarded clock was not shown to lose cycles. The old requirement that every
sampled STR interval equal exactly 4 was inappropriate at a sampling boundary.
Original strict-mode FAIL evidence is retained without rewriting its verdict.

Target: PM12-K7-3A17A1B402212223, EEPROM1803, integrated PM build c7c42d28.
FPGA SRAM image SHA256 remained
`1dbafd99033f803a086d4153ed3d873adfc9b4208b806785f00d3024bdfbf1ac`.
No new gateware compilation, MCU/CPLD programming, configuration-flash write,
PLL profile change or external clock change was needed.

## Mechanism and controlled observations

The diagnostic captures STR and the parallel ADC data using independent two-stage
`MultiReg` synchronizers in the 320 MHz nominal capture domain. CAP is generated
through the MGT-reference/SYS MMCM chain. The forwarded ADC clock has a
programmable phase. At a sampling boundary, a STR edge can be registered on
one of two neighboring capture ticks. Consecutive timestamps can therefore have
intervals 3 and5 although the nominal cycle is4 ticks. This is sampled-edge
quantization; these observations do not measure physical jitter in picoseconds.

Evidence separating this case from a defective channel or lost clock:

* Phase sweep: DAC-A code 0 produced3/4/5 intervals; codes 1024 and 2048 produced
  only4 in the exploratory sweep. A controlled repeat retained 38 uniquely named
  raw buffers:27 ALIGNED and 11 EDGE_QUANTIZED. Its code 1024 controls were clean.
* All selected ADC words in that repeat equaled the preceding raw data sample.
  Both rising and falling edge positions stayed within a one-tick-wide phase
  range relative to the ideal4× sample grid, without accumulating slips.
* Reloading the **identical FPGA image**, without CPLD EXTEST or other CPLD
  programming, changed which channels lay at the sampling boundary:

| Context | Raw buffers | ALIGNED | EDGE_QUANTIZED | Quantized channels |
|---|---:|---:|---:|---|
| Before reload |72|66|6|12|
| First FPGA-only reload |72|71|1|10|
| Second FPGA-only reload |72|66|6|3|

All 216 buffers passed the bounded-phase, edge-count, pulse-width and selected-word
stability checks. Both ADC banks and all 12 physical digital paths were captured
three times per context. CPLDs and ADC clock settings were unchanged. This
supports relative FPGA sampling phase as the cause of the original strict-check
failure, rather than a persistent fault specifically on channel 12.

The initial exploratory sweep recorded 122 observations but reused two baseline
filenames, leaving 120 unique raw files. That exploratory dataset is not the
qualified repeat above. `debug_adc_strobe.py` now includes the acquisition
generation in each filename and writes with exclusive creation. The38-buffer
repeat has no overwritten files or filename/generation mismatch.

## Corrected validation

`ipbus_adc/adc_decode.py` is shared by acquisition, native IPbus ADC checks,
independent raw-histogram verification and report/time/FFT plotting.
It requires:

1. Exactly 4096 raw words, correct EV bank and no reserved bits.
2. 1023 or 1024 rising edges and 1023 or 1024 falling edges.
3. Rising intervals only 3/4/5 **and** rising/falling cumulative phase spans
   no greater than one capture tick. A long-term drift cannot be hidden by
   an approximately correct median interval.
4. Sampled high/low pulse widths 1..3 ticks.
5. Every selected word immediately before STR equals its preceding complete
   ADC-data sample. An unstable or partially transitioning word is rejected.

`ALIGNED` and `EDGE_QUANTIZED` remain distinct recorded results. The existing
`--strict-edges` mode still rejects3/5 intervals as a **phase-alignment diagnostic**.
A clock-loss, extra-edge, drift or unstable-word result still aborts acquisition.
This does not certify electrical clock jitter, all sub-sample glitches or
production source-synchronous timing margin.

## Repeated physical qualification

A fresh complete resident sequence passed: identity/PGOOD, MCU/peripherals and
CPU–FPGA SPI, HDMI, synthetic/physical ADC paths,64-pulse TDC,20-point DAC-A gate
phase sweep and 257-point differential ADC scan on physical channel 12 A/B.

* 514 raw ADC buffers  / 2,105,344 words; every histogram and EV tag exact;
  capture generations contiguous.
* 369 buffers were EDGE_QUANTIZED; 145 ALIGNED. All selected words passed the
  two-sample stability rule; all edge phases were bounded to one tick.
* ADC A: 12/12 bits and 11/11 adjacent pairs PASS, 3099 visited codes,
  241831 non-rail samples.
* ADC B: 12/12 bits and 11/11 adjacent pairs PASS, 3053 visited codes,
  241763 non-rail samples.
* The FPGA-only reload control above passed separately, proving that the
  corrected capture checks handle a new startup sampling phase.

Raw samples and figures are retained in `evidence-str-debug-20261107/`.
The dataset remains a functional ADC path test, not full 4096-code/DNL qualification.
Missing analog channels remain unmeasured.

## Repeat

On the owning Optiplex, with the qualified images already loaded:

```sh
/home/codex-hil/kasli-phase-tester/run-python \
 /home/codex-hil/fit-testing-publish/diagnostics/pm12/acceptance/debug_adc_strobe.py \
 --station /home/codex-hil/fit-testing-publish/diagnostics/pm12/acceptance/profiles/pm12-3A17A1B402212223.json \
 --codes 0 1024 8192 --repeats 2 --out NEW-PHASE-DIRECTORY
```

The diagnostic changes only channel 12 DAC-A and explicitly restores raw 0000;
its active code has no hardware readback. All board leases and PGOOD guards apply.
`debug_reload_adc.py --station PROFILE --out NEW --reloads 2` performs the
FPGA-only SRAM reload control, with checksum validation and private-link recovery.
Heavy compilation, if subsequently required, remains on Dell.
