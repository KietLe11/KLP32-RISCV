module adder32 (X, Y, result, overflow);

    parameter integer n = 32;
    input signed [n-1:0] X, Y;
    output signed [n-1:0] result;
    output overflow;

    assign result = X + Y;
    assign overflow = (X[n-1] == Y[n-1]) && (X[n-1] != result[n-1]);

endmodule
