module decode (
    input clk,
    input logic [31:0] i_inst,
    input logic [31:0] i_pc,
    input logic [31:0] i_pc_inc,

    input logic i_reg_wr_en,
    input logic [4:0] i_write_addr,
    input logic [31:0] i_writeback,

    output logic [31:0] o_decode_inst,

    output logic [31:0] o_decode_pc,
    output logic [31:0] o_decode_pc_inc,

    output logic [31:0] o_decode_data_1,
    output logic [31:0] o_decode_data_2,

    output logic [24:0] o_decode_immediate,

    output logic [2:0] o_decode_load_store_mode,
    output logic o_decode_reg_wr_en,
    output logic o_decode_alu_src_1_sel,
    output logic o_decode_alu_src_2_sel,
    output logic o_decode_br_u,
    output logic o_decode_mem_rw,
    output logic o_decode_pc_sel,
    output logic [2:0] o_decode_imm_sel,
    output logic [3:0] o_decode_alu_sel,
    output logic [1:0] o_decode_wb_sel
);

    logic reg_wr_en,
            alu_src_1_sel,
            alu_src_2_sel,
            br_u,   // Branch Unsigned
            br_lt,  // Branch Less Than
            br_eq,  // Branch Equal,
            mem_rw,
            pc_sel;

    logic [2:0] load_store_mode;
    logic [2:0] imm_sel;
    logic [3:0] alu_sel;
    logic [1:0] wb_sel;

    logic [4:0] reg_addr_1, reg_addr_2;
    logic [24:0] immediate;

    assign reg_addr_1 = i_inst[19:15];
    assign reg_addr_2 = i_inst[24:20];
    assign immediate = i_inst[31:7];

    control controller(.instr(i_inst),
                       .BrEq(br_eq),
                       .BrLT(br_lt),
                       .BrUn(br_u),
                       .RegWEn(reg_wr_en),
                       .ImmSel(imm_sel),
                       .ALUsrc1(alu_src_1_sel),
                       .ALUsrc2(alu_src_2_sel),
                       .AluSEL(alu_sel),
                       .MemRw(mem_rw),
                       .LoadStoreMode(load_store_mode),
                       .WBSel(wb_sel),
                       .PCSel(pc_sel)
                       );

    logic [31:0] reg_data_1, reg_data_2;

    // Register File
    registers32 regFile(.clk(clk),
                        .read_addr1(reg_addr_1),
                        .read_addr2(reg_addr_2),
                        .write_addr(i_write_addr),
                        .write_data(i_writeback),
                        .write_enable(i_reg_wr_en),
                        .read_data1(reg_data_1),
                        .read_data2(reg_data_2)
                        );

    always_comb begin
        o_decode_inst               = i_inst;
        o_decode_pc                 = i_pc;
        o_decode_pc_inc             = i_pc_inc;
        o_decode_data_1             = reg_data_1;
        o_decode_data_2             = reg_data_2;
        o_decode_immediate          = immediate;
        o_decode_load_store_mode    = load_store_mode;
        o_decode_reg_wr_en          = reg_wr_en;
        o_decode_alu_src_1_sel      = alu_src_1_sel;
        o_decode_alu_src_2_sel      = alu_src_2_sel;
        o_decode_br_u               = br_u;
        o_decode_mem_rw             = mem_rw;
        o_decode_pc_sel             = pc_sel;
        o_decode_imm_sel            = imm_sel;
        o_decode_alu_sel            = alu_sel;
        o_decode_wb_sel             = wb_sel;
    end

endmodule
