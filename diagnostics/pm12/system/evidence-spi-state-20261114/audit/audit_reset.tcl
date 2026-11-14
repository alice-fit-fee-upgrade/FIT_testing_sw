set_param general.maxThreads 4
open_checkpoint [lindex $argv 0]
set f [open [lindex $argv 1] w]
foreach c {FDPE FDPE_1} {
 foreach n {C D CE PRE} {
  set p [get_pins -quiet $c/$n];if {[llength $p]} {
   puts $f "PIN $p NET=[get_nets -of_objects $p] DRIVERS=[get_pins -of_objects [get_nets -of_objects $p] -filter {DIRECTION==OUT}] STARTPOINTS=[all_fanin -flat -startpoints_only -to $p]"
  }
 }
}
puts $f "CLK_IO [get_property CLOCK_DEDICATED_ROUTE [get_nets -of_objects [get_ports HSCK]]]"
close $f
exit
