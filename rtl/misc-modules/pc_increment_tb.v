`timescale 1ns/1ps
module pc_increment_tb();

    parameter integer n = 32;
    reg [n-1:0] pc;
    wire [n-1:0] result;
    reg clk;
    reg [n-1:0] expected_result;

    pc_increment pcPlus4(.pc_in(pc), .pc_out(result));

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
        expected_result = pc + 4;
        #20
        check_result("Test Case 1");

        // Test Case 2
        pc = 32'h00107600;
        expected_result = pc + 4;
        #20
        check_result("Test Case 2");

    end

    task check_result(input [255:0] test_name);
        if (result == expected_result) begin
            $display("PASS: %s. Expected: %d, Got: %d", test_name, expected_result, result);
        end else begin
            $display("FAIL: %s. Expected: %d, Got: %d", test_name, expected_result, result);
        end
    endtask

endmodule
