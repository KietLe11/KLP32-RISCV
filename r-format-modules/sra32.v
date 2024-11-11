// Arithmetic Right Shift
module sra32(X, shift, result);

    parameter n = 32;
    input [n-1:0] X;
    input [n-1:0] shift;
    output [n-1:0] result;

    assign result = (X >>> shift) | (32'h80000000 & X);

endmodule
