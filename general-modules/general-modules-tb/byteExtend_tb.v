`timescale 1ns/1ps
module byteExtend_tb();

    reg [7:0] byte;
    reg sign_extend;
    wire [31:0] byteExtended;
    reg clk;

    byteExtend BE(.byte(byte),
                    .sign_extend(sign_extend),
                    .byteExtended(byteExtended));

    initial clk = 0;
    always #10 clk = ~clk;

    initial begin

        byte = 8'b0;
        sign_extend = 0;

        #20;

        // Test Case 1: Unsigned Extend
        byte = 8'b10101010;
        sign_extend = 0;

        #2;

        if (byteExtended == 32'b00000000000000000000000010101010) begin
            $display("[PASS] Test Case 1: Unsigned Extend");
        end else begin
            $display("[FAIL] Test Case 1: Unsigned Extend");
        end

        // Test Case 2: Signed Extend
        byte = 8'b10101010;
        sign_extend = 1;

        #2;

        if (byteExtended == 32'b11111111111111111111111110101010) begin
            $display("[PASS] Test Case 2: Signed Extend");
        end else begin
            $display("[FAIL] Test Case 2: Signed Extend");
            $display("Got %b", byteExtended);
        end

    end

endmodule
