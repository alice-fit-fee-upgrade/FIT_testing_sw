#!/bin/bash
set -euo pipefail
# Build in a fresh worktree. Never modify the running reconstruction checkout.
# Usage: build.sh /path/to/FIT_PM_FW_uPC /absolute/new/build-worktree
# Requires the shared AVR GCC 7.3.0 toolchain on PATH.
# No programmer, UART, reset or power-control operations are performed.
if [ "$#" -ne 2 ]; then echo "Usage: $0 source-repo new-worktree" >&2; exit 2; fi
here=$(cd -- "$(dirname -- "$0")" && pwd)
git -C "$1" worktree add --detach "$2" 30dec0a
git -C "$2" apply "$here/firmware-extension.patch"
make -C "$2" development-check
make -C "$2" exact-check
# Firmware: <worktree>/development/build/development.hex
# UART console: @PING, @HW, @TEMP, @TDC 0 83, @TDC 1 83,
# @TDC 2 83, @PLL, @PGTIME, terminated by CR.
# PG timer uses TCE0, preserves original timeout and power-off branches.
# FPGA scratch write-test and explicit config reset/boot commands are included.
# Flash commands read only; no flash programming or erasing.
# Before physical testing: identify UART/PDI, back up MCU FLASH/EEPROM/fuses,
# preserve board power/restart behavior, hold the shared PM12 hardware lease.
