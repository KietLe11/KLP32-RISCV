`timescale 1ns/1ps
module halfWordExtend_tb();

    reg [15:0] halfWord;
    reg sign_extend;
    wire [31:0] halfWordExtended;
    reg clk;

    halfWordExtend HWE(.halfWord(halfWord),
                    .sign_extend(sign_extend),
                    .halfWordExtended(halfWordExtended));

    initial clk = 0;
    always #10 clk = ~clk;

    initial begin

        halfWord = 16'b0;
        sign_extend = 0;

        #20;

        // Test Case 1: Unsigned Extend
        halfWord = 16'b1010101010101010;
        sign_extend = 0;

        #2;

        if (halfWordExtended == 32'b00000000000000001010101010101010) begin
            $display("[PASS] Test Case 1: Unsigned Extend");
        end else begin
            $display("[FAIL] Test Case 1: Unsigned Extend");
        end

        // Test Case 2: Signed Extend
        halfWord = 16'b1010101010101010;
        sign_extend = 1;

        #2;

        if (halfWordExtended == 32'b11111111111111111010101010101010) begin
            $display("[PASS] Test Case 2: Signed Extend");
        end else begin
            $display("[FAIL] Test Case 2: Signed Extend");
        end

    end

endmodule