module KLP32V2(clk,
               reset
               );

    input logic clk, reset;

    // ============= Fetch-Decode Registers =============
    logic [31:0] fd1_inst, fd2_inst, fd1_pc, fd2_pc, fd1_pc_inc, fd2_pc_inc;

    // ============= Memory-Writeback Register =============
    logic [31:0] mw_writeback;

    // ============= Decode-Execute Registers =============
    logic [31:0] de1_data_1, de1_data_2, de2_data_1, de2_data_2;
    logic [25:0] de1_immediate, de2_immediate;
    logic [2:0] de1_load_store_mode, de2_load_store_mode;
    logic de1_reg_wr_en, de2_reg_wr_en;
    logic de1_alu_src_1_sel, de2_alu_src_1_sel;
    logic de1_alu_src_2_sel, de2_alu_src_2_sel;
    logic de1_br_u, de2_br_u;
    logic de1_mem_rw, de2_mem_rw;
    logic de1_pc_sel, de2_pc_sel;
    logic [2:0] de1_imm_sel, de2_imm_sel;
    logic [3:0] de1_alu_sel, de2_alu_sel;
    logic [1:0] de1_wb_sel, de2_wb_sel;

    // ============= Execute-Memory Stage Registers =============
    logic [31:0] em1_inst, em2_inst, em1_alu_result,
                    em2_alu_result, em1_pc, em2_pc,
                    em1_pc_inc, em2_pc_inc, em1_data_2, em2_data_2;
    logic em1_mem_rw, em2_mem_rw, em1_pc_sel, em2_pc_sel, em1_reg_wr_en, em2_reg_wr_en;
    logic [2:0] em1_load_store_mode, em2_load_store_mode;
    logic [1:0] em1_wb_sel, em2_wb_sel;

    // ============= Memory-Writeback Stage Registers =============
    logic [31:0] mw1_inst, mw2_inst, mw1_wb_mux_result, mw2_wb_mux_result;
    logic mw1_pc_sel, mw2_pc_sel, mw1_reg_wr_en, mw2_reg_wr_en;

    // ============= Writeback-End Stage Registers =============
    logic w_reg_wr_en;
    logic [31:0] w_wb_mux_result, w_write_addr;


    // Fetch Stage Module
    fetch F(.clk(clk),
            .reset(reset),
            .i_alu_in(em2_alu_result),
            .i_pc_sel(em2_pc_sel),
            .o_fetch_pc_inc(fd1_pc_inc),
            .o_fetch_pc(fd1_pc),
            .o_fetch_inst(fd1_inst)
            );

    // ============= Fetch-Decode Pipeline Stage Register =============
    always_ff @(posedge clk or reset) begin
        if (reset) begin
            fd2_inst        <= 32'b0;
            fd2_pc          <= 32'b0;
            fd2_pc_inc      <= 32'b0;
        end else begin
            fd2_inst        <= fd1_inst;
            fd2_pc          <= fd1_pc;
            fd2_pc_inc      <= fd1_pc_inc;
        end
    end

    // Decode Stage Module
    decode D(
        .clk(clk),
        .reset(reset),
        .i_inst(fd2_inst),
        .i_pc(fd2_pc),
        .i_pc_inc(fd2_pc_inc),
        .i_reg_wr_en(w_reg_wr_en),
        .i_write_addr(w_write_addr),
        .i_writeback(w_wb_mux_result),
        .o_decode_inst(de1_inst),
        .o_decode_pc(de1_pc),
        .o_decode_pc_inc(de1_pc_inc),
        .o_decode_data_1(de1_data_1),
        .o_decode_data_2(de1_data_2),
        .o_decode_immediate(de1_immediate),
        .o_decode_load_store_mode(de1_load_store_mode),
        .o_decode_reg_wr_en(de1_reg_wr_en),
        .o_decode_alu_src_1_sel(de1_alu_src_1_sel),
        .o_decode_alu_src_2_sel(de1_alu_src_2_sel),
        .o_decode_br_u(de1_br_u),
        .o_decode_mem_rw(de1_mem_rw),
        .o_decode_pc_sel(de1_pc_sel),
        .o_decode_imm_sel(de1_imm_sel),
        .o_decode_alu_sel(de1_alu_sel),
        .o_decode_wb_sel(de1_wb_sel)
    );

    // ============= Decode-Execute Pipeline Stage Register =============
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            de2_inst               <= 32'b0;
            de2_pc                 <= 32'b0;
            de2_pc_inc             <= 32'b0;
            de2_data_1             <= 32'b0;
            de2_data_2             <= 32'b0;
            de2_immediate          <= 25'b0;
            de2_load_store_mode    <= 3'b0;
            de2_reg_wr_en          <= 1'b0;
            de2_alu_src_1_sel      <= 1'b0;
            de2_alu_src_2_sel      <= 1'b0;
            de2_br_u               <= 1'b0;
            de2_mem_rw             <= 1'b0;
            de2_pc_sel             <= 1'b0;
            de2_imm_sel            <= 3'b0;
            de2_alu_sel            <= 4'b0;
            de2_wb_sel             <= 2'b0;
        end else begin
            de2_inst               <= de1_inst           ;
            de2_pc                 <= de1_pc             ;
            de2_pc_inc             <= de1_pc_inc         ;
            de2_data_1             <= de1_data_1         ;
            de2_data_2             <= de1_data_2         ;
            de2_immediate          <= de1_immediate      ;
            de2_load_store_mode    <= de1_load_store_mode;
            de2_reg_wr_en          <= de1_reg_wr_en      ;
            de2_alu_src_1_sel      <= de1_alu_src_1_sel  ;
            de2_alu_src_2_sel      <= de1_alu_src_2_sel  ;
            de2_br_u               <= de1_br_u           ;
            de2_mem_rw             <= de1_mem_rw         ;
            de2_pc_sel             <= de1_pc_sel         ;
            de2_imm_sel            <= de1_imm_sel        ;
            de2_alu_sel            <= de1_alu_sel        ;
            de2_wb_sel             <= de1_wb_sel         ;
        end
    end

    // Execute Stage Module
    execute E(
        .clk(clk),
        .reset(reset),
        .i_inst(de2_inst),
        .i_pc(de2_pc),
        .i_pc_inc(de2_pc_inc),
        .i_data_1(de2_data_1),
        .i_data_2(de2_data_2),
        .i_immediate(de2_immediate),
        .i_imm_sel(de2_imm_sel),
        .i_load_store_mode(de2_load_store_mode),
        .i_reg_wr_en(de2_reg_wr_en),
        .i_alu_src_1_sel(de2_alu_src_1_sel),
        .i_alu_src_2_sel(de2_alu_src_2_sel),
        .i_br_u(de2_br_u),
        .i_mem_rw(de2_mem_rw),
        .i_pc_sel(de2_pc_sel),
        .i_alu_sel(de2_alu_sel),
        .i_wb_sel(de2_wb_sel),
        .o_execute_inst(em1_inst),
        .o_execute_alu_result(em1_alu_result),
        .o_execute_data_2(em1_data_2),
        .o_execute_mem_rw(em1_mem_rw),
        .o_execute_load_store_mode(em1_load_store_mode),
        .o_reg_wr_en(em1_reg_wr_en),
        .o_execute_wb_sel(em1_wb_sel),
        .o_execute_pc_sel(em1_pc_sel),
        .o_execute_pc(em1_pc),
        .o_execute_pc_inc(em1_pc_inc)
    );

    // ============= Execute-Memory Pipeline Stage Register =============
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            em2_inst                  <= 32'b0;
            em2_alu_result            <= 32'b0;
            em2_data_2                <= 32'b0;
            em2_mem_rw                <= 1'b0;
            em2_load_store_mode       <= 3'b0;
            em2_reg_wr_en             <= 1'b0;
            em2_wb_sel                <= 2'b0;
            em2_pc_sel                <= 1'b0;
            em2_pc                    <= 32'b0;
            em2_pc_inc                <= 32'b0;
        end else begin
            em2_inst                  <= em1_inst           ;
            em2_alu_result            <= em1_alu_result     ;
            em2_data_2                <= em1_data_2         ;
            em2_mem_rw                <= em1_mem_rw         ;
            em2_load_store_mode       <= em1_load_store_mode;
            em2_reg_wr_en             <= em1_reg_wr_en      ;
            em2_wb_sel                <= em1_wb_sel         ;
            em2_pc_sel                <= em1_pc_sel         ;
            em2_pc                    <= em1_pc             ;
            em2_pc_inc                <= em1_pc_inc         ;
        end
    end

    // Memory Stage Module
    memory M(
        .clk(clk),
        .i_alu_result(em2_alu_result),
        .i_inst(em2_inst),
        .i_load_store_mode(em2_load_store_mode),
        .i_mem_rw(em2_mem_rw),
        .i_pc_inc(em2_pc_inc),
        .i_pc_sel(em2_pc_sel),
        .i_reg_wr_en(em2_reg_wr_en),
        .i_wb_sel(em2_wb_sel),
        .i_writedata(em2_data_2),
        .o_memory_inst(mw1_inst),
        .o_memory_pc_sel(mw1_pc_sel),
        .o_memory_reg_wr_en(mw1_reg_wr_en),
        .o_memory_wb_mux_result(mw1_wb_mux_result)
    );

    // ============= Execute-Memory Pipeline Stage Register =============
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            mw2_inst            <= 32'b0;
            mw2_wb_mux_result   <= 32'b0;
            mw2_pc_sel          <= 1'b0;
            mw2_reg_wr_en       <= 1'b0;
        end else begin
            mw2_inst            <= mw1_inst         ;
            mw2_reg_wr_en       <= mw1_reg_wr_en    ;
            mw2_pc_sel          <= mw1_pc_sel       ;
            mw2_wb_mux_result   <= mw1_wb_mux_result;
        end
    end

    // Writeback Stage Module
    writeback W(
        .i_inst(mw2_inst),
        .i_reg_wr_en(mw2_reg_wr_en),
        .i_wb_mux_result(mw2_wb_mux_result),
        .o_writeback_reg_wr_en(w_reg_wr_en),
        .o_writeback_wb_mux_result(w_wb_mux_result),
        .o_writeback_write_addr(w_write_addr)
    );

endmodule
