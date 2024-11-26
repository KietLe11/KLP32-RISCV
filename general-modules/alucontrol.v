module alucontrol(instr,alusel); 
    input logic [31:0] instr; 
    output logic [3:0] alusel; 
    reg [3:0] aluinstr; 


    always@(*)
        begin 
        alusinstr = {instr[30],instr[14:12]};
            case(aluinstr)
            4'b0000 : alusel = alusinstr;
            4'b1000 : alusel = alusinstr;
            4'b0001 : alusel = alusinstr;
            4'b0010 : alusel = alusinstr;
            4'b0011 : alusel = alusinstr;
            4'b0100 : alusel = alusinstr;
            4'b0101 : alusel = alusinstr;
            4'b1101 : alusel = alusinstr;
            4'b0110 : alusel = alusinstr;
            4'b0111 : alusel = alusinstr;
            4'b1111 : alusel = alusinstr;
        end 
endmodule 