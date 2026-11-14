`timescale 1ns/1ps
module tb;
 reg watch=0,sys=0,refclk=0,ref_run=1,arm=0,locked=0,cap=1,rst=0,sel=0,sck=0,mosi=0;
 always #4.1585 watch=~watch;always #12.475 sys=~sys;always #5 if(ref_run)refclk=~refclk;
 reg[9:0] index=0;wire[31:0] data,status,count;
 clock_observer dut(watch,sys,refclk,arm,locked,cap,rst,sel,sck,mosi,index,data,status,count);
 integer n,found;reg[31:0] state;
 task frozen;begin
  n=0;while(!status[1]&&n<5000)begin @(posedge sys);n=n+1;end
  if(!status[1]||status[0]||count<2)$fatal(1,"not frozen count=%d status=%h",count,status);
 end endtask
 task read_state(input integer i);begin
  index=2*i+1;repeat(3)@(negedge sys);state=data;
 end endtask
 initial begin
  #100;locked=1;#200;arm=1;#10000;if(status[1] || !status[0])$fatal(1,"startup loss must clear on ARM");sel=1;repeat(8)begin #100;sck=~sck;end
  locked=0;rst=1;#100;locked=1;rst=0;sel=0;frozen;
  found=0;for(n=0;n<count;n=n+1)begin read_state(n);if(state[2])found=1;end
  if(!found)$fatal(1,"SYS reset not recorded");
  arm=0;#500;locked=0;#1;locked=1;frozen;
  found=0;for(n=0;n<count;n=n+1)begin read_state(n);if(state[6])found=1;end
  if(!found)$fatal(1,"short lock loss not latched");
  $display("CLOCK_OBSERVER_SIM_PASS reset persistence rearm short-pulse latch count=%d",count);$finish;
 end
 initial begin #200000;$fatal(1,"watchdog");end
endmodule
