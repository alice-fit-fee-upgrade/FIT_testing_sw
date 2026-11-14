`timescale 1ns/1ps
module tb;
 reg clk=0,rst=0,ready=1,busy=0,write=0;reg[15:0]address=0;reg[31:0]data=0;reg[2:0]normal=0;wire[2:0]pins;wire[7:0]cfg;
 pin_override dut(clk,rst,ready,busy,write,address,data,normal,pins,cfg);
 always #5 clk=~clk;
 task set_cfg(input[31:0]v);begin @(negedge clk);write=1;address='h17c;data=v;@(negedge clk);write=0;#1;end endtask
 integer n;
 initial begin
 #1;normal=5;#1;if(pins!==5)$fatal;
 for(n=0;n<8;n=n+1)begin set_cfg(8+n);if(pins!==n[2:0]||cfg!==8+n)$fatal;end
 busy=1;set_cfg(8);if(cfg!==15)$fatal;busy=0;
 set_cfg(16);if(cfg!==15)$fatal;
 ready=0;@(negedge clk);#1;if(cfg!==0||pins!==5)$fatal;ready=1;
 set_cfg(8);rst=1;@(negedge clk);#1;if(cfg!==0)$fatal;
 $display("PASS pin override normal/manual, all eight values, busy guard, invalid reject, readiness/reset restore");$finish;
 end
endmodule
