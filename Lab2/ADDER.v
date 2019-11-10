module DECODER(d0,d1,d2,d3,d4,d5,d6,d7,x,y,z);
	input x,y,z;
	output d0,d1,d2,d3,d4,d5,d6,d7;
	wire x0,y0,z0;
	not n1(x0,x);
	not n2(y0,y);
	not n3(z0,z);
	and a0(d0,x0,y0,z0);
	and a1(d1,x0,y0,z);
	and a2(d2,x0,y,z0);
	and a3(d3,x0,y,z);
	and a4(d4,x,y0,z0);
	and a5(d5,x,y0,z);
	and a6(d6,x,y,z0);
	and a7(d7,x,y,z);
endmodule

module FADDER(s,c,x,y,z);
	input x,y,z;
	wire d0,d1,d2,d3,d4,d5,d6,d7;
	output s,c;
	DECODER dec(d0,d1,d2,d3,d4,d5,d6,d7,x,y,z);
	assign s = d1 | d2 | d4 | d7,
	 c = d3 | d5 | d6 | d7;
endmodule

module FADDER8BIT(s,c,x,y,z);
	input [7:0] x,y;
	input z;
	output [7:0] s;
	output c;
	wire c1, c2, c3, c4, c5, c6, c7;
	
	FADDER f0(s[0], c1, x[0], y[0], z);
	FADDER f1(s[1], c2, x[1], y[1], c1);
	FADDER f2(s[2], c3, x[2], y[2], c2);
	FADDER f3(s[3], c4, x[3], y[3], c3);
	FADDER f4(s[4], c5, x[4], y[4], c4);
	FADDER f5(s[5], c6, x[5], y[5], c5);
	FADDER f6(s[6], c7, x[6], y[6], c6);
	FADDER f7(s[7], c, x[7], y[7], c7);

endmodule
	
module FADDER32BIT(s,c,x,y,z);
	input [31:0] x,y;
	input z;
	output [31:0] s;
	output c;
	wire c1, c2, c3;
	
	FADDER8BIT f0(s[7:0], c1, x[7:0], y[7:0], z);
	FADDER8BIT f1(s[15:8], c2, x[15:8], y[15:8], c1);
	FADDER8BIT f2(s[23:16], c3, x[23:16], y[23:16], c2);
	FADDER8BIT f3(s[31: 24], c, x[31: 24], y[31: 24], c3);
	
endmodule

module testbench;
	 reg [31:0] x,y;
	 reg z;
	 wire [31:0] s;
	 wire c;
	 
	 FADDER32BIT fl(s,c,x,y,z);
	 initial
	 $monitor("x=%b,y=%b,z=%b,s=%b,c=%b",x,y,z,s,c);
	 initial
	 begin
	 #0 x=32'b00000000000000000000000000000000;y=32'b00000000000000000000000000000000;z=1'b0;
	 #4 x=32'b11111111111111111111111111111111;y=32'b11111111111111111111111111111111;z=1'b0;
	 #4 x=32'b11111111111111111111111111111111;y=32'b11111111111111111111111111111111;z=1'b1;
	
	 end
endmodule