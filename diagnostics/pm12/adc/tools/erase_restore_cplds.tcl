source [file join [file dirname [info script]] common.tcl]
source [file join [file dirname [info script]] cpld.tcl]
pm12_open
for {set ch 1} {$ch<=12} {incr ch} {
 cpld_ir $ch 228
 cpld_ir $ch 237
 cpld_dr $ch 759 0
 runtest_hw_jtag -tck 100000 -wait_state IDLE -end_state IDLE
 cpld_ir $ch 240
 runtest_hw_jtag -tck 20000 -wait_state IDLE -end_state IDLE
 cpld_ir $ch 240
 cpld_dr $ch 759 0
 runtest_hw_jtag -tck 800000 -wait_state IDLE -end_state IDLE
 cpld_ir $ch 192
 puts "CPLD_ERASED_RESTORED_BLANK $ch"
}
pm12_close
puts "ALL_CPLD_ERASED_RESTORED"
exit
