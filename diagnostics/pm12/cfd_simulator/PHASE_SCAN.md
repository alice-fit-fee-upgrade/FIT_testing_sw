# Repeated ADC-clock phase scans through CFD_SIM

`phase_scan.py` sweeps raw **DAC A** on any selected PM12 channel1..12.
It uses the existing MCU `@DAC <channel> W A <hhhh>` command (already supports
all12 channels and outputsA..D), and the resident RPH1 Kasli buffer through
UART. It does not program/reset devices or change B/C/D. Ethernet/IPbus transport
is deferred by the owner; the separate estimator and injected acquisition callback
allow it to be reused later without changing the phase calculation.

Default scan: **101 points**, `round(i*65535/100)` for i=0..100; integer increments
655/656 and both endpoints included. Each point writes DAC A, waits100ms, triggers
one simultaneous4095-word capture on the requested Kasli lanes, downloads the
frozen buffers and checks every hardware phase record against raw samples.
4095x8 samples span34.125us at nominal960MS/s, about2730 rising edges per lane.
UART downloading takes longer than the actual acquisition. `--repeats` adds
independent captures at each DAC code; all their edge observations are pooled.

PM12 and Kasli must retain the shared generator reference. The current diagnostic
CPLD image drives both gate outputs directly from the local80MHz ADC clock.
A25ns/24-bin reference frame has TWO rising edges. The estimator therefore folds
all raw rising-edge positions modulo12 bins/12.5ns, while retaining the complete
24-bin histogram as well. It includes an edge at the first sample using the
captured preceding sample, and uses absolute sample-counter timestamps so that
captures with different first-sample positions can be combined.

For neighboring bins n/n+1, the weighted centroid is
`n + count(n+1)/(count(n)+count(n+1))`, including the circular11/0 boundary.
For the full histogram it unwraps around the most populated bin before averaging.
CSV contains modulo phase, unwrapped phase, phase relative to DAC code0, observed
spread, edge count and occupied span. Continuation between adjacent codes assumes
that the physical delay step is less than half an80MHz period (6.25ns). Integer
period ambiguities and absolute LHC phase zero cannot be resolved from this clock.

The centroid can vary by less than one sample bin. This is a statistical estimate
of sampled edge position; it is not automatically an unbiased physical phase
measurement. A jitter/noise distribution and sampling-bin calibration are needed
to claim finer accuracy. No independent-sample `sigma/sqrt(N)` error bar is reported.
Irregular or missing clocks, excessive phase spread, a changed clock profile or a
restarted/reused sample-counter epoch abort the scan instead of producing a curve.

## Invocation

Use the pinned Kasli Python environment (contains pyserial/pyftdi):

```sh
/home/codex-hil/kasli-diot-bringup/.venv/bin/python \
  /home/codex-hil/fit-testing-publish/diagnostics/pm12/cfd_simulator/phase_scan.py \
  --afe 12 --lanes 8,9 --restore-code "$KNOWN_ACTIVE_DAC_A_HEX" \
  --out /srv/codex-hil-nvme/measurements/afe12-phase-UNIQUE
```

Set `KNOWN_ACTIVE_DAC_A_HEX` to the known active hexadecimal DAC-A code before
running. The script requires it; it does NOT derive hardware state from `@DAC S`.
Those values are computed stored parameters, not DAC readback. The previous DC
sweep established B/C/D=0000 but deliberately did not establish/write DAC A.
No DAC-A baseline code is currently verified by this script's development.

For the existing connection, logical8/9 correspond to slot7 physical channels1/3.
Mapping for subsequent modules:

* logical0..7: slot6 physical1,3,5,7,9,11,13,15;
* logical8..15: slot7 physical1,3,5,7,9,11,13,15.

`--afe` chooses the PM12 DAC chip; `--lanes` chooses the measured returns.
These mappings are supplied explicitly, not inferred by software. The recorder
supports only the two return pairs per socket, not all four RJ45 pairs.

Before the first write, the runner takes a baseline phase capture and verifies
MCU S/N1803, physical PGOOD and the Kasli RPH1 profile. It holds PM12, Atmel-ICE
and Kasli leases throughout. Both DIO cards are configured as inputs and left
that way. PGOOD is rechecked at every point. On success, error or Ctrl+C it
attempts the explicit restore code and verifies the phase returns within one bin
of baseline. A restore/verification failure remains an error in `report.json`.
A successful SPI reply and matching phase are corroboration, not code readback.

