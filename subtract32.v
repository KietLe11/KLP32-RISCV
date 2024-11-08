module subtract32 (X, Y, result);
parameter n = 32;
input [n-1:0] X, Y;
output [n-1:0] result;

wire carryout;
wire [n-1:0] adderResult;

// Implement subtractor by using Two's complement addition
adder32 subtractor (
    .carryin(1'b1),
    .X(X),
    .Y(~Y),
    .S(adderResult),
    .carryout(carryout)
);

assign result = adderResult;

endmodule
