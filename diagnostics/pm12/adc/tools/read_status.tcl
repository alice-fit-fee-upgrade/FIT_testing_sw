source [file join [file dirname [info script]] common.tcl]
pm12_open
scan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffc2
for {set n 0} {$n<3} {incr n} {
 set report [scan_dr_hw_jtag 524 -tdi 0]
 if {[expr {("0x$report") & 0xffffffff}] != 0x504dad01} {error "Wrong ADC diagnostic signature"}
 puts "ADC_STATUS [clock milliseconds] $report"
 after 500
}
pm12_close
puts "STATUS_PASS"
exit
