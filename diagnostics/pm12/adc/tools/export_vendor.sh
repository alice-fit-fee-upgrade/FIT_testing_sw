#!/usr/bin/env bash
set -euo pipefail
here=$(cd "$(dirname "$0")/.." && pwd)
settings=${PM12_ISE_SETTINGS:-/home/codex-hil/.local/opt/xilinx/14.7/ISE_DS/settings64.sh}
set +u
source "$settings" "$(dirname "$settings")"
set -u
compat=${PM12_ISE_COMPAT:-/home/codex-hil/coolrunner2-recovery/toolchain/ise-compat/root}
export LD_LIBRARY_PATH="$compat/lib/x86_64-linux-gnu:$compat/usr/lib/x86_64-linux-gnu${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
work_dir=${PM12_VENDOR_WORK_DIR:-$here/work}
jed_file=${PM12_CPLD_JED:-$here/cpld/build/design.jed}
mkdir -p "$work_dir"
python3 - "$work_dir" "$XILINX" "$jed_file" <<'PY'
import sys
from pathlib import Path
r=Path(sys.argv[1]);ise=Path(sys.argv[2]);jed=Path(sys.argv[3]);commands=['setMode -bs',f'setCable -port svf -file {r}/adc-chain.svf']
for ch in range(1,13):commands.append(f'addDevice -p {ch} -file {jed}')
commands.append(f'addDevice -p 13 -file {ise}/kintex7/data/xc7k160t_ffg676.bsd')
for ch in range(1,13):commands.append(f'program -p {ch} -e -v')
commands.append('quit');(r/'export-chain.cmd').write_text('\n'.join(commands)+'\n')
PY
impact -batch "$work_dir/export-chain.cmd"
python3 "$here/tools/svf_to_tcl.py" "$work_dir/adc-chain.svf" "$work_dir/program-vendor.tcl"
