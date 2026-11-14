# Individual HDMI SPI pins — 2026-11-14

PM12-K7-3A17A1B402212223 / MCU1803, PM SRAMc7531465 unchanged.
Temporary Kasli GPIO mux, marker5350, compiled on Dell. Setup WNS0.162ns,
hold0.067ns, DRC0errors. Simulation checks passthrough, all eight GPIO values,
busy/invalid guards and reset/readiness fallback. Candidate bit SHA256
8080c159a87ddf398d0b7bfa92bd4c6ca38466be97548418a28994f2a1c64476.

## Completed bounded series (bounded03)

Physical mapping independently verified by MCU @HW port-input reads:
SEL→PD4, SCK→PD7, MOSI→PD5; only the expected bits change. GPIO output
readback and held OE/ready status validated for every recorded sample.

| GPIO stimulus | Cycles | Observed SYS counter decreases | Counter timeouts |
|---|---:|---:|---:|
| SEL, SCK/MOSI0 |36|0|0|
| SCK, SEL/MOSI0 |36|0|0|
| MOSI, SEL/SCK0 |36|0|0|
| MOSI, SEL1/SCK0 |24|0|0|

Pulses are host-timed (requested1ms/10ms dwell, plus I/O latency), not
full-speed SPI stress. No single-pin fault is excluded at every possible rate.
Toggling SEL alone has no clocked frame; MOSI-selected has SCK held low.

Normal signature reads before and after each raw series remain positive
controls: **2/12 confirmed counter decreases before and2/12 after**.
Counter samples timed out in4/12 and6/12 frames respectively; these are
unknown counter outcomes, not stable PASS. Counts are conservative observed
decreases, not a complete number of physical resets. Thus individual GPIO
activity did not reproduce the observed full-frame fault in this tested regime.
No particular SPI input is identified as the cause.

## MISO constant-zero probe on restored original Kasli

PM diagnostic hdmi_slave.v contents(3)=0; new helper sends only read3 plus
existing signature reads0/1/2. It performs no diagnostic or peripheral writes.
The shift register is primed by a first read3 in each block;23 subsequent
read3 frames logically return all-zero MISO throughout, with physical output
still gated by SEL. There is no continuous electrical trace of the pad.
No counter decreases or timeouts occurred in these23 frames, but the18
ordinary signature controls were also stable. The MISO result is therefore
**inconclusive**; the reset condition did not reproduce in that series.
Both warmup frames and all raw traces remain included.

Its terminal ADC check found one unstable selected word onch01 at position1255.
All12 raw files are retained. This failure interrupted saving the helper's
final metadata; it does not invalidate the earlier43 individually saved SPI
trials. Separate fresh leased postflight passed physical ADC bankA on all12,
PGOOD, samec7531465 identity and frontend0xfff. The one capture failure is an
open observation, not silently converted into PASS or a proven assembly fault.

## Interrupted trials and final state

Initial hardware series was interrupted deliberately after lengthy IPbus
read timeouts; exact fallback restoration and ADC check passed. bounded
attempt stopped on a missing mode-write acknowledgement and restored too.
Neither is a completed negative pin-test series. Original executed sources,
logs and data are retained alongside completed bounded03. Later bounded
series keeps timeouts separate from proven counter decreases.

Exact original four-port Kasli SHA256
a71a08a258620b0e5a52c5d03aefd8c69040c9d15e8de6391c484ac182b7173b
restored. Slot6 mask00b0 and FPGA enable1/status9 retained, mode/divider
restored. Reload intervals necessarily interrupted outputs and are excluded
from stimulation results. During raw trials no OE release or direction
reversal was performed. FIN direction is not an independent both-sides-disable
control, so it was not reversed into the active FPGA transmitter.
No PM/MCU/CPLD/flash/external PLL programming or analog changes.

[Source/procedure](../spi_pins/README.md), [raw traces](raw.tar.gz),
[source, bit and Dell reports](source-and-bit.tar.gz), [validation](summary.json).
Reproduce offline with spi_pins/analyze.py --result EXTRACTED/bounded03/result.json
--out NEW_SUMMARY.json. No hardware required for analysis.
