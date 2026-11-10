#!/bin/bash
set -euo pipefail
here=$(cd -- "$(dirname -- "$0")" && pwd)
"$here/check_spi.sh"
# Generated RTL and BRAM initialization are included; Migen is not required.
vivado -mode batch -nolog -nojournal -source "$here/build.tcl"
# Offline only: no programming, flash writes or hardware-server calls.
