# Read-only Device DNA. No program_hw_devices, eFUSE writes, reset or EXTEST.
lassign $argv cable server
open_hw_manager
connect_hw_server -url $server
set targets [get_hw_targets -quiet *$cable]
if {[llength $targets] != 1} {error "Missing or ambiguous JTAG cable"}
current_hw_target [lindex $targets 0]
open_hw_target
set devices [get_hw_devices -quiet xc7k160t*]
if {[llength $devices] != 1} {error "Expected exactly one PM Kintex-7 160T"}
set device [lindex $devices 0]
refresh_hw_device -update_hw_probes false $device
puts "FIT_PART [get_property PART $device]"
puts "FIT_DNA [get_property REGISTER.EFUSE.FUSE_DNA $device]"
if {![catch {get_property REGISTER.USERCODE $device} usercode]} {puts "FIT_USER_ACCESS $usercode"}
close_hw_target
disconnect_hw_server
close_hw_manager
