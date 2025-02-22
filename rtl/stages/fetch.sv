module fetch (
    input clk,
    input reset,
    input [31:0] i_alu_in,
    input i_pc_sel,

    output [31:0] o_pc_inc_out,
    output [31:0] o_pc_out,
    output [31:0] o_inst
)

    wire [31:0] inst, pc_value, pc_inc_out, pcSelMuxOut;

    pc_increment pcInc(.pc_in(pc_value), .pc_out(pc_inc_out));
    pc_select_mux pcSelMux(.pc_in(pc_inc_out), .alu_in(i_alu_in), .pc_sel(i_pc_sel), .result(pcSelMuxOut));
    pc ProgramCounter(.clk(clk),
                      .reset(reset),
                      .pc_in(pcSelMuxOut),
                      .pc_out(pc_value));

    // Instruction Memory
    inst_memory32 instMem(.addr(pc_value), .inst(inst));

    assign o_inst = inst;
    assign o_pc_inc_out = pc_inc_out;
    assign o_pc_out = pc_inc_out;

endmodule