Outputs are flushed after each point:

* `phase.csv`: one row per DAC code/lane plus baseline/restored rows;
* `events.jsonl`: estimates, histograms, console responses and restoration status;
* `sweep-CODE-REPEAT.json.gz`: complete raw and hardware phase buffers;
* `report.json`: parameters, codes, identities, mapping, final status and errors.

No DMM or monitor-mux selection is needed. The shared analog MCX bus is unchanged.
No physical DAC scan was executed during script development. Software checks cover
wraparound, two edges per frame, retained real captures, missing clocks, restoration
after serial/capture/file failures and Ctrl+C, and refusal to write without a valid
baseline. Run them with:

```sh
python3 -m unittest discover -s diagnostics/pm12/cfd_simulator -v
```

## Explicit zero baseline — owner-authorized2026-11-06

When the prior raw DAC-A code is unknown and retaining it is unnecessary, add
`--initialize-zero --restore-code 0000`. This records an as-found capture, writes
raw0, records the new baseline, performs the scan and finishes at0. This is NOT
restoration of an inferred original code. The owner explicitly selected this mode
for the first physical phase scan. The baseline phase guard compares the final0
to the explicitly established initial0. The first run uses full4095-word buffers,
about2730 rising edges per input/point, and101 points; UART download dominates.

Offline report/plots, using the existing plotting environment:

```sh
/srv/codex-hil-nvme/tool-venvs/fit-measurements/bin/python \
  diagnostics/pm12/cfd_simulator/plot_phase_scan.py MEASUREMENT_DIRECTORY --plot
```

For subsequent IPbus comparison, keep the DAC codes, settling, buffer length and
lane mapping identical. Compare phase relative to code0 and complete histograms;
reconfiguring FPGA clocks may change the absolute sample-epoch phase zero.


## First physical result

The2026-11-06 scan has all101 points and exact retained-data checks, with a FAILED
phase-return guard after an acknowledged final DAC-A=0000. See the top-level
README and `evidence-phase-20261106/validation.json`; do not relabel the process
as a complete PASS. Use `validate_phase_scan.py DIRECTORY --data-only` to verify
all retained buffers and CSV while preserving the restoration failure. Without
`--data-only`, that verifier rejects a failed phase-return receipt.

`compare_phase_scans.py FIRST SECOND --out comparison.json` requires two completed,
phase-restored scans with identical settings and complete code grids; this first
run is not silently accepted as a restored comparison reference.

Owner's next proposed precision method: independent FPGA state machine stepping
only the receiver MMCM, waiting for step completion, detecting a selected edge,
stopping at the first crossing and retaining its step count. This was not built
or loaded during the UART baseline run. Keep it separate from this recorded scan.

## Original gate divider restored —20-point run

The recovered original gate-clock fragment is restored in all12 CPLDs:
falling-edge ADC80 counter, CLK20_P=count(1), CLK20_N=registered complement.
The existing ADC diagnostic mux/EV logic is retained. Backup two-pass NV read,
verification against the previous exact JEDEC, new program/verify and passive
Kintex check are retained with the result. No Kasli or MCU programming in this run.

Repeat with `--clock-mhz 20 --intervals 19` for exactly20 codes including endpoints.
The raw phase estimator uses48sample bins/50ns; the hardware24-bin record format
is unchanged and continues to be checked against raw data. The full20-point run
covers about25ns on RX8 and24.35ns on RX9. It retains a failed final phase-return
guard (-5bins on both lanes versus baseline) despite an acknowledged final DAC0.
Evidence: `evidence-original20-phase-20261106/`.


## IPbus available

Add `--transport ipbus --ipbus-host 192.168.2.241`. UART remains selectable.
The same estimator, code grid and raw/hardware consistency checks are used.
Network block prefetch replaces per-word round trips; measured20-point repeat
is12s against449s by UART. The sampler/gate configuration is unchanged.
See `evidence-ipbus-phase-20261106/` and Kasli `docs/GATE_PHASE_IPBUS.md`.

The old UART run failed its phase-return guard. Comparing its complete verified
raw data requires explicit `compare_phase_scans.py FIRST SECOND --out RESULT.json
--allow-phase-return-failure`; append `--plot` in the plotting environment.
Both state receipts are retained, and the comparator reports raw zero-origin
differences plus centered residuals excluding code0, rather than declaring the
failed restoration a PASS.
