# PM HDMI SPI parser held in reset

Temporary PM image from the clock-corrected c7531465 baseline. Kasli is not
reloaded, no buffer directions/OE or external PLL settings are changed.
The original hdmi_slave sees internal SEL=physical HSEL AND NOT hold_reset.
This keeps its count/reading state in the original deselected/reset branch
while physical SCK/HSEL/MOSI remain driven normally. MISO data is forced0;
physical output enable remains the original NOT HSEL. Debug scratch/write
counters are retained; no peripheral or MCU SPI engine is reset here.

Runtime IPbus word305 accepts only0/1 and reads53520000|hold. Hold defaults0
at FPGA configuration and deliberately survives SYS resets: it is a separate
SYS-clocked register with initialization and no SYS reset input. Writes are
accepted only outside SYS reset. Toggle it only while Kasli master is idle.
Normal HDMI mode301 and ADC/TDC/clock functions are unchanged.

Test: three shared leases and physical DNA/power checks; temporary SRAM load;
invalid hold-write rejection; normal signatures; alternating matched read3
blocks (normal/held), then held and normal signature controls. Read3 is an
isolated diagnostic address returning0. Prime in normal mode first so normal
and held cases have logically zero MISO data. It is not a continuous electrical
pad measurement. Same Kasli image, divider and stimulus in each matched block.
Record counter decreases, timeouts and retained hold independently. A missing
read is unknown, not a reset or stable PASS. Positive normal controls are
required to distinguish suppression from non-reproduction after programming.

Always restore exact PMc7531465 in finally, with Kasli SPI still driven.
Check identity/power/frontend and fresh physical ADC. No MCU/CPLD/flash or
external clock-profile programming. All heavy builds use Dell and shared slots.
prepare.py emits isolated sources/new ID; test_reset.py --work ROOT performs
hardware test/restoration. TB checks original signatures, held parser state
under full clocked frames, zero MISO and release recovery.

The authoritative derivative manifest is reset-build.json; retained older manifests
describe the baseline. Build the prepared HDL/Tcl directly. Re-running the old
Migen generate.py would omit this wrapper; apply prepare.py to a fresh baseline.
