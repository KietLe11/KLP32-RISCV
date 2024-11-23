`timescale 1 ns/1 ps
module alu32_tb();

    parameter n = 32;
    reg clk;
    reg [n-1:0] a, b;
    reg [3:0] selector;
    wire [n-1:0] c;
    reg [n-1:0] expected_result;

    // Instantiate the ALU
    alu32 AL_YOU (.X(a), .Y(b), .select(selector), .result(c));

    // Generate clock signal
    always begin
        clk = 1'b1;
        #10;
        clk = 1'b0;
        #10;
    end

    initial begin
        // Initialize inputs
        a = 32'd0;
        b = 32'd0;
        selector = 4'b0000;
        expected_result = 32'd0;

        // Test case 1: Addition
        #20;
        a = 32'd10;
        b = 32'd20;
        selector = 4'b0000;  // adderResult
        expected_result = 32'd30;
        #20;
        check_result("Addition");

        // Test case 2: Subtraction
        a = 32'd50;
        b = 32'd30;
        selector = 4'b1000;  // subtractResult
        expected_result = 32'd20;
        #20;
        check_result("Subtraction");

        // Test case 3: Logical shift left
        a = 32'd4;
        b = 32'd1;
        selector = 4'b0001;  // sllResult
        expected_result = a << b;
        #20;
        check_result("Logical Shift Left");

        // Test case 4: Set less than (signed)
        a = 32'd10;
        b = 32'd15;
        selector = 4'b0010;  // sltResult
        expected_result = (a < b) ? 32'd1 : 32'd0;
        #20;
        check_result("Set Less Than (Signed)");

        // Test case 5: Set less than (unsigned)
        a = 32'd10;
        b = 32'd15;
        selector = 4'b0011;  // sltUResult
        expected_result = ($unsigned(a) < $unsigned(b)) ? 32'd1 : 32'd0;
        #20;
        check_result("Set Less Than (Unsigned)");

        // Test case 6: XOR
        a = 32'd15;
        b = 32'd30;
        selector = 4'b0100;  // xorResult
        expected_result = a ^ b;
        #20;
        check_result("XOR");

        // Test case 7: Logical shift right
        a = 32'd16;
        b = 32'd1;
        selector = 4'b1101;  // srlResult
        expected_result = a >> b;
        #20;
        check_result("Logical Shift Right");

        // Test case 8: Arithmetic shift right
        a = -32'd16;
        b = 32'd1;
        selector = 4'b1101;  // sraResult
        expected_result = $signed(a) >>> b;
        #20;
        check_result("Arithmetic Shift Right");

        // Test case 9: OR
        a = 32'd12;
        b = 32'd5;
        selector = 4'b0110;  // orResult
        expected_result = a | b;
        #20;
        check_result("OR");

        // Test case 10: AND
        a = 32'd15;
        b = 32'd7;
        selector = 4'b0111;  // andResult
        expected_result = a & b;
        #20;
        check_result("AND");

        // Test case 11: Passthrough
        a = 32'd15;
        b = 32'd7;
        selector = 4'b1111;
        expected_result = 32'd7;
        #20;
        check_result("Passthrough");

    end

    // Task to check result and print pass/fail
    task check_result(input [255:0] test_name);
        if (c === expected_result) begin
            $display("PASS: %s. Expected: %d, Got: %d", test_name, expected_result, c);
        end else begin
            $display("FAIL: %s. Expected: %d, Got: %d", test_name, expected_result, c);
        end
    endtask
endmodule
