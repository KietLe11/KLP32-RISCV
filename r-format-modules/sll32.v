// Basic Starter Logical Left Shift
module LLS32 (X, shift, result);

    parameter n = 32;
    input [n-1:0] X;
    input [4:0] shift; // Allow 31 max bit shifts
    output wire [n-1:0] result;

    assign result = X << shift;

endmodule
