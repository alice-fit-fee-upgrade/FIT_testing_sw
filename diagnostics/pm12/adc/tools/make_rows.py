import sys,json,hashlib,argparse
from pathlib import Path
import jedlib
root=Path(__file__).resolve().parents[1]
f=jedlib.read(root/'cpld/build/design.jed')['fuses']
rows=[0]*80;masks=[0]*80;seen=[]
parser=argparse.ArgumentParser();parser.add_argument('--map',type=Path,default=Path('/home/codex-hil/.local/opt/xilinx/14.7/ISE_DS/ISE/xbr/data/xc2c128.map'));mp=parser.parse_args().map
(root/'work').mkdir(exist_ok=True)
lines=mp.read_text().splitlines();assert len(lines)==752
for col,line in enumerate(lines):
 empty=True
 for row,t in enumerate(line.split('\t')):
  if row>=80:break
  if t:
   empty=False
   if t.isdigit():
    idx=int(t);v=f[idx];seen.append(idx);masks[row]|=1<<(751-col)
   elif t.startswith('spare'):v=1
   else:raise ValueError((col,row,t))
  else:v=0 if empty else 1
  rows[row]|=v<<(751-col)
assert len(set(seen))==len(f)==len(seen),(len(f),len(seen))
(root/'work/sram-rows.txt').write_text(''.join(f'{r:0188x} {m:0188x}\n' for r,m in zip(rows,masks)))
print('mapped',len(f),'fuses; JEDEC sha256',hashlib.sha256((root/'cpld/build/design.jed').read_bytes()).hexdigest())
