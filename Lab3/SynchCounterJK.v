`timescale 1ns / 1ps
module JKFlipFlop(J, K, clock, Q);
  initial
    begin
      $dumpfile("SynchCounterJK.vcd");
      $dumpvars;
    end
  input J, K, clock;
  output Q;
  reg Q;
  initial
    Q = 1'b0;
  always @(posedge clock)
    case({J, K})
      2'b00:  Q <= Q;
      2'b01:  Q <= 1'b0;
      2'b10:  Q <= 1'b1;
      2'b11:  Q <= ~Q;
    endcase
endmodule

module SynchCounterJK(clk, Q);
    input clk;
    output[3:0] Q;
    wire w0, w1;
    
    assign w0 = Q[0] & Q[1];
    assign w1 = w0 & Q[2]; 

    JKFlipFlop F0(1'b1, 1'b1, clk, Q[0]);
    JKFlipFlop F1(Q[0], Q[0], clk, Q[1]);
    JKFlipFlop F2(w0, w0, clk, Q[2]);
    JKFlipFlop F3(w1, w1, clk, Q[3]);
endmodule

module SynchCounterJK_TB;
    reg clock;
    wire [3:0] Q;

    SynchCounterJK SCJK(clock, Q);

    // initial
    // begin
    //   clock = 1'b0;
    //   repeat (10)
    //   #2  clock = ~clock;
    // end

    initial 
        clock = 1'b0;
    
    always
        #2 clock = ~clock;

    initial
        begin
          $monitor($time, "  CLK = %b, Q = %b", clock, Q);
          #64 $finish;
        end
endmodule