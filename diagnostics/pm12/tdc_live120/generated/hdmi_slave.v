`timescale 1ns/1ps
// Native PM HDMI transport: active-high SEL, falling-edge shift, 16-bit header.
// Isolated diagnostic register map. No writes to real peripheral controls.
module hdmi_slave(input clk,sel,mosi,input locked,output miso,output [15:0] scratch_out,output [15:0] writes_out);
 reg [4:0] count=0;reg reading=0;reg [7:0] address=0;
 reg [15:0] data=0,scratch=0,writes=0;
 assign miso=data[15];assign scratch_out=scratch;assign writes_out=writes;
 function [15:0] contents(input [7:0] a);
 begin case(a)
  0:contents=16'h4844;1:contents=16'h4d49;2:contents={15'b0,locked};
  8'h40:contents=scratch;8'h41:contents=writes;8'h42:contents=~scratch;
  default:contents=16'h0000;
 endcase end endfunction
 always @(negedge clk or negedge sel)begin
  if(!sel)begin count<=0;reading<=0;end
  else begin
   count<=count==31?16:count+1'b1;
   if(count==0)reading<=mosi;
   if(count==9)address<={data[6:0],mosi};
   if(count[3:0]==15&&reading)data<=contents(address);
   else data<={data[14:0],mosi};
   if(count==31&&!reading&&address==8'h40)begin scratch<={data[14:0],mosi};writes<=writes+1'b1;end
  end
 end
endmodule
