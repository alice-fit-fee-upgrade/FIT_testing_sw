"""Frozen raw TDC download via the existing native IPbus client; no implicit ARM."""
from pathlib import Path
import argparse,fcntl,json,struct,sys
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'ipbus_adc'))
from client import Client

def download(client):
    if client.read(0)!=[0x504d1202] or client.read(1)!=[0x10002]:
        raise RuntimeError('TDC diagnostic ABI mismatch')
    status=client.read(0x201)[0]
    if status & 0x23 != 1:
        raise RuntimeError('No valid, frozen, fault-free TDC acquisition')
    generation,depth,channels=client.read(0x202,3)
    if depth!=4096 or channels!=12:
        raise RuntimeError('Unexpected buffer dimensions')
    counts=client.read(0x220,channels)
    if any(n>depth for n in counts):
        raise RuntimeError('Unexpected buffer dimensions/counts')
    data=[client.block(0x20000+(ch<<12),count) for ch,count in enumerate(counts)]
    if any(word>0x1fff for words in data for word in words):
        raise RuntimeError('Nonzero reserved raw-record bits')
    final=client.read(0x201,2)
    if final[0]&0x23!=1 or final[1]!=generation:
        raise RuntimeError('Acquisition changed during download')
    return generation,status,counts,data

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--host',default='192.168.2.240');p.add_argument('--out',type=Path,required=True)
    a=p.parse_args();leases=[]
    for name in ['atmel-ice-J41800043065','pm12-210249A73E43']:
        lease=(Path.home()/'.cache'/(name+'.lock')).open('a+')
        fcntl.flock(lease,fcntl.LOCK_EX|fcntl.LOCK_NB);leases.append(lease)
    c=Client(a.host)
    try:
        generation,status,counts,data=download(c)
        a.out.mkdir(parents=True,exist_ok=False)
        for ch,words in enumerate(data):
            (a.out/('tdc%02d.bin'%(ch+1))).write_bytes(struct.pack('<%dH'%len(words),*words))
        report=dict(generation=generation,status=status,counts=counts,format='little-endian u16; raw[12:0], upper3 zero; fine=raw&127,coarse=(raw>>7)&63',read_retries=c.read_retry_events)
        (a.out/'summary.json').write_text(json.dumps(report,indent=2)+'\n')
        print(json.dumps(report,indent=2))
    finally:c.close()
