module inst_memory32_2 (addr, inst);

    parameter integer n = 32;
    input [n-1:0] addr;
    output reg [n-1:0] inst;

    reg [n-1:0] inst_memory [1023:0]; // 4 kilobytes of instruction memory

    // Hard-code the instructions
    always @(*) begin
        case (addr[11:2]) // Using the upper 10 bits of the address for memory location
            10'd0  : inst = 32'h00000013; // NOP: ADDI x0, x0, 0
            10'd1  : inst = 32'h00500513; // ADDI a0, zero, 5
            10'd2  : inst = 32'h00400793; // LI a5, 4
            10'd3  : inst = 32'h40F50533; // SUB a0, a0, a5
            10'd4  : inst = 32'h00A7F833; // AND a6, a5, a0
            10'd5  : inst = 32'h00A7F033; // OR a6, a5, a0
            default: inst = 32'b0;        // Default case (NOP or no-op for other addresses)
        endcase
    end

endmodule
