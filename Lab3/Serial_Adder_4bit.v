`timescale 1s / 1ns
module ShiftReg(in, en, clock, q);
  parameter n = 4;
  input in, en, clock;
  output[n-1:0] q;
  reg [n-1:0]q;
  initial
    q = 4'd10;
  always @ (posedge clock)
    begin
      if(en)
        q = {in, q[n-1:1]};
    end
endmodule

module DFlipFlop_Async_Clear(d, not_clear, clock, q);
  input d, not_clear, clock;
  output  q;
  reg q;
  always @ (negedge not_clear or posedge clock)
    begin
      if(!not_clear)
        q <= 1'b0;
      else
        q <= d;
    end
endmodule

module FADDER_1bit (Cout, Sum, In1, In2, Cin);
    input In1, In2, Cin;
    output Cout;
    output Sum;
    assign {Cout,Sum} = In1+In2+Cin;
endmodule

module Serial_Adder_4bit(SO1, sum, SI, shiftCtrl, clear, clock);
    initial
    begin
      $dumpfile("Serial_Adder_4bit.vcd");
      $dumpvars;
    end

    output[3:0] SO1;
    output sum;
    input SI, shiftCtrl, clear, clock;

    wire cout, q, sum;
    wire[3:0] SO1, SO2;

    ShiftReg SR1(sum, shiftCtrl, clock, SO1);
    ShiftReg SR2(SI, shiftCtrl, clock, SO2);

    FADDER_1bit FA(cout, sum, SO1[0], SO2[0], q);
    DFlipFlop_Async_Clear DFF(cout, clear, clock & shiftCtrl, q);

endmodule

module tb_Serial_Adder;
    reg SI, shiftCtrl, clear, clock;
    wire[3:0] a;
    wire sum;

    reg[0:3] b;

    integer i;

    Serial_Adder_4bit SA(a, sum, SI, shiftCtrl, clear, clock);

    always @(posedge clock)
        $display($time, " ShftCtrl = %b ", shiftCtrl, " SI = %b ", SI," sum:= ",sum ," Acc = %b ", a, "Clk: = ",clock," dff_out = %b ", SA.DFF.q);

    initial
        begin
          shiftCtrl = 1'b1;
          clock = 1'b0;
          clear = 1'b0;
          #2 clear = 1'b1;
          
        //   a = 4'b0111;
          b = 4'b0110;

          for(i = 0; i < 4; i++)
          begin
            SI = b[i];
            #2 clock = 1'b1;
            #2 clock = 1'b0;
          end
        end

endmodule