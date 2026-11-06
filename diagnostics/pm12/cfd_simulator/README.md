# Reusable DAC-A phase scan —2026-11-06

[Phase scan instructions](PHASE_SCAN.md):101 points across0..65535, selected PM12
channel and Kasli RX lanes, raw buffers/histograms/CSV, explicit DAC restoration.
Uses current UART recorder; IPbus migration deferred. Software-tested; no new
physical DAC sweep has been run.

# Channel12 B/C/D DAC sweep completed —2026-11-05

65points per DAC across raw0..65535,3 readings per point;13additional lower-edge
points0..1024. Owner explicitly deferred ADC-clock DAC A/phase to the LVDS task;
no rawA writes were made. Whole-chain observations through CFD_SIM/MCXJ9/DMM:

| DAC / monitor | Code0 (V) | Code65535 (V) | Interior gain vs nominal |
|---|---:|---:|---:|
| B / DRV_OFFSET | 1.043846000 | 1.003721000 | +0.0119% |
| C / CFD_OFFSET | 1.034097000 | 1.013671333 | +0.0018% |
| D / CFD_CMP_OFFSET | 0.004514860 | 1.062607333 | -0.0366% |

Nominal slopes from PM12 sheet11: B=-0.612745uV/code, C=-0.3125uV/code,
D=+16.262755uV/code. Fits use5–95% of the scanned span. All65-point coarse
curves are monotonic in the expected direction. This is not a complete16bit
INL/DNL or calibrated uncertainty result. Interior maximum residuals are
about1.94uV(B),2.03uV(C),80.25uV(D), including the entire analog chain and DMM.

The lower edge is nonlinear/flat: with a10uV comparison threshold, highest
tested codes remaining near their zero-code voltage are64(B),128(C),256(D).
D stays about4.49mV through code256, is about5.40mV at512 and13.67mV at1024.
The responsible part (DAC output amplifier versus external opamp/loading)
was not isolated. Zero-code residuals from interior fits: about-36.9uV(B),
-54.6uV(C),+7.412mV(D). Do not claim true zero or full resolution at that edge.

[Full curves](evidence-dac-20261105/dac-curves.png),
[lower-edge detail](evidence-dac-20261105/dac-low-edge.png),
[validation](evidence-dac-20261105/validation.json). SVG and raw CSV also retained.

Supply values are now reported AFTER the nominal33/53 divider correction:
* N5V5_PM12: -5.511384V
* P5V5_PM12: 5.486824V

Raw mux voltages remain in `volts_at_mux`, physical/report voltage in `volts`.
`report_voltage()` is used by both DC scanning and DAC scans. Divider component
tolerances are not calibrated out. DMM model/serial confirmed;10V range for
8-input scans,1V for DAC curves,5PLC, high-Z AUTO, autozeroON/filterOFF.
ASCII precision was AUTO. Readings above1V were rounded at roughly1uV in the
retained output; do not infer sub-LSB INL from averaged samples.

**State-restoration correction:** the original scan used computed STORED RAM
parameter codes as if they were active hardware state. The voltage guard caught
that this assumption was false with the diagnostic FPGA. Raw0000 on B/C/D
reproduced the initial analog levels; an independent full monitor scan and a
final selected-mux check passed. Original active register codes were not read
back. Current host REQUIRES explicit known restore codes and preserves the
failed receipt. The fine scan also initially sampled target-restored readings
after mux inhibit; those rows are invalid/excluded, ordering is corrected and
an independent final check confirms the actual voltages returned. Curve rows
were acquired while selected and are retained. No failure receipt was relabeled.

Current physical state: B/C/D explicit0000; final B/C voltage differences from
initial about1.3uV, D about5.6uV. Monitor inhibited (latch0E), TCA70/71 masks00.
Passive FPGA504d5a03 retained; scratch32bit/restore, ADTIDC3, PSU ON/PLL locked
and normal temperature rechecked. No raw DAC-A writes. Existing parameter RAM
untouched. DMM returned to10V DCV/high-Z/5PLC. All board/DMM leases released.

