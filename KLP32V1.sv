module KLP32V1(clk, reset);

    input logic clk, reset;

    logic aluOut, pc_inc_out, pcSelMuxOut, pcOut;
    pc_increment pcInc(.pc_in(pcOut), .pc_out(pc_inc_out));

    pc_select_mux pcSelMux(.pc_in(pc_inc_out), .alu_in(aluOut), .pc_sel(CONTROL), .result(pcSelMuxOut));

    pc ProgramCounter(.clk(clk), .reset(reset), .pc_in(pcSelMuxOut), pc_out(pcOut));

    logic inst;
    inst_memory32 instMem(.addr(pcOut), .inst(inst));

    logic writeBack, regData1, regData2;
    registers32 regFile(.clk(clk), .read_addr1(inst[19:15]), .read_addr2(inst[24:20]), .write_addr(inst[11:7]), .write_data(writeBack), .write_enable(CONTROL), .read_data1(regData1), .read_data2(regData2));

    logic immGenOut;
    immgen immGen(.instr(inst), imm_sel(CONTROL), .imm_extended(immGenOut));

    logic aluInA;
    alu_input_mux_A aluInMuxA(.pc_in(pcOut), .data1(regData1), .A_select(CONTROL), .out(aluInA));

    logic aluInB;
    alu_inputPmux_B aluInMuxB(.data2(regData2), .immGenData(immGenOut), .B_select(CONTROL), .out(aluInB));

    alu32 alu(.X(aluInA), .Y(aluInB), .select(CONTROL), .result(aluOut));

    logic dataMemReadOut;
    data_memory32 dataMem(.clk(clk), .write_enable(CONTROL), .addr(aluOut), .write_data(regData2), .read_data(dataMemReadOut));

    writeback_mux wbMux(.pc_in(pc_inc_out), .alu_in(aluOut), .mem_in(.dataMemReadOut), .wb_select(CONTROL), .writeBack(writeBack));

endmodule