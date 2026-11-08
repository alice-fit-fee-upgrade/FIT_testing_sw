# Parameterized bench drawing

`bench_setup.json` is the complete editable diagram: parameters, module labels,
positions/sizes, parent enclosures, connections, cable colors and annotations.
A small JSON file may override only selected parameters, keeping the reviewed layout:

```json
{
  "parameters": {
    "dut": "PM12",
    "dac": "MOD-DAC-28",
    "cfd_slot": 7,
    "hdmi_slot": 6,
    "lhc_mhz": "40.0787",
    "multiplier": 3,
    "pm_sfp": 1
  }
}
```

`kasli_mhz` is derived exactly with decimal arithmetic:40.0787×3=120.2361.
The multiplier block is a child of the generator enclosure and moves with it.
Node names use label placeholders, e.g. `slot {cfd_slot}`. Custom parameters can
be added and referenced in labels. Unknown placeholders, duplicate nodes,
missing cable endpoints, cyclic containment and invalid clocks are rejected.

```sh
PYTHON diagnostics/pm12/acceptance/bench_setup.py --config my-bench.json --out NEW-DRAWING
PYTHON diagnostics/pm12/acceptance/report.py report --runs BATCH \
  --bench-config my-bench.json --out NEW-REPORT --latex /path/to/tectonic
```

Use `/srv/codex-hil-nvme/tool-venvs/fit-measurements/bin/python` for `PYTHON`.
Reports archive `figures/bench-configuration.json` with the complete effective
configuration and `bench-parameters.json` with the calculated values. A complete
archived configuration can be rendered without the original default config.
Chapter assembly retains each chapter's existing diagram; customize it when
creating the chapter from measurements.

A partial override merges `parameters`, `canvas`, `colors` and `title` dictionaries.
If supplied, `nodes`, `links` and `annotations` replace their complete lists.
To edit layout, copy the full configuration and adjust:

- Nodes: `id`, `label`, `xy`, `size`, `color`, optional `parent`.
  Child coordinates are relative to the parent center; children must fit inside it.
- Links: `start`/`end` name a node and side (`left/right/top/bottom`), with optional
  offset along that side. `at: [dx,dy]` specifies an internal anchor.
  Endpoints track moving nodes. `via` bends and label positions remain explicit
  layout coordinates; routing is not an automatic graph-layout solver.
- `direction`: `forward`, `both` or `none`; cable `kind` selects its color.

These parameters describe documentation only. They do not configure PLLs,
change DIO directions, select ADC channels or change test limits. Recorded
acquisition mappings and the board UID remain independent of diagram edits.
