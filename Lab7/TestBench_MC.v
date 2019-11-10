`include "MultiCycle_Control.v"

module TestBench_MC;
    reg [5:0] opcode;
	reg [3:0] state;
	wire PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemToReg, PCSource1, PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0, ALUSrcA, RegWrite, RegDst;
	wire [3:0] NS;

    MultiCycle_Control MC(opcode, state, PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemToReg, PCSource1, PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0, ALUSrcA, RegWrite, RegDst, NS);

    initial begin
        $monitor("opcode: %b ",opcode,"state: %b ",state," PCWrite: %b ", PCWrite ,"PCWriteCond : %b ", PCWriteCond,"IorD: %b ", IorD," MemRead: %b ", MemRead," MemWrite: %b ", MemWrite," IRWrite: %b ", IRWrite," MemToReg: %b ", MemToReg," PCSource1: %b ", PCSource1," PCSource0: %b ", PCSource0," ALUOp1: %b ", ALUOp1," ALUOp0: %b", ALUOp0, " ALUSrcB1: %b ", ALUSrcB1," ALUSrcB0 : %b ", ALUSrcB0," ALUSrcA: %b ", ALUSrcA," RegWrite: %b ", RegWrite," RegDst: %b ", RegDst," NS: %b", NS );
        state = 4'b0000;
		#5 state = 4'b0001;
		#10 opcode = 6'b100011;  //6'h23;
		#15 state = 4'b0010;
        #20 state = 4'b0011;
        #25 state = 4'b0100;
        #30 $finish;
    end
endmodule