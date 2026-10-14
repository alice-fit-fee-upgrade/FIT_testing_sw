source [file join [file dirname [info script]] common.tcl]
pm12_open
set current_hw_jtag [get_property hw_jtag [current_hw_target]]
source $::env(PM12_PAYLOAD)
set_property ENDSTATE_IR IDLE $current_hw_jtag
set_property ENDSTATE_DR IDLE $current_hw_jtag
pm12_close
puts "NATIVE_EXECUTE_PASS"
exit
