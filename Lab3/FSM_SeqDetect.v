module FSM_Seq_Detect(in, clock, reset);
    input clock, reset, in;

    reg [2:0] state;

    parameter  s0 = 3'b000,
               s1 = 3'b001,
               s2 = 3'b010,
               s3 = 3'b011,
               s4 = 3'b100;

    always @(posedge clock or posedge reset)
    begin
      if(reset)
            state <= s0;
      else
        begin
          case(state)
            s0: begin
                    if(in)
                        state <= s1;
                    else
                        state <= s0;
                end
            
            s1: begin
                    if(in)
                        state <= s1;
                    else
                        state <= s2;
                end
            
            s2: begin
                    if(in)
                        state <= s3;
                    else
                        state <= s0;
                end
            
            s3: begin
                    if(in)
                        state <= s4;
                    else
                        state <= s2;
                end

            s4: begin
                    $display("Sequence detected");
                    if(in)
                        state <= s1;
                    else
                        state <= s2;
                end
          endcase
        end
    end
endmodule

module tb_FSM_SeqDetect;
    reg in, clock, reset;
    integer i;

    FSM_Seq_Detect fsm(in, clock, reset);

    initial
        clock = 1'b0;

    // always
    //     #2 clock = ~clock;
    // always @(posedge clock)
    //     $display($time, " Seq = %b, Reset = %b", in, reset);

    reg [0:15] seq;

    initial
        begin
          //$monitor(,$time, " Seq = %b, Reset = %b", in, reset);
          reset = 1'b0;
          reset = 1'b1;
          
          seq = 16'b1011_0000_1011_0000;

          #2 reset = 1'b0;

          for(i = 0; i < 16; i = i+1)
          begin
            in = seq[i];
            #2 clock = 1'b1;
            #2 clock = 1'b0;
            $display($time, " State = ", fsm.state, " Input = ", in);
          end
          #100 $finish;
        end
endmodule