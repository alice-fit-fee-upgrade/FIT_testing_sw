"""Require external packet delivery, clean RX code groups and MAC reception."""
import math

def analyze(entries,host):
 result=[]
 for mode in [0,512,1024,1536,2048,2560,3072,3584]:
  a=next(e for e in entries if e['name']==f'MODE_{mode}_A')
  b=next(e for e in entries if e['name']==f'MODE_{mode}_B')
  row={k:(b[k]-a[k])&0xffffffff for k in ['txframes','rxframes','ci_count','cfg_count','invalid_count','rx_mac_errors']}
  row.update(mode=mode,rx_polarity=bool(mode&512),tx_polarity=bool(mode&1024),fixed_rate=bool(mode&2048),link_up=all((e['flags']&0x37f)==0x33f and e['command']==mode for e in [a,b]),partner=b['partner'],time_a_ms=a['time_ms'],time_b_ms=b['time_ms'])
  row['host_udp_in_window']=sum(int(count) for second,count in host['per_second'].items() if math.ceil(a['time_ms']/1000)<=int(second)<math.floor(b['time_ms']/1000))
  row['qualified_rx_link']=row['link_up'] and row['ci_count']>1000000 and row['invalid_count']==0
  row['external_packets_pass']=row['qualified_rx_link'] and row['host_udp_in_window']>100 and row['txframes']>100 and row['rxframes']>5 and row['rx_mac_errors']==0 and host['bad_payloads']==0
  result.append(row)
 return {'modes':result,'status':'EXTERNAL_PASS' if any(m['external_packets_pass'] for m in result) else ('PCS_RX_PASS' if any(m['qualified_rx_link'] for m in result) else 'LINK_FAIL')}
