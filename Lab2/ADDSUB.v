module FULLADDER(sum, cout, a, b, cin);
	output sum, cout;
	input a, b, cin;
	reg sum, cout;
	
	always@(a or b or cin)
		{cout, sum} = a + b + cin;
		
endmodule

/*module FULLADDER(sum, cout, a, b, cin);
	output sum, cout;
	input a, b, cin;
	reg sum, cout;
	
	always @(a or b or cin)
		if(a == 0 && b == 0 && cin == 0)
		begin
			sum = 0;
			cout = 0;
		end
		
		else if(a == 0 && b == 0 && cin == 1)
		begin
			sum = 1;
			cout = 0;
		end
		
		else if(a == 0 && b == 1 && cin == 0)
		begin
			sum = 1;
			cout = 0;
		end
		
		else if(a == 0 && b == 1 && cin == 1)
		begin
			sum = 0;
			cout = 1;
		end
		
		else if(a == 1 && b == 0 && cin == 0)
		begin
			sum = 1;
			cout = 0;
		end
		
		else if(a == 1 && b == 0 && cin == 1)
		begin
			sum = 0;
			cout = 1;
		end
		
		else if(a == 1 && b == 1 && cin == 0)
		begin
			sum = 0;
			cout = 1;
		end
		
		else if(a == 1 && b == 1 && cin == 1)
		begin
			sum = 1;
			cout = 1;
		end
endmodule
*/

module ADDSUB(sum, V, A, B, M);
	output [3:0] sum;
	output V;
	input [3:0] A, B;
	input M;
	
	wire [3:0] b;
	wire c1, c2, c3, c4;
	
	xor(b[0], B[0], M);
	xor(b[1], B[1], M);
	xor(b[2], B[2], M);
	xor(b[3], B[3], M);
	
	FULLADDER f0(sum[0], c1, A[0], b[0], M);
	FULLADDER f1(sum[1], c2, A[1], b[1], c1);
	FULLADDER f2(sum[2], c3, A[2], b[2], c2);
	FULLADDER f3(sum[3], c4, A[3], b[3], c3);
	
	xor(V, c4, c3);
endmodule

module testbench;
	wire [3:0] sum;
	wire V;
	reg [3:0] A, B;
	reg M;
	
	ADDSUB AS(sum, V, A, B, M);
	
	initial
	begin
		$monitor(,$time," A=%b, B=%b M=%b, sum=%b, Overflow=%b",A, B, M, sum, V);
		#5 A=4'b0000; B=4'b0000; M = 1'b0;
		#5 A=4'b0001; B=4'b0010; M = 1'b0;
		#5 A=4'b0010; B=4'b0100; M = 1'b0;
		#5 A=4'b0011; B=4'b1000; M = 1'b0;
		#5 A=4'b0100; B=4'b1010; M = 1'b0;
		#5 A=4'b0101; B=4'b0010; M = 1'b0;
		#5 A=4'b0110; B=4'b0100; M = 1'b1;
		#5 A=4'b0111; B=4'b1000; M = 1'b1;
		#5 A=4'b1000; B=4'b1111; M = 1'b1;
		#5 A=4'b1001; B=4'b1000; M = 1'b1;
		#5 $finish;
	end
endmodule