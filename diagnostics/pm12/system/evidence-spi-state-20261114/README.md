# Direct SPI-state / SYS-reset correlation — 2026-11-14

**Four SYS reset events captured. Every one occurs with the parser IDLE**:
HSEL0, HSCK0, bit_count0, reading0, stable debug flag1. The parser has no SYS
reset input and had already been idle for9.608–10.219nominal ms after frame end.
SYS MMCM LOCK falls; its RST/PWRDWN remain0. CAP LOCK and GTX PLL LOCK stay1
throughout all four captured windows. LOCK-low spans8.483–8.633nominal us.
All12 saved stimulated frames contain exactly64 sampled SCK edges and correct
signatures. No sampled extra SCK edge is seen; shorter electrical glitches
are not excluded by this40.0787MHz sampled recorder.

| Divider | Saved frames | SYS-reset captures |
|---|---:|---:|
|600|6|0|
|601|6|4|

At601, both repeats of reads0/1 reset; both read2 cases are stable. The pre-test
idle window is also stable. Counts are small and ordered, not randomized.
Changing600→601 changes both rate and phase progression relative to the common
LHC clock; this is a timing-sensitivity lead, not proof of a unique phase,
MISO, FIN or external-PLL cause.

## Netlist audit: original and instrumented images

Originalc7531465 routed DCP and observer DCP inspected on Dell. Actual SYS
MMCM CLKIN1 fanin is IBUFDS_GTE2/ODIV2→BUFG, with CLKINSEL1. RST/PWRDWN,
PSCLK/PSEN/PSINCDEC and DCLK/DEN/DWE have constant-ground drivers in both.
Feedback is the MMCM's own CLKFBOUT; compensation is INTERNAL. SYS reset is
FDPE_1 with asynchronous preset derived from inverted SYS MMCM LOCK. SPI
inputs do not drive this reset/clock-control cone. Targeted MDRV/NSTD/UCIO
checks reported no violations. Constant-ground net aliases to unrelated RAM
address bits are normal shared constants, not evidence of merged state names.

| Physical signal | Package pin |
|---|---|
|HSCK|G22|
|HSEL|G26|
|HMOSI|F25|
|HMISO|F24|
|MGTCLK P/N|H6/H5|
|MCLK1 P/N|AA3/AA2|

HSCK fanout is to HDMI parser clock pins; HSEL drives its reset/enable and MISO
tristate. These results find no accidental SPI/reset merge in the inspected
netlist cone. They do not exclude PCB coupling, clock quality or other logic.

## Completeness and timing limits

Saved13 complete captures: one idle,12 stimulated, four resets. Planned56
windows (54frames+2idle) were **not completed**. The first602/read0 returned a
correct signature and its frozen data were read, but an ancillary uptime-read
timeout occurred before those records were persisted. That case is UNKNOWN;
42later windows were not attempted. It is not added to stable/reset counts.
Frozen save order is fixed in the current helper; executed.py preserves the
actual older measurement code. Four full reset records are unaffected.

Observer samples actual parser state/address/shift plus clock/reset signals
on nominal40.0787MHz MCLK1, not SYS; trace survives SYS reset. SPI multibit
sampling is not atomic; stable flag means two equal watch samples. Ignore
first8ARM-settling ticks. Times use a nominal running-clock scale: a common
watch/reference stop is not represented. Ref-age maximum102ticks is consistent
with reference progress while watch runs; it does not prove clean phase/jitter.
Internal MISO data is recorded, not a physical voltage during tristate.

Temporary PM56069fb9 SHA256
da6a48fe62b8fd08e4a952177109c6e989483f9545fa060cb358ea87d6eeccab.
Dell WNS0.066ns/WHS0.051ns, no DRC errors/critical warnings (baseline FIFO warning).
Simulation covers debug-state capture, reset survival, readout, rearm and short
LOCK-loss latching. Source/bitstream, raw data, independent analysis and audits
are included. Scientific plots are English and generated from raw records.

Final: exactc7531465 restored; Kasli never reloaded, SPI outputs remain driven,
frontend0xfff, power healthy, fresh physical ADC bankA all12PASS on first attempt.
No explicit external PLL/profile, MCU, CPLD, flash or analog changes. The
intermittent HDMI/SYS fault remains open. No active parser-state correlation
or accidental reset-net merge is established; loss of actual MMCM LOCK is observed.

[Plot](spi-reset-state.png), [reset rows](reset-states.csv), [raw data](raw.tar.gz),
[code/procedure](../spi_state/README.md), [source/bit](source-and-bit.tar.gz).
Reproduce with spi_state/analyze.py and plot.py (see --help), no hardware needed.
