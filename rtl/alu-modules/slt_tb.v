`timescale 1 ns/1 ps

module slt_tb();

    reg [31:0] a, b;
    wire [31:0] c;

    // Instantiate the SLT module
    slt dut(.X(a), .Y(b), .result(c));

    initial begin
        // Monitor signal values during simulation
        $monitor("Time: %0t | a: %0d | b: %0d | c: %0d", $time, a, b, c);

        // Test case 1: a < b
        a = 32'h00000001;
        b = 32'h00000002;
        #20;
        if (c != 32'h00000001)
            $display("Test case 1 failed: a < b");

        // Test case 2: a == b
        a = 32'h00000002;
        b = 32'h00000002;
        #20;
        if (c != 32'h00000000)
            $display("Test case 2 failed: a == b");

        // Test case 3: a > b
        a = 32'h00000003;
        b = 32'h00000002;
        #20;
        if (c != 32'h00000000)
            $display("Test case 3 failed: a > b");

        // Test case 4: a is negative, b is positive
        a = 32'hFFFFFFFF;  // -1 in 32-bit two's complement
        b = 32'h00000001;
        #10;
        if (c != 32'h00000001)
            $display("Test case 4 failed: a (negative) < b (positive)");

        // Test case 5: a is positive, b is negative
        a = 32'h00000001;
        b = 32'hFFFFFFFF;  // -1 in 32-bit two's complement
        #10;
        if (c != 32'h00000000)
            $display("Test case 5 failed: a (positive) > b (negative)");

    end
endmodule
