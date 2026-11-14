#!/usr/bin/env python3
"""Make an isolated clock-corrected build from retained c7c42d28 HDL.

No hardware access; generate a new identity and exact source manifest. Original
frontend/generated files and historical measurement contracts stay unchanged.
"""
from pathlib import Path
import argparse,hashlib,json,re,shutil

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--baseline',type=Path,required=True);p.add_argument('--out',type=Path,required=True);a=p.parse_args();a.out.mkdir(parents=True,exist_ok=False)
 shutil.copytree(a.baseline,a.out,dirs_exist_ok=True,ignore=shutil.ignore_patterns('__pycache__','build','*.bit','*.dcp','*.log','*.jou'))
 shutil.copy2(Path(__file__).with_name('frontend40.py'),a.out/'frontend40.py')
 f=a.out/'pm12_ipbus_adc.v';s=f.read_text();assert s.count('.CLKIN1_PERIOD(8.333333333333334)')==3 and s.count(".DIVCLK_DIVIDE(2'd3)")==3
 s=s.replace('.CLKIN1_PERIOD(8.333333333333334)',f'.CLKIN1_PERIOD({1e9/40078700:.15f})').replace(".DIVCLK_DIVIDE(2'd3)",".DIVCLK_DIVIDE(1'd1)")
 assert s.count("32'd3351522600")==1
 for n in ['pins.xdc','tdc-pins.xdc']:
  f2=a.out/n;text=f2.read_text().replace('-name lhc120 -period 8.316969','-name lhc40 -period 24.950917071662').replace('-period 8.316969 -name MCLK','-period 24.950917071662 -name MCLK').replace('-period 3.326788 -name TDCCLK','-period 4.990183414332 -name TDCCLK');f2.write_text(text)
 g=a.out/'generate.py';text=g.read_text().replace('from hdmi import HDMI','from hdmi import HDMI\nfrom frontend40 import Frontend');text=text.replace("build_sources += ['hdmi_slave.v'","build_sources += ['frontend40.py','hdmi_slave.v'");g.write_text(text)
 t=a.out/'build.tcl';text=t.read_text().replace('route_design\nfile mkdir build','route_design\nphys_opt_design -directive AggressiveExplore\nroute_design -directive AggressiveExplore\nfile mkdir build');t.write_text(text)
 h=hashlib.sha256(s.encode()+(a.out/'frontend40.py').read_bytes()+(a.out/'pins.xdc').read_bytes()+(a.out/'tdc-pins.xdc').read_bytes()).digest();identity=int.from_bytes(h[:4],'big');s=s.replace("32'd3351522600",f"32'd{identity}");f.write_text(s)
 (a.out/'build-id.txt').write_text(f'{identity:08x}\n')
 meta={'build_id':f'{identity:08x}','baseline_build_id':'c7c42d28','mclk_hz':40078700,'tdc_reference_hz':200393500,'tdc_mmcm':{'input_divider':1,'feedback_multiplier':30,'output_dividers':[2,2,4],'vco_hz':1202361000,'fast_hz':601180500,'coarse_hz':300590250},'sources':{str(x.relative_to(a.out)):hashlib.sha256(x.read_bytes()).hexdigest() for x in sorted(a.out.rglob('*')) if x.is_file()}}
 (a.out/'clock40-manifest.json').write_text(json.dumps(meta,indent=2)+'\n');print(meta['build_id'])
if __name__=='__main__':main()
