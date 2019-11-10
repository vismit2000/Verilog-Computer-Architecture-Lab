`include "AND_32_Bit.v"
`include "OR_32_Bit.v"
`include "FADDER32BIT.v"
`include "MUX_32_bit_2_ip.v"
`include "MUX_32_bit_3_ip.v"

module ALU_32_bit (a,b,Binvert,Carryin,Operation,Result,CarryOut);
	input Binvert, Carryin;
	input [1:0] Operation;
	input [31:0] a,b;
	output [31:0] Result;
	output CarryOut;
	
	wire [31:0] out, notB, in0, in1, in2;
	assign {notB} = ~b;
	
	AND_32_Bit AND(in0, a, b);
	OR_32_Bit OR(in1, a, b);
	MUX_32_bit_2_ip ADDORSUB(out, Binvert, b, notB);
	FADDER32BIT FA(in2, CarryOut, a, out, Carryin);
	
	MUX_32_bit_3_ip FINAL(Result, Operation, in0, in1, in2);
endmodule

module tbALU;
	reg Binvert, Carryin;
	reg [1:0] Operation;
	reg [31:0] a,b;
	wire [31:0] Result;
	wire CarryOut;
	ALU_32_bit ALU(a,b,Binvert,Carryin,Operation,Result,CarryOut);
	initial
	begin
	$monitor($time, " :A = %b,\n\t B = %b,\n\t Operation = %b,\n\t BInvert = %b,\n\t Result = %b,\n\t Carry Out = %b.", a, b, Operation, Binvert, Result, CarryOut);
	a=32'ha5a5a5a5;
	b=32'h5a5a5a5a;
	Operation=2'b00;
	Binvert=1'b0;
	Carryin=1'b0; //must perform AND resulting in zero
	#100 Operation=2'b01; //OR
	#100 Operation=2'b10; //ADD
	#100 Binvert=1'b1;//SUB
	#200 $finish;
	end
endmodule