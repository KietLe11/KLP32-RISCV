module inst_memory32 (addr, inst);

    parameter n = 32;
    input [n-1:0] addr;
    output reg [n-1:0] inst;

    reg [n-1:0] inst_memory [1023:0]; // 4 kilobytes of instruction memory

    // Initialize all instruction memory to 0
    integer i;
    initial begin
        for (i=0; i<1024; i = i + 1) begin
            inst_memory[i] = 32'b0;
        end
        // Load instructions from the file
        $readmemh("test_instructions.hex", inst_memory);
    end

    always @(*) begin
        // 4KB has 10 bit address space
        inst = inst_memory[addr[9:0]];
    end

endmodule
