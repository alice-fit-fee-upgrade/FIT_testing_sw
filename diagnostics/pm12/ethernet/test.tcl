source [file join [file dirname [info script]] .. tcl common.tcl]
pm12_open
proc report {name} {
 scan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffc2
 set r [scan_dr_hw_jtag 524 -tdi 0]
 puts "ETH_REPORT $name [clock milliseconds] $r"
 if {[expr {("0x$r") & 0xffffffff}] != 0x504de701} {error "signature failure"}
 return [expr {("0x$r") + 0}]
}
proc command {value} {
 scan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffc3
 scan_dr_hw_jtag 28 -tdi [format %x $value]
}
command 2
after 3000
report MAC_A
after 3000
report MAC_B
command 66
after 2000
report BAD_PAYLOAD
command 2
after 3000
report PAYLOAD_RECOVERY_A
after 3000
report PAYLOAD_RECOVERY_B
command 18
after 3000
report PRBS_A
after 3000
report PRBS_B
command 50
after 2000
report MISMATCH
command 18
after 3000
report RECOVERY_A
after 3000
report RECOVERY_B
command 2
after 3000
report MAC_RECOVERY_A
after 3000
report MAC_RECOVERY_B
pm12_close
exit
