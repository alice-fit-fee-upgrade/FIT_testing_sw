"""Stop-and-wait PM12 ADC capture client. Caller must hold the PM12 board lease."""
import socket,struct,time,json,statistics,hashlib
from pathlib import Path
class Client:
 def __init__(self,ip='192.168.2.240'):
  self.target=(ip,40000);self.sock=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);self.sock.settimeout(1)
 def request(self,op,ch=0,bank=0,page=0,expected_id=None):
  req=struct.pack('!4sBBBB',b'ADC1',op,ch,bank,page)
  # Retrying ARM creates a new acquisition; caller always uses the returned ID.
  for attempt in range(4):
   self.sock.sendto(req,self.target)
   limit=time.monotonic()+1
   while time.monotonic()<limit:
    try:p,src=self.sock.recvfrom(2048)
    except socket.timeout:break
    if src!=self.target or len(p)<16:continue
    magic,reply,c,b,pg,cid,flags=struct.unpack('!4sBBBBII',p[:16])
    if (magic,reply,c,b,pg)!=(b'ADC1',op|128,ch,bank,page):continue
    if expected_id is not None and cid!=expected_id:continue
    if len(p)!=(1040 if op==2 else 16):raise ValueError('incorrect response length')
    return cid,flags,p[16:]
  raise TimeoutError(f'No ADC reply op={op}, channel={ch}, bank={bank}, page={page}')
 def close(self):self.sock.close()
def analyze(raw,bank):
 words=struct.unpack('<4096H',raw);clocks=[(w>>13)&1 for w in words]
 rises=[i for i in range(1,len(words)) if clocks[i] and not clocks[i-1]]
 periods=[b-a for a,b in zip(rises,rises[1:])]
 # Estimate plateau values away from each forwarded-clock edge. Raw data is
 # oversampled independently; this is a functional check, not ADC calibration.
 values=[words[i]&4095 for i in range(2,len(words)-2) if clocks[i-1]==clocks[i]==clocks[i+1]]
 if not values:values=[w&4095 for w in words]
 ored=0;anded=4095
 for v in values:ored|=v;anded&=v
 return dict(selector_correct=all(((w>>12)&1)==bank for w in words),clock_edges=len(rises),clock_hz=320e6/statistics.mean(periods) if periods else 0,clock_period_capture_ticks=sorted(set(periods)),minimum=min(values),maximum=max(values),mean=statistics.mean(values),stddev=statistics.pstdev(values),distinct_codes=len(set(values)),adc_output_activity=len(set(values))>1,toggling_bits=ored^anded,raw_sha256=hashlib.sha256(raw).hexdigest())
def run(out):
 out=Path(out);out.mkdir(parents=True,exist_ok=True);c=Client();records=[]
 try:
  cid,flags,_=c.request(0);print('UDP status',cid,flags,flush=True)
  rejected=0
  for magic,op,ch,bank,page in [(b'BAD!',1,0,0,0),(b'ADC1',3,0,0,0),(b'ADC1',1,12,0,0),(b'ADC1',1,0,2,0),(b'ADC1',1,0,0,8)]:
   c.sock.settimeout(0.15);c.sock.sendto(struct.pack('!4sBBBB',magic,op,ch,bank,page),c.target)
   try:c.sock.recvfrom(2048);raise AssertionError('Malformed request unexpectedly replied')
   except socket.timeout:rejected+=1
   finally:c.sock.settimeout(1)
  cid_after,_,_=c.request(0);assert cid_after==cid,'Invalid request triggered acquisition'
  for iteration,bank in enumerate([0,1,0]):
   cid,flags,_=c.request(1,bank=bank)
   assert flags&7==7,('capture/link/clock not ready',flags)
   for ch in range(12):
    raw=b''.join(c.request(2,ch,bank,page,expected_id=cid)[2] for page in range(8))
    p=out/f'capture{iteration}-adc{ch+1}-{bank}.bin';p.write_bytes(raw)
    r=dict(iteration=iteration,channel=ch+1,bank=bank,capture_id=cid,**analyze(raw,bank));records.append(r)
    print(json.dumps(r),flush=True)
  verdict=all(r['selector_correct'] and 0<r['clock_edges'] and 70e6<r['clock_hz']<90e6 for r in records)
  report=dict(digital_path_pass=verdict,invalid_requests_dropped=rejected,analog_stimulus='not confirmed; pedestal capture only',capture_clock_hz=320000000,samples_per_channel=4096,records=records)
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');return report
 finally:c.close()
if __name__=='__main__':
 import argparse
 p=argparse.ArgumentParser();p.add_argument('out');args=p.parse_args();run(args.out)
