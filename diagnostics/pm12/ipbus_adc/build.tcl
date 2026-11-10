set here [file dirname [file normalize [info script]]]
cd $here
create_project -in_memory -part xc7k160tffg676-3
read_verilog $here/pm12_ipbus_adc.v
read_verilog $here/eth_jtag.v
read_vhdl $here/pm12_mcu_spi.vhd
set manifest [open $here/ipbus-sources.json r]
set text [read $manifest]
close $manifest
# Ordered list generated from the qualified upstream dependency manifest.
foreach f [split [string trim [read [set fp [open $here/ipbus-order.txt r]]]] "\n"] {
 read_vhdl -vhdl2008 $here/ipbus/$f
}
close $fp
read_xdc $here/pins.xdc
synth_design -top pm12_ipbus_adc -part xc7k160tffg676-3
foreach name {I2C_SDA I2C_SCL I2C_RESET_N} {
 if {[get_property DIRECTION [get_ports $name]] ne "IN"} {error "I2C ownership violation: $name"}
}
opt_design
place_design
route_design
file mkdir build
report_drc -file build/drc.txt
report_utilization -file build/utilization.txt
report_timing_summary -file build/timing.txt
foreach corner {max min} {
 if {[llength [get_timing_paths -quiet -delay_type $corner -slack_lesser_than 0 -max_paths 1]]} {error "Timing failed $corner"}
}
write_checkpoint -force build/pm12_ipbus_adc.dcp
write_bitstream -force build/pm12_ipbus_adc.bit
exit
