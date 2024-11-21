`timescale 1 ns/1 ps

module subtract32_tb();

    reg [31:0] a, b;
    wire [31:0] c;
    wire d;
    reg clk;

    subtract32 dut(.X(a), .Y(b), .result(c), .overflow(d));

    always begin
        clk = 1'b1;
        #10;
        clk = 1'b0;
        #10;
    end

    initial
    begin
        $display("Testing subtract32 module");

        // Test case 1: 0 - 0
        a = 0;
        b = 0;
        #20; // Wait 20 ns
        if (c !== 32'd0)
            $display("Test case failed: 0 - 0. Expected 0, got %d", c);

        // Test case 2: 1 - 1
        a = 1;
        b = 1;
        #20;
        if (c !== 32'd0)
            $display("Test case failed: 1 - 1. Expected 0, got %d", c);

        // Test case 3: 0 - 1
        a = 0;
        b = 1;
        #20;
        if (c !== ~32'd0)
            $display("Test case failed: 0 - 1. Expected -1 (or 0xFFFFFFFF), got %h", c);

        // Test case 4: Large positive number - Small positive number
        a = 32'd123456;
        b = 32'd65432;
        #20;
        if (c !== 32'd58024)
            $display("Test case failed: 123456 - 65432. Expected 58024, got %d", c);

        // Test case 5: Small positive number - Large positive number
        a = 32'd65432;
        b = 32'd123456;
        #20;
        if (c !== -32'd58024)
            $display("Test case failed: 65432 - 123456. Expected -58024 (or 0xFFFF18F8), got %h", c);

        // Test case 6: Negative number - Positive number
        a = -32'd10;
        b = 32'd20;
        #20;
        if (c !== -32'd30)
            $display("Test case failed: -10 - 20. Expected -30 (or 0xFFFFFFE2), got %h", c);

        // Test case 7: Positive number - Negative number
        a = 32'd20;
        b = -32'd10;
        #20;
        if (c !== 32'd30)
            $display("Test case failed: 20 - (-10). Expected 30, got %d", c);

        // Test case 8: Negative number - Negative number
        a = -32'd10;
        b = -32'd20;
        #20;
        if (c !== 32'd10)
            $display("Test case failed: -10 - (-20). Expected 10, got %d", c);

        // Test case 9: Maximum positive number - Minimum negative number
        a = 32'h7FFFFFFF; // 2^31 - 1
        b = 32'h80000000; // -2^31
        #20;
        if (c !== 32'hFFFFFFFF) // Expected result is -1
            $display("Test case failed: 0x7FFFFFFF - 0x80000000. Expected -1 (or 0xFFFFFFFF), got %h", c);

        // Test case 10: Minimum negative number - Maximum positive number
        a = 32'h80000000; // -2^31
        b = 32'h7FFFFFFF; // 2^31 - 1
        #20;
        if (c !== 32'h00000001) // Expected result is 1 (or 0x00000001)
            $display("Test case failed: 0x80000000 - 0x7FFFFFFF. Expected 0x00000001, got %h", c);


        $display("All test cases completed");
    end

endmodule
