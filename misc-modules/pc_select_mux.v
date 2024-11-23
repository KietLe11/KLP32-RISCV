// Select what program counter source (PC or ALU) to send to the PC and instruction memory
module pc_select_mux (pc_in, alu_in, pc_sel, result);

    parameter n = 32;
    input wire [n-1:0] pc_in, alu_in;
    input wire pc_sel;
    output wire [n-1:0] result;

    // 0 selects default PC, 1 selects ALU source
    assign result = (pc_sel == 0) ? pc_in : alu_in;

endmodule
