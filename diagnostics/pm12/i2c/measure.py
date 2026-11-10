"""INA3221 read-only telemetry. Shunt values from PM12 v1.1, not calibrated."""
import time,statistics
from client import Bus
CHANNELS={4:[('P1V0_LDO',.010,'R53'),('P1V2_LDO',.010,'R55'),('P1V8_LDO',.010,'R56')],5:[('P3V8',None,'R15 (not populated)'),('P3V3',.001,'R92'),('P1V8',.001,'R84')],6:[('P1V0',.001,'R74'),('P5V5',.001,'R216'),('TP1/TP2',None,None)]}
def signed_code(raw):
 return (raw-65536 if raw&32768 else raw)>>3
def decode(shunt,bus,resistance):
 vsh=signed_code(shunt)*40e-6;vbus=signed_code(bus)*.008
 clipped=signed_code(shunt) in [-4096,4095]
 return {'bus_V':vbus,'shunt_V':vsh,'shunt_clipped':clipped,'current_A':None if clipped or resistance is None else vsh/resistance}
def run(samples=20):
 b=Bus();assert b.gpio(0)==7
 original={a:b.transfer(a,read=1) for a in [0x70,0x71]};assert all(v is not None for v in original.values())
 result={'samples_per_monitor':samples,'shunt_values_source':'FIT_PM12v1.1.PDF pages14,16,17,19,20,21','calibrated':False,'monitors':[]}
 try:
  for a in original:b.transfer(a,b'\0')
  for route,mapping in CHANNELS.items():
   b.transfer(0x71,bytes([1<<route]));assert b.transfer(0x71,read=1)==bytes([1<<route])
   ident=[b.reg(0x40,n) for n in [0xfe,0xff]];assert ident==[0x5449,0x3220]
   config=b.reg(0x40,0);assert config&7==7,'Monitor not in continuous shunt+bus mode'
   rows=[]
   for i in range(samples):
    started=time.time();raw=[b.reg(0x40,n) for n in range(1,7)];ended=time.time()
    rows.append({'start_unix':started,'end_unix':ended,'raw':raw,'channels':[decode(raw[2*j],raw[2*j+1],r) for j,(_,r,_) in enumerate(mapping)]})
    time.sleep(.05)
   channels=[]
   for j,(rail,r,ref) in enumerate(mapping):
    vals=[x['channels'][j] for x in rows];v=[x['bus_V'] for x in vals];curr=[x['current_A'] for x in vals if x['current_A'] is not None]
    channels.append({'rail':rail,'shunt_ohm':r,'resistor':ref,'bus_V_mean':statistics.mean(v),'bus_V_min':min(v),'bus_V_max':max(v),'current_A_mean':statistics.mean(curr) if curr else None,'current_A_min':min(curr) if curr else None,'current_A_max':max(curr) if curr else None,'clipped_samples':sum(x['shunt_clipped'] for x in vals)})
   monitor={'mux':'0x71','mux_channel':route,'address':'0x40','manufacturer_id':ident[0],'die_id':ident[1],'config_before':config,'config_after':b.reg(0x40,0),'channels':channels,'samples':rows}
   assert monitor['config_after']==config
   result['monitors'].append(monitor);print('TELEMETRY',route,channels,flush=True)
   b.transfer(0x71,b'\0')
 finally:
  for a,r in original.items():b.transfer(a,r)
  b.gpio(0)
 result['mux_restored']={hex(a):b.transfer(a,read=1)==v for a,v in original.items()};assert all(result['mux_restored'].values())
 result['final_lines']=b.gpio();assert result['final_lines']==7
 return result
if __name__=='__main__':
 assert signed_code(0xfff8)==-1 and signed_code(0x8000)==-4096
 assert decode(0x7ff8,1000,.001)['current_A'] is None
 assert abs(decode(256,1000,.01)['current_A']-.128)<1e-12
 print('DECODE_CHECK_PASS')
