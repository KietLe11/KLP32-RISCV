module control (instr, BrLT, BrEq, RegWEn, ImmSel, ALUsrc1,
                ALUsrc2, AluSEL, BrUn, MemRw, LoadStoreMode, WBSel, PCSel);

    parameter integer n = 32;
    input [n-1:0] instr;
    input BrEq, BrLT;

    output [2:0] LoadStoreMode;
    output RegWEn, ALUsrc1, ALUsrc2, BrUn, MemRw, PCSel;
    output [2:0] ImmSel;
    output [3:0] AluSEL;
    output [1:0] WBSel;
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg branch_pcSel;
    reg [13:0] controls;
    reg [3:0] alucontrol;
    assign {AluSEL} = alucontrol;
    assign {RegWEn, ImmSel, ALUsrc1, ALUsrc2, BrUn, MemRw, LoadStoreMode, WBSel, PCSel} = controls;

    always @(*) begin
        funct3 = instr[14:12];
        opcode = instr[6:0];

        case (opcode)
            7'b0110011 : begin
                controls = 14'b1_xxx_0_0_x_0_xxx_01_0; // R-TYPE OPERATIONS
                alucontrol = {instr[30],instr[14:12]};
            end
            7'b0010011 : begin // I-TYPE OPERATIONS
                case (funct3)
                    3'b101 : begin
                        controls = 14'b1_111_0_1_x_0_xxx_01_0;
                        alucontrol = {instr[30],instr[14:12]};
                    end
                    default : begin
                        controls = 14'b1_000_0_1_x_0_xxx_01_0;
                        alucontrol = {1'b0,instr[14:12]};
                    end
                endcase
            end
            7'b0100011 : begin // S-TYPE OPERATIONS
                /*
                    funct3 map:
                        000 - SB
                        001 - SH
                        010 - SW
                */
                controls = {1'b0, 3'b001, 1'b0, 1'b1 ,1'bx, 1'b1, funct3, 2'b01, 1'b0};
                alucontrol = 4'b0000;
            end
            7'b1100011 : begin
                alucontrol = 4'b0000;
                if(funct3 == 001 & !BrEq) // BNE
                    branch_pcSel = 1'b1;
                else if((funct3 == 100 || funct3 == 110)& BrLT) // BLTU and BLT
                    branch_pcSel = 1'b1;
                else if(funct3 == 000 & BrEq) // BEQ
                    branch_pcSel = 1'b1;
                else if((funct3 == 101 || funct3 == 111) & !BrLT) // BGE and BGEU
                    branch_pcSel = 1'b0;
                else
                    branch_pcSel = 0;
                controls = {1'b0, 3'b010, 1'b1, 1'b1 ,1'bx, 1'b0, 3'bxxx, 2'b01, branch_pcSel};
            end
            7'b0000011 : begin // LOAD OPERATIONS
                /*
                    funct3 map:
                        000 - LB
                        001 - LH
                        010 - LW
                        100 - LBU
                        101 - LHU
                */
                controls = {1'b1, 3'b000, 1'b0, 1'b1 ,1'bx, 1'b0, funct3, 2'b00, 1'b0};
                alucontrol = 4'b0000;
            end
            7'b1101111 : begin
                controls = 14'b1_100_1_1_x_0_xxx_10_1; // JAL OPERATIONS
                alucontrol = 4'b0000;
            end
            7'b1100111 : begin
                controls = 14'b1_000_0_1_x_0_xxx_10_1; // JALR OPERATIONS
                alucontrol = 4'b0000;
            end
            7'b0110111 : begin
                controls = 14'b1_101_0_1_x_0_xxx_01_0; // LUI OPERATIONS
                alucontrol = 4'b1111;
            end
            7'b0010111 : begin
                controls = 14'b1_101_1_1_x_0_xxx_01_0; // AUIPC
                alucontrol = 4'b0000;
            end
            default: begin
                controls = 14'b0_000_0_1_x_0_xxx_01_0;
                alucontrol = 4'b0000;
            end
        endcase
    end
endmodule
