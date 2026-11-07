# FIT Testing Software

## Current contents

- PMT Sim firmware (ARTIQ) and example code
- [PM12 JTAG connection test](diagnostics/pm12/README.md): discovery and schematic comparison for 168 CPLD–FPGA lines

## Prerequisites

- Nix (you can use [Determinate Nix Installer](https://determinate.systems/posts/determinate-nix-installer/))
- for building firmware Vivado 2022.2 is required

## PMT Sim

### How to build firmware?

First, make sure your Vivado 2022.2 isntallation is available under right location, i.e.
that file `/opt/Xilinx/Vivado/2022.2/settings64.sh` exists.

Then run:

```
nix build .#fit-testing-firmware
```

### How to flash firmware?

1. Build firmware.

1. Enter ARTIQ shell:

```
nix develop .#
```

2. Create IP address configuration:

```
artiq_mkfs -s ip 192.168.1.2 storage.img
```

3. Flash Kasli:

```
artiq_flash -t kasli -d ./result -f ./storage.img erase gateware bootloader firmware storage start
```

### Running experiment

1. Enter ARTIQ shell:

```
nix develop .#
```

2. Enter `experiments` directory.

3. Run experiment:

```
artiq_run repository/pmtsim_example.py
```

## PM12 acceptance dossiers

[Runner, batch collection and editable LaTeX/PDF reports](diagnostics/pm12/acceptance/README.md).
[212-page historical specimen](diagnostics/pm12/acceptance/evidence-20261107/historical-212pages.pdf),
[fresh channel12 CFD chapter](diagnostics/pm12/acceptance/evidence-20261107/live-cfd-chapter.pdf),
and [rejected post-restore ADC timing capture](diagnostics/pm12/acceptance/evidence-20261107/post-restore-failure.pdf).
See the validation record before inferring board acceptance; unmeasured channels
and unresolved timing findings remain explicit.

STR sampling follow-up: [diagnosis and corrected capture validation](diagnostics/pm12/acceptance/ADC_STROBE_DEBUG.md),
[engineering note PDF](diagnostics/pm12/acceptance/evidence-str-debug-20261107/diagnosis.pdf).
Original exact4-tick failures are retained; controlled phase/reload tests identify
sample-grid edge quantization, with independent data-coherency checks.
