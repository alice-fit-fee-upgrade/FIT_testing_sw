"""Canonical board identity and collision-checked inventory; never writes board IDs."""
import fcntl
import json
import os
from pathlib import Path
import re


def canonical_dna(value):
    value = str(value).strip().lower().removeprefix('0x').replace('_', '')
    if not re.fullmatch(r'[0-9a-f]{1,16}', value):
        raise ValueError('Expected at most 64 hexadecimal DNA bits')
    number = int(value, 16)
    if number in (0, (1 << 64)-1):
        raise ValueError('Blank DNA is not an identity')
    return f'{number:016X}'


def board_uid(dna):
    return 'PM12-K7-'+canonical_dna(dna)


def register(path, identity):
    """Keep all observed hardware IDs and human labels; refuse conflicting aliases."""
    path = Path(path)
    uid = board_uid(identity['fpga_dna'])
    if identity['uid'] != uid:
        raise ValueError('UID does not match raw FPGA DNA')
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.with_suffix('.lock').open('a+') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        registry = json.loads(path.read_text()) if path.exists() else {'schema': 1, 'boards': {}}
        for other_uid, row in registry['boards'].items():
            if other_uid != uid and identity.get('asset_label') and row.get('asset_label') == identity['asset_label']:
                raise ValueError('Asset label already belongs to another DNA')
        old = registry['boards'].get(uid, {})
        # EEPROM serial is mutable; preserve every observation, do not merge by serial.
        observations = old.get('observations', [])
        observations.append(identity)
        registry['boards'][uid] = dict(uid=uid, fpga_dna=canonical_dna(identity['fpga_dna']),
                                      asset_label=identity.get('asset_label', old.get('asset_label')),
                                      observations=observations)
        temp = path.with_suffix('.tmp')
        temp.write_text(json.dumps(registry, indent=2)+'\n')
        os.replace(temp, path)
    return uid
