#!/usr/bin/env bash
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
export PYTHONPATH=/home/codex-hil/fit-bringup/sources/litex-eth-check:/home/codex-hil/fit-bringup/sources/liteeth-eth-check:/home/codex-hil/fit-bringup/sources/liteiclink-eth-check${PYTHONPATH:+:$PYTHONPATH}
python_exe=${PM12_HDL_PYTHON:-/srv/codex-hil-data/artiq-zynqmp/venv/bin/python}
"$here/cpld/build.sh"
python3 "$here/tools/make_rows.py"
"$here/tools/export_vendor.sh"
"$python_exe" "$here/fpga/test_server.py"
"$python_exe" "$here/fpga/generate.py"
vivado -mode batch -source "$here/fpga/build.tcl"
