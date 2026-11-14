# Correct-clock TDC repeat — 2026-11-14

Board PM12-K7-3A17A1B402212223 / MCU1803. SRAM build **c7531465** retained.
The earlier c7c42d28 assumed120MHz MCLK; actual MCLK is40.0787MHz.
Only the internal TDC MMCM and corresponding constraints were corrected:
DIVCLK1, multiplier30, VCO1202.361MHz, fast601.1805MHz, coarse300.59025MHz.
Texas CDCE62005 and SiLabs profiles, MCU, CPLDs and flash were not changed.

**PASS: TDC9–12**,128 captures,19,268 events,25 phase positions/channel,
128 events/phase,8 empty quiet windows, no lost or cross-channel records.
Independent raw validation is in validation.json. The coarse gain is
1.24769–1.25231 codes/serializer bin, versus1.25 predicted.
ADC digital regression passed on all12 channels, both banks, physical and
synthetic acquisitions. This does not replace analog characterization.

**Still open:** HDMI/SPI caused SYS counter restarts in8/12 signature reads;
CFD11 monitor MUX7 divider discrepancy remains a separate fixture finding.
Slot6 SPI outputs stayed driven throughout. USB stimulus remains on PM10.
Channels1–8 TDC have not been qualified by this repeat.

Raw13-bit TDC words and frozen measurement sources are in hardware-raw.tar.gz.
Source, bitstream and Dell timing/DRC receipts are in source-and-bit.tar.gz.
The bit SHA256 is4f0b3edba1271eed41757bc7f21845e43a4ecb2e2c023abe28f3b5770abc8c16.
Implementation WNS0.085ns, WHS0.066ns; no DRC errors/critical warnings.

Phase plots unwrap fine codes modulo128. Coarse codes are unwrapped across
the largest empty arc and folded modulo10 (one Kasli word), then unwrapped
along the scan. This removes whole-word start branches, not absolute LHC
trigger alignment. No intrinsic-jitter or calibrated-LSB claim is made.
Historical measurements are retained; this versioned repeat supersedes their
correct-clock qualification without rewriting the frozen campaign protocol.

Reproduce analysis with ../clock40/analyze.py --status EXTRACTED/hardware/tdc/status.json
--out NEW_DIRECTORY (optional --legacy HISTORICAL_STATUS).
The editable consolidated report includes the new chapter.
