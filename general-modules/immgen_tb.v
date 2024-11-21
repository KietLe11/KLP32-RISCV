`timescale 1ns / 1ps

module immgen_tb;

    // Parameters
    parameter k = 3;
    parameter n = 32;

    // Inputs and outputs for the testbench
    reg [31:7] instr;          // 25-bit instruction input
    reg [k-1:0] imm_sel;       // Immediate selection signal
    wire [31:0] imm_extended;  // Output for the extended immediate

    // Instantiate the immgen module
    immgen uut (
        .instr(instr),
        .imm_sel(imm_sel),
        .imm_extended(imm_extended)
    );

    // Test vectors
    initial begin
        // Test I-type immediate (e.g., addi)
        instr = 25'b0000000001001000000000010;  // Example bits for I-type immediate
        imm_sel = 3'b000;  // Assume imm_sel = 000 for I-type
        #10;
        $display("I-type immediate: Expected = [EXPECTED_VALUE], Got = %h", imm_extended);

        // Test S-type immediate (e.g., sw)
        instr = 25'b0000000000000001001000001;  // Example bits for S-type immediate
        imm_sel = 3'b001;  // Assume imm_sel = 001 for S-type
        #10;
        $display("S-type immediate: Expected = [EXPECTED_VALUE], Got = %h", imm_extended);

        // Test B-type immediate (e.g., beq)
        instr = 25'b1111111000000000010001100;  // Example bits for B-type immediate
        imm_sel = 3'b010;  // Assume imm_sel = 010 for B-type
        #10;
        $display("B-type immediate: Expected = [EXPECTED_VALUE], Got = %h", imm_extended);

        // Test U-type immediate (e.g., lui)
        instr = 25'b0001001001100101000000001;  // Example bits for U-type immediate
        imm_sel = 3'b011;  // Assume imm_sel = 011 for U-type
        #10;
        $display("U-type immediate: Expected = [EXPECTED_VALUE], Got = %h", imm_extended);

        // Test J-type immediate (e.g., jal)
        instr = 25'b1111111111110000000010001;  // Example bits for J-type immediate
        imm_sel = 3'b100;  // Assume imm_sel = 100 for J-type
        #10;
        $display("J-type immediate: Expected = [EXPECTED_VALUE], Got = %h", imm_extended);

        // End simulation
        $stop;
    end

endmodule