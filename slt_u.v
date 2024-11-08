// Set less than SLT Unsigned
module slt_u (X, Y, result);
input [31:0] X, Y;
output wire result;

assign result = (X < Y) ? 1 : 0;

endmodule
