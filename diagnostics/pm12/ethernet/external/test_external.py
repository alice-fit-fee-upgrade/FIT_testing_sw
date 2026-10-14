#!/usr/bin/env python3
"""Discover PM12 external 1000BASE-X mode using real UDP delivery and RX frames."""
import argparse,fcntl,hashlib,importlib.util,json,re,shlex,subprocess,sys
from pathlib import Path
from external_verdict import analyze
HERE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('pm12_board',HERE.parents[1]/'test_board.py');board=importlib.util.module_from_spec(spec);spec.loader.exec_module(board)

def main():
 p=argparse.ArgumentParser(description=__doc__)
 p.add_argument('--serial',required=True);p.add_argument('--server',default='localhost:3121')
 p.add_argument('--bitstream',type=Path,required=True);p.add_argument('--restore-bitstream',type=Path,required=True)
 p.add_argument('--host-ip',default='192.168.2.107',help='Must match the host address compiled into the FPGA image')
 p.add_argument('--output',type=Path,required=True);p.add_argument('--vivado-command',default='vivado')
 p.add_argument('--step-timeout',type=int,default=280);p.add_argument('--lock',type=Path)
 a=p.parse_args()
 if not re.fullmatch(r'[A-Za-z0-9_-]+',a.serial):p.error('Invalid serial')
 out=a.output.resolve();out.mkdir(parents=True,exist_ok=True);bit=a.bitstream.resolve();restore=a.restore_bitstream.resolve()
 for image in [bit,restore]:board.payload(image,out/'validate.hex')
 (out/'validate.hex').unlink()
 lock=a.lock or Path.home()/'.cache'/f'pm12-{a.serial}.lock';lock.parent.mkdir(parents=True,exist_ok=True)
 report={'board':'PM12','serial':a.serial,'status':'FAIL','persistent_writes':False,'bitstream_sha256':hashlib.sha256(bit.read_bytes()).hexdigest(),'restore_bitstream_sha256':hashlib.sha256(restore.read_bytes()).hexdigest(),'limits':['Fixed IPv4/UDP frame generator, no ARP/ping or general IP stack','RX pattern mismatch count includes unrelated switch frames; RX MAC error count includes PCS/FCS/padding errors','Live asynchronous JTAG reports and host timestamps are not precision timing measurements']}
 def run(label,tcl,image):
  payload=out/(label+'.hex');bits=board.payload(image,payload)
  command=shlex.split(a.vivado_command)+['-mode','batch','-nolog','-nojournal','-notrace','-source',str(tcl),'-tclargs',a.serial,a.server,str(payload),str(bits)]
  print(label,flush=True)
  try:
   with (out/(label+'.log')).open('w') as log:subprocess.run(command,cwd=out,stdout=log,stderr=subprocess.STDOUT,timeout=a.step_timeout,check=True)
   return (out/(label+'.log')).read_text()
  finally:payload.unlink(missing_ok=True)
 with lock.open('a+') as lease:
  try:fcntl.flock(lease,fcntl.LOCK_EX|fcntl.LOCK_NB)
  except BlockingIOError:
   report['error']='Board busy';(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');return 1
  try:
   run('load',HERE/'load.tcl',bit)
   capture=subprocess.Popen([sys.executable,str(HERE/'udp_host.py'),str(out/'udp-host.json'),a.host_ip])
   try:text=run('test',HERE/'test_external.tcl',bit)
   finally:
    capture.wait(timeout=100)
    if capture.returncode:raise RuntimeError('UDP capture/probe process failed')
   fields=['magic','tick','flags','command','refcount','txframes','rxframes','badframes','prbs_error_samples','rxbytes','raw_8b10b','partner','ci_count','cfg_count','invalid_count','rx_mac_errors'];entries=[]
   for name,ms,data in re.findall(r'^ETH_REPORT (\S+) (\d+) ([a-fA-F0-9]+)$',text,re.M):
    value=int(data,16);entry={'name':name,'time_ms':int(ms),**{k:(value>>(32*i))&0xffffffff for i,k in enumerate(fields)}}
    if entry['magic']!=0x504de701:raise ValueError('Signature mismatch')
    entries.append(entry)
   report['samples']=entries;report['udp_host']=json.loads((out/'udp-host.json').read_text());report.update(analyze(entries,report['udp_host']))
  except (Exception,KeyboardInterrupt) as exc:report['status']='FAIL';report['error']=str(exc) or type(exc).__name__
  finally:
   try:report['restoration']='PASS' if 'LOAD_PASS' in run('restore',HERE.parents[1]/'tcl/load.tcl',restore) else 'FAIL'
   except (Exception,KeyboardInterrupt) as exc:report['restoration']='FAIL';report['restore_error']=str(exc)
   if report['restoration']!='PASS':report['status']='FAIL'
   (out/'report.json').write_text(json.dumps(report,indent=2)+'\n')
 print(report['status'],flush=True);return 0 if report['status']=='EXTERNAL_PASS' else 1
if __name__=='__main__':raise SystemExit(main())
