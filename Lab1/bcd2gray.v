//Gate level Design Model for BCD to Gray Code Converter
module bcd2gray_gate(b, g);
	input [3:0] b;
	output [3:0] g;
	buf (g[3], b[3]);
	xor (g[2], b[3], b[2]);
	xor (g[1], b[2], b[1]);
	xor (g[0], b[1], b[0]);
endmodule


//Dataflow level Design Model for BCD to Gray Code Converter
module bcd2gray_df(b, g);
	input [3:0] b;
	output [3:0] g;
	
	assign g[3] = b[3];
	assign g[2] = b[3] ^ b[2];
	assign g[1] = b[2] ^ b[1];
	assign g[0] = b[1] ^ b[0];
endmodule


//Stimulus module for BCD to Gray Code Converter
module testbench;
	reg [3:0] b;
	wire [3:0] g;
	
	bcd2gray_df bcd_df(b, g);
	
	initial
		begin
			$monitor(,$time," b = %b, g = %b",b,g);
			#5 b=4'b0000;
			#5 b=4'b0001;
			#5 b=4'b0010;
			#5 b=4'b0011;
			#5 b=4'b0100;
			#5 b=4'b0101;
			#5 b=4'b0110;
			#5 b=4'b0111;
			#5 b=4'b1000;
			#5 b=4'b1001;
			#5 $finish;
		end
endmodule
	