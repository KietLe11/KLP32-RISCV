module registers32 (clk, read_addr1, read_addr2, write_addr, write_data, write_enable, read_data1, read_data2);

    parameter n = 32;
    input clk;
    input [4:0] read_addr1, read_addr2, write_addr;
    input [n-1:0] write_data;
    input write_enable;
    output [n-1:0] read_data1;
    output [n-1:0] read_data2;

    reg [31:0] gpr [n-1:0]; // All riscv specifications have 32 GPRs

    // Initialize all registers to zero
    integer i;
    initial begin
        for (i = 0; i < n; i = i + 1) begin
            gpr[i] = 32'b0; // Set all registers to 0
        end
    end

    // Output requested registers
    assign read_data1 = gpr[read_addr1];
    assign read_data2 = gpr[read_addr2];

    always @(posedge clk) begin
        if (write_enable & write_addr != 5'd0) begin
            gpr[write_addr] <= write_data;
        end
    end

endmodule
