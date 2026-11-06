#!/usr/bin/env python3
"""Run the validated resident-board CFD/TDC test using the station Kasli project.

Forwarded options: --out, --expected-channel, --counts, --phase-bins, --pm-host,
--kasli-host. No FPGA programming or clock initialization is performed.
"""
import argparse
from pathlib import Path
import subprocess
import sys

def main():
    p=argparse.ArgumentParser(add_help=False)
    p.add_argument('--kasli-root',type=Path,default=Path('/home/codex-hil/kasli-phase-tester'))
    a,rest=p.parse_known_args()
    launcher=a.kasli_root/'run-python'
    if not launcher.is_file():raise SystemExit('Kasli project missing: '+str(a.kasli_root))
    return subprocess.call([str(launcher),'-m','host.pm_tdc_test',*rest])

if __name__=='__main__':sys.exit(main())
