#!/usr/bin/env bash
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
settings=/home/codex-hil/.local/opt/xilinx/14.7/ISE_DS/settings64.sh
set +u
source "$settings" "$(dirname "$settings")"
set -u
compat=/home/codex-hil/coolrunner2-recovery/toolchain/ise-compat/root
export LD_LIBRARY_PATH="$compat/lib/x86_64-linux-gnu:$compat/usr/lib/x86_64-linux-gnu${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
build_dir=${PM12_CPLD_BUILD_DIR:-$here/build}
termination=${PM12_CPLD_TERMINATION:-keeper}
case "$termination" in keeper|pullup|float) ;; *) echo "Unsupported CPLD termination" >&2; exit 2;; esac
mkdir -p "$build_dir"
cd "$build_dir"
printf 'vhdl work "%s/adc_mux.vhd"\n' "$here" > design.prj
cat > design.xst <<'X'
run
-ifn design.prj
-ifmt mixed
-ofn design
-ofmt NGC
-p xc2c128-7-vq100
-top adc_mux
-opt_mode Speed
-opt_level 1
X
xst -ifn design.xst -ofn design.syr
ngdbuild -p xc2c128-7-vq100 -uc "$here/pins.ucf" design.ngc design.ngd
cpldfit -p xc2c128-7-vq100 -unused float -terminate "$termination" -iostd LVCMOS33 -optimize speed design.ngd
hprep6 -i design.vm6
