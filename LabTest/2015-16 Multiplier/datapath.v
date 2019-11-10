module mux_16_Entries(X, out);
    input [3:0] X;
    output [8:0] out;

    assign out = 25*X;
endmodule


module dff(q, qbar, d, clk, reset);
    input d, clk, reset;
    output q, qbar;

    reg q;
    wire qbar;
    assign qbar = ~q;
    initial 
        q <= 1'b0;

    always @(posedge clk or reset)
    begin
      if(reset)
        q <= 1'b0;
      else
        q <= d;

    //   qbar = ~q;
    end

endmodule


module ACC_RST(clk, reset, Acc_rst1, Acc_rst2);
    input clk, reset;
    output Acc_rst1, Acc_rst2;

    wire [3:0] q, qbar;

    dff DFF1(q[0], qbar[0], qbar[0], clk, reset);
    dff DFF2(q[1], qbar[1], qbar[1], q[0], reset);
    dff DFF3(q[2], qbar[2], qbar[2], q[1], reset);
    dff DFF4(q[3], qbar[3], qbar[3], q[2], reset);

    assign Acc_rst1 = q[2];
    assign Acc_rst2 = q[3];
endmodule

module Adder_Register(Acc_rst1, Acc_rst2, clk, out, Y);
    input Acc_rst1, Acc_rst2, clk;
    input[8:0] out;
    output[12:0] Y;

    reg[12:0] acc;

    initial
        acc = 13'b0;

    always @(posedge clk)
    begin
      if(Acc_rst1 == 1)
        acc = acc + {4'b0, out};
      else  
        acc = acc;
    end

    always @(posedge Acc_rst2 or negedge Acc_rst2)
    begin
      acc = 13'b0;
    end

    assign Y = acc;

endmodule


module INTG(reset, clk, X, Y);
    input reset, clk;
    input[3:0] X;

    output[12:0] Y;

    wire[8:0] out;
    wire Acc_rst1, Acc_rst2;

    mux_16_Entries mx(X, out);
    ACC_RST rst(clk, reset, Acc_rst1, Acc_rst2);
    Adder_Register ar(Acc_rst1, Acc_rst2, clk, out, Y);

endmodule

module tb_INTG;

    initial begin
        $dumpfile("datapath.vcd");
        $dumpvars;
    end

    reg reset, clk;
    reg[3:0] X;

    wire[12:0] Y;

    INTG int(reset, clk, X, Y);

    always
        #8 clk = ~clk;

    initial 
        begin
            clk = 1'b0;
            reset = 1'b1;
            X = 4'd0;
            #16  reset = 1'b0;
            #8  X = 4'd10;
            #16 X = 4'd5;
            #16 X = 4'd12;
            #16 X = 4'd1;

            #16 X = 4'd13;
            #16 X = 4'd7;
            #16 X = 4'd9;
            #16 X = 4'd2;

            #16 X = 4'd11;
            #16 X = 4'd5;
            #16 X = 4'd4;
            #16 X = 4'd2;
            #200 $finish;
        end

endmodule