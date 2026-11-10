#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
# Existing workspace dependencies; no downloads or package installation.
export PYTHONPATH="${FIT_LITEX_ROOT:-/home/codex-hil/fit-bringup/sources/litex-eth-check}:${FIT_LITEETH_ROOT:-/home/codex-hil/fit-bringup/sources/liteeth-eth-check}:${FIT_LITEICLINK_ROOT:-/home/codex-hil/fit-bringup/sources/liteiclink-eth-check}${PYTHONPATH:+:$PYTHONPATH}"
"${FIT_HDL_PYTHON:-/srv/codex-hil-data/artiq-zynqmp/venv/bin/python}" generate.py
vivado -mode batch -source build.tcl
