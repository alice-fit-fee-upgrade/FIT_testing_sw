source [file join [file dirname [info script]] common.tcl]
pm12_open
proc report {name} {
 scan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffc2
 set r [scan_dr_hw_jtag 1772 -tdi 0]
 puts "CONTROL $name [clock milliseconds] $r"
 if {[expr {("0x$r") & 0xffffffff}] != 0x504d1201} {error "signature failure"}
 return [expr {("0x$r") + 0}]
}
proc command {value} {
 scan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffc3
 scan_dr_hw_jtag 14 -tdi $value
}
set status [catch {
 for {set run 0} {$run<3} {incr run} {
  command 1
  after 10
  set run_a [report RUN_${run}_A]
  after 500
  set run_b [report RUN_${run}_B]
  if {(($run_a>>32)&0xffffffff)==(($run_b>>32)&0xffffffff)} {error "Monitor clock stopped"}
  command 3
  after 10
  set a [report FREEZE_${run}_A]
  after 100
  set b [report FREEZE_${run}_B]
  if {!(($a>>1504)&1) || !(($b>>1504)&1)} {error "freeze not acknowledged"}
  if {(($a>>32)&0xffffffff) != (($b>>32)&0xffffffff)} {error "frozen count changed"}
  command 1
  after 100
  set c [report RESUME_$run]
  if {($c>>1504)&1} {error "resume failed"}
  if {(($c>>32)&0xffffffff)==(($b>>32)&0xffffffff)} {error "Resumed counter did not advance"}
  command 0
  after 10
  set reset_r [report RESET_$run]
  if {(($reset_r>>32)&0xffffffff) >= (($c>>32)&0xffffffff)} {error "Counter reset failed"}
 }
} err opts]
command 0
pm12_close
if {$status} {return -options $opts $err}
puts "CONTROL_PASS"
exit
