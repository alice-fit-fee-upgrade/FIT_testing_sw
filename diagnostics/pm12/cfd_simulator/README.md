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
MCXJ7 is connected toIC2 COM. MCXJ9 center appears unconnected on this PDF;
do not assume these are a daisy-chain pair without checking the PCB.

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
