// USER1: DR read, LSB first. USER2: write reset-toggle bit0/freeze bit1.
// Read USER1 only after freeze ack. The top-level adds live pins separately.
module jtag_report (
    input wire tck, reset, capture1, shift1, sel1,
    input wire update2, sel2, shift2, tdi,
    input wire [1759:0] report,
    output wire tdo1,
    output reg reset_toggle = 0,
    output reg freeze_request = 0
);
    reg [1759:0] shift_reg = 0;
    reg [1:0] command = 0;
    always @(posedge tck) begin
        if (reset) begin command <= 0; end
        else begin
            if (sel1 && capture1) shift_reg <= report;
            else if (sel1 && shift1) shift_reg <= {tdi,shift_reg[1759:1]};
            if (sel2 && shift2) command <= {tdi,command[1]};
        end
    end
    // UPDATE changes on TCK falling edge; command is stable by then.
    always @(negedge tck)
        if (sel2 && update2) begin
            reset_toggle <= command[0]; freeze_request <= command[1];
        end
    assign tdo1 = shift_reg[0];
endmodule
