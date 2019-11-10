module ALUControlUnit (Operation, ALUOp1, ALUOp0, Funct);
	input [5:0] Funct;
	input ALUOp0, ALUOp1;
	output [2:0] Operation;
	
	assign Operation[2] = ALUOp0 | (Funct[1] & ALUOp1);
	assign Operation[1] = (~ALUOp1) | (~Funct[2]);
	assign Operation[0] = ALUOp1 & (Funct[0] | Funct[3]);
	
endmodule

module ALUControlTB;
  reg [5:0] Funct;
  reg ALUOp0, ALUOp1;
  wire [2:0] Operation;
  
  ALUControlUnit ACU(Operation, ALUOp1, ALUOp0, Funct);
  initial begin
    $monitor($time, " ALUOp1 = %b, ALUOp0 = %b, Function Field = %b, Operation = %b.", ALUOp1, ALUOp0, Funct, Operation);
    #0  ALUOp1 = 1'b0;  ALUOp0 = 1'b0; Funct = 6'b000000;
    #10 ALUOp1 = 1'b0;  ALUOp0 = 1'b1; Funct = 6'b000000;
    #10 ALUOp1 = 1'b1;  ALUOp0 = 1'b0; Funct = 6'b000000;
    #10 ALUOp1 = 1'b1;  ALUOp0 = 1'b0; Funct = 6'b000010;
    #10 ALUOp1 = 1'b1;  ALUOp0 = 1'b0; Funct = 6'b000100;
    #10 ALUOp1 = 1'b1;  ALUOp0 = 1'b0; Funct = 6'b000101;
    #10 ALUOp1 = 1'b1;  ALUOp0 = 1'b0; Funct = 6'b001010;
    #10 $finish;
  end
endmodule