Current2026-11-13: original A/B gates are restored, and CFD port assignments now cover12/11/10/9. See the[latest campaign procedure](../../acceptance/TIMING_CAMPAIGN.md).

# Four CFD simulators on the existing slot7 DIO card

## Physical assignment

Kasli is slot0. HDMI remains on slot6. The four CFD simulators use the four
RJ45 sockets of slot7, in the same order as the previous channel12 cable.
Only the first LVDS pair of a selected socket transmits. Both gate-return
pairs and the unused second pair remain inputs.

| PM physical channel | Slot7 RJ45 (zero based) | CFD output channel | Gate A logical RX | Gate B logical RX |
|---|---:|---:|---:|---:|
| 12 | 0 | 0 | 8 | 9 |
| 10 | 1 | 4 | 10 | 11 |
| 8 | 2 | 8 | 12 | 13 |
| 6 | 3 | 12 | 14 | 15 |

The DAC gate-phase scan and TDC input-phase scan are separate measurements.
CFD_SIM's LVDS timing input feeds its SN65LVDS101 and the PM TDC directly;
the PM DAC-A phase shifter affects the integrator gate path. A DAC sweep alone
does not supply a controlled input-phase sweep to the TDC.

No external MOD-DAC-28 or DMM is used or acquired by these procedures.

## Optional four-port gateware

Apply `git apply --unidiff-zero /path/to/gateware.patch` to a separate snapshot of the existing
`kasli-phase-tester`, preserving other threads' sources. Generate with
`--ipbus --cfd-tx --cfd-ports 4 --pm-link --pm-bridge --hdmi --hdmi-data-base 0`.
The default remains one CFD port. Run new heavy Vivado builds on Dell and
qualify timing, DRC, the18 ISERDES receivers,4 OSERDES transmitters,3 GTP channels,
and physical CFD output pins before SRAM programming.

Byte-addressed Kasli control registers (IPbus word address = byte address/4):

| Byte address | Meaning |
|---|---|
| 0xd8 | CFD port extension magic `0x43464434` |
| 0xdc | Selected RJ45 port0..3; writable only while disabled/stopped |
| 0xe0..0xfc | Existing finite CFD player ABI, unchanged |

There is a separate serializer per physical output IOB; only the selected
output can drive. STOP and reference loss release outputs. The repeater direction
mask must equal `1 << (4*port)`. Direction changes occur only after FPGA release.
Other slot7 pairs are kept as inputs. The legacy host driver releases outputs and
selects port0 during initialization; it also rejects a direction/route mismatch.
The four-port runner returns the selector to port0 during cleanup. All returned direction states are checked.

The qualified baseline image counted7 differential-output cells, including
nested bidirectional-pad buffers and the recovered-clock output. The four-port
image counts10, exactly three more. Check package pins as well as cell counts:
K7/K6, K11/J11, G5/G4, H4/H3.

`test_cfd_ports.py` tests selection, rejection while enabled and STOP/reference
loss. Run it in the patched source snapshot with the pinned Migen environment.
`test_pattern_banks.py` checks204 byte-exact host pattern commits through both
RAM banks. An update must compare against the *inactive bank's* contents,
not merely the last transmitted pattern, because every commit swaps banks.

## Repeat acquisitions

Hold the existing PM12/Atmel/Kasli leases. The station scripts obtain these
leases themselves and check physical PGOOD and expected board identities.
They never program FPGA/CPLD images or initialize PLLs implicitly.

```sh
/home/codex-hil/kasli-phase-tester/run-python \
 diagnostics/pm12/cfd_simulator/scan_four_phase.py \
 --channels 12 10 8 6 --intervals 100 --out NEW-GATE-DIRECTORY

/home/codex-hil/kasli-phase-tester/run-python \
 diagnostics/pm12/tdc_live120/scan_four_cfd.py \
 --channels 12 10 8 6 --out NEW-TDC-DIRECTORY
```

The gate scan explicitly initializes/restores DAC A=0 on each requested channel,
inhibits the shared analog monitor, records all eight slot7 gate-return lanes,
and validates hardware phase records against raw ISERDES samples. No actual
DAC readback is claimed. `pass_` in this acquisition receipt means completed
acquisition/cleanup; missing gate edges are retained as measurement results,
not converted into a hardware PASS.

**Historical state on2026-11-10: CPLD12 retained the INTB-off experimental image.** Both original
complementary gates were temporarily restored for its full phase-shifter scan,
then INTB-off was restored and vendor-verified. Establish the required gate mode
explicitly before repeating that measurement; the generic scan does not program
CPLDs. The TDC input-phase scan does not depend on this integrator-gate mode.

The TDC runner first discovers each port with16 pulses and requires exactly16
records on the expected channel and zero on all other channels. It then measures
25 phase positions,128 events each, one serializer bit per step; total span one
LHC period. Quiet captures and no cross-channel records are checked. All13 raw
bits are preserved. Fine-phase plots unwrap modulo128 by nearest continuation;
coarse fields are retained separately, not used to repair fine phase.

Timing axes assume the supplied40.0787MHz reference: one serializer bit is
1/(24*40.0787MHz), about1.0396ns. This is not frequency-counter verification or
complete calibrated TDC timestamp reconstruction.

For offline overlays, extract the archived run directory and use
`plot_four_cfd.py --run-root EXTRACTED-RUN --out NEW-PLOT-DIRECTORY` with the
existing `fit-measurements` Python environment. It writes editable SVG, PNG,
PDF, CSV and JSON. All four physical channels share the same plot axes.

## Historical return-path qualification

Slot7 physical DIO5 and9 (logical RX10/12, currently INTA from PM10/8)
already belonged to a failed5↔9 loopback on2026-10-16. The later2026-10-28
dynamic9↔13 loopback also failed. Check these fixture paths before attributing
constant-HIGH returns to PM or CFD hardware. The historical failures do not
physically isolate a specific endpoint. Exact receipts are archived with the
four-channel report as `historical-lvds-context.json`.
