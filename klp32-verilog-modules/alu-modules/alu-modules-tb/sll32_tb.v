`timescale 1 ns/1 ps

module sll32_tb();

    reg [31:0] a, b;
    wire [31:0] c;

    // Instantiate the SLL module
    sll32 dut(.X(a), .shift(b), .result(c));

    initial begin
        // Monitor signal values during simulation
        $monitor("Time: %0t | a: %0h | b: %0d | c: %0h", $time, a, b, c);

        // Test case 1: Simple shift
        a = 32'h00000001;
        b = 32'h00000002;
        #20;
        if (c != a << b)
            $display("Test case 1 failed");

        // Test case 2: Shifting a zero
        a = 32'h00000000;
        b = 32'h0000001F;
        #20;
        if (c != a << b)
            $display("Test case 2 failed");

        // Test case 3: Shift by zero (should retain original value)
        a = 32'hFFFFFFFF;
        b = 32'h00000000;
        #20;
        if (c != a)
            $display("Test case 3 failed");

        // Test case 4: Maximum shift
        a = 32'h80000000;
        b = 32'h0000001F;
        #20;
        if (c != a << b)
            $display("Test case 4 failed");

        // Test case 5: Middle shift with mixed pattern
        a = 32'hA5A5A5A5;
        b = 32'h00000010;
        #20;
        if (c != a << b)
            $display("Test case 5 failed");

        // Test case 6: Alternating pattern with small shift
        a = 32'h55555555;
        b = 32'h00000001;
        #20;
        if (c != a << b)
            $display("Test case 6 failed");

    end
endmodule
