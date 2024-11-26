module control(clk, instr,BrLT, BrEq, RegWEn, ImmSel,ALUsrc1, ALUsrc2, AluSEL, BrUn, MemRw, ldU,WBSel, PCSel );
    parameter n = 32; 
	 input clk; 
    input [n-1:0] instr; 
    input BrEq, BrLT; 
	 output [2:0] ldU; 
    output RegWEn,ALUsrc1, ALUsrc2, BrUn, MemRw, PCSel; 
    output [2:0] ImmSel; 
    output [3:0] AluSEL; 
    output [1:0] WBSel; 
    reg [6:0] opcode; 
	 reg [2:0] funct3; 
    reg branch_pcSel; 
    reg [14:0] controls; 
	 reg [3:0] alucontrol; 
	 reg BrUn_selection; 
	 assign {AluSEL} = alucontrol;
    assign {RegWEn,ImmSel,ALUsrc1, ALUsrc2, BrUn, MemRw, ldU, WBSel, PCSel} = controls; 
	


    always@(posedge clk)
        begin 
				BrUn_selection = instr[14] & instr[13]; 
				funct3 = instr[14:12]; 
            opcode = instr[6:0]; 
            case(opcode) //                  RegWEn_ImmSel_ALUsrc1_ALUsrc2_BrUn_MEMRW_ldU_WBSel_PCSel
                7'b0110011 :
					 begin
					 
					 controls <= 15'b1_xxx_0_0_x_0_0_xxx_01_0;  //  R-TYPE OPERATIONS
					 alucontrol = {instr[30],instr[14:12]}; 
					 end
                7'b0010011 : 
					 begin
					 controls <= 15'b1_000_0_1_x_0_0_xxx_01_0; // I-TYPE OPERATIONS
					 if(funct3 == 101) 
						alucontrol = {instr[30],instr[14:12]}; 
					 else 
						alucontrol = {0,instr[14:12]}; 
					 end
                7'b0100011 :
					 begin
					 controls <= 15'b0_001_0_1_x_0_1_xxx_01_0; // S-TYPE OPERATIONS
					 alucontrol = {0,0,0,0}; 
					 end
                7'b1100011 :
					 begin
					 controls <= 15'b0_000_1_1_x_0_0_xxx_01_0; // B-TYPE OPERATIONS
					 alucontrol = {0,0,0,0}; 
					 end 
                7'b0000011 : 
					 begin
					 controls <= 15'b1_000_0_1_x_0_0_xxx_10_0; // LOAD OPERATIONS 
					 alucontrol = {0,0,0,0}; 
					 end 
                7'b1101111 : 
					 begin
					 controls <= 15'b1_000_0_1_x_0_0_xxx_01_0; // JAL OPERATIONS 
					 alucontrol = {0,0,0,0}; 
					 end 
                7'b1100111 : 
					 begin
					 controls <= 15'b1_000_0_1_x_0_0_xxx_01_0; // JALR OPERATIONS 
					 alucontrol = {0,0,0,0}; 
					 end
                7'b0110111 : 
					 begin
					 controls <= 15'b1_000_0_1_x_0_0_xxx_10_0; // LUI OPERATIONS
					 alucontrol = {1,1,1,1}; 
					 end
                7'b0010111 : 
					 begin 
					 controls <= 15'b1_000_1_1_x_0_0_xxx_10_0; // AUIPC 
					 alucontrol = {0,0,0,0}; 
					 end 

            default :
				begin
				controls <= 15'b0_000_0_1_x_0_0_xxx_01_0;// 
				alucontrol = {0,0,0,0}; 
				end
            endcase; 
        end 
		  
		  always@(BrLT, BrEq)
		  begin 
			funct3 = instr[14:12];
			// RegWEn_ImmSel_ALUsrc1_ALUsrc2_BrUn_MEMRW_ldU_WBSel_PCSel
			if(opcode == 7'b1100011) 
			begin 
				if(funct3 == 001 & !BrEq) // BNE
					branch_pcSel = 1; 
			   else if((funct3 == 100 || funct3 == 110)& BrLT) //BLTU and BLT
					branch_pcSel = 1; 
			   else if(funct3 == 000 & BrEq) //BEQ
					branch_pcSel = 1; 
			   else if((funct3 == 101 & funct3 == 111) & !BrLT)  //BGE and BGEU
					branch_pcSel = 1; 
				else 
					branch_pcSel = 0; 
				controls <= {0,0,1,0,1,1,{BrUn},0,0,0,0,0,0,1,{branch_pcSel}};
			end 
								

			end 
	
endmodule 