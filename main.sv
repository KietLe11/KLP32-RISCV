module main (clk, reset);

    input clk, reset;

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

endmodule
