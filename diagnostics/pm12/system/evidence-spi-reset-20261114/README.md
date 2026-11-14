# HDMI parser held in reset — 2026-11-14

**Inconclusive for root cause.** Temporary PM8da2d6d3:132 measured frames,
zero observed SYS counter decreases and zero read timeouts in every group:

| Group | Frames | SYS decreases | Timeouts |
|---|---:|---:|---:|
| Normal signature reads |24|0|0|
| Normal matched zero-data read3 |48|0|0|
| Parser held, matched read3 |48|0|0|
| Parser held, signature stimuli |12|0|0|

Nine read3 priming frames are additional, excluded from the measured denominator.
Normal positive controls did not reproduce the intermittent fault, so absence
of resets while held is not proof that holding the parser fixes it.
After exactc7531465 restoration,36 further ordinary signatures also produced
zero decreases/timeouts. The known intermittent HDMI/SYS finding remains open.

## What was reset

Only the PM FPGA HDMI SPI parser, not the Kasli master or MCU SPI engine.
Its original internal SEL was forced low, holding count/reading in the original
reset/deselected branch; scratch/write counters are retained. Physical SCK
still clocks the circuit: this is a logic reset, not a clock gate. MISO data
is forced0 while held, but physical pad enable remains governed by actual HSEL.

Runtime IPbus305 accepts0/1, reads53520000|hold, defaults0 at configuration
and deliberately retains hold across SYS resets. Source and simulation cover
this design intent; no SYS reset occurred here to demonstrate retention on
hardware. Held state was read back after each block. Invalid value2 rejected
without changing hold or HDMI mode. Zero-data read3 was primed in normal mode
before each block to logically match MISO. No continuous electrical pad trace.

Alternating held/normal blocks ran in one PM image with unchanged Kasli,
external clock profiles, OE and buffer direction. No Kasli programming.
PM programming/restoration intervals are excluded from the comparison.
Source baselinec7531465 retains corrected MCLK40.0787MHz timing. Candidate
8da2d6d3 SHA256f6e72bf8ad90610f07773e3dddeab53630630729552121d2ad373819c840120d;
Dell setup0.095ns, hold0.007ns, DRC no errors, baseline FIFO warning only.

Exact original PMc7531465 restored, held Kasli SPI enable1/status9 unchanged,
frontend0xfff, power healthy. Fresh physical ADC bankA passed after restoration
and after the36-frame original-image control; no retry needed this time.
No MCU/CPLD/flash or external PLL/profile programming was requested/performed.

A first preflight was rejected because the historical station identity helper
hardcodes oldc7c42d28. It stopped before programming. The completed version
uses explicitc7531465 identity, MCU1803 and DNA3A17A1B402212223; historical
campaign helper was left unchanged. Rejected script/log retained as such.

[Procedure/source](../spi_reset/README.md), [raw records](raw.tar.gz),
[source/bit/timing receipts](source-and-bit.tar.gz), [independent validation](summary.json).
Reproduce offline with spi_reset/analyze.py --result EXTRACTED/hardware/result.json
--out NEW_SUMMARY.json. Read timeouts are unknown outcomes, never auto-PASS.
