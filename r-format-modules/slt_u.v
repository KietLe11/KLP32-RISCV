// Set less than SLT Unsigned
module slt_u (X, Y, result);

    parameter n = 32;
    input [n-1:0] X, Y;
    output wire [n-1:0] result;

    assign result = X < Y;

endmodule
