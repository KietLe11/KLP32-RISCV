`timescale 1ns/1ps
module alu_input_mux_B_tb();

    parameter integer n = 32;
    reg [n-1:0] immValue, data;
    wire [n-1:0] result;
    reg bSel;
    reg clk;
    reg [n-1:0] expected_result;

    alu_input_mux_B aluMuxB(.data2(data), .immGenData(immValue), .B_select(bSel), .out(result));

    always begin
        clk = 1'b1;
        #10;
        clk = 1'b0;
        #10;
    end

    initial begin
        // Initialize values
        data = 0;
        bSel = 0;
        immValue = 0;

        #20;

        // Test Case 1: Select Data from register file output 2 (B select = 1)
        immValue = 32'h00510193;
        data = 32'h00200113;
        bSel = 1;
        expected_result = immValue;
        #20
        check_result("Test Case 1 - Select Data 2");

        // Test Case 2: Select Value from Immediate Generator (B select = 0)
        immValue = 32'h00100093;
        data = 32'h00008067;
        bSel = 0;
        expected_result = data;
        #20
        check_result("Test Case 2 - Select Imm Gen");

    end

    task check_result(input [255:0] test_name);
        if (result == expected_result) begin
            $display("PASS: %s. Expected: %d, Got: %d", test_name, expected_result, result);
        end else begin
            $display("FAIL: %s. Expected: %d, Got: %d", test_name, expected_result, result);
        end
    endtask

endmodule
