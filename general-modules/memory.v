module memory (clk, write_enable, addr, write_data, read_data);

    parameter n = 32;
    input clk;
    input write_enable;
    input [n-1:0] addr, write_data;
    output reg [n-1:0] read_data;

    reg [n-1:0] memory_block [0:1023]; // 4 kilobytes of memory

    // Initialize all registers to zero
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            memory_block[i] = 32'b0;
        end
    end

    // 4 kilobytes has 10 bit addresses => addr[9:0]
    always @(posedge clk) begin
        if (write_enable)
            memory_block[addr[9:0]] <= write_data;
        else
            read_data <= memory_block[addr[9:0]];
    end

endmodule
