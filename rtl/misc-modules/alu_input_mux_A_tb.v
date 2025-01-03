`timescale 1ns/1ps
module alu_input_mux_A_tb();

    parameter integer n = 32;
    reg [n-1:0] pc, data;
    wire [n-1:0] result;
    reg aSel;
    reg clk;
    reg [n-1:0] expected_result;

    alu_input_mux_A aluMuxA(.pc_in(pc), .data1(data), .A_select(aSel), .out(result));

    always begin
        clk = 1'b1;
        #10;
        clk = 1'b0;
        #10;
    end

    initial begin
        // Initialize values
        pc = 0;
        data = 0;
        aSel = 0;

        #20;

        // Test Case 1: Select PC (A select = 1)
        pc = 32'h00510193;
        data = 32'h00200113;
        aSel = 1;
        expected_result = pc;
        #20
        check_result("Test Case 1 - Select PC");

        // Test Case 2: Select Data register 1 (A select = 0)
        pc = 32'h00100093;
        data = 32'h00008067;
        aSel = 0;
        expected_result = data;
        #20
        check_result("Test Case 2 - Select Data register 1");

    end

    task check_result(input [255:0] test_name);
        if (result == expected_result) begin
            $display("PASS: %s. Expected: %d, Got: %d", test_name, expected_result, result);
        end else begin
            $display("FAIL: %s. Expected: %d, Got: %d", test_name, expected_result, result);
        end
    endtask

endmodule
