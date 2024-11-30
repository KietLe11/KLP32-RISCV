module alu32 (X, Y, select, result);

    parameter integer n = 32;
    input [n-1:0] X, Y;
    input [3:0] select;
    output reg [n-1:0] result;

    wire [n-1:0] adderResult;
    wire adderOverflow;
    adder32 adder_func(.X(X), .Y(Y), .result(adderResult), .overflow(overflow));

    wire [n-1:0] andResult;
    and32 and_func(.X(X), .Y(Y), .result(andResult));

    wire [n-1:0] orResult;
    or32 or_func(.X(X), .Y(Y), .result(orResult));

    wire [n-1:0] sllResult;
    sll32 sll_func(.X(X), .shift(Y), .result(sllResult));

    wire [n-1:0] sltUResult;
    slt_u sltU_func(.X(X), .Y(Y), .result(sltUResult));

    wire [n-1:0] sltResult;
    slt slt_func(.X(X), .Y(Y), .result(sltResult));

    wire [n-1:0] sraResult;
    sra32 sra_func(.X(X), .shift(Y), .result(sraResult));

    wire [n-1:0] srlResult;
    srl32 srl_func(.X(X), .shift(Y), .result(srlResult));

    wire [n-1:0] subtractResult;
    wire subOverflow;
    subtract32 subtract_func(.X(X), .Y(Y), .result(subtractResult), .overflow(subOverflow));

    wire [n-1:0] xorResult;
    xor32 xor_func(.X(X), .Y(Y), .result(xorResult));

    // Passthrough second input
    wire [n-1:0] yPassthrough = Y;

    always @(*) begin
        case (select)
            4'b0000: result = adderResult;
            4'b1000: result = subtractResult;
            4'b0001: result = sllResult;
            4'b0010: result = sltResult;
            4'b0011: result = sltUResult;
            4'b0100: result = xorResult;
            4'b0101: result = srlResult;
            4'b1101: result = sraResult;
            4'b0110: result = orResult;
            4'b0111: result = andResult;
            4'b1111: result = yPassthrough;
        endcase
    end

endmodule
