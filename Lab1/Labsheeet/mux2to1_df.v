module mux2to1_df (a,b,s,f);
	input a,b,s;
	output f;
	assign f = s ? a : b;
endmodule