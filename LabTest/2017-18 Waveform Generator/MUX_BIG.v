`include "MUX_SMALL.v"
module MUX_BIG(sel, in, out);
    input[2:0] sel;
    input[7:0] in;
    output out;

    wire[5:0] w;

    MUX_SMALL m0(sel[0], in[1:0], w[0]);
    MUX_SMALL m1(sel[0], in[3:2], w[1]);
    MUX_SMALL m2(sel[0], in[5:4], w[2]);
    MUX_SMALL m3(sel[0], in[7:6], w[3]);

    MUX_SMALL m4(sel[1], w[1:0], w[4]);
    MUX_SMALL m5(sel[1], w[3:2], w[5]);

    MUX_SMALL m6(sel[2], w[5:4], out);
endmodule
/*
module tb_MUX_BIG;
    reg[2:0] sel;
    reg [7:0] in;
    wire out;

    MUX_BIG MB(sel, in, out);

    initial
        begin
          $monitor($time, " Sel = %b, Input = %b, Out = %b", sel, in, out);
          #0 in = 8'b10111000;
          #5 sel = 3'b000;
          #5 sel = 3'b001;
          #5 sel = 3'b010;
          #5 sel = 3'b011;
          #5 sel = 3'b100;
          #5 sel = 3'b101;
          #5 sel = 3'b110;
          #5 sel = 3'b111;
          #5 $finish;
        end
endmodule
*/