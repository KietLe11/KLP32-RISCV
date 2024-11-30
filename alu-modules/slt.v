// Set less than SLT Signed
module slt (X, Y, result);

    parameter integer n = 32;
    input [n-1:0] X, Y;
    output reg [n-1:0] result;

    reg resultReg;

    always @(*) begin
        // Check MSB to see if different sign
        if (X[n-1] != Y[n-1]) begin
            result <= X[n-1];
        // If same sign, check magnitude
        end else begin
            result <= X < Y;
        end
    end

endmodule
