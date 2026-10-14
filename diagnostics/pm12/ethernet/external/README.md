# External PM12 SFP / switch diagnostic

Physical external Ethernet **PASS** on 2026-10-14. The current connection works
with normal TX/RX polarity and fixed-rate 1000BASE-X at 1 Gb/s (command 0x800),
with FPGA-side Clause 37 autonegotiation suppressed. The original autonegotiated
profile did not reach link-up. The exact module model is not recorded; this
result identifies a working configuration, not the cause of the negotiation failure.

The host received **21187 exact UDP payloads**, zero bad payloads. In the
qualified two-second window: 4007 FPGA TX frames, 27 received switch/host frames,
zero new invalid code groups or MAC errors, and 1997 exact host UDP deliveries
in its fully enclosed one-second bucket. Host broadcast probes exercise the
physical RX path; unrelated LAN traffic may contribute to the RX total.

A good RX symbol stream alone cannot prove TX. An earlier RX-only experiment
suggested TX inversion; real host UDP delivery rejected that interpretation.
With inverted TX, valid RX symbols/frames remained but host UDP delivery stopped.
With inverted RX, host UDP continued but FPGA reception failed. Only the
standard-polarity fixed-rate profile passed both directions in this test.

## Contents and scope

The gateware contains the tested LiteEth MAC/PCS/PMA plus selectable polarity,
fixed-rate diagnostics, RX symbol/config/error counters and a valid fixed UDP
frame generator. This is not an IP service: **no ARP, ICMP/ping, DHCP or general
UDP receiver/echo**. Source 198.18.0.12 is a diagnostic packet source from the
benchmark address range, not a configured reachable board IP address.

Frames use source MAC 02:00:00:00:00:02, source UDP port 49154, destination port
49155 and payload `PM12-SFP-UDP-TEST!`. Rate is approximately 2000 frames/s.
The host listener checks every payload and sends about ten small diagnostic
UDP broadcasts/s to port 49154 on its laboratory /24 LAN. Host reception uses
a normal UDP socket; root/CAP_NET_RAW is unnecessary. The host must be on the
same Layer 2 network/VLAN as the PM12 switch port.

Default generated RTL targets the measured host 192.168.2.107 /
6c:2b:59:f4:76:e8. To target another host, regenerate with the pinned dependencies
listed in the parent README:

```sh
python diagnostics/pm12/ethernet/external/gateware/generate.py \
  --host-ip YOUR_HOST_IP --host-mac YOUR_HOST_MAC
vivado -mode batch -source diagnostics/pm12/ethernet/external/gateware/build.tcl
```

The default regeneration was compared byte-for-byte with the physically tested
RTL. Full implementation: setup WNS 3.994 ns, hold 0.078 ns, zero DRC checks and
zero unconstrained internal endpoints. MCLK1 is approximately 120 MHz; reference
GTX clock approximately 200 MHz.

## Reproduce

```sh
python3 diagnostics/pm12/ethernet/external/test_external.py \
  --serial 210249A73E43 \
  --bitstream diagnostics/pm12/ethernet/external/gateware/build/pm12_eth_diag.bit \
  --restore-bitstream diagnostics/pm12/gateware/build/pm12_link_diag.bit \
  --host-ip 192.168.2.107 --output /tmp/pm12-external
```

Use the existing hardware-server container via `--vivado-command` if needed,
including container-side `timeout 240`; the host step timeout defaults to 280 s.
The shared PM12 lock covers loading, all eight mode trials, host capture/probes
and restoration. All IDCODEs and both bitstream part headers are checked.
The gateware's default mode is internal PMA loopback; the runner selects external
modes, checks them, and restores the original link diagnostic. No persistent
writes or other-board actions. Near-end PMA loopback can still drive TX pins;
only samples with the external command value qualify as external test windows.

The portable CLI wraps the same load/scan/capture/restore sequence used for the
recorded physical run. Recorded data and bitstream hashes are in
`validation-2026-10-14.json`.

The original 512-bit USER1 report is extended in its previously unused words:
word10 raw RX code/decoded byte/status; word11 partner/last config registers;
word12 valid CI count; word13 config count; word14 invalid code count;
word15 RX MAC error frame count (includes PCS/FCS/padding errors).
USER2 adds bit9 RX polarity, bit10 TX polarity, bit11 fixed-rate mode.
In fixed mode, flag5 means recent valid idle/config code groups, not completed
Clause 37 negotiation. PASS also requires clean code groups, MAC reception
and byte-exact delivery to the real host. Mode changes can reset RX-domain
counters; their wrapped deltas are not meaningful during unstable profiles.

Schematics show SFP TX_DISABLE grounded, RS0/RS1 pulled high, and SDA/SCL,
LOS, TX_FAULT and MOD_ABS unconnected. Their states/EEPROM cannot be read
through the FPGA/ATxmega from those schematic connections.

Run verdict regressions with:

```sh
python3 -m unittest discover -s diagnostics/pm12/ethernet/external -p test_verdict.py -v
```
