# Individual HDMI SPI pin test

Temporary SRAM-only Kasli extension built from the exact retained four-CFD
source. External FIN direction remains slot6 mask0x00b0. FIN direction control
selects opposing repeaters; it is not a both-sides-disable command.

The patch replaces only the three SPI pad data sources with a mux. FPGA
output enable remains the original enabled&ready expression. No clock,
transceiver or PM image change is part of the extension. At17c, writes0..15
set config: bit3manual; bits2:0MOSI/SCK/SEL. Normal config0 uses the original
master. Writes while busy, invalid values and wrong addresses are ignored.
Reset/readiness loss returns normal mode. Read17c has marker5350 in bits31:16,
config in15:8 and the original capture-valid bit0. Historical helpers expecting
read17c==1 are incompatible with this temporary image; restore first.

Procedure: acquire PM/MCU/Kasli leases, identify both boards, verify candidate
implementation and exact fallback hash, load candidate, reconnect bridge and
enable stable SPI, verify/read back the existing direction latches. Compare
normal read frames before and after individual GPIO trials. During raw trials:
SEL alone with SCK/MOSI0; SCK alone with SEL/MOSI0; MOSI alone with SEL/SCK0;
MOSI with SEL1 but SCK0. No complete arbitrary SPI command is sent. No FPGA
OE release or direction change during GPIO trials. Kasli reloading itself
necessarily interrupts its outputs; that programming interval is excluded.

Always restore the exact four-port image in finally, re-enable held SPI,
restore mode/divider, check PM buildc7531465, MCU power, frontend0xfff and
fresh physical ADC acquisition. No MCU/CPLD/flash/external PLL programming.

prepare.py copies retained generated sources into a new directory. Build
with shared Dell slot and Vivado. pin_override.v/tb.v checks all eight manual
values, normal passthrough, busy/invalid guards and reset/readiness fallback.
test_pins.py --work ARTIFACT_ROOT owns all leases and restores the fallback.
