#!/bin/bash
set -euo pipefail
here=$(cd -- "$(dirname -- "$0")" && pwd)
work=$(mktemp -d)
trap 'rm -rf -- "$work"' EXIT
GHDL=${GHDL:-/home/codex-hil/coolrunner2-recovery/tools/ghdl}
"$GHDL" -a --std=08 --workdir="$work" "$here/pm12_mcu_spi.vhd" "$here/tb_spi.vhd"
"$GHDL" -e --std=08 --workdir="$work" tb_spi
"$GHDL" -r --std=08 --workdir="$work" tb_spi --assert-level=error
