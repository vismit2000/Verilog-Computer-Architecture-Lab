module MEMORY;
    reg[7:0] mem[0:15];

    integer i;

    initial
        begin
          for(i = 0; i < 16; i = i+1)
            begin
              if(i % 2 == 0)
                mem[i] = 8'b11001100;
              else
                mem[i] = 8'b10101010;
            end
        end
endmodule