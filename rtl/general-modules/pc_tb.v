`timescale 1ns/1ps
module pc__tb();

    parameter integer n = 32;
    reg [n-1:0] pc;
    wire [n-1:0] result;
    reg clk;
    reg [n-1:0] expected_result;

    pc program_counterl(.clk(clk), .reset(1'b0), .pc_in(pc), .pc_out(result));

    always begin
        clk = 1'b1;
        #10;
        clk = 1'b0;
        #10;
    end

    initial begin
        // Initialize values
        pc = 0;

        #20;

        // Test Case 1
        pc = 32'h00510193;
        expected_result = pc;
        #20
        check_result("Test Case 1");

        // Test Case 2
        pc = 32'h00100093;
        expected_result = pc;
        #20
        check_result("Test Case 2");

        // Test Case 3: Change pc_in mid clock
        pc = 32'h00100093;
        #5
        pc = 32'h76767676;
        expected_result = 32'h00100093; // Result should still be same as TC2
        #15
        check_result("Test Case 3");

    end

    task check_result(input [255:0] test_name);
        if (result == expected_result) begin
            $display("PASS: %s. Expected: %d, Got: %d", test_name, expected_result, result);
        end else begin
            $display("FAIL: %s. Expected: %d, Got: %d", test_name, expected_result, result);
        end
    endtask

endmodule
