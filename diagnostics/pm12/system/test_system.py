#!/usr/bin/env python3
"""Station entry point for the integrated PM12 + Kasli IPbus hardware suite."""
import argparse
from pathlib import Path
import subprocess


def main():
    parser=argparse.ArgumentParser(add_help=False)
    parser.add_argument('--kasli-root',type=Path,default=Path('/home/codex-hil/kasli-phase-tester'))
    args,rest=parser.parse_known_args()
    launcher=args.kasli_root/'run-python'
    if not launcher.is_file():
        raise SystemExit('Missing pinned Kasli station environment: '+str(launcher))
    return subprocess.call([str(launcher),'-m','host.pm_system_test',*rest])


if __name__=='__main__':
    raise SystemExit(main())
