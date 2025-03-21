`timescale 1ns/1ps
module execute_tb();

    logic clk;
    logic reset;
    logic [31:0] i_inst;
    logic [31:0] i_pc;
    logic [31:0] i_pc_inc;
    logic [31:0] i_data_1;
    logic [31:0] i_data_2;
    logic [25:0] i_immediate;
    logic [2:0] i_imm_sel;
    logic [2:0] i_load_store_mode;
    logic i_reg_wr_en;
    logic i_alu_src_1_sel;
    logic i_alu_src_2_sel;
    logic i_br_u;
    logic i_mem_rw;
    logic i_pc_sel;
    logic [3:0] i_alu_sel;
    logic [1:0] i_wb_sel;
    logic [31:0] o_execute_inst;
    logic [31:0] o_execute_alu_result;
    logic o_execute_mem_rw;
    logic [2:0] o_execute_load_store_mod;
    logic [1:0] o_execute_wb_sel;
    logic o_execute_pc_sel;
    logic o_execute_pc;
    logic o_execute_pc_in;

    parameter numOfInst = 10;
    logic unsigned [31:0] inst_lut [numOfInst-1:0] = '{
        32'h00A7B833, 32'h00A7A833, 32'h00A79833, 32'h00A7C833, 32'h00A7E833,
        32'h00A7F833, 32'h40F50533, 32'h00400793, 32'h00500513, 32'h00000013
    };

    execute E(
        .clk(clk),
        .reset(reset),
        .i_inst(i_inst),
        .i_pc(i_pc),
        .i_pc_inc(i_pc_inc),
        .i_data_1(i_data_1),
        .i_data_2(i_data_2),
        .i_immediate(i_immediate),
        .i_imm_sel(i_imm_sel),
        .i_load_store_mode(i_load_store_mode),
        .i_reg_wr_en(i_reg_wr_en),
        .i_alu_src_1_sel(i_alu_src_1_sel),
        .i_alu_src_2_sel(i_alu_src_2_sel),
        .i_br_u(i_br_u),
        .i_mem_rw(i_mem_rw),
        .i_pc_sel(i_pc_sel),
        .i_alu_sel(i_alu_sel),
        .i_wb_sel(i_wb_sel)
        .o_execute_inst(o_execute_inst),
        .o_execute_alu_result(o_execute_alu_result),
        .o_execute_mem_rw(o_execute_mem_rw),
        .o_execute_load_store_mode(o_execute_load_store_mode),
        .o_execute_wb_sel(o_execute_wb_sel),
        .o_execute_pc_sel(o_execute_pc_sel),
        .o_execute_pc(o_execute_pc),
        .o_execute_pc_inc(o_execute_pc_inc)
    );

    initial clk = 1'b0;
    always #10 clk = ~clk;

    initial begin
        inst = 32'd0;
        reset = 1'b1;
        pc = 32'b0;
        pc_inc = 32'd4;
        i_data_1 = 32'd54;
        i_data_2 = 32'd1;
        @(posedge clk);

        reset = 1'b0;
        inst = inst_lut[0];
        @(posedge clk);


    end

endmodule