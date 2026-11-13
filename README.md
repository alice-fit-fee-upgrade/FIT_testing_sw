# FIT hardware testing and characterization

Software, diagnostic gateware, measurement procedures and reports for testing
FIT front-end electronics, currently focused on **PM12 boards and CFD simulator
modules**. The bench combines PM12, Kasli-DIOT with DIO-LVDS interfaces,
programmable stimuli and laboratory instruments.

The current workflow uses dedicated diagnostic gateware, Python control scripts,
IPbus/Ethernet and MCU UART access. **ARTIQ is not the entry point for the current
PM12 acceptance workflow.** The original ARTIQ PMT simulator remains available as
[a historical project](docs/legacy-pmt-sim-artiq.md).

## Tests and measurements

| Area | Procedures and tools |
|---|---|
| JTAG and CPLD–FPGA connections | [Discovery, boundary scan and schematic comparison](diagnostics/pm12/README.md) for 168 link signals |
| MCU and board control | [UART, CPU–FPGA communication, sensors and power observations](diagnostics/pm12/mcu/README.md) |
| Integrated digital paths | [HDMI, ADC and TDC test runner](diagnostics/pm12/system/README.md) |
| ADC acquisition | [IPbus acquisition](diagnostics/pm12/ipbus_adc/README.md), [DC response](diagnostics/pm12/cfd_simulator/ADC_DC_SCAN.md) and [data-line checks](diagnostics/pm12/cfd_simulator/ADC_DATA_LINES.md) |
| TDC and timing | [Live TDC diagnostics](diagnostics/pm12/tdc_live120/README.md), [CFD phase scans](diagnostics/pm12/cfd_simulator/PHASE_SCAN.md) and [four-channel repair verification](diagnostics/pm12/tdc_live120/FOUR_CFD_REPAIR_REPEAT.md) |
| Integrators | [Channel 12 balance, signed ramp scans and LaTeX report](diagnostics/pm12/cfd_simulator/INTEGRATOR_SCAN.md) |
| CFD DAC outputs | [Shared-mux voltage scans with Keysight SMU2](diagnostics/pm12/cfd_simulator/SMU_DAC_SCAN.md) |
| Board dossiers | [Sequential acceptance runner, channel batches and LaTeX/PDF reports](diagnostics/pm12/acceptance/README.md) |

Each procedure describes its required image, wiring, instrument configuration,
restoration behavior and qualification status. The acquisition scripts are not
interchangeable across arbitrary FPGA images or bench connections.

## Collect data, generate chapters, assemble the dossier

1. Identify the board and instruments, configure the station profile and verify
   wiring. Acquire the shared board/instrument leases before hardware access.
2. Run the selected hardware procedures and retain raw samples, command logs,
   identities, configuration hashes and explicit validation results. CFD channels
   can be collected in separate batches.
3. Generate figures and an editable LaTeX chapter from the chosen data batches.
   Plot channels together to expose differences. Rendering is offline and does
   not open hardware connections.
4. Assemble the chapters, setup diagrams, device inventory and photographs into
   the board dossier, then compile the PDF.

Start with the [acceptance workflow](diagnostics/pm12/acceptance/README.md).
The [LaTeX template](diagnostics/pm12/acceptance/templates/report.tex) and
[parameterized bench diagram](diagnostics/pm12/acceptance/BENCH_CONFIGURATION.md)
can be edited independently of acquisition. The
[SMU DAC procedure](diagnostics/pm12/cfd_simulator/SMU_DAC_SCAN.md) also provides
standalone acquisition, plotting and LaTeX generation commands.

## Environments and tools

- **Acquisition:** Linux/Python plus the dependencies specified by each procedure.
  The laboratory setup uses the existing pinned Kasli environment and instrument
  drivers; station paths, cable identities and LAN addresses must be configured
  for the actual bench. This repository is not a self-contained station installer.
- **Offline reports:** NumPy and Matplotlib
  ([qualified requirements](diagnostics/pm12/acceptance/requirements-report.txt)),
  plus Tectonic for the validated PDF build. The report generator also supports
  `pdflatex`; see its documented validation limits.
- **Gateware builds:** use the toolchain required by the selected design.
  PM12 Kintex-7 diagnostics were validated with Vivado 2025.2. Heavy laboratory
  builds run on Dell; JTAG/UART and physical tests remain on the station owning
  the attached board. Building is separate from collecting data with an already
  qualified image.
- **Historical ARTIQ project:** its Nix/Vivado 2022.2 instructions are documented
  [separately](docs/legacy-pmt-sim-artiq.md), not as global tester requirements.

No firmware flashing or hardware operation is needed to regenerate reports from
archived measurements.

## Example evidence and reports

- **Integrator balance, channel 12:** [PDF](diagnostics/pm12/cfd_simulator/evidence-integrator-20261113/report.pdf), [procedure and results](diagnostics/pm12/cfd_simulator/INTEGRATOR_SCAN.md). Signed A/B ramp response and revisited zero crossings; 688 raw ADC buffers.

- **CFD DAC outputs, channels 10/8/6:** [PDF](diagnostics/pm12/cfd_simulator/evidence-smu-dac-20261110/report.pdf), [editable LaTeX](diagnostics/pm12/cfd_simulator/evidence-smu-dac-20261110/report.tex), [raw CSV](diagnostics/pm12/cfd_simulator/evidence-smu-dac-20261110/samples.csv). Nine transfer curves, 2727 samples; acquisition/status/restoration checks passed.
- **Board dossier and wiring tables:** [compact specimen](diagnostics/pm12/acceptance/evidence-english-setup-20261108/report.pdf).
- **ADC timing investigation:** [diagnosis and controlled repeats](diagnostics/pm12/acceptance/ADC_STROBE_DEBUG.md), with original rejected evidence retained.
- **CFD gate/TDC repair repeat:** [measurements and interpretation](diagnostics/pm12/tdc_live120/FOUR_CFD_REPAIR_REPEAT.md).

A PASS applies to the selected procedure, configuration and measured channels.
Archived examples do not certify other boards or unmeasured channels. Functional
transfer scans do not imply exhaustive INL/DNL, calibrated jitter or complete
board acceptance. Read each validation record alongside its plots and report.
