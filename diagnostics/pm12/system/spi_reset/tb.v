`timescale 1ns/1ps
module tb;
 reg clk=0,sel=0,mosi=0,locked=1,hold_reset=0;wire miso;wire[15:0]scratch,writes;reg[15:0]rx;
 hdmi_reset_wrapper dut(clk,sel,mosi,locked,hold_reset,miso,scratch,writes);
 task frame(input[7:0]address);integer i;reg[31:0]packet;begin
 packet=32'h80000000|({24'd0,address}<<22);rx=0;sel=0;#3;sel=1;
 for(i=31;i>=0;i=i-1)begin mosi=packet[i];#3;clk=1;#3;if(i<16)rx={rx[14:0],miso};clk=0;#3;end
 sel=0;#3;end endtask
 initial begin
 #2;frame(0);if(rx!==16'h4844)$fatal(1,"normal %h",rx);
 frame(1);if(rx!==16'h4d49)$fatal;
 hold_reset=1;#3;
 frame(0);if(rx!==0||dut.core.count!==0||dut.core.reading!==0||writes!==0)$fatal;
 frame(1);if(rx!==0||dut.core.count!==0||dut.core.reading!==0)$fatal;
 frame(3);if(rx!==0)$fatal;
 hold_reset=0;#3;frame(0);if(rx!==16'h4844)$fatal;
 frame(3);frame(3);if(rx!==0)$fatal;
 $display("PASS normal signatures, parser held in reset under clocked frames, zero MISO, release/recovery, constant-zero normal read3");$finish;
 end
endmodule
