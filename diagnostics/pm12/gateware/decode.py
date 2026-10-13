"""Decode a USER1 1760-bit scan value (hex, least-significant bit first)."""
import argparse
import json

def decode(value):
    def field(offset, bits): return (value >> offset) & ((1 << bits)-1)
    if field(0,32) != 0x504d1201:
        raise ValueError('Invalid signature: check scan length, USER1 and chain order')
    channels=[]
    for c in range(12):
        channels.append(dict(channel=c+1,live=field(1568+14*c,14),
            sampled=field(64+14*c,14),seen_high=field(232+14*c,14),
            seen_low=field(400+14*c,14),changed=field(568+14*c,14),
            strobes=field(736+32*c,32),last_data=field(1120+32*c,13)))
    return dict(signature='504d1201',cycles=field(32,32),
                frozen=bool(field(1504,1)),channels=channels)

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('hex_value');a=p.parse_args()
    print(json.dumps(decode(int(a.hex_value,16)),indent=2))
