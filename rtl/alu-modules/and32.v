module and32(X, Y, result);

    parameter integer n = 32;
    input [n-1:0] X, Y;
    output [n-1:0] result;

    assign result = X & Y;

endmodule
