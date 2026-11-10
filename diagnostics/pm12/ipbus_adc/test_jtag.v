`timescale 1ns/1ps
module BSCANE2 #(parameter JTAG_CHAIN=1)(output TCK,RESET,CAPTURE,SHIFT,SEL,TDI,UPDATE,input TDO);endmodule
module test_jtag;
reg clk=0,rst=0,cap=0,sh=0,sel=0,tdi=0,upd=0;
wire [15:0] command;
eth_jtag dut(.report(512'b0),.command(command));
always #5 clk=~clk;
initial begin
 force dut.tck2=clk;force dut.reset2=rst;force dut.cap2=cap;force dut.shift2=sh;force dut.sel2=sel;force dut.tdi2=tdi;force dut.update2=upd;
 force dut.tck=clk;force dut.sel=1'b0;force dut.cap=1'b0;force dut.shift=1'b0;force dut.tdi=1'b0;
end
task cycle;begin @(posedge clk);@(negedge clk);#1;end endtask
task send(input [15:0] v);integer i;begin
 sel=1;cap=1;cycle;cap=0;sh=1;
 // Twelve bypass clocks precede the16 payload bits at the FPGA TDI.
 for(i=0;i<12;i=i+1)begin tdi=0;cycle;end
 for(i=0;i<16;i=i+1)begin tdi=v[i];cycle;end
 sh=0;upd=1;cycle;upd=0;sel=0;cycle;
 if(command!==v)$fatal(1,"Normal USER2 command failed");
end endtask
initial begin
 #1;cycle;send(16'h8002);
 // Reproduce TAP-reset stale UPDATE; it must not clear the arm bit.
 force dut.cr=16'h0000;rst=1;sel=1;upd=1;cycle;cycle;
 if(command!==16'h8002)$fatal(1,"TAP reset corrupted command");
 rst=0;upd=0;sel=0;release dut.cr;cycle;
 // UPDATE after CAPTURE but without SHIFT must also leave command intact.
 sel=1;cap=1;cycle;cap=0;upd=1;cycle;upd=0;sel=0;
 if(command!==16'h8002)$fatal(1,"Empty USER2 transaction corrupted command");
 send(16'ha123);send(16'h8123);
 repeat(512)cycle;
 if(command!==16'h8123)$fatal(1,"Idle/readback corrupted command");
 $display("PASS USER2 commands,TAP reset stale UPDATE,empty transaction and readback hold");$finish;
end
endmodule
