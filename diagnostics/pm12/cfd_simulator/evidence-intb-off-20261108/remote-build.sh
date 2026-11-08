#!/bin/bash
set -euo pipefail
cd /srv/nvme-fast-4/simulations/pm12-intb-off-20261108
mkdir -p sim
cd sim
ghdl -a --std=08 ../cpld/adc_mux.vhd ../cpld/tb.vhd
ghdl -e --std=08 tb
ghdl -r --std=08 tb -gINTB_ENABLE=true --assert-level=error > ../simulation-original.log
ghdl -r --std=08 tb -gINTB_ENABLE=false --assert-level=error > ../simulation-intb-off.log
cd ..
PM12_ISE_SETTINGS="$ISE_SETTINGS" PM12_ISE_COMPAT=/nonexistent bash cpld/build.sh > build.log 2>&1
set +u
source "$ISE_SETTINGS" "$(dirname "$ISE_SETTINGS")"
set -u
impact -batch export.cmd > export.log 2>&1
