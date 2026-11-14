#!/usr/bin/env python3
from pathlib import Path
import argparse,shutil,hashlib,json
p=argparse.ArgumentParser();p.add_argument('--baseline',type=Path,required=True);p.add_argument('--out',type=Path,required=True);a=p.parse_args();shutil.copytree(a.baseline,a.out)
f=a.out/'pm12_ipbus_adc.v';s=f.read_text();assert s.count("32'd3344110693")==1
s=s.replace('reg [31:0] top_hdmi_rdata;', '''reg [31:0] top_hdmi_rdata;
// Runtime hold survives SYS reset; FPGA initialization defaults to normal.
reg hdmi_hold_reset = 1'b0;
always @(posedge sys_clk) begin
 if (!sys_rst && top_hdmi_commit && top_hdmi_selected && top_hdmi_write && !top_hdmi_error && top_hdmi_address==10'd773)
  hdmi_hold_reset <= top_hdmi_wdata[0];
end''')
s=s.replace('top_hdmi_address <= 10\'d772','top_hdmi_address <= 10\'d773')
old="assign top_hdmi_error = ($signed({1'd0, top_hdmi_write}) & ($signed({1'd0, (top_hdmi_address != 10'd769)}) | (($signed({1'd0, top_hdmi_wdata}) & 9'sd320) != $signed({1'd0, 1'd0}))));"
assert old in s;s=s.replace(old,"assign top_hdmi_error = top_hdmi_write && !((top_hdmi_address==10'd769 && (top_hdmi_wdata & 32'd320)==0) || (top_hdmi_address==10'd773 && top_hdmi_wdata<=1));")
s=s.replace("case (top_hdmi_address)\n", "case (top_hdmi_address)\n        10'd773: top_hdmi_rdata <= {16'h5352,15'd0,hdmi_hold_reset};\n",1)
s=s.replace('top_hdmi_command <= top_hdmi_wdata;',"if (top_hdmi_address==10'd769) top_hdmi_command <= top_hdmi_wdata;")
s=s.replace('hdmi_slave hdmi_slave(','hdmi_reset_wrapper hdmi_slave(\n    .hold_reset(hdmi_hold_reset),')
shutil.copy2(Path(__file__).with_name('hdmi_reset_wrapper.v'),a.out/'hdmi_reset_wrapper.v')
identity=int.from_bytes(hashlib.sha256(s.encode()+(a.out/'hdmi_reset_wrapper.v').read_bytes()).digest()[:4],'big');s=s.replace("32'd3344110693",f"32'd{identity}");f.write_text(s)
f=a.out/'build.tcl';s=f.read_text().replace('read_verilog $here/hdmi_slave.v','read_verilog $here/hdmi_slave.v\nread_verilog $here/hdmi_reset_wrapper.v');f.write_text(s)
(a.out/'reset-build.json').write_text(json.dumps(dict(build_id=f'{identity:08x}',baseline='c7531465',hold_csr=0x305,hold_survives_sys_reset=True,sources={str(p.relative_to(a.out)):hashlib.sha256(p.read_bytes()).hexdigest()for p in a.out.rglob('*')if p.is_file()}),indent=2)+'\n');print(f'{identity:08x}')
