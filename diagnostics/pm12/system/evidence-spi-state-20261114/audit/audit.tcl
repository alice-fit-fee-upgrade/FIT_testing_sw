set_param general.maxThreads 4
open_checkpoint [lindex $argv 0]
set f [open [lindex $argv 1] w]
proc describe {f p} {
 puts $f "PIN $p"
 puts $f "NET [get_nets -quiet -segments -of_objects $p]"
 puts $f "DRIVERS [get_pins -quiet -of_objects [get_nets -quiet -of_objects $p] -filter {DIRECTION == OUT}]"
 puts $f "STARTPOINTS [all_fanin -quiet -flat -startpoints_only -to $p]"
}
foreach c [get_cells -hier -filter {REF_NAME =~ MMCME2*}] {
 puts $f "CELL $c [get_property REF_NAME $c]"
 foreach n {CLKIN1 CLKIN2 CLKINSEL CLKFBIN RST PWRDWN} {foreach p [get_pins -quiet $c/$n] {describe $f $p}}
}
foreach name {HSCK HSEL HMOSI HMISO MGTCLK_P MGTCLK_N MCLK1_P MCLK1_N} {
 set p [get_ports $name];puts $f "PORT $name PIN=[get_property PACKAGE_PIN $p] NET=[get_nets -of_objects $p]"
 puts $f "FANOUT [all_fanout -quiet -flat -endpoints_only -from $p]"
}
foreach n [get_nets -quiet -hier -filter {NAME == sys_rst || NAME =~ *async_reset*}] {
 puts $f "RESET_NET $n";foreach p [get_pins -quiet -of_objects $n -filter {DIRECTION == OUT}] {describe $f $p}
}
close $f
report_drc -checks {MDRV-1 NSTD-1 UCIO-1} -file [lindex $argv 2]
exit
