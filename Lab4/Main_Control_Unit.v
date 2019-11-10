module MainControlUnit (RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp2, Op);
	input [5:0] Op;
	output RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp2;
	
	wire Rformat, lw, sw, beq;
	
	assign Rformat = (~Op[0])& (~Op[1])& (~Op[2])& (~Op[3])& (~Op[4])& (~Op[5]);
	assign lw = (Op[0])& (Op[1])& (~Op[2])& (~Op[3])& (~Op[4])& (Op[5]);
	assign sw = (Op[0])& (Op[1])& (~Op[2])& (Op[3])& (~Op[4])& (Op[5]);
	assign beq = (~Op[0])& (~Op[1])& (Op[2])& (~Op[3])& (~Op[4])& (~Op[5]);
	
	assign RegDst = Rformat;
	assign ALUSrc = lw | sw;
	assign MemtoReg = lw;
	assign RegWrite = Rformat | lw;
	assign MemRead = lw;
	assign MemWrite = sw;
	assign Branch = beq;
	assign ALUOp1 = Rformat;
	assign ALUOp2 = beq;
endmodule

module MainControlTB;
  reg [5:0] Op;
  wire  RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp0, ALUOp1;
  MainControlUnit MCU(RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp0, ALUOp1, Op);
  initial begin
    $monitor($time, " Op[5] = %b, Op[4] = %b, Op[3] = %b, Op[2] = %b, Op[1] = %b, Op[0] = %b, RegDst = %b, ALUSrc = %b, MemToReg = %b, RegWrite = %b, MemRead = %b, MemWrite = %b, Branch = %b, ALUOp0 = %b, ALUOp1 = %b.", Op[5], Op[4], Op[3], Op[2], Op[1], Op[0], RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp0, ALUOp1);
    #5  Op[5] = 1'b0; Op[4] = 1'b0; Op[3] = 1'b0; Op[2] = 1'b0; Op[1] = 1'b0; Op[0] = 1'b0;
    #100  Op[5] = 1'b1; Op[4] = 1'b0; Op[3] = 1'b0; Op[2] = 1'b0; Op[1] = 1'b1; Op[0] = 1'b1;
    #100  Op[5] = 1'b1; Op[4] = 1'b0; Op[3] = 1'b1; Op[2] = 1'b0; Op[1] = 1'b1; Op[0] = 1'b1;
    #100  Op[5] = 1'b0; Op[4] = 1'b0; Op[3] = 1'b0; Op[2] = 1'b1; Op[1] = 1'b0; Op[0] = 1'b0;
    #100  $finish;
  end
endmodule