MCU application SHA256:
`f49643c80c6189afebdaa3f7301f4ecebacb55645e60456f66831106d38b9464`.
`@DAC 12 W B 8000` sends one raw code; `@DAC 12 S` reports computed STORED
parameter codes, NOT hardware readback. Use explicit known restoration state.
New bounded3-byte SPI driver matches recovered headers, restores chip-selects
and CTRL/IRQ state, checks power/bus ownership, times out each byte. Full MCU
development suite and additional packet/timeout/65536-pattern arithmetic tests
PASS.10 host safety tests PASS, including an offline flow test that rejects any
DMM read after mux inhibit and verifies restored codes/A exclusion.

Repeat full-span scan only with verified active restore codes, for example for
the CURRENT explicit-zero baseline:

```
python diagnostics/pm12/cfd_simulator/dac_sweep.py --out NEW_DIRECTORY --dmm-host ACTUAL_IP --restore-codes B=0000 C=0000 D=0000
```

Add `--low-codes --curve-only` for the lower-edge refinement. All scans retain
raw samples. Plotting uses the separate matplotlib3.10.7 environment on NVMe,
with requirements retained alongside evidence. No MCU/FPGA recompilation is
needed to repeat the scans. Protected MCU regions were verified unchanged;
full private backups remain outsideGit.

The following sections retain earlier work for provenance.

# Installed generic I2C console and physical DC scan —2026-11-05

PM12 S/N1803, Gembird/Prolific115200 hardware flow control. The MCU extension
is installed and checked against full FLASH readback; protected boot/EEPROM/
fuses/lock/user/prodsig unchanged against a fresh physical backup. Exact
recovered baseline remains unchanged; firmware source in FIT_PM_FW_uPC,
see docs/i2c_development_candidate.md for the full command contract.

Generic commands use hexadecimal7-bit addresses/bytes and1..8byte payloads:

```
@I2C W 70 00
@I2C W 71 08
@I2C WR 20 01 14
@I2C R 71 01
@I2C W 71 00
```

The example disconnects0x70, selectsAFE12 on0x71, reads MCP register14 and the
routing mask, then disconnects0x71. In a reusable script save BOTH old TCA masks
first and restore them in finally, as ConsoleI2C.routed does. W sends bytes;
R reads count bytes; WR sends pointer/data and reads count bytes with repeated
START. Reply example: `I2C ADDR=20 TX=14 RX=0F`. Generic writes intentionally
permit arbitrary registers: caller owns the target's semantics/restoration.
Bare @I2C status and @I2C TEST remain available. Main-loop ownership, bounded
clock stretching, physicalPG/reset guards and deferred temperature service
remain active. Reserved7-bit addresses and invalid/oversize requests rejected.

Restricted `@CFD 12 R 14` / `@CFD 12 W 14 0F` are also installed for monitor-only
control with automatic upstream-route restoration and a GPIO whitelist.
Use the Python MCP adapter for initialization/read-modify-write; preserve all
unrelated bits rather than blindly using the example on another chip/setup.

`console.py` implements generic UART transport and checked TCA routing.
`mcp23017.py` safely initializes and controls the monitor pins only.
`measure_channel12.py` ran24DCV readings through owner-confirmedMCXJ9 and the
existing labinstruments DMM driver, model/serial checked at192.168.2.16.
DMM front terminals,10V fixed range,AUTO high impedance,5PLC,autozero ON,
averaging OFF. Three-reading means (functional observations, not calibration):

| Monitor | Volts |
|---|---:|
| CFD_OFFSET | 1.034093667 |
| CFD_CMP_OFFSET | 0.004463487 |
| BUFFER_OFFSET | 1.023867667 |
| DRV_OFFSET | 1.043842333 |
| DRV_VOCM | 1.535756667 |
| N5V5_PM12_DIV | -3.431447667 |
| P1V3 | 1.321909000 |
| P5V5_PM12_DIV | 3.416380333 |

