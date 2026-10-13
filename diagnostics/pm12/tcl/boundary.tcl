# Ephemeral EXTEST only; no ISC programming instructions.
source [file join [file dirname [info script]] common.tcl]
pm12_open
set status [catch {
 scan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffc2
 set r [scan_dr_hw_jtag 1772 -tdi 0]
 if {[expr {("0x$r") & 0xffffffff}] != 0x504d1201} {error "FPGA diagnostic signature missing"}
 scan_ir_hw_jtag 102 -tdi 00c0c0c0c0c0c0c0c0c0c0c0c1
 set baseline [scan_dr_hw_jtag 4893 -tdi 0]
 puts "BASELINE $baseline"
 set base [expr {("0x$baseline") + 0}]
 # Preserve sampled non-link output data/control. Link output OE is active high.
 set cells {253 250 247 244 241 235 232 229 226 73 76 79 82 88}
 set mask 0
 set enables 0
 for {set j 0} {$j<12} {incr j} {
  foreach cell $cells {
   set offset [expr {1293+300*$j+$cell}]
   set mask [expr {$mask | (1 << $offset)}]
   set enables [expr {$enables | (1 << ($offset-1))}]
  }
 }
 set base [expr {($base & ~$mask) | $enables}]
 # Preload before EXTEST so no uninitialized drive reaches pads.
 scan_dr_hw_jtag 4893 -tdi [format %llx $base]
 scan_ir_hw_jtag 102 -tdi 00000000000000000000000001
 set vectors [list [list ZERO 0] [list ONES [expr {(1<<168)-1}]]]
 for {set bit 0} {$bit<168} {incr bit} {
  lappend vectors [list ONE_$bit [expr {1<<$bit}]]
  lappend vectors [list ZERO_$bit [expr {((1<<168)-1) ^ (1<<$bit)}]]
 }
 foreach vec $vectors {
  lassign $vec name bits
  set value $base
  for {set j 0} {$j<12} {incr j} {
   for {set k 0} {$k<14} {incr k} {
    if {($bits >> (14*$j+$k)) & 1} {set value [expr {$value | (1 << (1293+300*$j+[lindex $cells $k]))}]}
   }
  }
  set hex [format %llx $value]
  scan_dr_hw_jtag 4893 -tdi $hex
  after 1
  set r [scan_dr_hw_jtag 4893 -tdi $hex]
  puts "VECTOR $name $r"
 }
} err opts]
# Always return CPLDs to functional mode, retaining their persistent firmware.
run_state_hw_jtag RESET
run_state_hw_jtag IDLE
scan_ir_hw_jtag 102 -tdi 3fffffffffffffffffffffffc2
puts "RESTORED_REPORT [scan_dr_hw_jtag 1772 -tdi 0]"
pm12_close
if {$status} {return -options $opts $err}
exit
