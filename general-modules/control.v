module control(instr,BrLT, BrEq, RegWEn, ImmSel,ALUsrc1, ALUsrc2, ALUSEL, BrUn, MEMRW, ldU,WBSel, PCSel );
    parameter n = 32; 
    input [n-1:0] instr; 
    input BrEq, BrLT; 
    output RegWEn,ALUsrc1, ALUsrc2, BrUn, MEMRW, ldU, PCSel; 
    output [2:0] ImmSel; 
    output [3:0] ALUSEL; 
    output [1:0] WBSel; 
    reg [6:0] opcode; 
    
    // controls = {}


    always@(*)
        begin 
            opcode = instr[6:0]; 
            case(opcode)
                7'b0110011 :  //  R-TYPE OPERATIONS
                7'b0010011 :  // I-TYPE OPERATIONS
                7'b0100011 : // S-TYPE OPERATIONS
                7'b1100011 : // B-TYPE OPERATIONS
            default
            endcase 
        end 
