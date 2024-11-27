module KLP32V1(clk, reset);

    input logic clk, reset;

    logic [31:0] aluInA, aluInB, aluOut, dataMemReadOut, immGenOut, inst, pc_inc_out, pcOut, pcSelMuxOut, regData1, regData2, writeBack;
    logic [4:0] writeReg, regAddr1, regAddr2;
    logic [24:0] immIn;

    // Control
    logic [8:0] controls;
    logic RegWEn, ALUsrc1, ALUsrc2, BrUn, memRW, ldU, PCSel, BrEq, BrLT;
    logic [2:0] immSel;
    logic [3:0] aluSel;
    logic [1:0] wb_select;
    control controller(.clk(clk),
                       .instr(inst),
                       .BrLT(BrLT),
                       .BrEq(BrEq),
                       .RegWEn(RegWEn),
                       .ImmSel(immSel),
                       .ALUsrc1(ALUsrc1),
                       .ALUsrc2(ALUsrc2),
                       .AluSEL(aluSel),
                       .BrUn(BrUn),
                       .MemRw(memRW),
                       .ldU(ldU),
                       .WBSel(wb_select),
                       .PCSel(PCSel));

    // Program Counter Logic
    pc_increment pcInc(.pc_in(pcOut), .pc_out(pc_inc_out));
    pc_select_mux pcSelMux(.pc_in(pc_inc_out), .alu_in(aluOut), .pc_sel(PCSel), .result(pcSelMuxOut));
    pc ProgramCounter(.clk(clk),
                      .reset(reset),
                      .pc_in(pcSelMuxOut),
                      .pc_out(pcOut));

    // Instruction Memory
    inst_memory32 instMem(.addr(pcOut), .inst(inst));
    assign writeReg = inst[11:7];
    assign regAddr1 = inst[19:15];
    assign regAddr2 = inst[24:20];
    assign immIn = inst[31:7];

    // Register File
    registers32 regFile(.clk(clk),
                        .read_addr1(regAddr1),
                        .read_addr2(regAddr2),
                        .write_addr(writeReg),
                        .write_data(writeBack),
                        .write_enable(RegWEn),
                        .read_data1(regData1),
                        .read_data2(regData2));

    // Branch Comp
    branch_comp branchComp(.data1(regData1),
                           .data2(regData2),
                           .BrUn(BrUn),
                           .BrEq(BrEq),
                           .BrLT(BrLT));

    // Immediate Generator
    immgen immGen(.instr(immIn), .imm_sel(immSel), .imm_extended(immGenOut));

    // ALU and ALU Inputs
    alu_input_mux_A aluInMuxA(.pc_in(pcOut), .data1(regData1), .A_select(ALUsrc1), .out(aluInA));
    alu_input_mux_B aluInMuxB(.data2(regData2), .immGenData(immGenOut), .B_select(ALUsrc2), .out(aluInB));
    alu32 alu(.X(aluInA),
              .Y(aluInB),
              .select(aluSel),
              .result(aluOut));

    // Data Memory
    data_memory32 dataMem(.clk(clk),
                          .write_enable(memRW),
                          .addr(aluOut),
                          .write_data(regData2),
                          .read_data(dataMemReadOut));

    // Write Back MUX for Register File
    writeback_mux wbMux(.pc_in(pc_inc_out),
                        .alu_in(aluOut),
                        .mem_in(dataMemReadOut),
                        .wb_select(wb_select),
                        .writeback(writeBack));

endmodule
