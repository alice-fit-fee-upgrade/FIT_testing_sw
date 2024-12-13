# FIT Testing Software

## Current contents

- PMT Sim firmware (ARTIQ) and example code

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
