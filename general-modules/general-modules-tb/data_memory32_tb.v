`timescale 1 ns/1 ps
module data_memory32_tb();

    parameter integer n = 32;
    reg [n-1:0] addr;
    reg [n-1:0] write_data;
    reg write_enable;
    reg [2:0] loadStoreMode;
    wire [n-1:0] read_data;
    reg clk;

    data_memory32 dut(.clk(clk),
                        .write_enable(write_enable),
                        .addr(addr),
                        .write_data(write_data),
                        .loadStoreMode(loadStoreMode),
                        .read_data(read_data));

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
        loadStoreMode = 0;

        // Wait for global reset
        #20;

        // Test Case 1: Write to register and verify read data
        write_enable = 1;
        addr = 32'd0;     // Choose address 1 for this test
        write_data = 32'hDEADBEEF;
        loadStoreMode = 3'b010;
        #20;                   // Wait for write to complete

        write_enable = 0;      // Disable write
        addr = 32'd0;     // Set read address to match written address
        #20;

        // Test Case 1: Check if data is read correctly
        if (read_data == 32'hDEADBEEF) begin
            $display("Test Case 1 Passed: Correct data read from address 1");
        end else begin
            $display("Test Case 1 Failed: Incorrect data read from address 1");
        end

        // Test Case 2: Write to another register and verify data isolation
        write_enable = 1;
        addr = 32'd4;     // Write to address 2
        write_data = 32'h12345678;
        loadStoreMode = 3'b010;
        #20;

        write_enable = 0;
        addr = 32'd4;
        #20;

        if (read_data == 32'h12345678) begin
            $display("Test Case 2.1 Passed: Data correctly isolated between registers 1 and 2");
        end else begin
            $display("Test Case 2.1 Failed: Data isolation error between registers 1 and 2");
        end

        write_enable = 0;
        addr = 32'd0;
        loadStoreMode = 3'b010;
        #20;

        if (read_data == 32'hDEADBEEF) begin
            $display("Test Case 2.2 Passed: Data correctly isolated between registers 1 and 2");
        end else begin
            $display("Test Case 2.2 Failed: Data isolation error between registers 1 and 2");
        end

        // Test Case 3: Attempt read from unwritten address
        addr = 32'd8;     // Choose an address that hasn't been written to
        loadStoreMode = 3'b010;
        #20;

        if (read_data == 0) begin
            $display("Test Case 3 Passed: Unwritten address returns zero");
        end else begin
            $display("Test Case 3 Failed: Unwritten address did not return zero");
        end

        // Test Case 4: Read should combinational (change mid clock cycle)
        write_enable = 1;
        addr = 32'd8;
        write_data = 32'h91827364;
        loadStoreMode = 3'b010;
        #5;
        write_enable = 0;
        addr = 32'd0;
        #1;

        if (read_data == 32'hDEADBEEF) begin
            $display("Test Case 4 Passed: Read should change mid cycle");
        end else begin
            $display("Test Case 4 Failed: Read should change mid cycle");
        end

        // #16;

        // Test Case 5: Store/Load Byte Unsigned (SB/LBU)
        write_enable = 1;
        addr = 32'd12;
        write_data = 32'b10101010;
        loadStoreMode = 3'b100;
        #20;
        write_enable = 0;
        #20;

        if (read_data == 32'b10101010) begin
            $display("[PASS] Test Case 5: Load Byte Unsigned");
        end else begin
            $display("[FAIL] Test Case 5: Load Byte Unsigned");
        end

        // Test Case 6: Store/Load Byte Signed (SB/LB)
        write_enable = 1;
        addr = 32'd16;
        write_data = 32'b10101010;
        loadStoreMode = 3'b000;
        #20;
        write_enable = 0;
        #20;

        if (read_data == 32'b11111111111111111111111110101010) begin
            $display("[PASS] Test Case 6: Load Byte Signed");
        end else begin
            $display("[FAIL] Test Case 6: Load Byte Signed");
        end

        // Test Case 7: Load HalfWord Unsigned (SH/LHU)
        write_enable = 1;
        addr = 32'd20;
        write_data = 32'b1010101010101010;
        loadStoreMode = 3'b101;
        #20;
        write_enable = 0;
        #20;

        if (read_data == 32'b00000000000000001010101010101010) begin
            $display("[PASS] Test Case 7: Load HalfWord Unsigned");
        end else begin
            $display("[FAIL] Test Case 7: Load HalfWord Unsigned");
        end

        // Test Case 7: Store/Load HalfWord Signed (SH/LH)
        write_enable = 1;
        addr = 32'd24;
        write_data = 32'b1010101010101010;
        loadStoreMode = 3'b001;
        #20;
        write_enable = 0;
        #20;

        if (read_data == 32'b11111111111111111010101010101010) begin
            $display("[PASS] Test Case 7: Load HalfWord Signed");
        end else begin
            $display("[FAIL] Test Case 7: Load HalfWord Signed");
        end

    end

endmodule
