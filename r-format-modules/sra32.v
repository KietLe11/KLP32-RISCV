// Arithmetic Right Shift
module sra32(X, shift, result);

    parameter n = 32;
    input signed [n-1:0] X, shift;
    output signed [n-1:0] result;

    assign result = X >>> shift;

endmodule
