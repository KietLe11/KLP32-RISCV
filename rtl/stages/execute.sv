module execute (
    input logic [31:0] i_inst,
    input logic [31:0] i_pc,
    input logic [31:0] i_pc_inc,

    input logic [31:0] i_data_1,
    input logic [31:0] i_data_2,

    input logic [25:0] i_immediate,
    input logic [2:0] i_imm_sel,

    input logic [2:0] i_load_store_mode,
    input logic i_reg_wr_en,
    input logic i_alu_src_1_sel,
    input logic i_alu_src_2_sel,
    input logic i_br_u,
    input logic i_mem_rw,
    input logic i_pc_sel,
    input logic [3:0] i_alu_sel,
    input logic [1:0] i_wb_sel,

    output logic [31:0] o_execute_inst,
    output logic [31:0] o_execute_alu_result,
    output logic [31:0] o_execute_data_2,
    output logic o_execute_mem_rw,
    output logic [2:0] o_execute_load_store_mode,
    output logic [1:0] o_execute_wb_sel,
    output logic o_execute_pc_sel,
    output logic o_execute_pc,
    output logic o_execute_pc_inc,
    output logic o_execute_reg_wr_en
);

    logic branch_equal, branch_less_than;
    // Branch Comp
    branch_comp branchComp(.data1(i_data_1),
                           .data2(i_data_1),
                           .BrUn(i_br_u),
                           .BrEq(branch_equal),
                           .BrLT(branch_less_than));

    logic [31:0] imm_gen_ext;
    // Immediate Generator
    immgen immGen(.instr(i_immediate), .imm_sel(i_imm_sel), .imm_extended(imm_gen_ext));

    logic alu_in_A, alu_in_B;
    logic [31:0] alu_result;
    // ALU and ALU Inputs
    alu_input_mux_A aluInMuxA(.pc_in(i_pc),
                                .data1(i_data_1),
                                .A_select(i_alu_src_1_sel),
                                .out(alu_in_A));
    alu_input_mux_B aluInMuxB(.data2(i_data_2),
                                .immGenData(imm_gen_ext),
                                .B_select(i_alu_src_2_sel),
                                .out(alu_in_B));
    alu32 alu(.X(alu_in_A),
              .Y(alu_in_B),
              .select(i_alu_sel),
              .result(alu_result));

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic branch_pc_sel;

    always_comb begin
        funct3 = i_inst[14:12];
        opcode = i_inst[6:0];

        case(funct3)
            3'b000: // BEQ
                branch_pc_sel = branch_equal;
            3'b001: // BNE
                branch_pc_sel = !branch_equal;
            3'b100: // BLT
                branch_pc_sel = branch_less_than;
            3'b101: // BGE
                branch_pc_sel = !branch_less_than;
            3'b110: // BLTU
                branch_pc_sel = branch_less_than;
            3'b111: // BGEU
                branch_pc_sel = !branch_less_than;
            default:
                branch_pc_sel = 1'b0;
        endcase
    end

    logic execute_pc_sel;
    assign execute_pc_sel = (opcode == 7'b1100011) ? branch_pc_sel : i_pc_sel;

    always_comb begin
        o_execute_alu_result        = alu_result;
        o_execute_inst              = i_inst;
        o_execute_data_2            = i_data_2;
        o_execute_load_store_mode   = i_load_store_mode;
        o_execute_mem_rw            = i_mem_rw;
        o_execute_pc                = i_pc;
        o_execute_pc_sel            = execute_pc_sel;
        o_execute_pc_inc            = i_pc_inc;
        o_execute_reg_wr_en         = i_reg_wr_en;
        o_execute_wb_sel            = i_wb_sel;
    end

endmodule
