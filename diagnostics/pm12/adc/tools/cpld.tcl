proc cpld_ir {channel opcode} {
 set off [expr {6+8*(12-$channel)}]
 set ir [expr {((1<<102)-1) & ~(255<<$off)}]
 set ir [expr {$ir | ($opcode<<$off)}]
 scan_ir_hw_jtag 102 -tdi [format %llx $ir]
}
proc cpld_dr {channel bits value} {
 set prefix [expr {13-$channel}]
 set data [scan_dr_hw_jtag [expr {$bits+12}] -tdi [format %llx [expr {$value<<$prefix}]]]
 return [expr {(("0x$data")>>$prefix) & ((1<<$bits)-1)}]
}
proc address {row} {
 set g [expr {$row^($row>>1)}]
 set r 0
 for {set i 0} {$i<7} {incr i} {set r [expr {($r<<1)|(($g>>$i)&1)}]}
 return $r
}
