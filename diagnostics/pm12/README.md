# PM12 JTAG connection test

Tests the 168 CPLD-to-FPGA DI/STR connections on PM12: twelve XC2C128 VQ100
CPLDs and one XC7K160T FFG676-3. Each connection is discovered by measured
walking-one and walking-zero responses, then compared with the PM12 schematic.
The test runs both through diagnostic gateware and independently through FPGA
boundary scan. It also checks monitor clock activity, reset, freeze and resume.

The script loads the FPGA SRAM only. CPLD EXTEST temporarily interrupts normal
acquisition. Sampled non-link boundary values are preloaded, and only the fourteen
link output enables per CPLD are forced active. Cleanup resets the TAPs and restores
functional CPLD operation. The diagnostic FPGA image remains loaded afterwards.
No CPLD firmware, FPGA flash or ATxmega programming is performed.

## Requirements

- Linux and Python 3.9+; Python standard library only.
- Vivado with Kintex-7 device support; validated using Vivado 2025.2.
- A running AMD `hw_server` with access to the selected JTAG cable.
- PM12 powered up with its normal supply management firmware.
- The actual cable serial number. The validated laboratory cable is
  Digilent HS2 `210249A73E43`; no automatic selection among other boards.

## Build the diagnostic

```sh
vivado -mode batch -source diagnostics/pm12/gateware/build.tcl
```

Output: `diagnostics/pm12/gateware/build/pm12_link_diag.bit`.
All pins are inputs; the diagnostic does not drive the DI/STR buses.
`pins.xdc` maps all 168 lines plus the MCLK1 LVDS pair to the schematic.
The clocks are constrained at 40.0787 MHz and JTAG 1 MHz. Asynchronous
observations are excluded from synchronous timing analysis.

## Run

With native Vivado and `hw_server` on localhost:

```sh
python3 diagnostics/pm12/test_board.py \
  --serial 210249A73E43 \
  --bitstream diagnostics/pm12/gateware/build/pm12_link_diag.bit
```

Use `--server HOST:3121` for a remote server. Use `--skip-program` instead
of `--bitstream` to test an already loaded compatible diagnostic; its signature
is checked before EXTEST. Programming uses one continuous CFG_IN scan because
fragmenting it into DRPAUSE scans failed on this chain.

On the shared rootless Docker laboratory host, run Vivado inside the active
`hw_server` container so `localhost:3121` resolves correctly. Find its actual
container ID with `docker -H unix:///run/user/1001/docker-vivado.sock ps`, then:

```sh
python3 diagnostics/pm12/test_board.py \
  --serial 210249A73E43 \
  --bitstream diagnostics/pm12/gateware/build/pm12_link_diag.bit \
  --vivado-command 'docker -H unix:///run/user/1001/docker-vivado.sock exec CONTAINER_ID /srv/codex-hil-data/toolchains/amd/Xilinx/2025.2/Vivado/bin/vivado'
```

Default hardware lease: `~/.cache/pm12-SERIAL.lock`. All other users of that board
must use the same lease. `--lock` overrides its path. The lease covers loading,
both discoveries, monitor tests and final TAP restoration. `--step-timeout`
defaults to 240 seconds; one 6.4 MB SRAM configuration scan at 1 MHz takes about
one minute. Test stages exit nonzero on failure. Use `--output NEW_DIRECTORY`
to choose a new report directory; existing directories are not overwritten.

## Results and limits

`results/TIMESTAMP/report.json` contains the verdict, per-line discovery,
bitstream hash and control results. `connections.csv` lists FPGA balls and
measured CPLD channels/pins. Raw JTAG stage logs are preserved. Each discovery
uses 338 vectors: all zeros, all ones, 168 walking ones and 168 walking zeros.
A PASS requires all 168 mappings and both logic levels to match in both receive
paths, monitor controls to pass, and final restoration to succeed.

This is a static functional connection test. It does not validate at-speed
acquisition timing, ADCs, analog circuitry or the current production CPLD
firmware. Clock frequency is estimated from host/JTAG elapsed time and is not a
precision measurement. Raw SAMPLE/EXTEST can stop other CPLD-generated signals
during the test. An uncatchable process/host failure can interrupt cleanup;
a JTAG TAP reset restores normal CPLD mode.

`pinmap.json` records the schematic SHA-256 and the original Xilinx BSDL hashes.
CPLDs are listed by Vivado in TDI-to-TDO order, followed by the FPGA. Serial scans
start with the FPGA at TDO, followed by CPLD12 down to CPLD1. The script validates
all thirteen IDCODEs before loading or forcing output states.

## Validation

The published runner completed a physical load/test/restore sequence on
2026-10-13 using a Vivado-built diagnostic: both discoveries PASS 168/168,
three monitor-control cycles PASS and TAP restoration PASS. The board remains
configured with that Vivado diagnostic. Summary and bitstream hash are in
`validation-2026-10-13.json`.

Run parser regression checks with:

```sh
python3 -m unittest discover -s diagnostics/pm12/tests -v
```

Fixtures are reduced actual JTAG measurements from PM12, not simulated data.
They retain the received FPGA bits and cleanup marker. The failure fixture is
an earlier openXC7 image whose 26 input configuration faults were correctly
identified as a failing connection test; it is retained to guard against false
PASS verdicts.

## Ethernet extension

The [Ethernet / PRBS diagnostic](ethernet/README.md) adds a Kintex GTX,
1000BASE-X PCS and MAC internal-loopback test, including negative controls
and restoration of this link diagnostic. Physical PM12 validation PASS;
external SFP / switch packet validation subsequently PASS in the
[external diagnostic](ethernet/external/README.md). ARP/ping and production
IP networking remain unimplemented.
