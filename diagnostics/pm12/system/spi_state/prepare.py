#!/usr/bin/env python3
from pathlib import Path
import argparse,shutil,hashlib,json
p=argparse.ArgumentParser();p.add_argument('--baseline',type=Path,required=True);p.add_argument('--out',type=Path,required=True);a=p.parse_args();shutil.copytree(a.baseline,a.out)
f=a.out/'hdmi_slave.v';s=f.read_text().replace('output [15:0] writes_out);','output [15:0] writes_out,output[5:0]debug_state,output[7:0]debug_address,output[15:0]debug_shift);');assert 'debug_state'in s;s=s.replace(' assign miso=', ' assign debug_state={reading,count};assign debug_address=address;assign debug_shift=data;\n assign miso=');f.write_text(s)
f=a.out/'pm12_ipbus_adc.v';s=f.read_text();anchor='// synthesis translate_off\n\tdummy_d_37 <= dummy_s;';assert s.count(anchor)==1
s=s.replace(anchor,"""if ((top_registers_adr>=32'h380 && top_registers_adr<=32'h384) || (top_registers_adr>=32'h8000 && top_registers_adr<32'h8600)) begin
 top_registers_valid_address<=1'b1;top_registers_writable<=(top_registers_adr==32'h380);
 top_registers_bad_write<=(top_registers_wd!=32'h41524d31);
 case(top_registers_adr)
 32'h380:top_registers_read_value<=32'h53504932;
 32'h381:top_registers_read_value<=spiwatch_status;
 32'h382:top_registers_read_value<=spiwatch_count;
 32'h383:top_registers_read_value<=32'd40078700;
 32'h384:top_registers_read_value<=32'h00030002;
 default:top_registers_read_value<=spiwatch_data;
 endcase
end
"""+anchor)
s=s.replace('hdmi_slave hdmi_slave(', 'hdmi_slave hdmi_slave(\n.debug_state(spiwatch_spi_state),.debug_address(spiwatch_spi_address),.debug_shift(spiwatch_spi_shift),')
addition="""
wire spiwatch_clk;wire[31:0]spiwatch_status,spiwatch_count,spiwatch_data;
wire[5:0]spiwatch_spi_state;wire[7:0]spiwatch_spi_address;wire[15:0]spiwatch_spi_shift;
reg spiwatch_arm=0;
BUFG spiwatch_clock(.I(top_sys_ref),.O(spiwatch_clk));
always @(posedge sys_clk)if(top_registers_is_ongoing0 && top_registers_wr && top_registers_adr==32'h380 && top_registers_wd==32'h41524d31)spiwatch_arm<=~spiwatch_arm;
spi_observer spiwatch(.watch_clk(spiwatch_clk),.sys_clk(sys_clk),.ref_clk(top_fixed100),.arm(spiwatch_arm),
.fixed_lock(top_fixed_cm_locked),.cap_lock(top_cap_cm_locked),.sys_reset(sys_rst),
.hsel(HSEL),.hsck(HSCK),.hmosi(HMOSI),.miso_data(top_hdmi_mi),
.fixed_rst(s7mmcm0_reset7),.fixed_powerdown(top_fixed_cm_power_down),.gt_lock(top_pma_k7_gtx_basex_pll_lock),
.spi_state(spiwatch_spi_state),.spi_address(spiwatch_spi_address),.spi_shift(spiwatch_spi_shift),
.read_index(top_registers_adr[10:0]),.data(spiwatch_data),.status(spiwatch_status),.event_count(spiwatch_count));
"""
assert s.count('endmodule')==1;s=s.replace('endmodule',addition+'\nendmodule')
shutil.copy2(Path(__file__).with_name('spi_observer.v'),a.out/'spi_observer.v')
identity=int.from_bytes(hashlib.sha256(s.encode()+(a.out/'spi_observer.v').read_bytes()+(a.out/'hdmi_slave.v').read_bytes()).digest()[:4],'big');assert s.count("32'd3344110693")==1;s=s.replace("32'd3344110693",f"32'd{identity}");f.write_text(s)
f=a.out/'build.tcl';s=f.read_text().replace('read_verilog $here/pm12_ipbus_adc.v','read_verilog $here/pm12_ipbus_adc.v\nread_verilog $here/spi_observer.v');s=s.replace('source $here/tdc-timing.tcl','source $here/tdc-timing.tcl\ncreate_generated_clock -name spiwatch_lhc40 -source [get_ports MCLK1_P] -divide_by 1 [get_pins spiwatch_clock/O]\nset_false_path -to [get_cells -hier -filter {NAME =~ *spiwatch/pins1_reg* || NAME =~ *spiwatch/spi1_reg* || NAME =~ *spiwatch/gray1_reg* || NAME =~ *spiwatch/arm1_reg* || NAME =~ *spiwatch/status1_reg*}]');f.write_text(s)
(a.out/'spi-state-build.json').write_text(json.dumps(dict(build_id=f'{identity:08x}',baseline='c7531465',watch_hz_nominal=40078700,words_per_event=3,sources={str(p.relative_to(a.out)):hashlib.sha256(p.read_bytes()).hexdigest()for p in a.out.rglob('*')if p.is_file()}),indent=2)+'\n');print(f'{identity:08x}')
