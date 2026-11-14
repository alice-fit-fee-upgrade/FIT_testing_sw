`timescale 1ns/1ps
module tb;
 reg watch=0,sys=0,refclk=0,arm=0,lock=0,cap=1,rst=0,sel=0,sck=0,mosi=0,miso=0;
 reg[5:0]spi=0;reg[7:0]addr=0;reg[15:0]shift=0;reg[10:0]index=0;
 wire[31:0]data,status,count;
 always #12.475 watch=~watch;always #12.475 sys=~sys;always #5 refclk=~refclk;
 spi_observer dut(watch,sys,refclk,arm,lock,cap,rst,sel,sck,mosi,miso,1'b0,1'b0,1'b1,spi,addr,shift,index,data,status,count);
 integer i,n,found;reg[31:0]w;
 task frozen;begin n=0;while(!status[1]&&n<5000)begin @(posedge sys);n=n+1;end if(!status[1]||count<2||count>512)$fatal;end endtask
 task read_word(input integer a);begin index=a;repeat(3)@(negedge sys);w=data;end endtask
 initial begin
 #100;lock=1;#200;arm=1;#1000;if(status[1]||!status[0])$fatal;
 sel=1;spi=6'h2a;addr=8'h12;shift=16'ha55a;
 repeat(8)begin #100;sck=~sck;end
 #100;sel=0;spi=0;#500;lock=0;rst=1;#200;lock=1;rst=0;
 frozen;found=0;
 for(i=0;i<count;i=i+1)begin read_word(3*i+1);if(w[2])begin if(w[21:16]!==0||!w[31]||w[9:8]!==0)$fatal(1,"bad reset state %h",w);read_word(3*i+2);if(w[15:0]!==16'ha55a)$fatal;found=1;end end
 if(!found)$fatal(1,"missing SYS reset record");
 arm=0;#500;lock=0;#1;lock=1;frozen;found=0;
 for(i=0;i<count;i=i+1)begin read_word(3*i+1);if(w[7])found=1;end
 if(!found)$fatal(1,"short lock loss not latched");
 $display("PASS state/address/data capture, idle-state correlation at SYS reset, persistence/readout, rearm and short-lock-loss latch");$finish;
 end
 initial begin #500000;$fatal(1,"watchdog");end
endmodule
