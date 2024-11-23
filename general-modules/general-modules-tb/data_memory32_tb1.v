// Testing all memory addresses

`timescale 1 ns/1 ps
module data_memory32_tb1();

    parameter n = 32;
    reg [n-1:0] addr;
    reg [n-1:0] write_data;
    reg write_enable;
    wire [n-1:0] read_data;
    reg clk;

    data_memory32 dut(.clk(clk), .write_enable(write_enable), .addr(addr), .write_data(write_data), .read_data(read_data));

    always begin
        clk = 1'b1;
        #1;
        clk = 1'b0;
        #1;
    end

    // Test procedure
    initial begin
        // Initialize signals
        addr = 0;
        write_data = 0;
        write_enable = 0;

        // Wait for global reset
        #10;
    end

    // Test all 1024 memory addresses for 0 data
    integer i;
    initial begin
        $display("Starting memory test...");
        for (i = 0; i < 1024; i = i + 1) begin
            addr = i;
            #1; // Wait for data_out to update
            if (read_data !== 32'b0) begin
                $display("Test failed at address %0d: value = %h", i, read_data);
            end
        end
        $display("All memory registers are set to 0. Test passed!");
    end

endmodule
