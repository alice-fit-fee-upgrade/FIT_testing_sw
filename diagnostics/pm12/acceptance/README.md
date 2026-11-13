[Latest: internal DAC B/C/D scans on channels9–12](evidence-campaign-smu-20261113/README.md).

[First measured campaign channel12: ADC A/B and integrators](evidence-campaign-ch12-20261113/README.md).

[Active Optiplex campaign and next-fitting handoff](ACTIVE_CAMPAIGN.md).

Current four-CFD workflow: [three fittings covering channels1–4,5–8,9–12](CAMPAIGN.md).
Use the campaign registry for new twelve-channel measurements, fixture mapping,
immutable repeats and the combined LaTeX report. The older examples below retain
their historical three-channel convention; the generic collector now permits four.

Parameterized diagrams: see [BENCH_CONFIGURATION.md](BENCH_CONFIGURATION.md). A small JSON override changes labels, slots and clocks; `--bench-config` applies it to a report and archives the effective configuration.

Setup2026-11-08: [English wiring diagram](evidence-english-setup-20261108/bench.pdf)
is included in the [current report](evidence-english-setup-20261108/report.pdf),
page4. Source: `bench_setup.py`; standalone PNG/PDF/SVG generation:

```sh
/srv/codex-hil-nvme/tool-venvs/fit-measurements/bin/python \
 diagnostics/pm12/acceptance/bench_setup.py --out NEW-DIRECTORY
```

The corrected physical routes are MOD-DAC-28→CFD_SIM, CFD_SIM→DIO-LVDS slot7,
and PM HDMI→LVDS-HDMI adapter→2RJ45→DIO-LVDS slot6. LHC enters the HDMI adapter;
the generator internal x3 output supplies Kasli. The generator uses this diagram for future reports.

Report layout2026-11-08: all168 static connections are now one multipage table,
with one common procedure and repeated column headings. This applies to both
historical and live boundary-scan runs. The [compact specimen](evidence-connection-table-20261108/historical-connections.pdf)
has22 pages; [editable LaTeX and complete inputs](evidence-connection-table-20261108/editable-report-source.tar.gz)
are retained. The earlier212-page specimen remains archived.

Latest2026-11-07: the post-reconfiguration STR case is [diagnosed and corrected](ADC_STROBE_DEBUG.md).
ADC validity now uses bounded4× edge phase and complete-word stability; strict
all4 spacing remains an explicit alignment diagnostic. Full A/B scan and two
FPGA-only reload controls PASS; original strict FAIL evidence is retained.

# PM12 evidence collection and editable LaTeX dossiers

Three separate operations: **collect batches → generate a chapter → assemble the report**.
Collection does not invoke LaTeX. Rendering never opens an instrument connection.
Existing batches are not overwritten. This is the initial acceptance framework,
not a claim that every historic diagnostic is already safe to execute on the
present integrated images. See the explicit migration/qualification matrix below.

## Board identity, photos and assets

Canonical printed label: `PM12-K7-<16 hexadecimal digits read from FUSE_DNA>`.
The current physical board was read as **PM12-K7-3A17A1B402212223** on2026-11-07;
its mutable MCU EEPROM serial is1803. The raw Vivado reply is retained. IDCODE
is a chip-type identifier and a JTAG cable serial identifies a tool, not the DUT.
No fuse, EEPROM or FPGA configuration memory is written to assign this label.

Read-only DNA enrollment:

```sh
python3 diagnostics/pm12/acceptance/suite.py enroll \
  --station diagnostics/pm12/acceptance/profiles/optiplex.example.json \
  --registry /srv/codex-hil-nvme/measurements/pm12-boards.json \
  --out /srv/codex-hil-nvme/measurements/NEW-ENROLLMENT
```

