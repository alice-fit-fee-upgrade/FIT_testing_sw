module pm12_link_diag (    input wire [12:0] DI1, input wire STR1,
    input wire [12:0] DI2, input wire STR2,
    input wire [12:0] DI3, input wire STR3,
    input wire [12:0] DI4, input wire STR4,
    input wire [12:0] DI5, input wire STR5,
    input wire [12:0] DI6, input wire STR6,
    input wire [12:0] DI7, input wire STR7,
    input wire [12:0] DI8, input wire STR8,
    input wire [12:0] DI9, input wire STR9,
    input wire [12:0] DI10, input wire STR10,
    input wire [12:0] DI11, input wire STR11,
    input wire [12:0] DI12, input wire STR12,
    input wire MCLK1_P, MCLK1_N);
 wire clk;
 IBUFDS #(.DIFF_TERM("TRUE")) clock_input (.I(MCLK1_P),.IB(MCLK1_N),.O(clk_pad));
 wire clk_pad;
 BUFG clock_global (.I(clk_pad),.O(clk));
 wire [167:0] pins = {STR12,DI12, STR11,DI11, STR10,DI10, STR9,DI9, STR8,DI8, STR7,DI7, STR6,DI6, STR5,DI5, STR4,DI4, STR3,DI3, STR2,DI2, STR1,DI1};
 wire [1567:0] monitor_report;
 wire reset_toggle,freeze_request,frozen;
 link_monitor monitor (.clk(clk),.pins(pins),.reset_toggle(reset_toggle),.freeze_request(freeze_request),.frozen(frozen),.report(monitor_report));
 wire tck, rst1, cap1, sh1, sel1, tdi1, tdo1;
 wire up2, sh2, sel2, tdi2;
 BSCANE2 #(.JTAG_CHAIN(1)) scan_read (.TCK(tck),.RESET(rst1),.CAPTURE(cap1),.SHIFT(sh1),.SEL(sel1),.TDI(tdi1),.TDO(tdo1));
 BSCANE2 #(.JTAG_CHAIN(2)) scan_control (.UPDATE(up2),.SHIFT(sh2),.SEL(sel2),.TDI(tdi2),.TDO(1'b0));
 // Both USER chains share physical TDI; select control input when USER2 selected.
 jtag_report transport (.tck(tck),.reset(rst1),.capture1(cap1),.shift1(sh1),.sel1(sel1),.update2(up2),.sel2(sel2),.shift2(sh2),.tdi(sel2 ? tdi2 : tdi1),.report({24'b0,pins,monitor_report}),.tdo1(tdo1),.reset_toggle(reset_toggle),.freeze_request(freeze_request));
endmodule
