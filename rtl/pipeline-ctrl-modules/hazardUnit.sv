module hazardUnit (
    input logic [6:0] IX_OPCODE,
    input logic [4:0] ID_RS1,
    input logic [4:0] ID_RS2,
    input logic [4:0] IX_RS1,
    input logic [4:0] IX_RS2,
    input logic [4:0] IX_RD,
    input logic [4:0] IM_RD,
    input logic [4:0] IW_RD,
    input logic MEM_RDY,
    output logic stall
);

    always_comb begin
        // Stall if there is a load use hazard
        stall = (IX_OPCODE == 7'b0000011) && (ID_RS1 == IX_RD) ||
        (ID_RS2 == IX_RD) && (IX_OPCODE != 7'b0100011) || !MEM_RDY;
    end

endmodule
