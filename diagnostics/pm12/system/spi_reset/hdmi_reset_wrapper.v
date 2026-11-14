// Hold the HDMI parser in its original deselected/reset state.
// Physical HSEL and HMISO output enable remain unchanged in the top level.
module hdmi_reset_wrapper(input clk,sel,mosi,locked,hold_reset,
 output miso,output [15:0] scratch_out,writes_out);
 wire internal_miso;
 hdmi_slave core(.clk(clk),.sel(sel & ~hold_reset),.mosi(mosi),.locked(locked),
 .miso(internal_miso),.scratch_out(scratch_out),.writes_out(writes_out));
 assign miso=hold_reset?1'b0:internal_miso;
endmodule
