// Functional activity monitor, not an ADC timing/accuracy validator.
module link_monitor (
    input wire clk,
    input wire reset_toggle,
    input wire freeze_request,
    input wire [167:0] pins,
    output reg frozen = 0,
    output wire [1567:0] report
);
    (* ASYNC_REG = "TRUE" *) reg [167:0] meta = 0, sampled = 0;
    (* ASYNC_REG = "TRUE" *) reg [1:0] freeze_sync = 0, reset_sync = 0;
    reg reset_seen = 0;
    reg [167:0] previous = 0, seen_high = 0, seen_low = 0, changed = 0;
    reg [31:0] cycles = 0;
    reg [31:0] strobes [0:11];
    reg [12:0] last_data [0:11];
    integer i;
    initial for (i=0; i<12; i=i+1) begin strobes[i]=0; last_data[i]=0; end
    // Channel c: data [14*c +:13], strobe [14*c+13].
    always @(posedge clk) begin
        meta <= pins; sampled <= meta;
        freeze_sync <= {freeze_sync[0], freeze_request};
        reset_sync <= {reset_sync[0], reset_toggle};
        frozen <= freeze_sync[1];
        if (reset_sync[1] != reset_seen) begin
            reset_seen <= reset_sync[1];
            cycles <= 0; seen_high <= 0; seen_low <= 0; changed <= 0;
            previous <= sampled;
            for (i=0; i<12; i=i+1) begin strobes[i]<=0; last_data[i]<=0; end
        end else if (!freeze_sync[1]) begin
            cycles <= cycles + 1;
            seen_high <= seen_high | sampled;
            seen_low <= seen_low | ~sampled;
            changed <= changed | (previous ^ sampled);
            previous <= sampled;
            for (i=0; i<12; i=i+1)
                if (sampled[14*i+13] && !previous[14*i+13]) begin
                    strobes[i] <= strobes[i] + 1;
                    last_data[i] <= sampled[14*i +:13];
                end
        end
    end
    assign report[31:0] = 32'h504d1201;
    assign report[63:32] = cycles;
    assign report[231:64] = sampled;
    assign report[399:232] = seen_high;
    assign report[567:400] = seen_low;
    assign report[735:568] = changed;
    genvar c;
    generate for(c=0;c<12;c=c+1) begin
        assign report[736+32*c +:32] = strobes[c];
        assign report[1120+32*c +:32] = {19'b0,last_data[c]};
    end endgenerate
    assign report[1567:1504] = {63'b0,frozen};
endmodule
