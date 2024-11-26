`timescale 1ns/1ps
module branch_comp_tb;

    // Parameters and signals
    parameter n = 32;

    logic [n-1:0] data1, data2;
    logic BrUn;
    logic BrEq, BrLT;

    branch_comp dut (
        .data1(data1),
        .data2(data2),
        .BrUn(BrUn),
        .BrEq(BrEq),
        .BrLT(BrLT)
    );

    int num_tests = 0;
    int num_passes = 0;

    task check_result(input string test_name, input logic expected_BrEq, input logic expected_BrLT);
        num_tests++;
        if (BrEq === expected_BrEq && BrLT === expected_BrLT) begin
            num_passes++;
            $display("[PASS] %s", test_name);
        end else begin
            $display("[FAIL] %s: Expected BrEq=%b, BrLT=%b, Got BrEq=%b, BrLT=%b",
                     test_name, expected_BrEq, expected_BrLT, BrEq, BrLT);
        end
    endtask

    initial begin
        // Test Case 1: Equality
        data1 = 32'hA5A5A5A5; data2 = 32'hA5A5A5A5; BrUn = 0;
        #20; check_result("Test 1: Equality", 1, 0);

        // Test Case 2: Unsigned less-than
        data1 = 32'h00000001; data2 = 32'h00000010; BrUn = 1;
        #20; check_result("Test 2: Unsigned less-than", 0, 1);

        // Test Case 3: Unsigned greater-than
        data1 = 32'h00000020; data2 = 32'h00000010; BrUn = 1;
        #20; check_result("Test 3: Unsigned greater-than", 0, 0);

        // Test Case 4: Signed less-than
        data1 = 32'hFFFFFFF0; data2 = 32'h00000010; BrUn = 0;
        #20; check_result("Test 4: Signed less-than", 0, 1);

        // Test Case 5: Signed greater-than
        data1 = 32'h7FFFFFFF; data2 = 32'h00000010; BrUn = 0;
        #20; check_result("Test 5: Signed greater-than", 0, 0);

        // Test Case 6: Unsigned and Signed equality edge case
        data1 = 32'h00000000; data2 = 32'h00000000; BrUn = 1;
        #20; check_result("Test 6: Unsigned equality", 1, 0);

        // Summary
        $display("Test Summary: Passed %d out of %d tests.", num_passes, num_tests);
    end

endmodule
