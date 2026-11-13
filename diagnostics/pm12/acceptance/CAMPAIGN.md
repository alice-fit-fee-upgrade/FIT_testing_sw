# Twelve-channel PM12 campaign: three fittings of four CFD simulators

The measurement unit is the **physical PM channel (1-based)**, never the order
in a file or the CFD's RJ45 number. Fit channels **1–4**, then **5–8**, then
**9–12**. Groups may be measured in another order; they remain disjoint in the
report. This replaces the former three-channel batch convention for this bench.

The operator only needs to announce the fitted group and any cable changes.
The controller/agent prepares its mapping, confirms the board, performs the
qualified procedures and archives results. No hardware is accessed by campaign
registration or report rendering. Existing acquisition scripts retain the
shared hardware/instrument leases and voltage/output restrictions.

## What identifies each measurement

- Campaign UUID, factory-DNA board UID and MCU serial.
- Fitting attempt, physical channel and CFD bench label CFD01–CFD04.
- Declared Kasli slot/RJ45, stimulus pair and A/B phase-return lanes.
- Confirmed external DAC pair, **which PM channel it actually stimulates**, and
  USB connector: J8 for ADC bypass; J6 for integrator stimulus.
- UTC time, instrument identities/settings, exact executed source snapshots,
  raw validator outcome, raw buffers/CSV and SHA-256 manifests.

CFD01–CFD04 are provisional bench labels, not invented factory serials. At the
first fitting, identify/mark the four physical modules and keep their mapping
stable. The default declaration is CFD01→slot7/RJ45port0 through
CFD04→slot7/RJ45port3. Increasing PM channels map to that order. Override the
mapping if the actual connection differs; confirm it by physical inspection and
the existing input/discovery tests before driving signals. Unknown module IDs
remain unknown in the report. Photos may accompany evidence and are deduplicated
by their content hash in the generated PDF.

**One external DAC pair does not imply four analog stimulus connections.**
Generated station profiles leave `analog_connected=false`. Confirm each USB
move, or an eventual USB mux selection, before that channel's analog test.
The shared voltage-monitor bus must inhibit all four fitted CFD muxes before
selecting one output; pass the complete inventory to the SMU runner.

## Frozen protocol and data layout

`profiles/campaign-four-cfd.json` declares required board and channel tests.
Board-wide JTAG, MCU, I2C, HDMI and Ethernet results can be collected once for
the board; each fitting still requires a fresh board identity. Per-channel
coverage includes CFD monitor, DAC B/C/D, gate phase, TDC, ADC response and
adjacent-bit checks, and integrator balance. A/B observables are required for
the ADC/integrator cases; internal B/C/D DAC curves remain separate observables.

```
CAMPAIGN/
  campaign.json              # board, selected results, comparison contracts
  protocol.json              # immutable scope; hash checked on every operation
  batches/
    ch01-04-attempt001/
      batch.json             # immutable mapping and preparation time
      identity.json          # fresh observed hardware identity
      fitting.json           # operator declaration / wiring confirmation
      station.json           # optional station snapshot
      results/result-UUID/
        record.json          # channel, fixture, method, units, status, context
        raw/                 # independent copy of all original evidence
        files.sha256.json
    ch05-08-attempt001/...
    ch09-12-attempt001/...
```

Imports freeze **per-test protocol and executed source hashes** at the first
successful result. Failed/partial attempts stay archived outside comparison overlays. Later channels must use the same method/settings/source version and
observable units. Physical mapping and stimulus routing are per-measurement
conditions, not an excuse to change the comparison protocol. Intentional method
changes require another campaign revision; never silently combine them.

A repeat always creates another result/attempt. The first result for a case
remains selected until `select` explicitly chooses another. Failed and partial
attempts stay in the archive and report history. Reimporting the exact same acquisition is rejected rather than counted as another independent measurement. No output is overwritten, no
"latest file wins" rule is used, and clipped constant ADC data are not balance.
Old channel12 or 12/10/8/6 characterization is reference evidence, **not** live
coverage of this new campaign.

## Controller workflow

Create a new campaign only once for this board/protocol:

```sh
python3 diagnostics/pm12/acceptance/campaign.py init \
  --root /absolute/CAMPAIGN --board-uid PM12-K7-FACTORY_DNA_16HEX --serial MCU_SERIAL
```

After the operator announces a fitting, prepare it. Start is 1, 5 or 9. The
station input must have the expected enrolled UID; its channel mapping is
replaced with the fitting-specific one, while its acquisition configuration is
retained. Do not reuse an old profile's Kasli image hash without checking the
expected current image and actual hardware.

```sh
python3 diagnostics/pm12/acceptance/campaign.py prepare \
  --root /absolute/CAMPAIGN --start 1 --station /path/station-base.json
```

The returned ID is, for example, `ch01-04-attempt001`. Run the existing leased
`station.py identity` using that fitting's station profile, then bind its
`result.json`. Identity must be observed **after** fitting preparation and match
both the factory UID and MCU serial. Binding also records the actual fitting
and cable declaration. It is not an electrical proof of cable routing.

```sh
python3 diagnostics/pm12/acceptance/campaign.py bind \
  --root /absolute/CAMPAIGN --batch ch01-04-attempt001 \
  --identity /path/identity/result.json \
  --fitting-note 'Owner fitted channels1-4; CFD01..04 and cable mapping checked'
```

