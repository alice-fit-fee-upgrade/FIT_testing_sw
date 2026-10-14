#!/usr/bin/env python3
"""PM12 SRAM-only Ethernet/PRBS laboratory test with restoration under a shared lock."""
import argparse
import fcntl
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import shlex
import subprocess
from analyze import analyze

HERE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('pm12_board',HERE.parent/'test_board.py')
board=importlib.util.module_from_spec(spec); spec.loader.exec_module(board)

def main():
 p=argparse.ArgumentParser(description=__doc__)
 p.add_argument('--serial',required=True)
 p.add_argument('--server',default='localhost:3121')
 p.add_argument('--bitstream',type=Path,required=True)
 p.add_argument('--restore-bitstream',type=Path,required=True)
 p.add_argument('--output',type=Path,required=True)
 p.add_argument('--vivado-command',default='vivado',help='Executable/arguments, shlex split; no shell')
 p.add_argument('--lock',type=Path)
 p.add_argument('--step-timeout',type=int,default=280)
 args=p.parse_args()
 if not re.fullmatch(r'[A-Za-z0-9_-]+',args.serial): p.error('Invalid serial')
 out=args.output.resolve(); out.mkdir(parents=True,exist_ok=True)
 bit=args.bitstream.resolve(); restore=args.restore_bitstream.resolve()
 # Validate both images before touching hardware.
 for image in [bit,restore]: board.payload(image,out/'validate.hex')
 (out/'validate.hex').unlink()
 lock=args.lock or Path.home()/'.cache'/f'pm12-{args.serial}.lock'
 lock.parent.mkdir(parents=True,exist_ok=True)
 report={'board':'PM12','serial':args.serial,'external_sfp':'NOT_RUN','persistent_writes':False,'status':'FAIL','bitstream_sha256':hashlib.sha256(bit.read_bytes()).hexdigest(),'restore_bitstream_sha256':hashlib.sha256(restore.read_bytes()).hexdigest()}
 def run(label,tcl,image):
  payload=out/(label+'.hex'); bits=board.payload(image,payload)
  command=shlex.split(args.vivado_command)+['-mode','batch','-nolog','-nojournal','-notrace','-source',str(tcl),'-tclargs',args.serial,args.server,str(payload),str(bits)]
  print(label,flush=True)
  try:
   with (out/(label+'.log')).open('w') as log:
    subprocess.run(command,cwd=out,stdout=log,stderr=subprocess.STDOUT,timeout=args.step_timeout,check=True)
   return (out/(label+'.log')).read_text()
  finally: payload.unlink(missing_ok=True)
 with lock.open('a+') as lease:
  try: fcntl.flock(lease,fcntl.LOCK_EX|fcntl.LOCK_NB)
  except BlockingIOError:
   report['error']='Board busy'; (out/'report.json').write_text(json.dumps(report,indent=2)+'\n'); return 1
  try:
   run('load',HERE/'load.tcl',bit)
   text=run('test',HERE/'test.tcl',bit)
   entries=[]
   fields=['magic','tick','flags','command','refcount','txframes','rxframes','badframes','prbs_error_samples','rxbytes']
   for name,ms,data in re.findall(r'^ETH_REPORT (\S+) (\d+) ([a-fA-F0-9]+)$',text,re.M):
    value=int(data,16)
    entry={'name':name,'time_ms':int(ms),**{key:(value>>(32*i))&0xffffffff for i,key in enumerate(fields)}}
    if entry['magic']!=0x504de701: raise ValueError('Ethernet signature mismatch')
    entries.append(entry)
   report['samples']=entries; report.update(analyze(entries))
  except (Exception,KeyboardInterrupt) as exc: report['error']=str(exc) or type(exc).__name__
  finally:
   try:
    text=run('restore',HERE.parent/'tcl'/'load.tcl',restore)
    report['restoration']='PASS' if 'LOAD_PASS' in text else 'FAIL'
   except (Exception,KeyboardInterrupt) as exc: report['restoration']='FAIL'; report['restore_error']=str(exc)
   if report.get('restoration')!='PASS': report['status']='FAIL'
   (out/'report.json').write_text(json.dumps(report,indent=2)+'\n')
 print(report['status'],flush=True)
 return 0 if report['status']=='PASS' else 1

if __name__=='__main__': raise SystemExit(main())
