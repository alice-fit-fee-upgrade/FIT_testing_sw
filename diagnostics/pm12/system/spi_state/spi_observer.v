// Sampled-state observer on MCLK1=40.0787MHz, independent of SYS reset.
// SPI multibit debug is sampled, not an atomic CDC transfer. stable means
// identical complete SPI bundle on two consecutive watch samples.
module spi_observer(input watch_clk,sys_clk,ref_clk,arm,
 input fixed_lock,cap_lock,sys_reset,hsel,hsck,hmosi,miso_data,
 input fixed_rst,fixed_powerdown,gt_lock,input[5:0]spi_state,
 input[7:0]spi_address,input[15:0]spi_shift,
 input[10:0]read_index,output[31:0]data,status,event_count);
 reg[15:0]ref_count=0;always @(posedge ref_clk)ref_count<=ref_count+1'b1;
 wire[7:0]gray=ref_count[15:8]^(ref_count[15:8]>>1);
 (* ASYNC_REG="TRUE" *)reg[7:0]gray1=0,gray2=0;
 (* ASYNC_REG="TRUE" *)reg[10:0]pins1=0,pins2=0;
 (* ASYNC_REG="TRUE" *)reg[29:0]spi1=0,spi2=0;
 (* ASYNC_REG="TRUE" *)reg arm1=0,arm2=0;
 reg[29:0]spi_previous=0;wire spi_stable=(spi2==spi_previous);
 reg seen=0,active=0,frozen=0,had_reset=0;reg[9:0]count=0;
 reg[31:0]tick=0;reg[61:0]previous=0;
 reg[7:0]last_gray=0,ref_age=0,max_ref_age=0;
 reg[10:0]tail_count=0;
 (* ram_style="block" *)reg[95:0]records[0:511];
 reg[95:0]rd=0;reg[1:0]rd_select=0;
 always @(posedge sys_clk)begin rd<=records[read_index/3];rd_select<=read_index%3;end
 assign data=(rd_select==0)?rd[31:0]:(rd_select==1)?rd[63:32]:rd[95:64];
 reg loss_latched=0;
 always @(posedge watch_clk or negedge fixed_lock)
  if(!fixed_lock)loss_latched<=1;else if(arm2!=seen)loss_latched<=0;
 wire[31:0]state_word={spi_stable,1'b0,spi2[13:6],spi2[5:0],5'b0,pins2};
 wire[31:0]detail_word={max_ref_age,ref_age,spi2[29:14]};
 wire[61:0]observed={spi_stable,spi2,pins2,20'b0};
 always @(posedge watch_clk)begin
  arm1<=arm;arm2<=arm1;gray1<=gray;gray2<=gray1;
  pins1<={gt_lock,fixed_powerdown,fixed_rst,loss_latched,miso_data,hmosi,hsck,hsel,sys_reset,cap_lock,fixed_lock};pins2<=pins1;
  spi1<={spi_shift,spi_address,spi_state};spi2<=spi1;spi_previous<=spi2;
  if(arm2!=seen)begin
   seen<=arm2;active<=1;frozen<=0;count<=0;tick<=0;previous<=~observed;
   had_reset<=0;tail_count<=0;max_ref_age<=0;ref_age<=0;last_gray<=gray2;
  end else if(active)begin
   tick<=tick+1'b1;
   if(gray2!=last_gray)begin last_gray<=gray2;ref_age<=0;end
   else if(ref_age!=255)ref_age<=ref_age+1'b1;
   if(ref_age>max_ref_age)max_ref_age<=ref_age;
   if((pins2[2]||pins2[7])&&tick>8)had_reset<=1;
   if(had_reset&&tail_count<1024)tail_count<=tail_count+1'b1;
   if(observed!=previous)begin previous<=observed;records[count[8:0]]<={detail_word,state_word,tick};count<=count+1'b1;end
   if(count>=511||tick>=40078700||(had_reset&&tail_count==1024))begin active<=0;frozen<=1;end
  end
 end
 (* ASYNC_REG="TRUE" *)reg[13:0]status1=0,status2=0;
 always @(posedge sys_clk)begin status1<={had_reset,seen,count,frozen,active};status2<=status1;end
 assign status={18'd0,status2};assign event_count={22'd0,status2[11:2]};
endmodule
