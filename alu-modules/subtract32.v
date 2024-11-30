module subtract32 (X, Y, result, overflow);

    parameter integer n = 32;
    input [n-1:0] X, Y;
    output [n-1:0] result;
    output overflow;

    assign result = X - Y;

    // Detect overflow:
    assign overflow = (X[31] == 0 && Y[31] == 1 && result[31] == 1)  // Positive overflow
                    | (X[31] == 1 && Y[31] == 0 && result[31] == 0); // Negative overflow

endmodule
