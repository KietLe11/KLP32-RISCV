`timescale 1ns/1ps
module KLP32V1_tb();

    logic clk, reset;

    logic [31:0] pcOut;
    logic [31:0] aluOut;
    logic [31:0] inst;
    logic [31:0] dataMemReadOut;
    logic [31:0] writeBack;
    logic BrEq;
    logic BrLT;
    logic RegWEn;
    logic memRW;

    KLP32V1 processor(
        .clk(clk),
        .reset(reset),
        .o_pcOut(pcOut),
        .o_aluOut(aluOut),
        .o_inst(inst),
        .o_dataMemReadOut(dataMemReadOut),
        .o_writeBack(writeBack),
        .o_BrEq(BrEq),
        .o_BrLT(BrLT),
        .o_RegWEn(RegWEn),
        .o_memRW(memRW)
    );

    // Generate clock
    initial clk = 0;
    always #10 clk = ~clk; // 20 ns clock period

    int num_tests = 0;
    int num_passes = 0;

    task static check_result(input string test_name,
                             input string output_type,
                             input logic [31:0] instruction,
                             input logic [31:0] actual_value,
                             input logic [31:0] expected_value
                            );
        num_tests++;
        if (actual_value == expected_value) begin
            num_passes++;
            $display("[PASS] %s: %x", test_name, instruction);
            $display("For %s, got: %b", output_type, actual_value);
        end else begin
            $display("[FAIL] %s: %x", test_name, instruction);
            $display("expected: %b, For %s,", expected_value, output_type);
            $display("     got: %b, For %s,", actual_value, output_type);
        end
    endtask

    initial begin

        reset = 1;
        #10;
        reset = 0;
        // Test 1: NOP (No operation, encoded as ADDI x0, x0, 0)
        check_result("NOP", "ALU Out", inst, aluOut, 32'b0);
        #20;
    end

endmodule
