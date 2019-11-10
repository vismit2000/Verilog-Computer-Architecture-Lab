module ENCODER(opcode, funcCode);
    input[7:0] funcCode;
    output[2:0] opcode;
    reg[2:0] opcode;

    always @(funcCode)
        begin
          if(funcCode[7])
            opcode = 3'b111;
          else if(funcCode[6])
            opcode = 3'b110;
          else if(funcCode[5])
            opcode = 3'b101;
          else if(funcCode[4])
            opcode = 3'b100;
          else if(funcCode[3])
            opcode = 3'b011;
          else if(funcCode[2])
            opcode = 3'b010;
          else if(funcCode[1])
            opcode = 3'b001;
          else if(funcCode[0])
            opcode = 3'b000;
        end
endmodule

module ALU(cout, X, A, B, opcode);
    input[3:0] A, B;
    input[2:0] opcode;
    output[3:0] X;
    output cout;
    reg[3:0] X;
    reg cout;

    always @(opcode or A or B)
    begin
        if(opcode == 3'b000)
            {cout, X} = A + B;
        else if(opcode == 3'b001)
            {cout, X} = A - B;
        else if(opcode == 3'b010)
            {cout, X} = A ^ B;
        else if(opcode == 3'b011)
            {cout, X} = A | B;
        else if(opcode == 3'b100)
            {cout, X} = A & B;
        else if(opcode == 3'b101)
            {cout, X} = A ~| B;
        else if(opcode == 3'b110)
            {cout, X} = A ~& B;
        else if(opcode == 3'b111)
            {cout, X} = A ~^ B;
    end
endmodule

module EvenParityGenerator(out, X);
    output out;
    input[3:0] X;

    assign out = X[0] ^ X[1] ^ X[2] ^ X[3];
endmodule

module Pipeline_First(opcode, A, B, clk, AOUT, BOUT, OPOUT);
    input[3:0] A, B;
    input[2:0] opcode;
    input clk;
    output[3:0] AOUT, BOUT;
    output[2:0] OPOUT;

    reg[3:0] AOUT, BOUT;
    reg[2:0] OPOUT;

    always @(posedge clk)
    begin
      OPOUT <= opcode;
      AOUT <= A;
      BOUT <= B;
    end
endmodule

module Pipeline_Second(clock, X, XOUT);
  input clock;
  input [3:0] X;
  output  [3:0] XOUT;
  reg [3:0] XOUT;
  always  @ (posedge clock) 
    begin
      XOUT <= X;
    end
endmodule

module PipelineDesign(clock, funcCode, A, B, out);
  input clock;
  input [7:0] funcCode;
  input [3:0] A, B;
  output out;
  wire [2:0] opcode, OPOUT;
  wire [3:0] AOUT, BOUT, X, XOUT;
  wire cout;
  ENCODER enc(opcode, funcCode);
  Pipeline_First ppf(opcode, A, B, clock, AOUT, BOUT, OPOUT);
  ALU alu(cout, X, A, B, opcode);
  Pipeline_Second pps(clock, X, XOUT);
  EvenParityGenerator epg(out, XOUT);
endmodule

module tb_Pipeline_Design;
  reg clock;
  reg [7:0] funcCode;
  reg [3:0] A, B;
  wire out;

  PipelineDesign PIPELINE(clock, funcCode, A, B, out);

  always
    #2  clock = ~clock;

  initial begin
    $monitor($time, " A = %b, B = %b, Function Code = %b, OpCode = %b, AOut = %b, BOut = %b, OpOut = %b, X = %b, Carry = %b, XOut = %b, Output = %b.", A, B, funcCode, PIPELINE.opcode, PIPELINE.AOUT, PIPELINE.BOUT, PIPELINE.OPOUT, PIPELINE.X, PIPELINE.cout, PIPELINE.XOUT, out);
    #0  clock = 1'b1;
    #4  A = 4'b0101; B = 4'b1110;  funcCode = 8'b10000000;
    #20 funcCode = 8'b01000000;
    #20 funcCode = 8'b00100000;
    #20 funcCode = 8'b00010000;
    #20 funcCode = 8'b00001000;
    #20 funcCode = 8'b00000100;
    #20 funcCode = 8'b00000010;
    #20 funcCode = 8'b00000001;
    #50 $finish;
  end

endmodule