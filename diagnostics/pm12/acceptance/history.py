"""Repackage measured legacy evidence. Never labels it a fresh acceptance run."""
import gzip
import json
from pathlib import Path
import shutil
import sys
from suite import files_manifest, write, utc

HERE=Path(__file__).resolve().parent
PM=HERE.parent


def create(output):
    output.mkdir(parents=True,exist_ok=False)
    folders={
        'jtag':PM/'tests/fixtures',
        'mcu':PM/'mcu/evidence/2026-10-15',
        'i2c':PM/'i2c/evidence',
        'system':PM/'system/evidence-20261106',
        'tdc':PM/'tdc_live120/evidence-phase-1slot-20261106',
        'adc-lines':PM/'cfd_simulator/evidence-adc-lines-20261107',
        'gate-phase':PM/'cfd_simulator/evidence-integrated-phase-20261106',
        'cfd-dacs':PM/'cfd_simulator/evidence-dac-20261105',
        'cfd-monitor':PM/'cfd_simulator/evidence-20261105',
        'ethernet':PM/'ethernet',
    }
    for label,source in folders.items():
        target=output/label;target.mkdir()
        for path in source.iterdir():
            if path.is_file() and path.suffix in ('.json','.gz','.csv','.log','.txt'):
                # Ethernet directory contains source scripts, not copied/executed here.
                shutil.copy2(path,target/path.name)
    shutil.copy2(PM/'pinmap.json',output/'pinmap.json')
    shutil.copy2(PM/'validation-2026-10-13.json',output/'jtag/validation.json')
    shutil.copy2(PM/'i2c/validation-2026-10-14.json',output/'i2c/validation.json')
    sys.path.insert(0,str(PM))
    from test_board import analyze
    for name,boundary in [('gateware',False),('boundary',True)]:
        data=gzip.decompress((output/'jtag'/(name+'-pass.log.gz')).read_bytes()).decode()
        write(output/'jtag'/(name+'-decoded.json'),analyze(data,boundary))
    # This dataset predates factory-DNA enrollment. Never bind it automatically
    # merely because its mutable EEPROM label and cable happen to match today.
    run=dict(schema=1,mode='HISTORICAL',run_id='legacy-1803-20261013-20261107',
             board_uid='LEGACY-SN1803-UNBOUND',board_serial='1803',channels=[12],
             status='INCOMPLETE',started_utc=None,packaged_utc=utc(),
             provenance_warning='Measurements from multiple dates/configurations. No factory DNA was recorded at acquisition. Not one acceptance run and not automatically bound to a newly enrolled board.',
             steps=[])
    write(output/'run.json',run)
    write(output/'files.sha256.json',files_manifest(output))
    return run
