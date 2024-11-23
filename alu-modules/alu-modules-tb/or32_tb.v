`timescale 1 ns/1 ps

module or32_tb();

    reg [31:0] a, b;
    wire [31:0] c;

    // Instantiate the AND module
    or32 dut(.X(a), .Y(b), .result(c)); // Assume and32 has inputs X, Y and output result

    initial begin
        // Monitor signal values during simulation
        $monitor("Time: %0t | a: %0h | b: %0h | c: %0h", $time, a, b, c);

        // Test case 1: Simple OR operation (1 & 2)
        a = 32'h00000001; // 00000001
        b = 32'h00000002; // 00000010
        #20;
        if (c != (a | b))
            $display("Test case 1 failed");

        // Test case 2: OR with zero (0 or 1)
        a = 32'h00000000; // 00000000
        b = 32'h00000001; // 00000001
        #20;
        if (c != (a | b))
            $display("Test case 2 failed");

        // Test case 3: OR with all ones (all ones should be unchanged)
        a = 32'hFFFFFFFF; // 11111111
        b = 32'hFFFFFFFF; // 11111111
        #20;
        if (c != (a | b))
            $display("Test case 3 failed");

        // Test case 4: OR with alternating bits (0x55555555 & 0xAAAAAAAA)
        a = 32'h55555555; // 01010101010101010101010101010101
        b = 32'hAAAAAAAA; // 10101010101010101010101010101010
        #20;
        if (c != (a | b))
            $display("Test case 4 failed");

        // Test case 5: OR with all zeros (should always return zero)
        a = 32'h00000000; // 00000000
        b = 32'h00000000; // 00000000
        #20;
        if (c != 32'h00000000)
            $display("Test case 5 failed");
    end
endmodule
