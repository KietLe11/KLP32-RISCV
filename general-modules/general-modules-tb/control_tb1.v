`timescale 1ns/1ps
module control_tb1(); 
    parameter n = 32; 
    reg clk, BrLT, BrEq;
    reg [n-1:0] instr; 
    wire BrUn, MemRw, RegWEn, PCSel, ALUsrc1, ALUsrc2; 
    wire [3:0] AluSEL; 
    wire [2:0] ImmSel, ldU; 
    wire [1:0] WBSel; 

    control uut(
        .clk(clk),
        .BrEq(BrEq), 
        .BrLT(BrLT),
        .RegWEn(RegWEn), 
        .ImmSel(ImmSel), 
        .AluSEL(AluSEL), 
        .ALUsrc1(ALUsrc1),
        .ALUsrc2(ALUsrc2), 
        .BrUn(BrUn), 
        .MemRw(MemRw), 
        .ldU(ldU),
        .WBSel(WBSel),
        .instr(instr),
        .PCSel(PCSel)
    );

    initial begin 
        // Test Case 1: addi x15, x0, 4 (I-Type)
        clk = 1; 
        BrLT = 1; 
        BrEq = 0; 
        instr = 32'h00400793; // addi x15, x0, 4 (I-Type)
        #10;
        $display("Instruction: addi x15, x0, 4 // I-Type");

        if (RegWEn != 1'b1)
            $display("Error with the RegWEn, Expected: 1");
        if (ImmSel != 3'b000)
            $display("Error with the ImmSel, Expected: 000");
        if (ALUsrc1 != 1'b0)
            $display("Error with the ALUsrc1, Expected: 0");
        if (ALUsrc2 != 1'b1)
            $display("Error with the ALUsrc2, Expected: 1");
        if (MemRw != 1'b0)
            $display("Error with the MemRw, Expected: 0"); 
        if (WBSel != 2'b01)
            $display("Error with the WBSel, Expected: 01"); 
        if (PCSel != 1'b0)
            $display("Error with the PCSel, Expected: 0"); 
        if (AluSEL != 4'b0000)
            $display("Error with the AluSEL, Expected: 0000");

        $display("Expected Results: RegWEn: 1, ImmSel: 000, ALUsrc1: 0, ALUsrc2: 1, BrUn: X, MemRw: 0(read), ldU: xxx, WBSel: 01, PCSel: 0, AluSEL: 0000");

        #10;

        // Test Case 2: sw x15, 4076(x8) (S-Type)
        clk = 1; 
        BrLT = 1; 
        BrEq = 0; 
        instr = 32'hfef42623; // sw x15, 4076(x8) (S-Type)
        #10;
        $display("Instruction: sw x15, 4076(x8) // S-Type");

        if (RegWEn != 1'b0)
            $display("Error with the RegWEn, Expected: 0");
        if (ImmSel != 3'b001)
            $display("Error with the ImmSel, Expected: 001");
        if (ALUsrc1 != 1'b0)
            $display("Error with the ALUsrc1, Expected: 0");
        if (ALUsrc2 != 1'b1)
            $display("Error with the ALUsrc2, Expected: 1");
        if (MemRw != 1'b1)
            $display("Error with the MemRw, Expected: 1"); 
        if (WBSel != 2'b01) // Not applicable for S-Type
            $display("Error with the WBSel, Expected: 01"); 
        if (PCSel != 1'b0)
            $display("Error with the PCSel, Expected: 0"); 
        if (AluSEL != 4'b0000)
            $display("Error with the AluSEL, Expected: 0000");

        $display("Expected Results: RegWEn: 0, ImmSel: 001, ALUsrc1: 0, ALUsrc2: 1, BrUn: X, MemRw: 1(write), WBSel: 01, PCSel: 0, AluSEL: 0000");

        #10;

        // Test Case 3: sub x10, x11, x12 (R-Type)
        clk = 1; 
        BrLT = 0; 
        BrEq = 0; 
        instr = 32'h40C58533; // sub x10, x11, x12 (R-Type)
        #10;
        $display("Instruction: sub x10, x11, x12 // R-Type");

        if (RegWEn != 1'b1)
            $display("Error with the RegWEn, Expected: 1");
        if (ImmSel != 3'bXXX) // Unused for R-Type
            $display("Error with the ImmSel, Expected: XXX");
        if (ALUsrc1 != 1'b0)
            $display("Error with the ALUsrc1, Expected: 0");
        if (ALUsrc2 != 1'b0)
            $display("Error with the ALUsrc2, Expected: 0");
        if (MemRw != 1'b0)
            $display("Error with the MemRw, Expected: 0");
        if (WBSel != 2'b01) // Write back from ALU
            $display("Error with the WBSel, Expected: 01");
        if (PCSel != 1'b0)
            $display("Error with the PCSel, Expected: 0");
        if (AluSEL != 4'b1000) // AluSEL for subtraction
            $display("Error with the AluSEL, Expected: 1000");

        $display("Expected Results: RegWEn: 1, ImmSel: XXX, ALUsrc1: 0, ALUsrc2: 0, BrUn: X, MemRw: 0, WBSel: 01, PCSel: 0, AluSEL: 1000");

        #10;

        // Test Case 4: lw x10, 4(x12) (I-Type)
        clk = 1; 
        BrLT = 0; 
        BrEq = 0; 
        instr = 32'h00458603; // lw x10, 4(x12) (I-Type)
        #10;
        $display("Instruction: lw x10, 4(x12) // Load Instruction");

        if (RegWEn != 1'b1)
            $display("Error with the RegWEn, Expected: 1");
        if (ImmSel != 3'b000) // Immediate for I-Type
            $display("Error with the ImmSel, Expected: 000");
        if (ALUsrc1 != 1'b0)
            $display("Error with the ALUsrc1, Expected: 0");
        if (ALUsrc2 != 1'b1)
            $display("Error with the ALUsrc2, Expected: 1");
        if (MemRw != 1'b0)
            $display("Error with the MemRw, Expected: 0 (read)");
        if (WBSel != 2'b00) // Write back from memory
            $display("Error with the WBSel, Expected: 00");
        if (PCSel != 1'b0)
            $display("Error with the PCSel, Expected: 0");
        if (AluSEL != 4'b0000) // ALU performs addition for read address calculation
            $display("Error with the AluSEL, Expected: 0000");

        $display("Expected Results: RegWEn: 1, ImmSel: 000, ALUsrc1: 0, ALUsrc2: 1, BrUn: X, MemRw: 0(read), WBSel: 00, PCSel: 0, AluSEL: 0000");

        #10;

        // Test Case 5: beq x10, x11, offset (B-Type)
        clk = 1; 
        BrLT = 0; 
        BrEq = 1; 
        instr = 32'h00058663; // beq x10, x11, offset (B-Type)
        #10;
        $display("Instruction: beq x10, x11, offset // Branch Instruction");

        if (RegWEn != 1'b0)
            $display("Error with the RegWEn, Expected: 0");
        if (ImmSel != 3'b010) // Immediate for B-Type
            $display("Error with the ImmSel, Expected: 010");
        if (ALUsrc1 != 1'b1)
            $display("Error with the ALUsrc1, Expected: 1");
        if (ALUsrc2 != 1'b1)
            $display("Error with the ALUsrc2, Expected: 1");
        if (MemRw != 1'b0)
            $display("Error with the MemRw, Expected: 0");
        if (WBSel != 2'b01) 
            $display("Error with the WBSel, Expected: 01");
        if (PCSel != 1'b1) // Branch taken
            $display("Error with the PCSel, Expected: 1");
        if (AluSEL != 4'b0000) // ALU performs addition to compute the branch taken PC address
            $display("Error with the AluSEL, Expected: 0000");

        $display("Expected Results: RegWEn: 0, ImmSel: 001, ALUsrc1: 0, ALUsrc2: 0, BrUn: 0, MemRw: 0, WBSel: XX, PCSel: 1, AluSEL: 0001");

        $stop; 
    end
endmodule
