//Gate level Design Model for BCD to Gray Code Converter
module magComp_gate(ALTB, AGTB, AEQB, A, B);
  input [3:0] A, B;
  output ALTB, AGTB, AEQB;
  wire [3:0]X, Y, Z, NotA, NotB;
  
  xnor 
      g01(X[3], A[3], B[3]),
      g02(X[2], A[2], B[2]),
      g03(X[1], A[1], B[1]),
      g04(X[0], A[0], B[0]);
  not 
      g05(NotA[3], A[3]),
      g06(NotA[2], A[2]),
      g07(NotA[1], A[1]),
      g08(NotA[0], A[0]),
      g09(NotB[3], B[3]),
      g10(NotB[2], B[2]),
      g11(NotB[1], B[1]),
      g12(NotB[0], B[0]);
  and
      g13(Y[0], A[3], NotB[3]),
      g14(Y[1], X[3], A[2], NotB[2]),
      g15(Y[2], X[3], X[2], A[1], NotB[1]),
      g16(Y[3], X[3], X[2], X[1], A[0], NotB[0]);
  and
      g17(Z[0], NotA[3], B[3]),
      g18(Z[1], X[3], NotA[2], B[2]),
      g19(Z[2], X[3], X[2], NotA[1], B[1]),
      g20(Z[3], X[3], X[2], X[1], NotA[0], B[0]);
      
  and g21(AEQB, X[3], X[2], X[1], X[0]);
  or  
      g22(ALTB, Z[0], Z[1], Z[2], Z[3]),
      g23(AGTB, Y[0], Y[1], Y[2], Y[3]);
endmodule


//Dataflow level Design Model for BCD to Gray Code Converter
module mag4comp_df(a, b, lt, gt, eq);
	input [3:0] a, b;
	output gt, lt, eq;
	wire x0, x1, x2, x3;
	
	assign x0 = a[0] ~^ b[0];
	assign x1 = a[1] ~^ b[1];
	assign x2 = a[2] ~^ b[2];
	assign x3 = a[3] ~^ b[3];
	
	assign lt = (~a[3] & b[3]) || (x3 & ~a[2] & b[2]) || (x3 & x2 & ~a[1] & b[1]) || (x3 & x2 & x1 & ~a[0] & b[0]);
	assign gt = (a[3] & ~b[3]) || (x3 & a[2] & ~b[2]) || (x3 & x2 & a[1] & ~b[1]) || (x3 & x2 & x1 & a[0] & ~b[0]);
	assign eq = x3 & x2 & x1 & x0;
	
endmodule


//Behavioural Design Model for BCD to Gray Code Converter
module mag4comp_beh(a, b);
	input [3:0] a, b;
	reg x0, x1, x2, x3;
	
	always@(a or b)
	begin
		x0 = a[0] ~^ b[0];
		x1 = a[1] ~^ b[1];
		x2 = a[2] ~^ b[2];
		x3 = a[3] ~^ b[3];
		
		if((~a[3] & b[3]) || (x3 & ~a[2] & b[2]) || (x3 & x2 & ~a[1] & b[1]) || (x3 & x2 & x1 & ~a[0] & b[0]))
			$display("At %0d, A < B", $time);
		else if((a[3] & ~b[3]) || (x3 & a[2] & ~b[2]) || (x3 & x2 & a[1] & ~b[1]) || (x3 & x2 & x1 & a[0] & ~b[0]))
			$display("At %0d, A > B", $time);
		else if(x3 & x2 & x1 & x0)
			$display("At %0d, A = B", $time);
	end
endmodule



//Stimulus module for BCD to Gray Code Converter
module testbench;
	reg [3:0] a, b;
	wire lt, gt, eq;
	
	mag4comp_df mag4comp(a, b, lt, gt, eq);
	
	initial
		begin
			$monitor(,$time," a = %4b, b = %4b, LT = %1b, GT = %1b, EQ = %1b", a, b, lt, gt, eq);
			#5 a=4'b0000; b=4'b0000;
			#5 a=4'b0001; b=4'b0010;
			#5 a=4'b0010; b=4'b0100;
			#5 a=4'b0011; b=4'b1000;
			#5 a=4'b0100; b=4'b1010;
			#5 a=4'b0101; b=4'b0010;
			#5 a=4'b0110; b=4'b0100;
			#5 a=4'b0111; b=4'b1000;
			#5 a=4'b1000; b=4'b1111;
			#5 a=4'b1001; b=4'b1000;
			#5 $finish;
		end
endmodule
	
