module writeback_mux(pc_in, alu_in, mem_in, wb_select, writeback);

    parameter n = 32;
    input [n-1:0] pc_in, alu_in, mem_in;
    input [1:0] wb_select;
    output reg [n-1:0] writeback;

    always @(*) begin
        case (wb_select)
            2'b00: writeback = mem_in;
            2'b01: writeback = alu_in;
            2'b10: writeback = pc_in;
        endcase
    end

endmodule
