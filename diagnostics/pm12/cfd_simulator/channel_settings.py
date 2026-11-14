"""Physical PM channel selection shared by the four-CFD procedures."""
import re


def adc_address(channel):
    if type(channel) is not int or not 1 <= channel <= 12:
        raise ValueError('Physical PM channel 1..12 required')
    return 0x10000 + (channel-1)*0x1000


def connected_channels(connected, selected=None):
    connected=list(connected)
    if len(connected)!=4 or len(set(connected))!=4:
        raise ValueError('List all four distinct connected CFD channels')
    for channel in connected:adc_address(channel)
    selected=list(connected if selected is None else selected)
    if not selected or len(set(selected))!=len(selected) or not set(selected)<=set(connected):
        raise ValueError('Scan only distinct physically connected channels')
    return connected,selected


def require_serial_reply(reply, expected):
    if not str(expected).isdigit() or not re.search(r'\bBoard S/N:\s*'+re.escape(str(expected))+r'\b',reply):
        raise ValueError('MCU board serial does not match station')


def snapshot_sources(directory, modules):
    """Retain already imported acquisition sources, excluding CLI/run arguments."""
    import hashlib
    import shutil
    import sys
    from pathlib import Path
    target=Path(directory)/'sources'
    target.mkdir()
    retained={}
    for name in modules:
        source=Path(sys.modules[name].__file__)
        if source.suffix!='.py':
            raise ValueError('Expected Python source for '+name)
        dest=target/(name+'.py')
        shutil.copy2(source,dest)
        retained[str(dest.relative_to(directory))]=hashlib.sha256(dest.read_bytes()).hexdigest()
    return retained
