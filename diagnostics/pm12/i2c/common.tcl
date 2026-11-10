# Explicit Tcl arguments also work through docker exec (host env is not inherited).
if {[llength $argv] != 4} {error "Expected serial, server, payload path and payload bits"}
lassign $argv ::env(PM12_SERIAL) ::env(PM12_SERVER) ::env(PM12_PAYLOAD) ::env(PM12_PAYLOAD_BITS)
proc pm12_open {} {
 open_hw_manager
 connect_hw_server -url $::env(PM12_SERVER)
 set ts [get_hw_targets -quiet *$::env(PM12_SERIAL)]
 if {[llength $ts] != 1} {error "PM12 cable missing or ambiguous"}
 current_hw_target [lindex $ts 0]
 set_property PARAM.FREQUENCY 1000000 [current_hw_target]
 open_hw_target -jtag_mode on
 run_state_hw_jtag RESET
 run_state_hw_jtag IDLE
 scan_ir_hw_jtag 102 -tdi 00404040404040404040404049
 set ids [scan_dr_hw_jtag 416 -tdi 0]
 puts "IDS $ids"
 set expected [string repeat 16d8a093 12]
 append expected 0364c093
 if {![string equal -nocase $ids $expected]} {error "Unexpected PM12 chain: $ids"}
}
proc pm12_close {} {
 run_state_hw_jtag RESET
 close_hw_target
 disconnect_hw_server
 close_hw_manager
}
