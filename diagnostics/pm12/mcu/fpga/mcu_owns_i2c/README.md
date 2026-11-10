# FPGA with MCU ownership of I2C

Build: `vivado -mode batch -nolog -nojournal -source build.tcl`.
Generated RTL and memory initialization are included. Regeneration uses the
same pinned Migen/LiteX environment as the parent diagnostic.

SDA H22, SCL H21 and RESET_N B26 are **input-only IBUF** in this variant. No FPGA
output driver exists for these nets, independently of UDP requests. RESET input
retains its pull-up. I2C1 zero-mask queries/releases are accepted; nonzero drive
requests are dropped. JTAG USER1 signature is `504d5a02`. Original MCU SPI slave
and fixed 1000BASE-X networking remain present.

Offline Vivado implementation/bitstream and generated-port checks PASS.
On 2026-10-15 physical SRAM loading/signature, ten Ethernet line queries and
five denied nonzero-drive requests with subsequent recovery PASS. SDA/SCL/RESET
were all HIGH; reported drive mask was zero. Original MCU status still reported
power ON/OK, NORMAL temperature and INTERNAL/PLL LOCKED after loading.
Raw evidence is in `evidence/`. This input-only image remains in FPGA SRAM;
no configuration flash or MCU memory was written.

This image alone does not add INA3221 support to the MCU or serialize its legacy
temperature clock on PA1. A compatible MCU software-I2C/temperature ownership
implementation is required before direct MCU sensor testing. It is absent from
both current diagnostic f9869c9 and recovery pm12-dev-001-timer-relocated.

HS2 210249A73E43 and original UART recovered after user rewiring. Atmel-ICE
J41800043065 was identified, but USB permissions blocked PDI before MCU access.
MCU backup/programming, SPI walking-pattern tests and MCU INA3221 reads remain
NOT_RUN. Current FPGA input-only operation is not validation of power-off
isolation or MCU ownership transitions. All hardware work uses the PM12 lease.


Superseding MCU checkpoint2026-10-15: Atmel-ICE permissions were restored;
MCU diagnostic f9869c9 was programmed and verified, and672 SPI patterns plus
read-only config-flash ownership/JEDEC/data/release passed. The matching
passive FPGA was reloaded after config tests and remains in SRAM. See the
parent MCU evidence summary for the current board state and pending scopes.
