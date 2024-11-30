`timescale 1ns/1ps
module pc_select_mux_tb();

    parameter integer n = 32;
    reg [n-1:0] pc, alu;
    wire [n-1:0] result;
    reg pc_sel;
    reg clk;
    reg [n-1:0] expected_result;

    pc_select_mux pcMux(.pc_in(pc), .alu_in(alu), .pc_sel(pc_sel), .result(result));

    always begin
        clk = 1'b1;
        #10;
        clk = 1'b0;
        #10;
    end

    initial begin
        // Initialize values
        pc = 0;
        alu = 0;
        pc_sel = 0;

        #20;

        // Test Case 1: Select PC (pc_sel = 0)
        pc = 32'h00510193;
        alu = 32'h00200113;
        pc_sel = 0;
        expected_result = pc;
        #20
        check_result("Test Case 1 - Select PC");

        // Test Case 2: Select ALU (pc_sel = 1)
        pc = 32'h00100093;
        alu = 32'h00008067;
        pc_sel = 1;
        expected_result = alu;
        #20
        check_result("Test Case 2 - Select ALU");

    end

    task check_result(input [255:0] test_name);
        if (result == expected_result) begin
            $display("PASS: %s. Expected: %d, Got: %d", test_name, expected_result, result);
        end else begin
            $display("FAIL: %s. Expected: %d, Got: %d", test_name, expected_result, result);
        end
    endtask

endmodule
