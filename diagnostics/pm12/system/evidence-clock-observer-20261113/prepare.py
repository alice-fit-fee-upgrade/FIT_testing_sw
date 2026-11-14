from pathlib import Path
import hashlib,json
root=Path(__file__).parent/'source';v=root/'pm12_ipbus_adc.v';s=v.read_text();assert s.count('endmodule')==1
# Add read-only trace window and one magic-protected ARM toggle.
anchor='// synthesis translate_off\n\tdummy_d_37 <= dummy_s;'
assert s.count(anchor)==1
s=s.replace(anchor,"""if ((top_registers_adr>=32'h380 && top_registers_adr<=32'h383) || (top_registers_adr>=32'h8000 && top_registers_adr<32'h8400)) begin
 top_registers_valid_address<=1'b1;top_registers_writable<=(top_registers_adr==32'h380);
 top_registers_bad_write<=(top_registers_wdata!=32'h41524d31);
 case(top_registers_adr)
 32'h380:top_registers_read_value<=32'h434c4b31;
 32'h381:top_registers_read_value<=observer_status;
 32'h382:top_registers_read_value<=observer_count;
 32'h383:top_registers_read_value<=32'd120236100;
 default:top_registers_read_value<=observer_data;
 endcase
end
"""+anchor)
# Existing latched bus data variable is wd, not input live wdata.
s=s.replace('top_registers_bad_write<=(top_registers_wdata!=32\'h41524d31);','top_registers_bad_write<=(top_registers_wd!=32\'h41524d31);')
addition="""
wire watch_clk;wire [31:0] observer_status,observer_count,observer_data;
reg observer_arm=0;
BUFG observer_clock(.I(top_sys_ref),.O(watch_clk));
always @(posedge sys_clk)if(top_registers_is_ongoing0 && top_registers_wr && top_registers_adr==32'h380 && top_registers_wd==32'h41524d31)observer_arm<=~observer_arm;
clock_observer observer(.watch_clk(watch_clk),.sys_clk(sys_clk),.ref_clk(top_fixed100),.arm(observer_arm),
.fixed_lock(top_fixed_cm_locked),.cap_lock(top_cap_cm_locked),.sys_reset(sys_rst),.hsel(HSEL),.hsck(HSCK),.hmosi(HMOSI),
.read_index(top_registers_adr[9:0]),.data(observer_data),.status(observer_status),.event_count(observer_count));
"""
s=s.replace('endmodule',addition+'\nendmodule');assert s.count("32'd3351522600")==1
identity=int.from_bytes(hashlib.sha256((s+(root/'clock_observer.v').read_text()).encode()).digest()[:4],'big');s=s.replace("32'd3351522600",f"32'd{identity}");v.write_text(s)
t=root/'build.tcl';text=t.read_text().replace('read_verilog $here/pm12_ipbus_adc.v','read_verilog $here/pm12_ipbus_adc.v\nread_verilog $here/clock_observer.v');text=text.replace('source $here/tdc-timing.tcl','source $here/tdc-timing.tcl\ncreate_generated_clock -name observer_lhc -source [get_ports MCLK1_P] -divide_by 1 [get_pins observer_clock/O]\nset_false_path -to [get_cells -hier -filter {NAME =~ *observer/inputs1_reg* || NAME =~ *observer/gray1_reg* || NAME =~ *observer/arm1_reg* || NAME =~ *observer/status1_reg*}]');text=text.replace('route_design\nfile mkdir build','route_design\nphys_opt_design -directive AggressiveExplore\nroute_design -directive AggressiveExplore\nfile mkdir build');t.write_text(text)
(root/'observer-build.json').write_text(json.dumps({'build_id':hex(identity),'baseline':'c7c42d28','sources':{str(p.relative_to(root)):hashlib.sha256(p.read_bytes()).hexdigest() for p in root.rglob('*') if p.is_file()}},indent=2)+'\n');print(hex(identity))
