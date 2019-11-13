module BHT(out, address, in, wr, clk, rst);
	input [9:0] address;
	input [1:0] in;
	input wr, clk, rst;
	output reg [1:0] out;

	reg [1:0] data[1023:0];

	integer i;
	initial
	begin
		for(i = 0; i < 1024; i = i + 1)
			data[i] <= 2'b00;
	end

	always @(posedge clk) begin
		if (!rst) begin
			for(i = 0; i < 1024; i = i + 1)
				data[i] <= 2'b00;
		end
		else if(wr) begin
			data[address] <= in;
		end
		else begin
			out <= data[address];
		end
	end
endmodule

module MUX1(out, in1, in2, s);
	input [1:0] in1, in2;
	input s;
	output [1:0] out;

	assign out = s?in2:in1;
endmodule

module PREDICTOR(n, x, clk);
	input x, clk;
	output reg [1:0] n;

	reg [1:0] state;


	always@(posedge clk) 
	begin
		n <= state;
		case(state)
		2'b00: begin
			if (x) state <= 2'b01;
		end

		2'b01: begin
			if (x) state <= 2'b11;
			else state <= 2'b00;
		end

		2'b10: begin
			if (x) state <= 2'b11;
			else state <= 2'b00;
		end

		2'b1: begin
			if (!x) state <= 2'b10;
		end
		endcase
	end
endmodule

module INTG(z, address, x, clk, rst);
	input [9:0] address;
	input x, clk, rst;
	output reg z;

	reg s;
	wire [1:0] n;
	wire [1:0] pred, pred1, pred2;

	MUX1 m1(pred, pred1, pred2, s);
	PREDICTOR p1(n, x, clk);
	BHT b1(pred1, address, n, wr, clk, rst);
	BHT b2(pred2, address, n, wr, clk, rst);

	initial
	begin
		s <= 1'b0;
	end

	always@(posedge clk or negedge rst)
	begin
		if (!rst) s <= 1'b0;
		else begin
			if(n > 2'b01) z <= 1'b1;
			else z <= 1'b0;
		end
	end
endmodule


