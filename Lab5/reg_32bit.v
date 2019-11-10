module d_ff(q, d, clk, reset);
    input d, clk, reset;
    output q;

    reg q;

    always @(posedge clk)
    begin
      if(!reset)
        q <= 1'b0;
      else
        q <= d;
    end
endmodule

module reg_32bit(q, d, clk, reset);
    input[31:0] d;
    input clk, reset;
    output[31:0] q;

    genvar i;
    
    generate for(i = 0; i < 32; i = i+1)
        begin: FF
        d_ff DFF(q[i], d[i], clk, reset);
        end
    endgenerate
endmodule

// module tb_reg_32bit();
//     wire [31:0] q;
//     reg [31:0] d;
//     reg clk, reset;

//     reg_32bit register( q, d, clk, reset);

//     always @(clk)
//         #5 clk <= ~clk;
    
//     initial
//         $monitor($time, " clk: ",clk," Reset = ", reset, " D = %b ", d, "Q = %b ",q);

//     initial begin
//         clk = 1'b1;
//         reset = 1'b0;
//         #20 reset = 1'b1;
//         #20 d = 32'hAFAFAFAF;
//         #200 $finish;
//     end

// endmodule

module mux4_1(regData, q1, q2, q3, q4, reg_no);
    input[31:0] q1, q2, q3, q4;
    input[1:0] reg_no;
    output[31:0] regData;
    reg[31:0] regData;

    always @(reg_no)
        begin
          case(reg_no)
            2'b00: assign regData = q1;
            2'b01: assign regData = q2;
            2'b10: assign regData = q3;
            2'b11: assign regData = q4;
          endcase
        end
endmodule

module decoder2_4 (register,reg_no);
    input[1:0] reg_no;
    output[3:0] register;
    reg[3:0] register;

    always @(reg_no)
        begin
          case(reg_no)
            2'b00: assign register = 4'b0001;
            2'b01: assign register = 4'b0010;
            2'b10: assign register = 4'b0100;
            2'b11: assign register = 4'b1000;
          endcase
        end
endmodule

module RegFile(clk,reset,readReg1,readReg2,writeData,writeReg,regWrite,readData1,readData2);
    input clk, reset, regWrite;
    input [1:0] readReg1, readReg2, writeReg;
    input [31:0] writeData;
    output [31:0] readData1, readData2;

    wire [3:0][31:0] regOut;
    reg [31:0] regIn;
    wire [3:0] decoderOut;
    wire [3:0] regClk;

    genvar j;

    assign regClk[0] = (clk & regWrite & decoderOut[0]);
    assign regClk[1] = (clk & regWrite & decoderOut[1]);
    assign regClk[2] = (clk & regWrite & decoderOut[2]);
    assign regClk[3] = (clk & regWrite & decoderOut[3]);

    reg_32bit r0( regOut[0], regIn, regClk[0], reset );
    reg_32bit r1( regOut[1], regIn, regClk[1], reset );
    reg_32bit r2( regOut[2], regIn, regClk[2], reset );
    reg_32bit r3( regOut[3], regIn, regClk[3], reset );

    mux4_1 m1( readData1, regOut[0] , regOut[1] , regOut[2], regOut[3], readReg1 );
    mux4_1 m2( readData2, regOut[0] , regOut[1] , regOut[2] , regOut[3], readReg2 );

    decoder2_4 dec1( decoderOut, writeReg );
endmodule

module tbRegFile4;
  reg Clock, Reset, RegWrite;
  reg [1:0] ReadReg1, ReadReg2, WriteRegNo;
  reg [31:0] WriteData;
  wire[31:0] ReadData1, ReadData2;
  
  RegFile rgf(Clock, Reset, ReadReg1, ReadReg2, WriteData, WriteRegNo, RegWrite, ReadData1, ReadData2);
  
  initial begin
    $monitor($time, ": Reset = %b, RegWrite = %b, ReadReg1 = %b, ReadReg2 = %b, WriteRegNo = %b, WriteData = %b, ReadData1 = %b, ReadData2 = %b.", Reset, RegWrite, ReadReg1, ReadReg2, WriteRegNo, WriteData, ReadData1, ReadData2);
    #0  Clock = 1'b1; ReadReg1 = 2'b00; ReadReg2 = 2'b01; Reset = 1'b1;
    #2  Reset = 1'b0;
    #10 Reset = 1'b1; RegWrite = 1'b1;  WriteData = 32'hF0F0F0F0; WriteRegNo = 2'b00;
    #10 RegWrite = 1'b1;  WriteData = 32'hF8F8F8F8; WriteRegNo = 2'b01;
    #10 RegWrite = 1'b1;  WriteData = 32'hFAFAFAFA; WriteRegNo = 2'b10;
    #10 RegWrite = 1'b1;  WriteData = 32'hFFFFFFFF; WriteRegNo = 2'b11;
    #10 RegWrite = 1'b0;
    #10 ReadReg1 = 2'b00; ReadReg2 = 2'b01;
    #10 ReadReg1 = 2'b10; ReadReg2 = 2'b11;
    #10 $finish;
  end
  always
    #5  Clock = ~Clock;
endmodule