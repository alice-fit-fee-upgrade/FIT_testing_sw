source [file join [file dirname [info script]] .. tcl common.tcl]
pm12_open
scan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffcb
scan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffff
runtest_hw_jtag -tck 120000 -wait_state IDLE -end_state IDLE
scan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffc5
set f [open $::env(PM12_PAYLOAD) r]
set data [read $f]
close $f
puts "LOAD_SINGLE_BEGIN"
scan_dr_hw_jtag $::env(PM12_PAYLOAD_BITS) -tdi $data
puts "LOAD_SINGLE_END"
scan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffcc
runtest_hw_jtag -tck 2000 -wait_state IDLE -end_state IDLE
scan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffff
runtest_hw_jtag -tck 2000
scan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffc2
set report [scan_dr_hw_jtag 524 -tdi 0]
if {[expr {("0x$report") & 0xffffffff}] != 0x504de701} {error "Loaded image lacks diagnostic signature"}
puts "LOAD_PASS $report"
pm12_close
exit
