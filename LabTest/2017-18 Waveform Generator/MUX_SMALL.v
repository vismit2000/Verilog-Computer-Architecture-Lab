module MUX_SMALL(sel, in, out);
    input sel;
    input[1:0] in;
    output out;

    assign out = (~sel & in[0]) | (sel & in[1]);
endmodule