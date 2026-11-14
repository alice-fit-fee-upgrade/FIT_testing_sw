// GPIO override without changing output enable or buffer direction.
// CSR17c write: bit3=manual, bits2:0={MOSI,SCK,SEL}.
// CSR17c read: bit0=legacy capture-valid, bits15:8=cfg,
// bits31:16=0x5350. Reset/readiness loss returns normal mode.
module pin_override(input clk,rst,ready,busy,write,input [15:0] address,
 input [31:0] data,input [2:0] normal,output [2:0] pins,output reg [7:0] cfg=0);
 always @(posedge clk) begin
  if(rst || !ready)cfg<=0;
  else if(write && address==16'h17c && !busy && data<16)cfg<=data[7:0];
 end
 assign pins=cfg[3]?cfg[2:0]:normal;
endmodule
