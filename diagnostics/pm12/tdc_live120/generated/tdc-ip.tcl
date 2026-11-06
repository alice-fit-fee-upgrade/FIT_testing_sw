# Recreate original standard (not FWFT) common-clock 6x16 shift-register FIFO.
file mkdir $here/ip-generated
if {[file exists $here/ip-generated/TDC_FIFO/TDC_FIFO.xci]} {
 read_ip $here/ip-generated/TDC_FIFO/TDC_FIFO.xci
} else {
 create_ip -name fifo_generator -vendor xilinx.com -library ip -module_name TDC_FIFO -dir $here/ip-generated
}
set_property -dict [list CONFIG.Fifo_Implementation {Common_Clock_Shift_Register} CONFIG.Input_Data_Width {6} CONFIG.Input_Depth {16} CONFIG.Output_Data_Width {6} CONFIG.Output_Depth {16} CONFIG.Performance_Options {Standard_FIFO} CONFIG.Reset_Type {Synchronous_Reset} CONFIG.Reset_Pin {true}] [get_ips TDC_FIFO]
generate_target all [get_ips TDC_FIFO]
synth_ip [get_ips TDC_FIFO]
