// Logical Right shift
module srl32(X, shift, result);

    parameter n = 32;
    input [n-1:0] X;
    input [4:0] shift;
    output [n-1:0] result;

    assign result = X >> shift;

endmodule
