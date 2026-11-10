# PM12: IPbus ADC buffers and passive I2C analyzer

Physical functional qualification **PASS2026-10-15**: native IPbus, official
uHAL,12-buffer real A/B/A, passive I2C/JTAG comparison, MCU sensors/SPI,
three PHY resets and verified CPLD restoration. See
[validation](validation-2026-10-15.json), [raw captures](measured/) and
[current state](CURRENT_STATE.md). Analog conversion remains unqualified.

The actual CERN IPbus v1.16 controller connects to the LiteEth 1000BASE-X
GTX PHY/MAC. Static endpoint `192.168.2.240:50001`, MAC `02:00:00:00:12:01`.
`addresses.xml` works with official uHAL. The controller has16 RX/TX packet
buffers, matching uHAL's16-packet in-flight window. The smaller RNG prototype
with4 buffers failed long pipelined reads; native stop-and-wait tests alone
did not reveal that failure. Upstream revision/local changes and Apache
license are included under `ipbus/` and `ipbus-sources.json`.

Twelve BRAM buffers each record4096 raw16-bit words at nominal320MHz, a12.8us
window. Physical samples contain ADC bits0..11, propagated CPLD EV bank bit12,
and forwarded nominal80MHz clock on STR bit13. The EV chain selects ADC A or B
on all twelve channels; acquisition waits25us for selection to settle.

Inputs use independent two-flop sampling. This diagnoses functional bus,
clock and selection activity; it does not qualify source-synchronous ADC
setup/hold or analog conversion accuracy. AFE/reference initialization and
a known stimulus remain required. Synthetic mode tests every buffer address
without relying on external ADC activity.

The original MCU SPI diagnostic slave is retained. FPGA I2C pins are strictly
input-only, with independent event RAM read ports for IPbus and JTAG.
**All acquisition ARM controls are IPbus-only.** JTAG USER2 changes only the
read cursor; arbitrary hardware-manager scans cannot arm/overwrite a trace.
New USER1 magic is `504d5a04`, with the original lower208-bit report layout.
Legacy standalone `504d5a03` capture tools cannot arm this image. The provided
`capture.tcl` waits for its parent to arm via IPbus, then dumps through JTAG.

The earlier standalone analyzer arms on either change of USER2 bit15. Physical
close/reopen changed the final command to zero and overwrote its frozen trace.
Both a fresh-shift UPDATE guard and rising-only ARM proved insufficient on
hardware. No claim is made about the hardware manager's exact internal scan
sequence. The integrated image therefore removes JTAG ARM entirely. Historical
rollback bit e215a8c3... retains that known limitation.

## Word addresses

|Address(hex)|Access|Meaning|
|---|---|---|
|0..2|R|Device504d1202, ABI00010001, exact-source build ID|
|3 /4|RW /R|Scratch / successful write count|
|5..6|R|Nominal40MHz uptime, low/high|
|7..9|R|System frequency, sample frequency, feature mask|
|10|RW|Control: bit0 ARM, bit1 bank B, bit8 synthetic|
|11|R|Status bits0..6: valid,busy,link,MMCM lock,synthetic,bank B,timeout|
|12..14|R|Capture ID, depth4096, channels12|
|20..21|R|Best-effort synchronized MCU SPI scratch/write count|
|100|W|I2C trace ARM bit0|
|101..105|R|Event count,active,elapsed,current lines,I2C acquisition ID|
|2000..2fff|R|I2C events: timestamp word then SDA/SCL/RESET_N bits|
|10000..1bfff|R|Twelve ADC buffers,4096 words per channel|

Unmapped/read-only writes, reserved control bits, busy acquisitions and reads
of invalid/unwritten buffers return bus errors. Completed buffers stay frozen
until an explicit new control write. Acquisition IDs detect changed captures.

## Prepared laboratory host

First prepare the CPLD mux/export as described in [the ADC diagnostic](../adc/README.md)
(`../adc/cpld/build.sh`, `../adc/tools/export_vendor.sh`). Then:

```sh
./build.sh
./build_uhal.sh
python3 test_hardware.py --program-cplds --leave-loaded --out /tmp/pm12-ipbus-run
python3 client.py --out /tmp/pm12-frozen-adc
```

The guarded hardware runner holds both PM12 and Atmel-ICE leases, verifies
both NV and SRAM are blank, checks MCU PGOOD before peripheral operations,
qualifies IPbus/native and official uHAL, programs the known CPLD mux,
records real A/B/A, compares I2C via JTAG/IPbus, and regresses MCU sensors/SPI.
It restores every blank CPLD NV/SRAM row on every exit. No MCU or FPGA flash
programming occurs. Failure restores the exact historical standalone FPGA;
`--leave-loaded` retains the integrated FPGA only after full success, including
a frozen ADC buffer. The explicit restore image and MCU power/console helpers
are dependencies from the existing local recovery workspace.

`--trace-only` omits CPLD programming and real ADC acquisitions. The standalone
client holds both leases and reads frozen data by default. `--acquire --pattern`
works with blank CPLDs; real `--acquire` requires the diagnostic CPLD mux.
Read timeouts permit at most two retries, recorded in evidence. Writes, ARM
and RMW are never automatically repeated.

`uhal_dump` downloads frozen physical data using the official uHAL library.
`test_retained.py` holds both leases, compares every byte with native IPbus,
restarts PHY three times, checks ADC/I2C storage across JTAG close/reopen,
and explicitly rearms another I2C trace through IPbus.

## Software checks

`test_registers.py` covers every simulated channel/address in A/B/A,
continuous-strobe bursts, nonincrementing operations, side-effect counts,
negative controls, freeze/MMCM loss/recovery, independent I2C read ports,
arbitrary USER2 scans without rearm, and explicit IPbus rearm.
`test_client.py` uses localhost UDP only to test lost/stale/malformed replies,
bounded read retries and no write/RMW duplication. `test_jtag.v` separately
checks fresh command qualification and stale/empty UPDATE handling; that
primitive-level guard alone did not fix the physical ARM issue.

## Recovery observations

Upper JTAG bits208..511 contain network magic504d4442, flags32, RX/TX frame
counts32, RX/TX byte counts32, RX-error16/padding16, IPbus-strobe cycles32,
net-clock tick32 and actual USER2 command16. Flags are link,capture-MMCM lock,
net-MMCM lock,got-IP,net reset,CPLL lock,TX init,RX init,TX-MMCM lock,
RX-MMCM lock,manual PHY reset,startup hold. Snapshots are asynchronous and
best-effort, not atomic traffic accounting.

The exact USER2 word `0x6b52` requests a volatile PHY reset; restore the prior
word to release it. Other USER2 values never control ARM. Startup holds PHY
reset for nominal50ms. Both RX/TX and MCU firmware remain independent of the
ADC frozen-buffer readout. FPGA programming is SRAM-only.
