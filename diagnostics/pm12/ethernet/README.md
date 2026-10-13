# PM12 Ethernet / PRBS diagnostic

SRAM-only GTX + 1000BASE-X PCS + Ethernet MAC test on XC7K160T FFG676-3.
Uses the PM12 SFP lane, a 200 MHz MGT reference and approximately 120 MHz
MCLK1 measured on the current board. It holds the shared PM12 board lock
through programming, tests and restoration of the link-discovery image.
CPLDs, ATxmega, flash and clock EEPROM are not programmed.

This is a raw Ethernet frame diagnostic: it does not provide IP, ARP or ping.
Internal PMA loopback tests FPGA circuitry. External SFP, cable and switch
are **NOT_RUN** unless a separate physical test is explicitly recorded.

## Build

Generated RTL and its memory initialization file are committed, so Vivado
can build without installing Python HDL dependencies:

```sh
vivado -mode batch -source diagnostics/pm12/ethernet/gateware/build.tcl
```

System timing is constrained at 120 MHz, MAC/PCS at 125 MHz and gearbox at
62.5 MHz. GTX output clocks and both JTAG clock outputs are constrained;
clock domains communicate through the LiteEth CDCs / synchronizers.

To regenerate RTL, use Migen and these upstream source revisions on PYTHONPATH:

| Project | Revision |
| --- | --- |
| [LiteEth](https://github.com/enjoy-digital/liteeth) | cb101652f69fab0979cfa1f9afbcfdf185fe662e |
| [LiteICLink](https://github.com/enjoy-digital/liteiclink) | 6e69216944e94c69f5a7d58d5c6d75dc3d754242 |
| [LiteX](https://github.com/enjoy-digital/litex) | 1c019732b7eb959a6fc741e46af46d4eeb706dbd |
| [Migen](https://github.com/m-labs/migen) | beffe831bf1a691eaebf9ddbb4660f8b3e7fd964 |

The K7 PHY comes from `liteeth.phy.serial.basex.wrappers.k7_gtx`.
Run `python generate.py` in the gateware directory. The dependencies use BSD
licenses; generated RTL contains their MAC/PCS/PMA logic.

## Hardware test

Build the link diagnostic from `../gateware` as the restoration image, then:

```sh
python3 diagnostics/pm12/ethernet/test_ethernet.py \
  --serial 210249A73E43 \
  --bitstream diagnostics/pm12/ethernet/gateware/build/pm12_eth_diag.bit \
  --restore-bitstream diagnostics/pm12/gateware/build/pm12_link_diag.bit \
  --output /tmp/pm12-ethernet
```

`--vivado-command` supports an executable plus arguments without a shell.
For Docker, execute Vivado in the existing hardware-server container; localhost
in a new container is a different server. Include a container-side bounded
`timeout 240` before the Vivado executable, with host `--step-timeout 280`.
The host board lease remains held through restoration. Both bitstreams are
validated for the correct FPGA part before any hardware action.

The test generates 60-byte frames (excluding FCS), local MAC addresses,
private EtherType 0x88b5 and a known payload. MAC adds preamble/FCS/IFG and
checks received FCS; the checker compares every received byte and length.
Settled windows check advancing TX/RX counts, byte counts and no new errors.
Negative controls change one payload byte and mismatch PRBS7/PRBS15;
subsequent windows must recover without new errors.

JTAG USER1: 512-bit report plus 12 CPLD bypass bits. 32-bit words are magic
`504de701`, system ticks, flags, command, reference ticks, TX frames, RX frames,
bad frames, PRBS error samples, RX bytes. Reference ticks use IBUFDS_GTE2 ODIV2.
Live reports and host timestamps give approximate rates, not a clock/jitter
measurement. PRBS counts are sampled error cycles, not exact bit-error totals.
Flags: CPLL lock, TX init done, RX init done, TX MMCM lock, RX MMCM lock,
PCS link, reference lost, PRBS error, TX reset done, RX reset done.

USER2 command: 16 bits plus 12 bypass bits. Bits 2:0 select GTX loopback,
bit4 enables PRBS7, bit5 selects mismatched RX PRBS15, bit6 changes the final
payload byte, bit8 resets the PHY. Modes: 2 normal internal MAC, 18 PRBS7,
50 PRBS mismatch, 66 wrong payload. Mode 0 selects the external MAC path.

Physical test on 2026-10-13: **PASS**. Three settled MAC windows received
265705 byte-exact frames, with zero new errors; PRBS7, both negative controls
and recovery passed. MCLK1 measured approximately 120 MHz and MGT reference
approximately 200 MHz. Full implementation: setup WNS 3.754 ns, hold 0.063 ns,
DRC zero checks and zero unconstrained internal endpoints. The link diagnostic
was restored successfully. Counters retain mode-transition and deliberate
errors; PASS uses settled deltas, not zero lifetime counts.

The current-board validation is stored in `validation-2026-10-13.json`.
Regression checks: `python3 -m unittest discover -s diagnostics/pm12/ethernet
-p test_analyzer.py -v` (join the command onto one line).
