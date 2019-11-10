module OR_32_Bit (out,in1,in2);
	input [31:0] in1,in2;
	output [31:0] out;
	assign {out}=in1 | in2;
endmodule

/*
module tb32bitor;
	reg [31:0] IN1,IN2;
	wire [31:0] OUT;
	
	OR_32_Bit a1 (OUT,IN1,IN2);
	
	initial
	begin
		$monitor("IN1=%b, IN2=%b, OUT=%b", IN1, IN2, OUT);
		IN1=32'hA5A5;
		IN2=32'h5A5A;
		#100 IN1=32'h5A5A;
		#400 $finish;
	end
endmodule
*/