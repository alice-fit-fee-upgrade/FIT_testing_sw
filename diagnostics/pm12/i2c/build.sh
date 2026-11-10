#!/bin/bash
set -euo pipefail
# Use the shared Migen/LiteX environment and shared Vivado; no tool installs.
here=$(cd -- "$(dirname -- "$0")" && pwd)
export PYTHONPATH=/home/codex-hil/fit-bringup/sources/litex-eth-check:/home/codex-hil/fit-bringup/sources/liteeth-eth-check:/home/codex-hil/fit-bringup/sources/liteiclink-eth-check
/srv/codex-hil-data/artiq-zynqmp/venv/bin/python "$here/test_server.py"
/srv/codex-hil-data/artiq-zynqmp/venv/bin/python "$here/generate.py"
vivado -mode batch -nolog -nojournal -source "$here/build.tcl"
# Hardware: python3 test_hardware.py --container <PM12 hw_server container>
# Cable 210249A73E43 only. Requires MCU isolation R226/R227/R228.
# UDP 192.168.2.240:40000, I2C1 protocol; one-second automatic line release.
# test_hardware.py holds board lease and restores link diagnostic FPGA SRAM.
# No CPLD, AVR, power-controller, PLL, flash or OTP writes.
# Voltage/current telemetry: python3 test_hardware.py --container <id> --measure
# Uses schematic shunts (LDO: 10 mOhm, bucks: 1 mOhm); no calibration claimed.
