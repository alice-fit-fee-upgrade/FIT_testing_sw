#!/usr/bin/env python3
from pathlib import Path
import shutil,argparse,hashlib,json
p=argparse.ArgumentParser();p.add_argument('--baseline',type=Path,required=True);p.add_argument('--out',type=Path,required=True);a=p.parse_args();shutil.copytree(a.baseline,a.out)
f=a.out/'gate_phase.v';s=f.read_text();s=s.replace('reg hdmitester_enabled', 'wire [2:0] hdmi_override_pins;\nwire [7:0] hdmi_override_cfg;\npin_override spi_pin_override(.clk(sys_clk),.rst(sys_rst),.ready(ready),.busy(hdmitester_busy),.write(hdmi_bus_write),.address(hdmi_bus_address),.data(hdmi_bus_write_data),.normal({hdmitester_mosi,hdmitester_sck,hdmitester_sel}),.pins(hdmi_override_pins),.cfg(hdmi_override_cfg));\nreg hdmitester_enabled',1)
for i,n in enumerate(['sel','sck','mosi']):
 old=f'.I(hdmitester_{n})';assert s.count(old)==1;s=s.replace(old,f'.I(hdmi_override_pins[{i}])')
old='hdmitester_read_data <= ({((hdmitester_windowcapture3_done';start=s.index(old);end=s.index(';',start);expr=s[start+len('hdmitester_read_data <= '):end];s=s[:start]+"hdmitester_read_data <= {16'h5350,hdmi_override_cfg,7'd0,"+expr+'}'+s[end:];f.write_text(s)
shutil.copy2(Path(__file__).with_name('pin_override.v'),a.out/'pin_override.v')
f=a.out/'gate_phase_route.tcl';s=f.read_text().replace('add_files {gate_phase.v}','add_files {gate_phase.v pin_override.v}');f.write_text(s)
f=a.out/'qualify.tcl';s=f.read_text().replace('$diffout!=8','$diffout!=10');f.write_text(s)
(a.out/'pin-override-manifest.json').write_text(json.dumps({str(p.relative_to(a.out)):hashlib.sha256(p.read_bytes()).hexdigest() for p in a.out.rglob('*') if p.is_file()},indent=2)+'\n')
