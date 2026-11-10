"""Share actual flock open-file descriptions with child test processes.

An environment flag alone never suppresses locking: inherited FDs must point
at exactly the requested lock inode and must still accept LOCK_EX|LOCK_NB.
"""
import fcntl
import json
import os
from pathlib import Path

ENV = 'FIT_TEST_LEASE_FDS'


def acquire(path):
    path = Path(path).expanduser().resolve()
    inherited = json.loads(os.environ.get(ENV, '{}'))
    if str(path) in inherited:
        fd = int(inherited[str(path)])
        st, expected = os.fstat(fd), path.stat()
        if (st.st_dev, st.st_ino) != (expected.st_dev, expected.st_ino):
            raise RuntimeError('Inherited lease inode mismatch: '+str(path))
        stream = os.fdopen(os.dup(fd), 'a+')
    else:
        path.parent.mkdir(parents=True, exist_ok=True)
        stream = path.open('a+')
    try:
        fcntl.flock(stream, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except BaseException:
        stream.close()
        raise
    return stream
