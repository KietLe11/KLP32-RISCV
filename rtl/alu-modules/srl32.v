// Logical Right shift
module srl32(X, shift, result);

    parameter integer n = 32;
    input [n-1:0] X;
    input [n-1:0] shift;
    output [n-1:0] result;

    assign result = X >> shift;

endmodule
