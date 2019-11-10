`include "TFF.v"
module COUNTER_3BIT(clear, clock, q);
    input clear, clock;
    output[2:0] q;

    reg [2:0]q;

    initial 
        q = 3'b0;

    wire in1, in3;
    wire [2:0] out;
    assign in1 = 1'b1;
    and( in3, out[1], out[0]);
    
    TFF ff1(out[0], in1, clock, clear);
    TFF ff2(out[1], out[0], clock, clear);
    TFF ff3(out[2], in3, clock, clear);

    always @(posedge clock or clear) 
      begin
        if(clear)
            q <= 3'b0;
        else
            q <= out;
    end
endmodule