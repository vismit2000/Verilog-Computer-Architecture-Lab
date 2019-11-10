module mux2to1(out,sel,in1,in2, in3);
	input in1,in2,in3;
	input [1:0] sel;
	output out;
	wire a1,a2,a3;
	wire [1:0] not_sel;
	not (not_sel[0],sel[0]);
	not (not_sel[1],sel[1]);
	and (a1,not_sel[1],not_sel[0],in1);
	and (a2,not_sel[1],sel[0],in2);
	and (a3,sel[1],not_sel[0],in3);
	or(out,a1,a2,a3);
endmodule

/*module bit8_2to1mux(out,sel,in1,in2);
	input [7:0] in1,in2;
	output [7:0] out;
	input sel;
	mux2to1 m0(out[0],sel,in1[0],in2[0]);
	mux2to1 m1(out[1],sel,in1[1],in2[1]);
	mux2to1 m2(out[2],sel,in1[2],in2[2]);
	mux2to1 m3(out[3],sel,in1[3],in2[3]);
	mux2to1 m4(out[4],sel,in1[4],in2[4]);
	mux2to1 m5(out[5],sel,in1[5],in2[5]);
	mux2to1 m6(out[6],sel,in1[6],in2[6]);
	mux2to1 m7(out[7],sel,in1[7],in2[7]);
endmodule
*/

module bit8_2to1mux(out,sel,in1,in2,in3);
	input [7:0] in1,in2,in3;
	output [7:0] out;
	input [1:0] sel;
	genvar j;     //this is the variable that is be used in the generate block
 
	generate for (j = 0; j < 8; j = j + 1) 
		begin: mux_loop                                    //mux_loop is the name of the loop
			mux2to1 m1(out[j],sel,in1[j],in2[j],in3[j]);          //mux2to1 is instantiated every time it is called
		end
	endgenerate
	
endmodule

module MUX_32_bit_3_ip(out,sel,in1,in2,in3);
	input [31:0] in1,in2,in3;
	output [31:0] out;
	input [1:0] sel;
	genvar j;     //this is the variable that is be used in the generate block
 
	generate for (j = 0; j < 4; j = j + 1) 
		begin: mux_loop                                   							                   //mux_loop is the name of the loop
			bit8_2to1mux m1(out[8*j+7:8*j],sel,in1[8*j+7:8*j],in2[8*j+7:8*j],in3[8*j+7:8*j]);          //mux2to1 is instantiated every time it is called
		end
	endgenerate
	
endmodule
/*
module tb_32bit2to1mux;
	reg [31:0] INP1, INP2, INP3;
	reg [1:0] SEL;
	wire [31:0] out;
	MUX_32_bit_3_ip M1(out,SEL,INP1,INP2, INP3);
	initial
	begin
		$monitor("INP1=%b, INP2=%b, INP3=%b, SEL=%b, out=%b", INP1, INP2, INP3, SEL, out);
		INP1=32'b10101010101010101010101010101010;
		INP2=32'b01010101010101010101010101010101;
		INP3=32'b11111111111111111111111111111111;
		SEL=2'b00;
		#100 SEL=2'b01;
		#100 SEL=2'b10;
		//#100 SEL=2'b11;
		#1000 $finish;
	end
endmodule
*/