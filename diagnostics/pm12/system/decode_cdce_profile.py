#!/usr/bin/env python3
"""Decode the recovered PM12 startup profile; no hardware access or writes.

TI CDCE62005 SCAS862G tables8,9,13,22,23,24,26,38,40–48.
Only feedback/output encodings present in the PM profile are accepted here;
unrecognised encodings fail instead of being treated as linear divisors.
"""
import argparse,hashlib,json
from pathlib import Path

def decode(words,reference_hz):
 regs={w&15:w>>4 for w in words}
 if not all(i in regs for i in range(9)):raise ValueError('Incomplete startup profile')
 pre={(0,1):1,(1,0):2}[(regs[0]&1,(regs[0]>>1)&1)]
 refdiv=1+((regs[2]&3)|((regs[3]&1)<<2))
 indiv=((regs[5]>>14)&255)+1
 fb={0:8,1:12,2:16,3:20,5:24,6:32,7:40}[(regs[6]>>3)&255]
 bypass={0:2,1:5,2:8,3:10,4:16,5:20,7:1}[(regs[6]>>13)&7]
 p={0:5,1:3,2:4,3:2}[(regs[6]>>1)&3]
 synth=reference_hz*fb*bypass/(pre*refdiv*indiv)
 result={'reference_hz_assumed':reference_hz,'registers':{str(a):f'0x{d<<4|a:08X}' for a,d in sorted(regs.items())},'primary_predivide':pre,'reference_divide':refdiv,'pll_input_divide':indiv,'feedback_divide':fb,'feedback_bypass_divide':bypass,'prescale':p,'synth_hz':synth,'vco_hz':synth*p,'outputs':[]}
 for a in range(5):
  d=regs[a];mux=((d>>4)&1,(d>>5)&1);code=(d>>13)&127;on=bool(d&(1<<20));divider={0x20:1,0x40:2,0x41:3,0x42:4,0x43:5,1:6,2:8,3:10}.get(code) if on else None
  if mux!=(1,1):raise ValueError('PM profile output no longer selects synth')
  if on and divider is None:raise ValueError('Unsupported output divider encoding')
  result['outputs'].append({'index':a,'divider_code':code,'divider_enabled':on,'divider':divider,'frequency_hz':synth/divider if on else None})
 return result

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--firmware',type=Path,required=True);p.add_argument('--reference-hz',type=float,default=40078700);p.add_argument('--out',type=Path,required=True);a=p.parse_args();b=a.firmware.read_bytes();words=[int.from_bytes(b[i:i+4],'little') for i in range(0x2916,0x293e,4)];r=decode(words,a.reference_hz);r['firmware_sha256']=hashlib.sha256(b).hexdigest();r['table_offset']=0x2916;r['transmitted_words']=[f'0x{w:08X}' for w in words];a.out.write_text(json.dumps(r,indent=2)+'\n')
if __name__=='__main__':main()
