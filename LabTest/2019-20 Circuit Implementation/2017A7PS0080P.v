// ID: 2017A7PS0080P
// Name: VISHAL MITTAL

`timescale 1ms/1ns

module MUX_2x1(sel, in1, in2, out);
	input sel, in1, in2;
	output out;
	
	assign out = (~sel & in1) | (sel & in2);
	
endmodule


module MUX_8x1(sel, in, out);
	input[2:0] sel;
	input[7:0] in;
	output out;
	
	assign out = (sel[2] ? (sel[1] ? (sel[0] ? in[7] : in[6]) : (sel[0] ? in[5] : in[4])) : (sel[1] ? (sel[0] ? in[3] : in[2]) : (sel[0] ? in[1] : in[0])));
	
endmodule 


module MUX_ARRAY(F, C, E);
	input[7:0] F, C;
	output[7:0] E;
		
	genvar j;
	
	generate for(j = 0; j < 8; j = j+1)
		begin: mux_loop
			MUX_2x1 M2(F[j], C[j], 1'b0, E[j]);
		end
	endgenerate
	
endmodule


module COUNTER_3BIT(Q, clock, clear);
	output [2:0] Q;
	input clock, clear;

	reg [2:0] Q;
	
	initial
		Q = 3'b0;
	
	always @(posedge clock or posedge clear)
		begin
			if(clear)
				Q = 3'b0;
			else
				Q = (Q + 1) % 8;
		end
		
endmodule


module DECODER(EN, A, B);
	input EN;
	input[2:0] A;
	output[7:0] B;
	
	reg[7:0] B;
	
	always @(A)
		begin
			if(EN == 0)
				B = 8'b00000000;
			else
				begin
					case(A)
						3'b000: B = 8'b00000001;
						3'b001: B = 8'b00000010;
						3'b010: B = 8'b00000100;
						3'b011: B = 8'b00001000;
						3'b100: B = 8'b00010000;
						3'b101: B = 8'b00100000;
						3'b110: B = 8'b01000000;
						3'b111: B = 8'b10000000;
					endcase
				
				end
		end
		
endmodule


module MEMORY(S, G);
	input[2:0] S;
	output[7:0] G;
	reg[7:0] mem[0:7];
	
	reg[7:0] G;
	
	//Initialize the memory
	initial
	begin
		 mem[0] = 8'b00000001;  //2'h01;
		 mem[1] = 8'b00000011;  //2'h03;
		 mem[2] = 8'b00000111;  //2'h07;
		 mem[3] = 8'b00001111;  //2'h0F;
		 mem[4] = 8'b00011111;  //2'h1F;
		 mem[5] = 8'b00111111;  //2'h3F;
		 mem[6] = 8'b01111111;  //2'h7F;
		 mem[7] = 8'b11111111;  //2'hFF;
	end
	
	always @(S)
		begin
			case(S)
				3'b000: G = mem[0];
				3'b001: G = mem[1];
				3'b010: G = mem[2];
				3'b011: G = mem[3];
				3'b100: G = mem[4];
				3'b101: G = mem[5];
				3'b110: G = mem[6];
				3'b111: G = mem[7];
			endcase
		
		end
	
endmodule


module TOP_MODULE(clock, clear, S, EN, OUT);
	input clock, clear, EN;
	input[2:0] S;
	output OUT;
	
	wire[2:0] Q;
	wire[7:0] B, G, E;
	
	MUX_8x1 M8(Q, E, OUT);
	MUX_ARRAY MA(G, B, E);
	COUNTER_3BIT CNTR3(Q, clock, clear);
	DECODER DEC(EN, Q, B);
	MEMORY MEM(S, G);
	
endmodule



module TESTBENCH;

	initial	
	begin
		$dumpfile("2017A7PS0080P.vcd");
		$dumpvars;
	end
	
	reg clock, clear, EN;
	reg[2:0] S;
	wire OUT;
	
	TOP_MODULE TM(clock, clear, S, EN, OUT);
	
	initial
		clock = 1'b0;
	
	always
		#0.5 clock <= ~clock;
	
	initial
		begin
			$monitor($time, " S = %b, Clear = %b, Output = %b", S, clear, OUT);
			clear = 1'b1;  //clear the counter
			EN = 1;
			S = 3'b000;
			#2 clear = 1'b0;  
			#8 S = 3'b001;
			#8 S = 3'b010;
			#8 S = 3'b011;
			#8 S = 3'b100;
			#8 S = 3'b101;
			#8 S = 3'b110;
			#8 S = 3'b111;
			#8 $finish;			
		end
	
endmodule

	