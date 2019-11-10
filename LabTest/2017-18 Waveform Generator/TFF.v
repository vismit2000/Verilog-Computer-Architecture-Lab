`ifndef TFF
`define TFF
module TFF(q, t, clk, reset);
    input t, clk, reset;
    output q;
    reg q;

    always @(reset or posedge clk)
        begin
          if(reset)
            q <= 1'b0;
          else
            begin
              if(t == 1)
                q <= ~q;
              else
                q <= q;
            end
        end
endmodule
/*
module tb_TFF;
  reg t, reset, clk;
  wire q;
  TFF tff(q, t, clk, reset);
  
  initial 
    clk = 1'b0;
    
  always
    #2 clk = ~clk;
  
  initial
    begin
      $monitor($time, " T = %b, Reset = %b, Clock = %b, Q = %b.", t, reset, clk, q);
      #4 t = 1'b0; reset = 1'b0;
      #4 t = 1'b1; reset = 1'b1;
      #4 t = 1'b0; reset = 1'b1;
      #4 t = 1'b1; reset = 1'b1;
      #4 $finish;
    end
endmodule
*/
`endif