Final monitor latch0F: INH HIGH (analog output disconnected); bothTCA masks00.
Passthrough/ADC selector/integrator GPIO were preserved by the monitor scan.
Passive FPGA504d5a03 retained; legacy RS says FPGA not ready because no
production PM application is loaded; diagnostic scratch32bit check passes.
All hardware leases released and private PM hw_server stopped. Existing
Genesys server untouched. No config-flash/EEPROM/OTP writes.

Eight host safety tests plus MCU bit-level I2C/CFD tests and the full existing
development suite PASS. [Physical validation](evidence-20261105/validation.json).
Raw DC readings are in evidence-20261105/dc.csv. Private full memory backups
remain outside Git. DAC transfer curves are NOT YET measured.

Repeat the scan using the project Python environment with pyserial installed:
`python diagnostics/pm12/cfd_simulator/measure_channel12.py --out NEW_DIRECTORY --dmm-host ACTUAL_IP`.
The runner assumes the owner-confirmed inventory contains only one simulator
connected to the shared DMM (channel12). Add ALL connected simulators before
extending this to a shared multi-board measurement bus. IP is a hint; exact
DMM model/serial is checked. No instrument reset or PSU switching is performed.

The following sections retain earlier preparation history.

# Schematic acquired —2026-11-05 update

Correct source is `Alice/cfd_sim.pdf`,339862bytes, SHA256
`a9191a74a35cb42cab16e857c8262fc32c4f43831b74607d47f1a8c8ac409305`.
Four schematic pages, print2026-11-05. This supersedes the missing-schematic
blocker below. [Verified transcription](schematic-map.json).

MCP23017 address0x20 (A0/A1/A2 grounded through56ohm resistors), RESET tied3.3V.
PM12 schematic sheet35 maps physical AFE12 toTCA0x71 bit3(mask08);0x70 must
be isolated to avoid another same-address simulator. Restore BOTH mux masks.
This is schematic-derived routing, not an ACK/address-discovery result.

Monitor IC2: select0..7 = CFD_OFFSET, CFD_CMP_OFFSET, BUFFER_OFFSET, DRV_OFFSET,
DRV_VOCM, divided negative raw supply, P1V3, divided positive raw supply.
Supply dividers are33/53: nominal±3.4245V for±5.5V. These are functional
reference points, not calibrated standards. P1V3 has20k/100nF filtering.
MCXJ7 is connected toIC2 COM. Owner confirmedMCXJ9 connected; the subsequent physical scan throughJ9 passed.

`mcp23017.py` implements the physical mapping A0/A1/A2=GPA2/GPA1/GPA0,
INH=GPA3. Active select codes are0,4,2,6,1,5,3,7. It preloads INH HIGH before
configuring only GPA0..3 as outputs, and forbids changes to other latch bits.
GPA7/T1 is left untouched; GPB5..7 ADC injection switching is left untouched.
Hardware R8/R10 pullups inhibit monitor/ADC switches after MCP reset;
R23 pulldown keepsT1 off. These defaults are schematic-derived, not measured.
IC3 switches the positive and negative injection poles separately between
ADCA andADCB; opposite selector states can mix two different ADCs. A future
ADC-selection command must change both poles together while inhibited.

Seven software tests pass, including physical bit ordering, unrelated-control
preservation and abort before output enable on bank/readback mismatch.

Read-only UART probe under BOTH hardware leases: CP2103 serial0001 at115200
responded to `@PING` with echo and `Password:`. This is not an identified PM12
extension console; no login attempts, reset or programming performed. Evidence
is private under artifacts/cfd-simulator-20261105/uart-identify.json. Awaiting
owner clarification of CP2103 versus historical Prolific/Gembird console.

Remaining implementation: typed MCU I2C backend/console integration, exact SPI
DAC channel/code mapping and restorable initial state, then real DCV scans.
`regs.read/write` in the Python adapter is an explicit integration interface,
not an existing MCU command. No physical mux selection or DMM measurement yet.

The text below records the initial assembly-only stage for provenance.

# CFD_SIM DC monitor and DAC sweeps — work in progress

