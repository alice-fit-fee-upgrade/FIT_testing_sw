source [file join [file dirname [info script]] .. .. tcl common.tcl]
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
foreach mode {0 512 1024 1536 2048 2560 3072 3584} {
 command [expr {$mode | 256}]
 after 50
 command $mode
 after 3000
 report MODE_${mode}_A
 after 2000
 report MODE_${mode}_B
}
command 258
after 50
command 2
after 3000
report INTERNAL_RECOVERY_A
after 3000
report INTERNAL_RECOVERY_B
pm12_close
exit
