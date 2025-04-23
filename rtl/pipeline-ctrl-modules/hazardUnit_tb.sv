module hazardUnit_tb;

    // Inputs
    logic [6:0] IX_OPCODE;
    logic [4:0] ID_RS1, ID_RS2, IX_RS1, IX_RS2, IX_RD, IM_RD, IW_RD;
    logic       MEM_RDY;

    // Output
    logic stall;

    // Instantiate DUT
    hazardUnit dut (
        .ID_RS1(ID_RS1),
        .ID_RS2(ID_RS2),
        .IX_RS1(IX_RS1),
        .IX_RS2(IX_RS2),
        .IX_RD(IX_RD),
        .IM_RD(IM_RD),
        .IW_RD(IW_RD),
        .MEM_RDY(MEM_RDY),
        .IX_OPCODE(IX_OPCODE),
        .stall(stall)
    );

    initial begin
        $display("=== Starting hazardUnit Testbench ===");

        // Test 1: Load-use hazard (IX_OPCODE = LOAD, ID_RS1 == IX_RD)
        ID_RS1 = 5'd10; ID_RS2 = 5'd20;
        IX_RD = 5'd10;
        IX_OPCODE = 7'b0000011;  // Load
        MEM_RDY = 1;
        #10;
        $display("Test 1: Stall = %b (expected 1)", stall);

        // Test 2: No hazard (different regs)
        ID_RS1 = 5'd5; ID_RS2 = 5'd6;
        IX_RD = 5'd7;
        IX_OPCODE = 7'b0000011;  // Load
        MEM_RDY = 1;
        #10;
        $display("Test 2: Stall = %b (expected 0)", stall);

        // Test 3: MEM not ready
        MEM_RDY = 0;
        #10;
        $display("Test 3: Stall = %b (expected 1)", stall);

        // Test 4: ID_RS2 == IX_RD, still a hazard
        MEM_RDY = 1;
        ID_RS2 = 5'd7;
        IX_RD = 5'd7;
        IX_OPCODE = 7'b0000011;
        #10;
        $display("Test 4: Stall = %b (expected 1)", stall);

        // Test 5: IX_OPCODE is store — no stall even if reg matches
        IX_OPCODE = 7'b0100011;  // Store
        #10;
        $display("Test 5: Stall = %b (expected 0)", stall);

        $display("=== Testbench Completed ===");
        $finish;
    end

endmodule
