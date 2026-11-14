// Reset-independent capture. Watch clock is external MCLK1 (LHC x3).
// ARM is a retained toggle, deliberately not reset by SYS. Trace freezes after
// one second, overflow, or 1024 watch cycles following the first SYS reset.
module clock_observer(input watch_clk,sys_clk,ref_clk,input arm,
 input fixed_lock,cap_lock,sys_reset,hsel,hsck,hmosi,
 input [9:0] read_index, output [31:0] data,
 output [31:0] status,output [31:0] event_count);
 reg [15:0] ref_count=0;
 always @(posedge ref_clk)ref_count<=ref_count+1'b1;
 wire [7:0] gray=ref_count[15:8]^(ref_count[15:8]>>1);
 (* ASYNC_REG="TRUE" *) reg [7:0] gray1=0,gray2=0;
 (* ASYNC_REG="TRUE" *) reg [6:0] inputs1=0,inputs2=0;
 (* ASYNC_REG="TRUE" *) reg arm1=0,arm2=0;
 reg seen=0,active=0,frozen=0;reg [9:0] count=0;
 reg [31:0] tick=0;reg [6:0] previous=0;
 reg [7:0] last_gray=0;reg [15:0] ref_age=0,max_ref_age=0;
 reg [10:0] tail_count=0;reg had_reset=0;
 (* ram_style="block" *)reg [63:0] records[0:511];
 // Two 32-bit words per event; max512events. Count is number of events.
 reg [63:0] read_data=0;reg read_select=0;
 always @(posedge sys_clk)begin read_data<=records[read_index[9:1]];read_select<=read_index[0];end
 assign data=read_select?read_data[63:32]:read_data[31:0];
 reg loss_latched=0;
 always @(posedge watch_clk or negedge fixed_lock)
  if(!fixed_lock)loss_latched<=1;else if(arm2!=seen)loss_latched<=0;
 always @(posedge watch_clk)begin
  arm1<=arm;arm2<=arm1;gray1<=gray;gray2<=gray1;
  inputs1<={loss_latched,hmosi,hsck,hsel,sys_reset,cap_lock,fixed_lock};inputs2<=inputs1;
  if(arm2!=seen)begin
   seen<=arm2;active<=1;frozen<=0;count<=0;tick<=0;previous<=~inputs2;
   had_reset<=0;tail_count<=0;max_ref_age<=0;ref_age<=0;last_gray<=gray2;
  end else if(active)begin
   tick<=tick+1'b1;
   if(gray2!=last_gray)begin last_gray<=gray2;ref_age<=0;end
   else if(ref_age!=65535)ref_age<=ref_age+1'b1;
   if(ref_age>max_ref_age)max_ref_age<=ref_age;
   if((inputs2[2] || inputs2[6]) && tick>8)had_reset<=1;
   if(had_reset&&tail_count<1024)tail_count<=tail_count+1'b1;
   if(inputs2!=previous)begin
    previous<=inputs2;
    records[count[8:0]]<={max_ref_age,ref_age[8:0],inputs2,tick};
    count<=count+1'b1;
   end
   if(count>=511 || tick>=120000000 || (had_reset&&tail_count==1024))begin active<=0;frozen<=1;end
  end
 end
 (* ASYNC_REG="TRUE" *)reg [13:0] status1=0,status2=0;
 always @(posedge sys_clk)begin status1<={had_reset,seen,count,frozen,active};status2<=status1;end
 assign status={18'b0,status2};assign event_count={22'b0,status2[11:2]};
endmodule
