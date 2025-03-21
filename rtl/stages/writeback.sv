module writeback (
    input logic [31:0] i_inst,
    input logic i_reg_wr_en,
    input logic [31:0] i_wb_mux_result,

    output logic o_reg_wr_en,
    output logic [31:0] o_wb_mux_result,
    output logic [4:0] o_write_addr
);
    assign o_writeback_reg_wr_en = i_reg_wr_en;
    assign o_writeback_wb_mux_result = i_wb_mux_result;
    assign o_writeback_write_addr = i_inst[11:7];

endmodule