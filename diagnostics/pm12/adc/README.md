# PM12 ADC functional diagnostic

XC2C128 diagnostic multiplexes the two AD9236 outputs on each
channel, tags the selected ADC in DOUT12, forwards ADC CLK80 through DV/STR,
and passes EV through the CPLD chain. EV originates on Kintex F23 and enters
CPLD12 before CPLD11…CPLD1. Selection is global: EV=0 ADC A, EV=1 ADC B.
Original falling-edge CLK80 charge-integrator clocks are preserved.

Kintex captures all 12 channels simultaneously in 12 BRAM buffers of 4096
16-bit raw samples. Bits 0…11 ADC, bit12 selector, bit13 forwarded clock.
Capture clock 320 MHz is generated from currently measured nominal MCLK1 40 MHz.
MCLK1 uses internal differential termination, matching the proven link diagnostic.
Independent two-flop input sampling records transitions; it does not replace
source-synchronous timing qualification. Host uses raw STR transitions to
estimate clock frequency and examine data plateaus.

Ethernet: 1 Gb/s fixed-rate 1000BASE-X, standard polarity, 200 MHz GTX reference,
MAC 02:00:00:00:12:01, IPv4 192.168.2.240, UDP40000. LiteEth supplies ARP and ICMP.
Do not use an already occupied IP. Acquisition control is stop-and-wait.

Request `!4sBBBB`: ADC1, opcode, channel0…11, bank0…1, page0…7.
0=status, 1=set bank and acquire all buffers, 2=read 512 samples.
Reply `!4sBBBBII`: ADC1, opcode|128, channel, bank, page, capture_id, flags;
flags bits0/1/2=capture-valid/link/MMCM-lock. READ appends 512 little-endian u16.
Capture IDs reject delayed pages from old acquisitions. Malformed requests
are dropped; READ requires a valid acquisition with matching bank.

## Build and simulation

Use shared ISE14.7 for `cpld/build.sh`; shared compatibility libraries are needed
on the lab host. `tools/export_vendor.sh` exports the exact 13-device programming
chain with iMPACT and converts its SVF to checked raw-JTAG Tcl. The converter
preserves IR/DR end states, masked comparisons and ISE's mixture of scoped and
full-chain scans. It bounds IR at 102 bits and accepts only CPLD programming,
erase/read/init/bypass/ID instructions. A stable DRPAUSE is inserted in the
zero-shift INIT transition that Vivado rejects directly. This avoids unsupported
ISE parsing in Vivado's built-in SVF reader and preserves vendor verification,
DONE status and security handling. No read protection is enabled.

Earlier SRAM-only attempts matched fuse readback but did not activate working
outputs. SRAM-only activation remains unvalidated; the runner uses the vendor
NV programming procedure. `tools/make_rows.py` remains available to compare
JEDEC and physical rows with all 55,341 fuse addresses covered.

FPGA generator uses the pinned LiteEth/LiteICLink/LiteX and Migen environment
from the existing PM12 Ethernet diagnostic. Generate `fpga/generate.py`, then
`vivado -mode batch -source fpga/build.tcl`. Timing failures stop bit generation.
Run `fpga/test_server.py` with the same Python environment. CPLD simulation is
`ghdl -a --std=08 cpld/adc_mux.vhd cpld/tb.vhd`, then elaborate and run `tb`.

## Hardware

Run `tools/test_hardware.py --container HW_SERVER_CONTAINER --out NEW_DIRECTORY`.
The current lab wrapper holds `~/.cache/pm12-210249A73E43.lock` throughout all
JTAG/network actions. It requires the exact 13-device chain and twice-read blank
NV baseline. It loads FPGA SRAM, programs/verifies the 12 CPLDs, captures A/B/A,
erases the diagnostic CPLD NV back to the blank baseline, reloads that NV into
SRAM and restores the documented FPGA link diagnostic. Final twice-read NV is
compared with every initial row. This test performs CPLD NV erase/program/erase
cycles. No ATxmega, PLL or FPGA flash writes occur. Abrupt interruption can leave
the diagnostic CPLD NV installed; rerun the guarded erase/restoration procedure
under the board lease, then verify the initial blank state.

For hw_server, use separate initialization arguments:
`hw_server -s tcp::3121 -e 'set jtag-port-filter 210249A73E43' -e 'set max-ir-length 128'`.
A semicolon-separated string was not interpreted as two settings on this host.

Pedestal/noise captures check clocks, selection, ADC output activity and the
transport. Full bit coverage, gain, linearity and analog accuracy require a
known input stimulus. Results must distinguish these scopes.

Pin/control reference: recovered CPLD branch [recovery/xc2c128-golden-2026](https://github.com/alice-fit-fee-upgrade/FIT_PM_GW_CPLD/tree/recovery/xc2c128-golden-2026), commit b82758b248ba75079bb0573109d63147abb0391a. This is new diagnostic logic with the recovered analog clock behavior and verified package pins.

Run `./build.sh` on the prepared laboratory host to fit CPLDs, export the vendor programming sequence, run receiver simulation, generate RTL and build the Kintex image. Tool paths can be overridden with PM12_ISE_SETTINGS, PM12_ISE_COMPAT and PM12_HDL_PYTHON.

## Output-drive test

To distinguish a constant driven code from a floating ADC data bus, build the
same CPLD logic with `PM12_CPLD_TERMINATION=pullup` and a separate
`PM12_CPLD_BUILD_DIR`. Export it with `PM12_CPLD_JED` and
`PM12_VENDOR_WORK_DIR`, then pass `--cpld-jed` and `--cpld-program` to the
hardware runner. The laboratory keeper/pullup images differ in exactly one
fuse, 55334; their logic and pins are otherwise identical. Input pullup/bus-hold
are the supported weak-bias options in [Xilinx UG445](https://docs.amd.com/api/khub/documents/sGvSBk5tpdaZRRXnyQfh7Q/content).

Unchanged data under weak pullup is evidence of driven lines. It is not a
measurement of drive strength and does not validate analog conversion accuracy.
The AD9236 uses a separate digital-driver supply; standby tri-states outputs,
according to its [datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ad9236.pdf).
PM12's schematic grounds MODE and PWDN, supplies DRVDD from P3V3, and AVDD from
P3V3_QDC. SENSE selects the external ADC_VREF. Verify analog supply/reference and
AFE initialization before interpreting the codes as charge measurements.

## Measured validation, 2026-10-14

[Validation summary](validation-2026-10-14.json): both keeper and pullup runs
PASS for all12 EV selections, all12 forwarded 80 MHz clocks, Ethernet control,
12-buffer acquisition and five malformed-command rejections. Each A/B/A run
received 147,456 raw samples. All24 A/B codes were unchanged with weak pullup;
this is evidence that ADC lines are driven, even though every trace contains a
constant word. Analog conversion, accuracy and full bit activity are not PASS
criteria at this bring-up stage. AFE and external ADC reference initialization
remain to be checked. Both runs restored the blank CPLD NV and the FPGA link
diagnostic, verified by final NV readback and FPGA signature.

Raw A/B traces and stage logs are under `measured/`. Clock values assume the
nominal 320 MHz capture clock; they are not precision frequency measurements.
