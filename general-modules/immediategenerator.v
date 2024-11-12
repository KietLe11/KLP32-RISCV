module immmediategenerator(instr,imm_sel, imm_extend); 
    parameter k = 3; 
    parameter n = 32; 
    input [31:7] instr; 
    input [k-1:0] imm_sel; 
    output [n-1:0]  imm_extend; 

    always@(imm_sel,instr)
    begin
        case(imm_sel)
            // I-Type Immediate extension 
            2'b000: imm_extend = {21{instr[31]}, instr[30:20]};  

            // S-Type Immediate extension
            2'b001: imm_extend = {21{instr[31]}, instr[30:25], instr[11:7]}; 

            // B-Type Immediate extension
            2'b010: imm_extend = {20{instr[31]}, instr[7], instr[30:25], instr[4:1],1'b0}; 

            // U-Type Immediate extension
            2'b011: imm_extend = {{instr[31]}, instr[30:20],instr[19:12], 12b'0}; 

            // J-Type Immediate extension 
            2'b100: imm_extend = {12{instr[31]}, instr[19:12],instr[20], instr[30:25], instr[24:21],1'b0};
            
            // Output an undefined result if the imm_sel is not valid
            defautl: imm_extend = 32'bx;
        endcase
endmodule