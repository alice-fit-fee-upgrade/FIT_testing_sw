source [file join [file dirname [info script]] common.tcl]
pm12_open
source [file join [file dirname [info script]] cpld.tcl]
set result [catch {
 foreach pass {A B} {
  for {set ch 1} {$ch<=12} {incr ch} {
   cpld_ir $ch 253
   puts "USERCODE $ch [format %08x [cpld_dr $ch 32 0]]"
   cpld_ir $ch 228
   cpld_ir $ch 238
   cpld_dr $ch 7 [address 0]
   runtest_hw_jtag -tck 25 -wait_state IDLE -end_state IDLE
   for {set row 0} {$row<82} {incr row} {
    set data [cpld_dr $ch 759 [expr {[address [expr {$row+1}]]<<752}]]
    puts "ARRAY $ch $pass $row [format %0188llx [expr {$data & ((1<<752)-1)}]]"
    runtest_hw_jtag -tck 25 -wait_state IDLE -end_state IDLE
   }
   cpld_ir $ch 192
   scan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffff
  }
 }
} error options]
pm12_close
if {$result} {return -options $options $error}
puts "CPLD_READ_PASS"
exit
