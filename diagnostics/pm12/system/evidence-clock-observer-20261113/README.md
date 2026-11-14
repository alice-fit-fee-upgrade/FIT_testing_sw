# PM12 reset-independent clock/SPI observation — 2026-11-13

Board PM12-K7-3A17A1B402212223, MCU1803. Kasli remains driven at idle0, slot6 mask00b0. No UART/PLL command during observer acquisition. The temporary observer was loaded only into PM SRAM; exact golden c7c42d28 restored afterwards and physical ADC acquisition, stable SYS and PGOOD checked. No MCU/CPLD/flash or external PLL configuration writes.

## Direct results

One idle control and five signature reads: two SYS reset events captured, after reads1 and0. Every transmitted frame has64sampled SCK transitions, each separated by200watch ticks. No sampled extra SCK edges; this does not exclude narrower glitches. The other three reads and idle control do not reset. All returned signatures are correct.

In both reset traces fixed SYS MMCM LOCK drops, SYS reset asserts, then LOCK returns and SYS reset releases two watch ticks later. CAP MMCM LOCK remains high. The reset recorder survives SYS reset. The first8watch ticks are ARM/startup settling and excluded from event analysis.

With a nominal40.0787MHz watch clock, LOCK-low spans340/341ticks (8.483/8.508us), about9.826/9.513ms after HSEL goes low. **These are nominal running-clock times; a simultaneous stop of watch and MGT clocks is not represented.** Reference heartbeat max age during captured SPI/reset events102/103watch ticks is consistent with continued reference progress while watch runs. It cannot exclude a shorter disturbance, phase/jitter event, or a common clock stop.

[Read1 waveform](analysis/trace02.png),[read0 waveform](analysis/trace04.png),[independent summary](analysis/summary.json),[raw records](hardware/result.json).

## Clock scale discrepancy

The source/XDC and observer CSR383 describe MCLK1/watch as120MHz. Measurements contradict this for this setup: a120million-watch-tick idle capture consumes approximately121million SYS ticks including host overhead; SCK half-period600Kasli ticks corresponds to200watch ticks, while Kasli uses the supplied120.2361MHz reference. Thus watch is approximately SYS rate,40.0787MHz, not120MHz. The heartbeat ratio provides a consistent cross-check. This is inferred frequency ratio, not a frequency-counter calibration. The waveform uses40.0787MHz and labels that assumption; the CSR frequency declaration must not be used as measured truth.

Do not automatically change CDCE outputs0/1/2 or use this finding to claim a specific root cause. The existing TDC frontend's120MHz input assumptions need separate clock audit before rated-throughput or absolute timing qualification. Historical functional TDC records remain raw observations, not proof of correct internal clock configuration.

## FIN hypothesis and PLL control

See[FIN input analysis](../FIN_INPUTS.md). Schematic FIN1101K8X has100Ω termination on both sides; its open-circuit fail-safe statement does not qualify a disconnected transmitter with termination. No physical FIN defect is established. Enabled Kasli CSR alone is not a continuous OE measurement: gateware additionally gates output with ready.

Earlier diagnostic @PLL used the existing CDCE status-read protocol, without frequency/profile writes. A subsequent probe issued no UART command at all: after SPI read1 the PM link timed out, then recovered with restarted SYS. It is retained as an interrupted experiment, not a completed scan. Live MCU background execution was never halted or disabled.

Next discrimination requires oscilloscope observation of SPI after the FIN/HDMI adapter and clock/reference behavior, ideally with a reference independent of the Texas PLL. Hardware wiring is not established. Do not classify the cause as FIN, MCU, external PLL or bad PM assembly yet.

## Reproduction and limitations

[source and exact diagnostic bit](source-and-bit.tar.gz),[HDL/TB](observer-source),[qualification](qualification),[deploy source](deploy.py),[analysis script](analyze.py). Station deployment scripts use explicit absolute board paths and all three shared leases, verify DNA/candidate/golden SHA, and restore golden in finally. Do not substitute a board or use this script without matching identity/cabling. Restore path deliberately leaves Kasli SPI driven; legacy global STOP/input_cards cleanup is forbidden in this state.

Final observer a21984fb: synthesis/implementation, setup+hold and DRC checks pass (only the baseline unused vendor FIFO warning); WNS0.034ns/WHS0.044ns. Icarus simulation checks startup-latch clearing, SYS reset survival, rearm and logical short-pulse capture. It is not an analog minimum pulse-width guarantee. An earlier observer trial prematurely froze from a startup latch; its logs and golden restoration are retained under startup-latch-rejected and are not used as measurements.
