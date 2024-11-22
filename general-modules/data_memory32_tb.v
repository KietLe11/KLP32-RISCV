`timescale 1 ns/1 ps
module data_memory32_tb();

    parameter n = 32;
    reg [n-1:0] addr;
    reg [n-1:0] write_data;
    reg write_enable;
    wire [n-1:0] read_data;
    reg clk;

    data_memory32 dut(.clk(clk), .write_enable(write_enable), .addr(addr), .write_data(write_data), .read_data(read_data));

    always begin
        clk = 1'b1;
        #10;
        clk = 1'b0;
        #10;
    end

    // Test procedure
    initial begin
        // Initialize signals
        addr = 0;
        write_data = 0;
        write_enable = 0;

        // Wait for global reset
        #20;

        // Test Case 1: Write to register and verify read data
        write_enable = 1;
        addr = 10'd1;     // Choose address 1 for this test
        write_data = 32'hDEADBEEF;
        #20;                   // Wait for write to complete

        write_enable = 0;      // Disable write
        addr = 10'd1;     // Set read address to match written address
        #20;

        // Test Case 1: Check if data is read correctly
        if (read_data == 32'hDEADBEEF) begin
            $display("Test Case 1 Passed: Correct data read from address 1");
        end else begin
            $display("Test Case 1 Failed: Incorrect data read from address 1");
        end

        // Test Case 2: Write to another register and verify data isolation
        write_enable = 1;
        addr = 10'd2;     // Write to address 2
        write_data = 32'h12345678;
        #20;

        write_enable = 0;
        addr = 10'd2;
        #20;

        if (read_data == 32'h12345678) begin
            $display("Test Case 2.1 Passed: Data correctly isolated between registers 1 and 2");
        end else begin
            $display("Test Case 2.1 Failed: Data isolation error between registers 1 and 2");
        end

        write_enable = 0;
        addr = 10'd1;
        #20;

        if (read_data == 32'hDEADBEEF) begin
            $display("Test Case 2.2 Passed: Data correctly isolated between registers 1 and 2");
        end else begin
            $display("Test Case 2.2 Failed: Data isolation error between registers 1 and 2");
        end

        // Test Case 3: Attempt read from unwritten address
        addr = 10'd3;     // Choose an address that hasn't been written to
        #20;

        if (read_data == 0) begin
            $display("Test Case 3 Passed: Unwritten address returns zero");
        end else begin
            $display("Test Case 3 Failed: Unwritten address did not return zero");
        end

        // Test Case 4: Read should combinational (change mid clock cycle)
        write_enable = 1;
        addr = 10'd4;
        write_data = 32'h91827364;
        #5;
        write_enable = 0;
        addr = 10'd1;
        #1;

        if (read_data == 32'hDEADBEEF) begin
            $display("Test Case 4 Passed: Read should change mid cycle");
        end else begin
            $display("Test Case 4 Failed: Read should change mid cycle");
        end

    end

endmodule
