module immgen(instr, imm_sel, imm_extended);
    parameter k = 3;
    parameter integer n = 32;

    input [31:7] instr;
    input [k-1:0] imm_sel;
    output  [31:0] imm_extended;
    reg [31:0] imm_extend = 32'bx;

    always @(imm_sel, instr) begin
        case (imm_sel)
            // I-Type Immediate extension
            3'b000: imm_extend = {{21{instr[31]}}, instr[30:20]};

            // S-Type Immediate extension
            3'b001: imm_extend = {{21{instr[31]}}, instr[30:25], instr[11:7]};

            // B-Type Immediate extension
            3'b010:  imm_extend = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};

            // U-Type Immediate extension
            3'b011:  imm_extend = {instr[31], instr[30:20], instr[19:12], 12'b0};

            // J-Type Immediate extension
            3'b100:  imm_extend = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:25], instr[24:21], 1'b0};

            // LUI Operation
            3'b101:  imm_extend = {{instr[31:12]}, 12'b0};

            // Default case for undefined imm_sel
            default:  imm_extend = 32'bx;
        endcase
    end
    assign imm_extended = imm_extend;

endmodule
