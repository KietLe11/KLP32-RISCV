module main (clk, reset_in);

    input clk, reset_in;
    logic reset;

    // Button on DE10 lite is default high unpressed
    // Change according to needs
    assign reset = ~reset_in;

    logic [31:0] pcOut;
    logic [31:0] pcOut_prev;
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
        .clk(second_clk),
        .reset(reset),
        .o_pcOut(pcOut),
        .o_PCSel(PCSel),
        .o_aluOut(aluOut),
        .o_aluSelect(aluSelect),
        .o_aluIn1(aluIn1),
        .o_aluIn2(aluIn1),
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

endmodule
