# PM12 MCU, FPGA SPI and config-flash diagnostic

Offline build/host tests and physical MCU UART/SPI/register-read diagnostics PASS.
MCU application f9869c9 was programmed2026-10-15 after backup, with full readback
and protected-memory comparison PASS. Configuration flash contents were not written.
Flash boot and PG timing remain unconfirmed; direct MCU INA3221 is not implemented.
The original PSU startup, PG timeout/shutdown, thermal protection and bootloader
remain in the development image. PG observer records elapsed time separately.

Build the MCU image in a new isolated worktree:

```sh
diagnostics/pm12/mcu/build.sh /path/to/FIT_PM_FW_uPC /absolute/new/worktree
```

Firmware is `development/build/development.hex`. The patch pins recovered source
commit 30dec0a; native tests and zero-difference golden baseline are checked.
Firmware changes and artifact hashes are in `diagnostic_contract.json`.

Build the matching Kintex diagnostic offline:

```sh
diagnostics/pm12/mcu/fpga/build.sh
```

Vivado 2025.2 support for xc7k160tffg676-3 is required. The generated RTL and BRAM
initialization are included; pinned Python dependency commits for regeneration
are in `fpga/validation.json`. GHDL simulation checks the SPI slave. Output is
`fpga/build/pm12_mcu_spi_diag.bit`. This image also includes the existing fixed
1000BASE-X Ethernet / I2C1 diagnostic (192.168.2.240:40000). Integration in this
new image has only offline validation. SPI is MCU SCK F22, MOSI G25, MISO G24,
active-low CS E26. MISO uses OBUFT and is high impedance when CS is high.

After UART wiring/programming and volatile FPGA loading are separately prepared,
run bounded UART capture under the shared PM12 board lock:

```sh
python3 diagnostics/pm12/mcu/read_uart.py --port /dev/serial/by-id/IDENTIFIED-PM12 --out uart.json --fpga-test
```

`--fpga-test` adds register reads and 32 walking-one/zero patterns, then restores
and verifies scratch register 40. IDs 504D/5350 at 41/42 are checked before writes.
Register 43 is version 0001, 44 the write counter. Without this option only the
existing read-only MCU diagnostics run. The serial adapter suppresses DTR/RTS
assertion; add `--rtscts` only after checking the four-wire console connections.

Configuration inspection is explicit and **destroys the volatile FPGA image**:
`@CFG` reads INIT_B/DONE/PROGRAM_B, `@CFG HOLD` asserts PROGRAM_B and enables
MCU SPIE ownership, `@FLASHID` reads opcode 9F, `@FLASHREAD 000000 10` reads opcode
03 (at most 16 bytes). Wait for DONE low before flash reads. No write-enable,
program or erase command exists. The original roughly five-second FPGA retry
remains active: HOLD is a short inspection, not a persistent programming mode.
Every flash transaction verifies ownership and releases CS even on timeout.

`@CFG BOOT` disables SPIE, releases the configuration bus and raises PROGRAM_B.
The response confirms only a request. Require INIT/DONE within a bounded deadline
and arrange JTAG restoration of the known SRAM image if flash boot fails or its
contents are unknown. Config-reset operations are deliberately excluded from
`read_uart.py`. Hold the PM12 lock over reset, UART, tests and restoration.


## PM12 console wiring confirmed 2026-10-15

Gembird/Prolific USB RS232 adapter: stable by-id
`usb-Prolific_Technology_Inc._USB-Serial_Controller-if00-port0`, 115200 8N1.
Adapter DB9 to PM12 X6 RJ45 numbering: 2→2, 3→3, 5→5, 7→7, 8→8.
Pin2 is board TX / host RX; pin3 board RX / host TX; pin7 board CTS / host RTS;
pin8 board RTS / host CTS. Previously swapped pins3/7 caused the original
console to emit only a few bytes per command. Correct wiring and asserted host
RTS gave complete replies. PF0 is MCU RTS output; PF1 is MCU CTS input.


## Physical validation2026-10-15

See [summary](evidence/2026-10-15/hardware-summary.json) and adjacent raw UART
records. Original physical FLASH matched golden e80e8612… exactly. Application
page programming with AVRDUDE6.3 PASS, full canonical FLASH matched candidate,
and boot/EEPROM/fuses/lock/user+production signatures were unchanged. Physical
fuse4 was F3 and retained; the historical programming ELF E3 was not applied.
Raw memory backups remain on the host at the location recorded in the summary.

ADT7311 ID C3/temperature, all three THS788 chipID reads8010, CDCE readback,
original RS status and21 FPGA tests (672 walking-bit patterns) PASS. Each
10-run SPI batch produced writecount014A (320patterns+10restorations). The
published read_uart.py with --rtscts --fpga-test also completed successfully.
Use --rtscts with the confirmed four-wire Gembird wiring.

Config-flash normal-owner rejection, HOLD/DONE-low, JEDEC016017,48 bytes of
READ03 and BOOT/bus release PASS. Those48 bytes were FF; this is not evidence
that the entire memory is blank. DONE did not assert in the2s observation, so
booting a stored image is NOT_CONFIRMED. Matching diagnostic was restored to
SRAM and SPI tests repeated successfully. PGTIME=NOT_STARTED: no physical
EN-to-PG rise/timeout proof. Fault injection, MCU INA/PA1 serialization and
full peripheral acquisition remain separate unvalidated work.

Current board: MCU diagnostic f9869c9, passive I2C/SPI FPGA504d5a02 in SRAM,
power ON/OK, NORMAL~32C, INTERNAL/PLL LOCKED. Original RS reports FPGA not ready
because production status is not emulated; this is not a failed SPI test.

PDI note: AVRDUDE6.3 defaults to Xmega per-page erase; do not use -e (chip erase)
or -D (disables page erase). Program only application after physical backup.
Its raw flash/boot output trims FF tails. The included PDI configuration adds a
bounded app_full alias for complete128KiB reads and rollback, preserving boot
and EEPROM. The alias read was physically checked against the full backup;
rollback writes were prepared but not needed/tested. Never substitute supplied
fuse/EEPROM files for the physical backup.
