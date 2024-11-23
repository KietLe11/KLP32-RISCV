// 32 Bit XOR Module
module xor32 (X, Y, result);

    parameter n = 32;
    input [n-1:0] X, Y;
    output wire [n-1:0] result;

    assign result = X ^ Y;

endmodule
