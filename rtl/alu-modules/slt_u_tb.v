`timescale 1 ns/1 ps

module slt_u_tb();

    reg [31:0] a, b;
    wire [31:0] c;

    // Instantiate the SLT module
    slt_u dut(.X(a), .Y(b), .result(c));

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
    end
endmodule