Owner request2026-11-05: one simulator fitted to PM12 physical channel12
(numbering1..12). This is NOT yet a verified MCU/DAC channel index or I2C route.

SMB `codex-hil/Alice/FIT_CFD.PDF` was freshly retrieved. SHA256
`e2b6ac0f8c9fc124e96147feb99554d5d5c4ab043d7f680d4f01964053754ee3`,
358292bytes, Altium export2026-11-04. It is one assembly drawing, CFD_SIMv1.0,
NOT a schematic. Visually identifiable parts include MCP23017-E/SO, MAX4051,
MAX4053, SN65LVDS1/SN65LVDS101 and BSS138. This differs from the public legacy
CFD release and the HDMI adapter previously discussed in the thread.
Local private source copy: fit-bringup/documentation/cfd-simulator/FIT_CFD.PDF.
No schematic, netlist, GPIO allocation or mux signal map was obtained.

Owner-described signal paths, pending schematic verification:

* External pulse injection to integrator or ADC through an analog selector.
* T1/OT1 control disables the internal integrator for external DAC injection.
* IC2 monitor mux sends one of eight internal DC signals to the shared MCX DMM.
* SPI-controlled PM12 DAC outputs are to be swept using the ATxmega console.

`control.py` implements break-before-make monitor selection, preserving all
unrelated GPIO bits; all-off across the COMPLETE inventory of connected
simulators before selection, between points and in finally; eight-channel
DC scanning; DAC-code scans with original-state capture and restoration.
Latched output readback is checked; this does not prove analog isolation.
If an all-off operation fails, shutdown is attempted on other boards and the
failure is reported. Software cannot guarantee an open analog switch during
lost power/I2C communication. Hardware reset/default inhibition must be
verified from the schematic. No startup GPIO direction is configured by this
host engine; that belongs in the schematic-specific MCU initialization.

`dmm.py` reuses `labinstruments.drivers.Driver` and an existing Transport. It
checks the model/serial, physical terminal selection, configures and reads
back DCV range/NPLC/high input impedance/autozero/filter, and requests READ?
only after verifying DCV. The driver is prepared but NOT physically tested.
SCPI references: local official DMM7510-901-01 RevC manual, sections11-8,
11-46,11-65,11-77. No remote instrument was configured in this task.

## What is intentionally unresolved

Obtain schematic/SchDoc/netlist, then fill the actual MCP address, bus route,
GPIO directions, address/inhibit pins, monitor0..7 signal names and polarity,
MAX4053 injection controls and T1 safe state. Do not guess these assignments.
The existing PM12 extension @I2C reports bus state and supports lock testing;
it is NOT an arbitrary MCP23017 register proxy. A typed MCU command/backend
must be added in the separately authorized development extension, preserving
power-good shutdown behavior, shared-bus ownership and other mux routing.
The exact recovered firmware baseline must remain unchanged.

For DAC sweeps, determine actual physical-channel12 SPI chip select, DAC output
mapping and safe code limits; obtain/restorably track initial DAC codes before
writing. Initial host sweep could use65points upward/downward plus selected
adjacent transitions. This is functional transfer characterization, not full
16-bit INL/DNL qualification. Save each result immediately with mux signal,
DAC/channel/code, timestamp, DMM settings and settling interval.

Hardware runner still needs integration with the PM12 console, real GPIO
initialization, the complete shared-MCX inventory and device leases (both
PM12/Atmel leases plus DMM serialization). Respect existing PGOOD checks before
access to powered PM12 peripherals. Confirm physical DMM HI/LO/terminal cabling.
No automatic hardware CLI is provided while these connections are unknown.

## Verification

`python3 -m unittest discover -s diagnostics/pm12/cfd_simulator -v`

Five simulated safety tests passed: break-before-make/preserved GPIO bits,
all-eight scanning and off after DMM timeout, continued isolation attempts
after I2C failure, DAC restoration after output-file failure and no DAC writes
when the original state cannot be obtained. These are NOT physical measurements.
No MCU/FPGA/flash changes, I2C/SPI writes or instrument configuration performed.
