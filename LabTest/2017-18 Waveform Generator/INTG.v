`include "TFF.v"
`include "MUX_BIG.v"
`include "COUNTER_4BIT.v"
`include "COUNTER_3BIT.v"
`include "MEMORY.v"
`timescale 1ms/1ns

module INTG(clear, clk, wf);
    input clear, clk;
    output wf;

    wire clk_COUNTER4BIT;
    wire[3:0] op_COUNTER4BIT;
    wire[2:0] op_COUNTER3BIT;

    and(clk_COUNTER4BIT, op_COUNTER3BIT[0], op_COUNTER3BIT[1], op_COUNTER3BIT[2]);

    MEMORY MEM();
    COUNTER_4BIT cnt4(clear, clk_COUNTER4BIT, op_COUNTER4BIT);
    COUNTER_3BIT cnt3(clear, clk, op_COUNTER3BIT);
    MUX_BIG mb(op_COUNTER3BIT, MEM.mem[op_COUNTER4BIT], wf);
endmodule

module tb_INTG;
    initial 
        begin
            $dumpfile("tb_INTG.vcd");
            $dumpvars;
        end

    reg clear, clock;
    wire wf;

    INTG intg(clear, clock, wf);

    initial 
        clock = 1'b0;
    always
        #0.5 clock = ~clock;
    
    initial begin
            clear = 1'b1;
        #1  clear = 1'b0;
        #1000 $finish;
    end

    // initial 
    //     $monitor("Main := clock = %b, clear = %b, wf = %b \n Cntr3bit := clock = %b, q = %d \n Cntr4bit := clock = %b, q = %d \n MuxLarge := input = %b, sel = %d, output = %b\n\n",clock, clear, wf, mod.cnt3bit.clock, mod.cnt3bit.q,mod.cnt4bit.clock, mod.cnt4bit.q,mod.mux.inp,mod.mux.sel, mod.mux.outp);
endmodule