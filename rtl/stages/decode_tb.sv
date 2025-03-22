`timescale 1ns/1ps
module decode_tb ();

    logic clk;
    logic reset;
    logic [31:0] inst, pc, pc_inc, writeback, decode_inst, decode_pc, decode_pc_inc;

    logic [31:0] decode_data_1, decode_data_2;

    logic [25:0] decode_immediate;

    logic [2:0] decode_load_store_mode;
    logic decode_reg_wr_en;
    logic decode_alu_src_1_sel;
    logic decode_alu_src_2_sel;
    logic decode_br_u;
    logic decode_mem_rw;
    logic decode_pc_sel;
    logic [2:0] decode_imm_sel;
    logic [3:0] decode_alu_sel;
    logic [1:0] decode_wb_sel;

    initial clk = 10;
    always #10 clk = ~clk;

    parameter integer NUM_OF_INST = 10;
    logic unsigned [31:0] inst_lut [0:NUM_OF_INST] = '{
        32'h00A7B833, 32'h00A7A833, 32'h00A79833, 32'h00A7C833, 32'h00A7E833,
        32'h00A7F833, 32'h40F50533, 32'h00400793, 32'h00500513, 32'h00000013
    };

    decode D(
        .clk(clk),
        .reset(reset),
        .i_inst(inst),
        .i_pc(pc),
        .i_pc_inc(pc_inc),
        .i_writeback(writeback),
        .o_decode_inst(decode_inst),
        .o_decode_pc(decode_pc),
        .o_decode_pc_inc(decode_pc_inc),
        .o_decode_data_1(decode_data_1),
        .o_decode_data_2(decode_data_2),
        .o_decode_immediate(decode_immediate),
        .o_decode_load_store_mode(decode_load_store_mode),
        .o_decode_reg_wr_en(decode_reg_wr_en),
        .o_decode_alu_src_1_sel(decode_alu_src_1_sel),
        .o_decode_alu_src_2_sel(decode_alu_src_2_sel),
        .o_decode_br_u(decode_br_u),
        .o_decode_mem_rw(decode_mem_rw),
        .o_decode_pc_sel(decode_pc_sel),
        .o_decode_imm_sel(decode_imm_sel),
        .o_decode_alu_sel(decode_alu_sel),
        .o_decode_wb_sel(decode_wb_sel)
    );

    integer i;
    initial begin

        inst = 32'd0;
        reset = 1'b1;
        pc = 32'b0;
        pc_inc = 32'd4;
        writeback = 32'd0;
        @(posedge clk);

        reset = 1'b0;
        @(posedge clk);

        for (i = 0; i < numOfInst; i = i + 1) begin
            $display("Instruction: %h", inst_lut[i]);
            inst = inst_lut[i];
            @(posedge clk);
        end

    end

endmodule
