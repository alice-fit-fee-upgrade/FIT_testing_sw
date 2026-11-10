# PM12 to Kasli link on LHC clocks

Owner cabling, 2026-11-06:
- Kasli SFP0: existing LAN/control IPbus192.168.2.241, fixed125MHz reference.
- Kasli SFP1: direct DAC cable to PM12, LHC120.2361MHz reference.
- Kasli SFP2: optical switch connection, reserved for the future data bridge.
- Kasli SFP3: wrongly connected; do not instantiate or test.

The first candidate is a PRBS diagnostic, NOT a packet bridge. PM12 CDCE
outputs0..4 and the MCU are untouched. PM12 GTX reference stays5*40.0787=
200.3935MHz. CPLL N1=4,N2=3,M=1 gives2404.722MHz VCO, output divide4
and DDR produce1202.361Mb/s. Kasli PLL1 uses120.2361MHz times4*5 and
the same output divide4, producing the identical serial rate. Its existing
PLL0 and SFP0 stay on the fixed125MHz reference.

Kasli source: kasli-phase-tester gateware/pm_link.py, enabled by
`build_gate_phase.py --ipbus --cfd-tx --pm-link`. The first image instantiates
only SFP0/SFP1. It retains16 phase receivers and the stopped CFD transmitter.
The current serializer parameter set is the established /4 1.25Gb/s CDR
profile; the actual rate is determined by PLL dividers and external clocks.
Physical qualification is required, including matched, mismatched and
recovery PRBS windows in both directions. Error counters count sampled
RXPRBSERR cycles, not error bits, so they do not directly measure BER.

First diagnostic PML1 registers are UART-only: the existing IPbus CSR aperture
is limited to bytes00..ff. SFP0 IPbus is independently checked before/after PRBS.
The packet-bridge integration must extend the aperture before exposing PML1 there.

Kasli byte CSR map:
100 control: bits2:0 loopback,4 PRBS7,5 RX PRBS15 mismatch,6 continuous
TX error injection,8 restart. Default16 emits PRBS7 on SFP1.
104 status: bits0 LAN PLL lock,1 PM PLL lock,2 TX init done,3 RX init done,
4 synchronized RX PRBS error.
108 error sample counter;10c SYS cycles;110 half-reference cycles (Gray CDC);
114 magic504d4c31;118 assumed reference120236100;11c assumed rate1202361000.
The last two are configuration metadata, NOT measured frequency counters.

Heavy implementation uses Dell. The hardware wrapper holds PM12/Atmel/Kasli
leases throughout programming and restoration, requires physical PGOOD and
identifies both boards. It changes only SRAM. Both rollback images are checked
by SHA256. Test artifacts: /srv/codex-hil-nvme/pm12-eth-lhc-20261106/ and
/srv/codex-hil-nvme/kasli-pm-link-20261106/.

Status update: normal packet bridge and channel12 CFD/TDC functional tests
PASS, see ../../tdc_live120/README.md and its evidence. This directory contains
the separate standalone PRBS diagnostic. Its latest restart-suppression change
compiled on Dell but has NOT been physically qualified. Earlier PRBS attempts
were invalidated by TAP mode changes and PCS automatic receiver restarts; do
not infer PRBS PASS from those receipts. The active image is the integrated
ADC/TDC image, not this standalone diagnostic.
