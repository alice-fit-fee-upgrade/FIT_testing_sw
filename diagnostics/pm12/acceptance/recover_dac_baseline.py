#!/usr/bin/env python3
"""Explicit guarded analog baseline recovery; not an ADC test or fault clearance."""
import argparse,contextlib,json
from pathlib import Path
from lease import acquire
from station import load_dependencies,identify,console
from suite import write

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--station',type=Path,required=True);p.add_argument('--channel',type=int,choices=range(1,13),required=True);p.add_argument('--out',type=Path,required=True);a=p.parse_args()
    cfg=json.loads(a.station.read_text());load_dependencies(cfg)
    from mod_dac28 import DAC,remote_lease
    from pm12_console_regression import capture
    from pm12_power import require_power_good
    pair=cfg['channels'][str(a.channel)]['dac_channels']
    a.out.mkdir(parents=True,exist_ok=False);result={'status':'ERROR','scope':'DAC control recovery only; does not clear previous ADC timing failure','channel':a.channel,'dac_channels':pair}
    try:
        with contextlib.ExitStack() as st:
            for n in sorted(cfg['run_leases']):st.enter_context(acquire(Path.home()/'.cache'/(n+'.lock')))
            result['identity']=identify(cfg,a.out)['identity']
            remote=st.enter_context(remote_lease());dac=DAC(remote,channels=pair);st.callback(dac.close)
            result['before']=dac.snapshot()
            with console(cfg) as u:
                result['pgood']=require_power_good(u,capture)
                dac.baseline()
                result['after']=dac.snapshot()
                if any(abs(result['after'][n]-1)>0.00006 for n in pair):raise RuntimeError('Baseline readback failed')
                if any(result['after'][n]!=result['before'][n] for n in range(8) if n not in pair):raise RuntimeError('Another DAC output changed')
                result['status']='PASS'
    finally:write(a.out/'result.json',result)

if __name__=='__main__':main()
