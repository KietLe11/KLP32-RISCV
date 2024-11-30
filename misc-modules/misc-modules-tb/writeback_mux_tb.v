`timescale 1ns/1ps
module writeback_mux_tb();

    parameter integer n = 32;
    reg [n-1:0] pc, alu, mem;
    wire [n-1:0] result;
    reg [1:0] select;
    reg clk;
    reg [n-1:0] expected_result;

    writeback_mux wbMux(.pc_in(pc), .alu_in(alu), .mem_in(mem), .wb_select(select), .writeback(result));

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
        select = 0;

        #20;

        // Test Case 1: Select Mem (select = 0)
        pc = 32'h00510193;
        alu = 32'h00200113;
        mem = 32'h10101010;
        select = 2'd0;
        expected_result = mem;
        #20
        check_result("Test Case 1 - Select Mem");

        // Test Case 2: Select ALU (select = 1)
        pc = 32'h76767676;
        alu = 32'h00008067;
        mem = 32'h20202020;
        select = 2'd1;
        expected_result = alu;
        #20
        check_result("Test Case 2 - Select ALU");

        // Test Case 3: Select PC (select = 2)
        pc = 32'h99999999;
        alu = 32'h23232323;
        mem = 32'h30303030;
        select = 2'b10;
        expected_result = pc;
        #20
        check_result("Test Case 3 - Select PC");

    end

    task check_result(input [255:0] test_name);
        if (result == expected_result) begin
            $display("PASS: %s. Expected: %d, Got: %d", test_name, expected_result, result);
        end else begin
            $display("FAIL: %s. Expected: %d, Got: %d", test_name, expected_result, result);
        end
    endtask

endmodule