Collect using the appropriate qualified scripts. `suite.py collect` now accepts
up to four channels. TDC and gate-phase four-port procedures already accept
explicit channel order. Integrator acquisition now accepts `--afe 1..12`; SMU
acquisition requires `--connected` for the complete four-module monitor bus.
Do not infer hardware qualification for unmeasured channels from software tests.

```sh
# Example commands only, after wiring and the relevant instrument route are confirmed:
.../run-python diagnostics/pm12/tdc_live120/scan_four_cfd.py \
  --channels 1 2 3 4 --out /absolute/NEW-TDC-RUN
.../run-python diagnostics/pm12/cfd_simulator/smu_dac_sweep.py \
  --connected 1 2 3 4 --channels 1 2 3 4 --confirm-force-voltmeter \
  --out /absolute/NEW-DAC-RUN
.../run-python diagnostics/pm12/cfd_simulator/integrator_scan.py \
  --afe 1 --board-serial MCU_SERIAL --base 2.048 1.024 \
  --out /absolute/NEW-INTEGRATOR-RUN
```

The numerical integrator settings are a starting coordinate from the channel12
experiment, not preassigned balance voltages for other channels. Adapt the
coarse/fine search within a frozen search protocol. The standalone
`report_integrator_scan.py` / `validate_integrator_scan.py` retain the original
channel12 reference experiment; they now refuse other channels rather than
mislabeling them. Use channel-aware validation/receipts and the campaign report
for the new cohort. `plot_integrator_scan.py` checks that all its inputs belong
to one physical channel and labels that channel correctly.

## Normalized evidence contract

A measurement adapter/controller creates `campaign-result.json` **from actual
raw validation and analysis**, inside the complete measurement evidence folder.
This keeps instrument-specific legacy formats intact and gives the campaign
one explicit interface. No new hardware command is issued by the importer.
The existing resident plan is not automatically extended with every legacy
script; qualify the relevant adapter before declaring its case PASS.

Example shape (placeholders must be filled from real evidence; not a result):

```json
{
  "mode": "LIVE",
  "board_uid": "FROM_FRESH_FITTING_IDENTITY",
  "test": "integrator",
  "channel": 1,
  "fixture_id": "CFD01",
  "measured_utc": "FROM_ACTUAL_CAPTURE_UTC",
  "status": "PASS",
  "protocol": {"method": "signed-adjacent-pair-v1", "reference_hz": 40078700, "hardware_configuration": {"pm_build": "FROM_HARDWARE", "kasli_build": "FROM_QUALIFIED_IMAGE", "clock_profile": "FROM_ACTUAL_SETUP", "cpld_gate_mode": "FROM_VERIFIED_CONFIGURATION"}},
  "source_files": ["sources/__main__.py", "sources/integrator_analysis.py"],
  "channel_checks": [{"file": "status.json", "key": "physical_channel"}],
  "validation": [{"file": "validation.json", "key": "pass_", "equals": true}],
  "connections": {"usb_input": "J6", "stimulus_channel": 1, "dac_channels": [0, 1]},
  "metrics": [
    {"name": "balance_delta", "bank": "A", "value": 0.0, "unit": "V"},
    {"name": "balance_delta", "bank": "B", "value": 0.0, "unit": "V"}
  ],
  "curves": [
    {"name": "ramp_response", "bank": "A", "x_unit": "V", "y_unit": "code", "x": [-0.01, 0.01], "y": [-1, 1]},
    {"name": "ramp_response", "bank": "B", "x_unit": "V", "y_unit": "code", "x": [-0.01, 0.01], "y": [-1, 1]}
  ],
  "photos": []
}
```

List **all relevant executed source dependencies**, not merely the launcher.
New integrator/SMU acquisitions snapshot their imported sources for this use.
Curves require increasing stimulus values and explicit units; reduce repeated
points explicitly. PASS requires successful raw validator checks and source
channel evidence matching the fitted physical channel. ERROR/FAIL/INCOMPLETE
can retain failed acquisition evidence without pretending to have valid curves.
Hardware factory identity comes from the fitting, not EEPROM/IP inference.

```sh
python3 diagnostics/pm12/acceptance/campaign.py record \
  --root /absolute/CAMPAIGN --batch ch01-04-attempt001 --source /path/COMPLETE-RUN
python3 diagnostics/pm12/acceptance/campaign.py select \
  --root /absolute/CAMPAIGN --result result-UUID
python3 diagnostics/pm12/acceptance/campaign.py status --root /absolute/CAMPAIGN
```

## One editable report after any fitting

```sh
/srv/codex-hil-nvme/tool-venvs/fit-measurements/bin/python \
  diagnostics/pm12/acceptance/campaign_report.py \
  --root /absolute/CAMPAIGN --out /absolute/NEW-REPORT \
  --latex /path/to/tectonic
```

Each report snapshots the campaign and all raw attempts. It produces editable
`report.tex` / `content.tex`, coverage JSON and common plots: up to12 channel
series on each curve plot, with fixed channel colors, and channel comparison
plots for scalar metrics. Missing results stay NM, failures stay FAIL, and the
attempt history shows which repeat was selected. Photos are included once.
The template is `templates/campaign.tex`. Report generation can be repeated
without physical hardware, including after only the first fitting.

Only when **every required case** is PASS is coverage
`COMPLETE_SELECTED_PROTOCOL`. Numerical acceptance limits and board release
remain a separate engineering disposition. The default campaign has not measured
anything merely because its folders/template exist.
