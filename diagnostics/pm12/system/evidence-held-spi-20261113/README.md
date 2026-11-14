# HDMI SPI restart isolation — 2026-11-13

This follow-up supersedes the earlier causal attribution to output release. It does NOT replace or erase the earlier assembly FAIL.

The DIOT LVDS repeaters have direction control, not a demonstrated output Hi-Z mode. Disabling the Kasli FPGA output while its repeater still transmits leaves the repeater input undefined. The current station entry uses `hold_spi.py`, retains FPGA output enable and slot6 mask0x00b0 (data0–3; SPI outputs4/5/7, input6), and leaves SEL/SCK/MOSI at idle0. It restores service I2C routing only. Slot7 and analog stimulus are untouched. No reset, programming or clock-profile commands were issued.

## Physical observations

* Three complete held-output HDMI trials: walking patterns, slow/fast PRBS, native idle and signatures4844/4d49/1 remain valid. SYS counter still restarts. The overall result is FAIL.
* Separate isolation started with the output already held and did not change card directions or FPGA enable. Twelve PM HDMI mode writes and idle observations are monotonic. Reads0/1/2 all return correct signatures.
* After read1, uptime drops from1974495869 to43798614 ticks. After read2 it drops from43974248 to3701546. Both occur after transfer completion, while Kasli enable=1 and idle status=9. Therefore release cannot be the sole trigger; the prior20ms observation window failed to distinguish delayed effects from release.
* MCU–FPGA scratch/write-count registers0x20/0x21 remain0/33 throughout isolation, across SYS restarts. SYS scratch/write-count registers3/4 reset. The former SPI counters have no SYS reset input in the generated design; this supports a domain reset rather than whole-chip reconfiguration. It does not directly measure PROGRAM_B/INIT_B/DONE electrically.
* Postflight12samples over approximately3seconds with held idle are monotonic, enable1/status9. MCU PGOOD checks before/after pass. They do not exclude sub-millisecond supply excursions.

## Reset path from the c7c42d28 source

Generated build-id is c7c42d28, matching live identity. SYS is produced by fixed_cm MMCM from the MGT reference path. Its reset synchronizer is asserted by NOT fixed_cm.locked. The uptime register has no host clear command; its reset is SYS reset. The isolated HDMI SPI slave has no logical reset connection to SYS. Source excerpts are retained under clock-source.

This narrows the investigation to why those SPI transactions disturb the SYS clock/LOCK path (including possible MCU interaction on shared HSEL/HSCK/HMOSI/HMISO). It does not yet prove external PLL loss of lock, clock switching, power disturbance or a specific MCU action. A sticky clock-loss observer in an independent clock domain or oscilloscope capture of clock/LOCK/SPI is needed to identify the electrical cause.

Current state: PM c7c42d28 resident, Kasli HDMI output enable1, slot6 direction0x00b0 held, SEL/SCK/MOSI0, HDMI mode0, last physical ADC A buffer retained, MCU power protection unchanged. Do not run legacy `host.pm_system_test.run`, `station.py integrated`, `input_cards` or global STOP against this state: they release HDMI outputs. Historical measurement sources remain unchanged to preserve campaign contracts.

Current command (same board only, owns all three leases):

```
./run-python /home/codex-hil/fit-testing-publish/diagnostics/pm12/system/hold_spi.py --out /srv/codex-hil-nvme/NEW-HELD-RUN --repeat 3
```

Use `isolate_spi_hold.py --out NEW-DIRECTORY` only after outputs are already held. It rejects a disabled/busy transmitter. Repeating SPI currently reproduces the domain reset; no full PASS is claimed. The source `HeldAdapter.stop` was checked with a mock: enabled/idle accepted, disabled/busy/error states rejected, zero writes in all four cases.
