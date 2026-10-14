import collections,json,socket,sys,time
from pathlib import Path
out=Path(sys.argv[1]); host_ip=sys.argv[2] if len(sys.argv)>2 else '192.168.2.107'; expected=b'PM12-SFP-UDP-TEST!'
s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);s.bind((host_ip,49155));s.setsockopt(socket.SOL_SOCKET,socket.SO_BROADCAST,1);s.settimeout(.05)
start=time.monotonic(); stop=start+65; next_send=start; counts=collections.Counter(); bad=0; sent=0; first=None; last=None
while time.monotonic()<stop:
 now=time.monotonic()
 if now>=next_send:
  s.sendto(b'PM12-HOST-RX-PROBE!',(host_ip.rsplit('.',1)[0]+'.255',49154));sent+=1;next_send=now+.1
 try: data,peer=s.recvfrom(2048)
 except socket.timeout: continue
 if peer==('198.18.0.12',49154):
  t=time.time();counts[int(t)]+=1;first=first or t;last=t
  if data!=expected:bad+=1
s.close();r=dict(expected_payload_hex=expected.hex(),source_ip='198.18.0.12',host_ip=host_ip,port=49155,received=sum(counts.values()),bad_payloads=bad,sent_broadcast_probes=sent,first_time=first,last_time=last,per_second=dict(counts));out.write_text(json.dumps(r,indent=2)+'\n');print('UDP_HOST',r,flush=True)
