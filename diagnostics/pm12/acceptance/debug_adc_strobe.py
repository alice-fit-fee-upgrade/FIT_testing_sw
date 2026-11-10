#!/usr/bin/env python3
"""Raw ADC strobe/phase characterization; deliberately does not accept bad strides.
Writes only selected channel DAC-A, restores explicit code0. No reprogramming.
"""
import argparse,collections,contextlib,json,struct,time
from pathlib import Path
from station import load_dependencies,identify,console
from lease import acquire
from suite import write


def stats(words):
    edges=[i for i in range(1,len(words)) if not words[i-1]&8192 and words[i]&8192]
    gaps=[b-a for a,b in zip(edges,edges[1:])]
    transitions=[i for i in range(1,len(words)) if (words[i]^words[i-1])&4095]
    since=[]
    for edge in edges:
        prior=[i for i in transitions if i<=edge]
        if prior:since.append(edge-prior[-1])
    return dict(edges=len(edges),intervals=dict(collections.Counter(gaps)),bad_intervals=sum(g!=4 for g in gaps),
                data_last_change_before_str=dict(collections.Counter(since)),
                edge_offset_min=min((e-4*n for n,e in enumerate(edges)),default=None),
                edge_offset_max=max((e-4*n for n,e in enumerate(edges)),default=None))


def main():
    p=argparse.ArgumentParser();p.add_argument('--station',type=Path,required=True);p.add_argument('--out',type=Path,required=True)
    p.add_argument('--codes',type=int,nargs='+',default=[0,1024,2048,4096,8192,16384,24576,32768,40960,49152,57344,65535])
    p.add_argument('--repeats',type=int,default=4);a=p.parse_args()
    if any(not 0<=v<=65535 for v in a.codes) or a.repeats<1:p.error('Invalid code/repeats')
    cfg=json.loads(a.station.read_text());load_dependencies(cfg)
    from client import Client
    from phase_scan import ConsoleDAC
    from pm12_console_regression import capture
    from pm12_power import require_power_good
    a.out.mkdir(parents=True,exist_ok=False);report=dict(status='ERROR',rows=[],commands=[],restore_code=0)
    with contextlib.ExitStack() as st:
        for n in sorted(cfg['identity_leases']):st.enter_context(acquire(Path.home()/'.cache'/(n+'.lock')))
        report['identity']=identify(cfg,a.out)['identity']
        u=st.enter_context(console(cfg));c=Client();st.callback(c.close)
        dac=ConsoleDAC(u,12,capture,report['commands'].append)
        changed=False
        def record(code,bank,repeat,channels):
            generation,state=c.acquire(bank,False)
            for channel in channels:
                words=c.block(0x10000+(channel-1)*0x1000,4096)
                assert c.read(0x12)==[generation] and all(w<16384 and ((w>>12)&1)==bank for w in words)
                name=f'gen{generation:08d}-code{code:05d}-bank{bank}-rep{repeat}-ch{channel:02d}.bin'
                with (a.out/name).open('xb') as raw:raw.write(struct.pack('<4096H',*words))
                row=dict(code=code,bank=bank,repeat=repeat,channel=channel,generation=generation,raw=name,**stats(words))
                report['rows'].append(row)
                print(code,bank,repeat,channel,row['intervals'],flush=True)
            write(a.out/'result.json',report)
        try:
            for bank in [0,1]:record(0,bank,0,range(1,13))
            for code in a.codes:
                require_power_good(u,capture);changed=True;dac.set_code(code);time.sleep(.1)
                for bank in [0,1]:
                    for repeat in range(a.repeats):record(code,bank,repeat,[12])
            report['status']='CHARACTERIZED'
        finally:
            if changed:
                dac.set_code(0);report['restore_command_accepted']=True;time.sleep(.1)
                for bank in [0,1]:record(0,bank,99,[12])
            c.acquire(0,False)
            report['pgood_final']=require_power_good(u,capture)
            write(a.out/'result.json',report)

if __name__=='__main__':main()
