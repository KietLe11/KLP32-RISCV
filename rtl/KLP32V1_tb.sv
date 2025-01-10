`timescale 1ns/1ps
module KLP32V1_tb();

    logic clk, reset;

    logic [31:0] pcOut;
    logic [31:0] aluOut;
    logic [3:0] aluSelect;
    logic [31:0] aluIn1, aluIn2;
    logic [31:0] inst;
    logic [31:0] dataMemReadOut;
    logic [31:0] writeBack;
    logic [1:0] wb_select;
    logic PCSel;
    logic BrEq;
    logic BrLT;
    logic RegWEn;
    logic memRW;
    logic [31:0] regData1;
    logic [31:0] regData2;

    KLP32V1 processor(
        .clk(clk),
        .reset(reset),
        .o_pcOut(pcOut),
        .o_PCSel(PCSel),
        .o_aluOut(aluOut),
        .o_aluSelect(aluSelect),
        .o_aluIn1(aluIn1),
        .o_aluIn2(aluIn2),
        .o_inst(inst),
        .o_dataMemReadOut(dataMemReadOut),
        .o_writeBack(writeBack),
        .o_wb_select(wb_select),
        .o_BrEq(BrEq),
        .o_BrLT(BrLT),
        .o_RegWEn(RegWEn),
        .o_memRW(memRW),
        .o_regData1(regData1),
        .o_regData2(regData2)
    );

    // Generate clock
    initial clk = 0;
    always #10 clk = ~clk; // 20 ns clock period

    int num_tests = 0;
    int num_passes = 0;

    task static check_result(input string output_type,
                             input logic [31:0] actual_value,
                             input logic [31:0] expected_value
                            );
        num_tests++;
        if (actual_value == expected_value) begin
            num_passes++;
            $display("[PASS] For %s, got: b'%0b/d'%0d/h'%0h",
                     output_type,
                     actual_value,
                     actual_value,
                     actual_value);
        end else begin
            $display("[FAIL] expected: b'%0b/d'%0d/h'%0h, for %s,",
                     expected_value,
                     expected_value,
                     expected_value,
                     output_type);
            $display("            got: b'%0b/d'%0d/h'%0h, for %s,",
                     actual_value,
                     actual_value,
                     actual_value,
                     output_type);
        end
    endtask

    initial begin

        reset = 1;
        #10;
        reset = 0;

        // Test R-type instructions
        $display("Test 1: NOP (No operation, encoded as ADDI x0, x0, 0)");
        check_result("ALU Out", aluOut, 32'b0);
        #20;
        $display("Test 2: 00500513 // addi a0, zero, 5");
        check_result("Writeback", writeBack, 32'd5);
        check_result("RegWEn", RegWEn, 32'd1);
        #20;
        $display("Test 3: 00400793 // li    a5,4");
        check_result("Writeback", writeBack, 32'd4);
        check_result("RegWEn", RegWEn, 32'd1);
        #20;
        $display("Test 4: 40F50533 // sub   a0, a0, a5");
        check_result("Writeback", writeBack, 32'd1);
        check_result("RegWEn", RegWEn, 32'd1);
        #20;
        $display("Test 5: 00A7F833 // and   a6, a5, a0");
        check_result("Writeback", writeBack, 32'd0);
        check_result("RegWEn", RegWEn, 32'd1);
        #20;
        $display("Test 6: 00A7E833 // or    a6, a5, a0");
        check_result("WBSelect", wb_select, 2'd1);
        check_result("Writeback", writeBack, 32'd5);
        check_result("RegWEn", RegWEn, 32'd1);
        #20;
        $display("Test 7: 00A7C833 // xor   a6, a5, a0");
        check_result("WBSelect", wb_select, 2'd1);
        check_result("Writeback", writeBack, 32'd5);
        check_result("RegWEn", RegWEn, 32'd1);
        #20;
        $display("Test 8: 00A79833 // sll   a6, a5, a0");
        check_result("Writeback", writeBack, 32'd8);
        check_result("RegWEn", RegWEn, 32'd1);
        #20;
        $display("Test 9: 00A7A833 // slt   a6, a5, a0");
        check_result("Writeback", writeBack, 32'd0);
        check_result("RegWEn", RegWEn, 32'd1);
        #20;
        $display("Test 10: 00A7B833 // sltu   a6, a5, a0");
        check_result("Writeback", writeBack, 32'd0);
        check_result("RegWEn", RegWEn, 32'd1);
        #20;
        $display("Test 11: 00A7D833 // srl   a6, a5, a0");
        check_result("Writeback", writeBack, 32'd2);
        check_result("RegWEn", RegWEn, 32'd1);
        #20;
        $display("Test 12: 40A7D833 // sra   a6, a5, a0");
        check_result("Writeback", writeBack, 32'd2);
        check_result("RegWEn", RegWEn, 32'd1);
        #20;

        // Test Set Load Store Operations
        $display("Test 13: lui   x7, 0x76");
        check_result("Writeback", writeBack, 32'h4C000);
        check_result("RegWEn", RegWEn, 32'd1);
        #20
        $display("Test 14: sw    x16, 6(x16)");
        check_result("Alu-in 1", aluIn1, 32'd2);
        check_result("Alu-in 2", aluIn2, 32'd6);
        check_result("ALU Out", aluOut, 32'd8);
        check_result("regData2", regData2, 32'd2);
        check_result("memRW", memRW, 1'b1);
        #20
        $display("Test 15: lw    x8, 6(x16)");
        check_result("ALU Out", aluOut, 32'h8);
        check_result("wb_select", wb_select, 32'd0);
        check_result("Writeback", writeBack, 32'h2);
        check_result("RegWEn", RegWEn, 32'd1);
        #20
        $display("Test 16: sb    x8, 6(x16)");
        check_result("Alu-in 1", aluIn1, 32'd2);
        check_result("Alu-in 2", aluIn2, 32'd6);
        check_result("ALU Out", aluOut, 32'h8);
        check_result("regData2", regData2, 32'd2);
        check_result("memRW", memRW, 1'b1);
        check_result("RegWEn", RegWEn, 32'd0);
        #20
        $display("Test 17: lb    x9, 6(x16)");
        check_result("Writeback", writeBack, 32'h2);
        check_result("RegWEn", RegWEn, 32'd1);
        #20
        $display("Test 18: sh    x9, 38(x16)");
        check_result("Alu-in 1", aluIn1, 32'd2);
        check_result("Alu-in 2", aluIn2, 32'd38);
        check_result("ALU Out", aluOut, 32'd40);
        check_result("regData2", regData2, 32'd2);
        check_result("memRW", memRW, 1'b1);
        check_result("RegWEn", RegWEn, 32'd0);
        #20
        $display("Test 19: lh    x9, 38(x16)");
        check_result("Writeback", writeBack, 32'h2);
        check_result("RegWEn", RegWEn, 32'd1);
        #20
        $display("Test 20: lbu   x9, 6(x16)");
        check_result("Writeback", writeBack, 32'h2);
        check_result("RegWEn", RegWEn, 32'd1);
        #20
        $display("Test 21: lhu   x9, 38(x16)");
        check_result("Writeback", writeBack, 32'h2);
        check_result("RegWEn", RegWEn, 32'd1);
        #20

        // Test Immediate Type Instructions
        $display("Test 22: addi  x11, x0, 76");
        check_result("Writeback", writeBack, 32'd76);
        check_result("RegWEn", RegWEn, 32'd1);
        #20
        $display("Test 23: addi  x12, x11, d-22");
        check_result("Alu-in 1", aluIn1, 32'd76);
        check_result("Alu-in 2", aluIn2, -32'd22);
        check_result("Writeback", writeBack, 32'd54);
        check_result("RegWEn", RegWEn, 32'd1);
        #20
        $display("Test 24: slti x12, x11, d1000");
        check_result("Writeback", writeBack, 32'd1);
        check_result("RegWEn", RegWEn, 32'd1);
        #20
        $display("Test 25: slti x12, x11, d10");
        check_result("Writeback", writeBack, 32'd0);
        check_result("RegWEn", RegWEn, 32'd1);
        #20
        $display("Test 26: sltiu x14, x11, d1000");
        check_result("Writeback", writeBack, 32'd1);
        check_result("RegWEn", RegWEn, 32'd1);
        #20
        $display("Test 27: sltiu x14, x11, -d22");
        check_result("Writeback", writeBack, 32'd1);
        check_result("RegWEn", RegWEn, 32'd1);
        #20
        $display("Test 28: xori  x15, x11, d89");
        check_result("Writeback", writeBack, 32'h15);
        check_result("RegWEn", RegWEn, 32'd1);
        #20
        $display("Test 29: ori   x16, x11, d89");
        check_result("Writeback", writeBack, 32'd93);
        check_result("RegWEn", RegWEn, 32'd1);
        #20
        $display("Test 30: and   x17, x11, d89");
        check_result("Writeback", writeBack, 32'd72);
        check_result("RegWEn", RegWEn, 32'd1);
        #20
        $display("Test 31: slli  x18, x11, d5");
        check_result("Writeback", writeBack, 32'd2432);
        check_result("RegWEn", RegWEn, 32'd1);
        #20
        $display("Test 32: srli  x19, x11, d1");
        check_result("Writeback", writeBack, 32'd38);
        check_result("RegWEn", RegWEn, 32'd1);
        #20
        $display("Test 33: srai  x19, x11, d1");
        check_result("Alu-in 1", aluIn1, 32'd76);
        check_result("Alu-in 2", aluIn2, 32'd1);
        check_result("Writeback", writeBack, 32'd38);
        check_result("RegWEn", RegWEn, 32'd1);
        #20
        $display("Test 34: addi  x20, x0, -d10"); // Put -10 in register x20
        check_result("Writeback", writeBack, -32'd10);
        check_result("RegWEn", RegWEn, 32'd1);
        #20
        $display("Test 35: srai  x21, x20, -d10");
        check_result("Writeback", writeBack, -32'd5);
        check_result("RegWEn", RegWEn, 32'd1);
        #20

        // AUIPC
        $display("Test 36: auipc x22, d100");
        check_result("Alu-in 1", aluIn1, pcOut);
        check_result("Alu-in 2", aluIn2, 32'd409600);
        check_result("Writeback", writeBack, pcOut + 32'd409600);
        check_result("RegWEn", RegWEn, 32'd1);
        #20
        $display("Test 37: auipc x22, d0");
        check_result("Alu-in 1", aluIn1, pcOut);
        check_result("Alu-in 2", aluIn2, 32'd0);
        check_result("Writeback", writeBack, pcOut + 32'd0);
        check_result("RegWEn", RegWEn, 32'd1);
        #20

        // JAL and JALR
        $display("Test 38: jalr  x1, x1, d8");
        $display("Current pcOut: %d", pcOut);
        check_result("Alu-in 1", aluIn1, pcOut - 32'd4);
        check_result("Alu-in 2", aluIn2, 32'd8);
        check_result("ALU Out", aluOut, pcOut + 32'd4);
        check_result("Writeback", writeBack, pcOut + 32'd4);
        check_result("wb_select", wb_select, 32'd2);
        check_result("RegWEn", RegWEn, 32'd1);
        check_result("PCSel", PCSel, 32'd1);
        #20
        $display("Test 37: jal   x1, -d128");
        $display("Current pcOut: %d", pcOut);
        check_result("Alu-in 1", aluIn1, pcOut);
        check_result("Alu-in 2", aluIn2, 32'd4);
        check_result("ALU Out", aluOut, pcOut + 32'd4);
        check_result("Writeback", writeBack, pcOut + 32'd4);
        check_result("RegWEn", RegWEn, 32'd1);
        check_result("PCSel", PCSel, 32'd1);
        #20

        $display("Test Summary: Passed %d out of %d tests.", num_passes, num_tests);
    end

endmodule
