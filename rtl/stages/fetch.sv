module fetch (
    input clk,
    input reset,
    input [31:0] i_alu_in,
    input i_pc_sel,

    output logic [31:0] o_fetch_pc_inc,
    output logic [31:0] o_fetch_pc,
    output logic [31:0] o_fetch_inst
);

    wire [31:0] inst, pc_value, pc_inc_out, pcSelMuxOut;

    pc_increment pcInc(.pc_in(pc_value), .pc_out(pc_inc_out));
    pc_select_mux pcSelMux(.pc_in(pc_inc_out), .alu_in(i_alu_in), .pc_sel(i_pc_sel), .result(pcSelMuxOut));
    pc ProgramCounter(.clk(clk),
                      .reset(reset),
                      .pc_in(pcSelMuxOut),
                      .pc_out(pc_value));

    // Instruction Memory
    inst_memory32 instMem(.addr(pc_value), .inst(inst));

    always_comb begin
        o_fetch_pc_inc = pc_inc_out;
        o_fetch_pc = pc_value;
        o_fetch_inst = inst;
    end

    // always_ff @(posedge clk or posedge reset) begin
    //     if (reset) begin
    //         o_fetch_pc_inc <= 32'b0;
    //         o_fetch_pc <= 32'b0;
    //         o_fetch_inst <= 32'b0;
    //     end else begin
    //         o_fetch_pc_inc <= pc_inc_out;
    //         o_fetch_pc <= pc_value;
    //         o_fetch_inst <= inst;
    //     end
    // end

endmodule
