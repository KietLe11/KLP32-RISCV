`timescale 1 ns/1 ps
module register32_tb();

    parameter n = 32;
    reg [4:0] read_addr1, read_addr2, write_addr;
    reg  [n-1:0] write_data;
    reg write_enable;
    wire [n-1:0] read_data1;
    wire [n-1:0] read_data2;
    reg clk;

    registers32 dut(.clk(clk), .read_addr1(read_addr1), .read_addr2(read_addr2), .write_addr(write_addr), .write_data(write_data), .write_enable(write_enable), .read_data1(read_data1), .read_data2(read_data2));

    always begin
        clk = 1'b1;
        #10;
        clk = 1'b0;
        #10;
    end

    // Test procedure
    initial begin
        // Initialize signals
        write_enable = 0;
        write_addr = 0;
        write_data = 0;
        read_addr1 = 0;
        read_addr2 = 0;

        // Wait for global reset
        #20;

        // Test Case 1: Write to register and verify read data
        write_enable = 1;
        write_addr = 5'd1;     // Choose address 1 for this test
        write_data = 32'hDEADBEEF;
        #20;                   // Wait for write to complete

        write_enable = 0;      // Disable write
        read_addr1 = 5'd1;     // Set read address to match written address
        #20;

        // Test Case 1: Check if data is read correctly
        if (read_data1 == 32'hDEADBEEF) begin
            $display("Test Case 1 Passed: Correct data read from address 1");
        end else begin
            $display("Test Case 1 Failed: Incorrect data read from address 1");
        end

        // Test Case 2: Write to another register and verify data isolation
        write_enable = 1;
        write_addr = 5'd2;     // Write to address 2
        write_data = 32'h12345678;
        #20;

        write_enable = 0;
        read_addr1 = 5'd2;
        read_addr2 = 5'd1;     // Read from both addresses 1 and 2 to check isolation
        #20;

        if (read_data1 == 32'h12345678 && read_data2 == 32'hDEADBEEF) begin
            $display("Test Case 2 Passed: Data correctly isolated between registers 1 and 2");
        end else begin
            $display("Test Case 2 Failed: Data isolation error between registers 1 and 2");
        end

        // Test Case 3: Attempt read from unwritten address
        read_addr1 = 5'd3;     // Choose an address that hasn't been written to
        #20;

        if (read_data1 == 0) begin
            $display("Test Case 3 Passed: Unwritten address returns zero");
        end else begin
            $display("Test Case 3 Failed: Unwritten address did not return zero");
        end

        // Test Case 4: Write and Read to same address
        write_enable = 1;
        write_addr = 5'd4;
        write_data = 32'h76767676;
        read_addr1 = 5'd4;
        read_addr2 = 5'd4;
        #20;

        if (read_data1 == 32'h76767676 && read_data2 == 32'h76767676) begin
            $display("Test Case 4 Passed: Return write data if read is same address as write address");
        end else begin
            $display("Test Case 4 Failed: Return write data was not read out");
        end

    end

endmodule
