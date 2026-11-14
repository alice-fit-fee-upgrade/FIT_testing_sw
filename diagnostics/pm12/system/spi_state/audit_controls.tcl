set_param general.maxThreads 4
set f [open [lindex $argv 2] w]
foreach file [lrange $argv 0 1] {
 open_checkpoint $file
 puts $f "CHECKPOINT $file"
 set c [get_cells MMCME2_ADV]
 puts $f "MMCM $c COMPENSATION=[get_property COMPENSATION $c]"
 foreach n {RST PWRDWN CLKINSEL CLKIN1 CLKIN2 CLKFBIN PSCLK PSEN PSINCDEC DCLK DEN DWE} {
  set p [get_pins -quiet $c/$n];if {[llength $p]} {
   puts $f "PIN $p DRIVERS=[get_pins -of_objects [get_nets -of_objects $p] -filter {DIRECTION==OUT}] STARTPOINTS=[all_fanin -flat -startpoints_only -to $p]"
  }
 }
 close_design
}
close $f
exit
