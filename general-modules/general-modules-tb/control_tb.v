`timescale 1ns/1ps

module control_tb;
    parameter n = 32;

    // Inputs to the DUT
    reg clk;
    reg [n-1:0] instr;
    reg BrEq, BrLT;

    // Outputs from the DUT
    wire [2:0] ldU;
    wire RegWEn, ALUsrc1, ALUsrc2, BrUn, MemRw, PCSel;
    wire [2:0] ImmSel;
    wire [3:0] AluSEL;
    wire [1:0] WBSel;

    // Instantiate the control module
    control uut (
        .clk(clk),
        .instr(instr),
        .BrEq(BrEq),
        .BrLT(BrLT),
        .RegWEn(RegWEn),
        .ImmSel(ImmSel),
        .ALUsrc1(ALUsrc1),
        .ALUsrc2(ALUsrc2),
        .AluSEL(AluSEL),
        .BrUn(BrUn),
        .MemRw(MemRw),
        .ldU(ldU),
        .WBSel(WBSel),
        .PCSel(PCSel)
    );

    // Clock generation
    initial clk = 1;
    always #10 clk = ~clk; // 20ns clock period

    // Task to check outputs
    task check_output;
        input [255:0] test_name;
        input [13:0] expected_controls;
        input [3:0] expected_alucontrol;
        begin
            if ({RegWEn, ImmSel, ALUsrc1, ALUsrc2, BrUn, MemRw, ldU, WBSel, PCSel} !== expected_controls ||
                AluSEL !== expected_alucontrol) begin
                $display("%-8s: FAILED for instr = %b", test_name, instr);
                $display("  Expected: controls = %b, alucontrol = %b", expected_controls, expected_alucontrol);
                $display("  Got: controls = %b, alucontrol = %b",
                          {RegWEn, ImmSel, ALUsrc1, ALUsrc2, BrUn, MemRw, ldU, WBSel, PCSel}, AluSEL);
            end else begin
                $display("%-8s: PASSED for instr = %b", test_name, instr);
            end
            #5;
        end
    endtask

    initial begin

        #20;

        // Test R-Type instruction (opcode = 0110011)
        instr = 32'b000000000000_00000_000_00000_0110011; // Example R-type instruction
        BrEq = 0; BrLT = 0;
        #15 check_output("Test R-Type", 14'b1_xxx_0_0_x_0_xxx_01_0, 4'b0000);

        // Test I-Type instruction (opcode = 0010011)
        instr = 32'b000000000000_00000_000_00000_0010011; // Example I-type instruction
        #15 check_output("Test I-Type", 14'b1_000_0_1_x_0_xxx_01_0, 4'b0000);

        // Test S-Type instruction (opcode = 0100011)
        instr = 32'b000000000000_00000_000_00000_0100011; // Example S-type instruction
        #15 check_output("Test S-Type", 14'b0_001_0_1_x_1_xxx_01_0, 4'b0000);

        // Test BEQ (opcode = 1100011, funct3 = 000)
        instr = 32'b000000000000_00000_000_00000_1100011; // BEQ instruction
        BrEq = 0; BrLT = 0;
        #15 check_output("Test BEQ", 14'b0_010_1_1_x_0_xxx_01_1, 4'b0000);

        // Test BNE (opcode = 1100011, funct3 = 001)
        instr = 32'b000000000000_00000_000_00000_1100011; // BNE instruction
        BrEq = 1; BrLT = 0;
        #15 check_output("Test BNE", 14'b0_010_1_1_x_0_xxx_01_1, 4'b0000);

        // Test BLTU (opcode = 1100011, funct3 = 100)
        instr = 32'b000000000000_00000_000_00000_1100011; // BNE instruction
        BrEq = 1; BrLT = 0;
        #15 check_output("Test BLTU", 14'b0_010_1_1_x_0_xxx_01_1, 4'b0000);

        // Test JAL (opcode = 1101111)
        instr = 32'b000000000000_00000_000_00000_1101111; // JAL instruction
        #15 check_output("Test JAL", 14'b1_000_0_1_x_0_xxx_01_0, 4'b0000);

        // Test LUI (opcode = 0110111)
        instr = 32'b000000000000_00000_000_00000_0110111; // LUI instruction
        #15 check_output("Test LUI", 14'b1_000_0_1_x_0_xxx_10_0, 4'b1111);

    end
endmodule
