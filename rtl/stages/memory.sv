module memory (
    input clk,

    input [31:0] i_alu_result,
    input [31:0] i_inst,
    input [2:0] i_load_store_mode,
    input i_mem_rw,
    input [31:0] i_pc_inc,
    input i_pc_sel,
    input i_reg_wr_en,
    input [1:0] i_wb_sel,
    input [31:0] i_writedata,

    output [31:0] o_memory_inst,
    output o_memory_pc_sel,
    output o_memory_reg_wr_en,
    output [31:0] o_memory_wb_mux_result
);

    logic [31:0] writeback, dataMemReadOut;

    // Data Memory
    data_memory32 dataMem(.clk(clk),
                          .write_enable(i_mem_rw),
                          .addr(i_alu_result),
                          .write_data(i_writedata),
                          .loadStoreMode(i_load_store_mode),
                          .read_data(dataMemReadOut)
                        );

    // Write Back MUX for Register File
    writeback_mux wbMux(.pc_in(i_pc_inc),
                        .alu_in(i_alu_result),
                        .mem_in(dataMemReadOut),
                        .wb_select(i_wb_sel),
                        .writeback(writeback)
                        );

    assign o_memory_inst = i_inst;
    assign o_memory_pc_sel = i_pc_sel;
    assign o_memory_wb_mux_result = writeback;
    assign o_memory_reg_wr_en = i_reg_wr_en;

endmodule
