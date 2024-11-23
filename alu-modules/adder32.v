module adder32 (X, Y, result, overflow);

    parameter n = 32;
    input [n-1:0] X, Y;
    output [n-1:0] result;
    output overflow;

    assign result = X + Y;
    assign overflow = (X + Y) > 32'hFFFFFFFF;

endmodule
