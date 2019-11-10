`include "TFF.v"
module COUNTER_4BIT(clear, clock, q);
    input clear, clock;
    output[3:0] q;

    reg [3:0]q;

    initial 
        q = 4'b0;

    wire in1, in3, in4;
    wire [3:0] out;
    assign in1 = 1'b1;
    and( in3, out[1], out[0]);
    and( in4, out[2], in3);
    
    TFF ff1(out[0], in1, clock, clear);
    TFF ff2(out[1], out[0], clock, clear);
    TFF ff3(out[2], in3, clock, clear);
    TFF ff4(out[3], in4, clock, clear);

    always @(posedge clock or clear) 
      begin
        if(clear)
            q = 4'b0;
        else
            q = out;
    end
endmodule