# Executed after synthesis: generated MMCM clocks retain automatic ratios/phases.
# Preserve upstream receiver timing intent, using the original instance names.
for {set n 1} {$n <= 3} {incr n} {
 set fast [get_clocks -of_objects [get_pins tdc_mmcm$n/CLKOUT0]]
 set coarse [get_clocks -of_objects [get_pins tdc_mmcm$n/CLKOUT2]]
 if {![llength $fast] || ![llength $coarse]} {error "Missing TDC MMCM clock $n"}
 set idx [expr {$n-1}]
 set receivers [get_cells -hier -filter "NAME =~ TDC${n}_CH*/C_PER_reg* || NAME =~ TDC${n}_CH*/C_STR1_reg || NAME =~ top_tdc_frontend_bc_time${idx}_reg* || NAME =~ top_tdc_frontend_s1${idx}_reg"]
 set_multicycle_path -setup -start -from $fast -to $receivers 2
 set_multicycle_path -hold -start -from $fast -to $receivers 1
 set raw [get_cells -hier -filter "NAME =~ TDC${n}_CH*/tdc_raw_i_reg*"]
 set_max_delay -datapath_only -from [concat [get_clocks TDCCLK$n] $coarse] -to $raw 3.000
 puts "TDC_TIMING_GROUP $n RAW_REGISTERS [llength $raw] COARSE_ENDPOINTS [llength $receivers]"
 if {[llength $raw] != 52} {error "Expected 52 raw timestamp registers per TDC"}
 set rst_sync [get_cells -hier -filter "NAME =~ TDC${n}_CH*/rs300_0_reg || NAME =~ TDC${n}_CH*/rs300_1_reg"]
 set_property ASYNC_REG true $rst_sync
 # Only the strobe's first synchronizer stage is an asynchronous endpoint.
 set_false_path -to [get_pins -of_objects [get_cells -hier -filter "NAME =~ TDC${n}_CH*/rs300_0_reg"] -filter {REF_PIN_NAME == D}]
}
# CFD is an asynchronous measurement input to the original oversampler.
set_max_delay -datapath_only -from [get_ports {IN*_P MCLK?_P}] -to [get_cells -hier -filter {REF_NAME == ISERDESE2}] 2.000