Use the resulting `station-enrolled.json` for acquisition. For a new board with an unknown EEPROM label, set `board_serial` to JSON `null` during enrollment; the observed value is filled into the enrolled profile, and later acquisitions require it to match. The prerequisites are the diagnostic MCU console and qualified integrated FPGA image already loaded; enrollment does not prepare or program a fresh board. Review station paths,
UART, exact cable identity and connected-channel mapping for each physical setup.
A dedicated temporary `hw_server` is filtered to this cable. The Genesys server
is not reused, stopped or reconfigured. DNA is read with Hardware Manager;
programming/EXTEST and MCU PDI reads are excluded from enrollment. PDI CPU
signature collection would reset the MCU managing power, so it is not done here.
Reference: [AMD UG908 FUSE_DNA](https://docs.amd.com/r/2020.2-English/ug908-vivado-programming-debugging/FUSE_DNA-Unique-Device-DNA).

The registry rejects assigning one human asset label to different DNA values.
Replacing an FPGA requires an explicit genealogy record, not silently merging
identities. Today IPbus does not expose DNA: its association with this DUT relies
on the physical single-PM bench cabling. Never connect several PMs using the same
fixed diagnostic IP/MAC simultaneously. Configuration image hashes in the station
file identify declared qualified artifacts; runtime build/signature reads are
not a cryptographic bitstream readback.

`modules` in the station/inventory JSON describes the DUT, Kasli, DIO cards,
CFD simulators, clock, DAC and DMM. Each accepts `hardware_uid`, `identity_source`,
`photo` (PNG/JPEG/PDF), `role`, `type` and secondary `label`/serial. Photo paths
are relative to the inventory JSON. Pass `--inventory inventory.json` at rendering;
images are copied into the report and hashed. Unknown IDs and absent pictures
remain explicit. Do not invent serials for passive modules; attach a physical
asset tag and mark its source as a human label. Hardware enrollment currently
reads the PM FPGA; additional tester module factory IDs are not yet polled.

## Batches of up to three CFD channels

```sh
python3 diagnostics/pm12/acceptance/suite.py collect \
  --station /path/to/station-enrolled.json \
  --channels 10 11 12 \
  --out /srv/codex-hil-nvme/measurements/PM12-UID/batch-01
```

Configure `channels` in the station JSON for the actual fitted simulators and
confirmed RX lane maps. An ADC scan additionally requires its external DAC pair
to be declared connected. **The current wiring qualifies only channel12.** One
shared DAC pair does not automatically stimulate three different modules: confirm
and document its routing before setting `analog_connected` on each channel.
Each channel also declares `dac_channels: [positive, negative]`, e.g. `[0,1]`, `[2,3]`, `[4,5]`. Only that selected pair is changed/restored; all other DAC outputs remain untouched. Pair routing is software-tested; physical qualification currently covers `[0,1]` only. The current DIO wiring also has one stimulated TDC channel, selected separately.

Use `--plan diagnostics/pm12/acceptance/profiles/acceptance.json` to start with the qualified JTAG/static test and automatic SRAM restoration, then run the resident stages below. The default `resident.json` avoids reprogramming between CFD batches.

The resident plan runs sequentially:

1. Factory DNA, EEPROM serial, known integrated FPGA build and stable PGOOD.
2. MCU UART, temperature/TDC IDs, PLL readback, CPU–FPGA SPI walking patterns
   with scratch restoration, INA/POWER observations.
3. Integrated HDMI/PRBS/allowlisted SPI, all12 digital ADC banks/strobes,
   quiet/64-pulse/quiet TDC on the configured connected channel.
4. Per-channel internal DAC-A phase scan,20 points, original20MHz gate divider,
   explicit zero initialization/restoration and phase-return check.
5. Per-channel external DAC257-point ADC A/B scan, raw validation and all
   adjacent bit-pair states. Success baseline remains DAC1V/1V, integratorOFF,
   external ADC A selected, monitor inhibited.

No FPGA build or programming is needed for this resident sequence. Shared PM,
MCU, Kasli and DAC locks remain held throughout the run. Children inherit the
actual lock open-file descriptions, not a bypass flag. The DAC still takes its
existing second-station leases. Other tests fail immediately if the board is busy.
Failures stop later hardware stages. Bounded termination sends SIGINT to allow
cleanup; an unresponsive child is not forcibly killed and retains its locks.
No automatic power-cycle or MCU protection override is used.

Every stage records argv, timestamps, status, conditions and limits. A zero
process exit alone is insufficient: explicit JSON result checks must pass.
`PASS` means the **selected plan and fitted channels**, not entire board release.
Static PGOOD does not prove startup timing or shutdown protection. Sensor reads
without approved rail limits are observations, not numerical rail acceptance.
P3V8 current readout is available according to the owner update2026-11-08. New MCU captures record numeric INA5/channel1 current; an unavailable/clipped reply is kept explicit. Historical measurements made without the shunt remain excluded. Numerical current acceptance still requires configured limits.

## Generate the CFD chapter after all batches

Use the offline plotting environment already installed on Optiplex:
`/srv/codex-hil-nvme/tool-venvs/fit-measurements/bin/python`.
The station environment remains the existing pinned `kasli-phase-tester/run-python`.

```sh
/srv/codex-hil-nvme/tool-venvs/fit-measurements/bin/python \
  diagnostics/pm12/acceptance/report.py chapter --name cfd \
  --runs /path/batch-01 /path/batch-02 /path/batch-03 /path/batch-04 \
  --inventory /path/inventory.json --out /path/cfd-chapter \
  --latex /path/to/tectonic
```

Omit `--latex` to generate sources only; `pdflatex` is also supported. LaTeX
produces the actual PDF, not an image-only PDF export. The master template is
[templates/report.tex](templates/report.tex). Each output includes editable
`report.tex`, `metadata.tex`, `content.tex`, figures, analysis JSON and complete
input evidence. Tectonic0.15.0 was used for the checked specimen. `pdflatex`
commands are supported but were not the engine physically exercised here.
Do not install report tooling onto the crowded system volume; local specimens
and the13.5MB Tectonic archive are on NVMe. No heavy FPGA build runs locally.

The merger rejects different board UIDs, historical/live mixing, different
configuration/source fingerprints and duplicate measurements of the same test
and channel. To select a repeat, explicitly choose its input batch; no silent
"latest wins". Generation verifies all raw-file hashes. ADC histograms and bit
verdicts are independently rebuilt from every retained raw buffer. Time traces
and FFT use strobe-decimated zero-input buffers. Phase overlays use retained CSV.

One common plot per observable shows all available channels with fixed colors
and common axes; ADC A/B use separate panels. Deviation tables compare each
channel with the channel median at **common** stimulus points, without hidden
interpolation. With one channel the deviation is NOT COMPARABLE, not zero.
Unmeasured channels remain NOT MEASURED. Channels1–11 are currently unqualified
for analog tests. Full4096-code density/DNL and calibrated jitter are not implied.

## Assemble edited chapters into the final report

```sh
/srv/codex-hil-nvme/tool-venvs/fit-measurements/bin/python \
  diagnostics/pm12/acceptance/report.py report \
  --chapters /path/digital-chapter /path/cfd-chapter \
  --out /path/final-report --latex /path/to/tectonic
```

This includes chapter sources with LaTeX `subimport`; it does not discard edits
and regenerate a substitute. After editorial `.tex` changes use
`--allow-edited-tex`: old/new hashes are recorded in `editorial-changes.json`.
This flag does **not** permit modified raw inputs, images or result JSON.
To regenerate a complete dossier directly from data instead, use
`report --runs ... --extended`; connections are always consolidated into one multipage table with repeated
column headers and one common procedure. `--extended` adds individual ADC-channel
cards only. Raw per-vector results remain in the evidence archive. Page count is
not an acceptance criterion.

Signing/release remains a human disposition. The template defaults to
INCOMPLETE / NOT RELEASED until the required coverage, tolerances, calibration
status and deviations have been reviewed. No unknown channel gets PASS from
the number of pages or from a successful digital transport test.

## Historical evidence and staged migration

```sh
PYTHON diagnostics/pm12/acceptance/report.py historical --out /path/history
PYTHON diagnostics/pm12/acceptance/report.py report --runs /path/history \
  --extended --out /path/history-dossier --latex /path/to/tectonic
```

The measured October/November evidence is intentionally labeled
`LEGACY-SN1803-UNBOUND`: factory DNA was not recorded at its acquisition dates.
It is not presented as a new run or silently rebound to today's enrolled DNA.
The package retains the failed initial CFD restoration attempt and boot-not-
confirmed result, not just successful summaries.

| Category | Automation status in this version |
|---|---|
| Resident MCU/SPI, HDMI, ADC, TDC, gate phase, ADC data lines | Sequential live runner implemented; measured qualification in validation record |
| JTAG/static boundary scan | Existing runner plus checksum-guarded integrated-image restoration adapter `boundary.py`, physically PASS168/168 in both paths with post-restore HDMI/ADC/TDC PASS |
| Old GTX internal PRBS / exact1G external Ethernet | Historical evidence retained; present40.0787MHz clock setup needs a qualified adapter |
| Full I2C topology | Historical address/ID data retained; live MCU telemetry integrated, exhaustive old FPGA-programming runner not invoked |
| Config flash ownership/read/boot | Historical read-only sequence retained; boot remains NOT CONFIRMED; not run in resident plan |
| MCU power startup / injected timeout faults | NOT RUN; requires separately defined fault procedure |
| DMM CFD monitor / DAC B/C/D | Existing channel12 scripts and raw results retained; generalized shared-mux/per-channel automation still pending |

`profiles/full-coverage.json` lists these cases explicitly as NOT_RUN rather than
silently omitting them. Do not launch old programming scripts directly: several
restore obsolete SRAM images or assume blank CPLDs. No MCU/CPLD/flash programming
is part of either qualified plan. `boundary.py` programs FPGA SRAM only and
restores the exact qualified integrated image under the same hardware lease.

## Software checks

```sh
/srv/codex-hil-nvme/tool-venvs/fit-measurements/bin/python -m unittest \
  discover -s diagnostics/pm12/acceptance/tests -v
/home/codex-hil/kasli-diot-bringup/.venv/bin/python -m unittest \
  discover -s diagnostics/pm12/cfd_simulator -p 'test_*.py' -v
python3 -m unittest discover -s diagnostics/pm12/tests -v
```

Tests check false-PASS prevention, evidence tampering, identity/source/config
collisions, duplicate batches, real inherited lease exclusion, archive containment
and LaTeX escaping. Physical tests are separate from software tests.

## Post-reconfiguration timing finding2026-11-07

JTAG/static connectivity and integrated-image restoration passed; the subsequent
broad HDMI/ADC/TDC functional check also passed. A stricter standalone ADC check
then rejected a raw buffer with1024 STR rising edges:1011 intervals of4 samples,
6 of3 and6 of5. At that checkpoint the cause was not established. The later diagnosis is linked above. This is not silently relabeled as
a PCB short or cleared by relaxing the test. The buffer and failure are retained.
A full acceptance run must pass the strict guard after reconfiguration; the
qualified restoration adapter alone is not proof of stable ADC sample phase.

On an ADC error, existing acquisition parks the selected DAC pair at0V and
attempts GPIO restoration. `recover_dac_baseline.py` is an explicit leased
control action to return a configured pair to1V/1V after checking physical board
identity and PGOOD; it does not turn a failed ADC result into PASS.
