`timescale 1 ns/1 ps

module xor32_tb();

    reg [31:0] a, b;
    wire [31:0] c;

    // Instantiate the XOR module
    xor32 dut(.X(a), .Y(b), .result(c));

    initial begin
        // Monitor signal values during simulation
        $monitor("Time: %0t | a: %0d | b: %0d | c: %0d", $time, a, b, c);

        // Test case 1
        a = 32'h00000001;
        b = 32'h00000002;
        #20;
        if (c != a ^ b)
            $display("Test case 1 failed");

        // Test case 2: a == b
        a = 32'h00000002;
        b = 32'h00000002;
        #20;
        if (c != a ^ b)
            $display("Test case 2 failed: a == b");

        // Test case 3
        a = 32'h00000003;
        b = 32'h00000002;
        #20;
        if (c != a ^ b)
            $display("Test case 3 failed: a > b");
    end
endmodule
