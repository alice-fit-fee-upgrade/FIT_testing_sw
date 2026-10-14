"""Strict JESD3 fuse parser; never writes input files."""
import hashlib, re
from pathlib import Path

def read(path):
    data = Path(path).read_bytes()
    start, end = data.index(b'\x02'), data.index(b'\x03')
    records = [r.strip().decode('ascii') for r in data[start+1:end].split(b'*') if r.strip()]
    qf = int(next(r[2:] for r in records if r.startswith('QF')))
    default_record = next((r[1:] for r in records if re.fullmatch(r'F[01]', r)), None)
    default = int(default_record) if default_record is not None else 0
    fuses, covered = [default]*qf, set()
    for r in records:
        if not r.startswith('L'): continue
        m = re.fullmatch(r'L(\d+)\s+([01\s]+)', r)
        if not m: raise ValueError('Malformed L record')
        addr, bits = int(m[1]), re.sub(r'\s', '', m[2])
        if addr+len(bits)>qf: raise ValueError('Fuse address exceeds QF')
        for i, bit in enumerate(bits, addr):
            if i in covered: raise ValueError('Overlapping L records')
            covered.add(i); fuses[i] = int(bit)
    if default_record is None and len(covered)!=qf: raise ValueError('Unspecified fuse without F record')
    checksum = sum(sum(fuses[i+j] << j for j in range(min(8,qf-i))) for i in range(0,qf,8)) & 65535
    c = [r for r in records if re.fullmatch(r'C[0-9a-fA-F]{4}',r)]
    declared = int(c[0][1:],16) if c else None
    tail = data[end+1:].strip()
    transmission = int(tail[:4],16) if len(tail)>=4 else None
    result = dict(sha256=hashlib.sha256(data).hexdigest(),qf=qf,default=default,
                  covered_fuses=len(covered),fuse_checksum=checksum,declared_checksum=declared,
                  checksum_valid=declared is None or checksum==declared,
                  transmission_checksum=transmission,transmission_calculated=sum(data[start:end+1])&65535,
                  records=[r for r in records if not r.startswith('L')],fuses=fuses,
                  header=data[:start].decode('ascii'))
    if not result['checksum_valid']: raise ValueError('Fuse checksum mismatch')
    if transmission not in (None,0,result['transmission_calculated']): raise ValueError('Transmission checksum mismatch')
    return result
