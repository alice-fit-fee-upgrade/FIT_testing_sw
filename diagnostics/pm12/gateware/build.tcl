set here [file dirname [file normalize [info script]]]
set candidates [get_parts -quiet *7k160t*ffg676*-3]
if {[llength $candidates] != 1} {error "Kintex part support missing or ambiguous: $candidates"}
set part [lindex $candidates 0]
create_project -in_memory -part $part
read_verilog [glob $here/*.v]
read_xdc $here/pins.xdc
synth_design -top pm12_link_diag -part $part
opt_design
place_design
route_design
file mkdir $here/build
report_drc -file $here/build/drc.txt
report_timing_summary -file $here/build/timing.txt
set slack [get_property SLACK [get_timing_paths -max_paths 1]]
if {$slack < 0} {error "Timing failed: $slack"}
write_checkpoint -force $here/build/pm12_link_diag.dcp
write_bitstream -force $here/build/pm12_link_diag.bit
exit
