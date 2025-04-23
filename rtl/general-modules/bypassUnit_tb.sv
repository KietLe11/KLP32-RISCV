module bypassUnit_tb;

    // Declare inputs
    logic [4:0] IM_RS2, IX_RS1, IX_RS2, IX_RD, IM_RD, IW_RD;

    // Declare outputs
    logic [1:0] a_sel_mux, b_sel_mux;
    logic data_sel_mux;

    // Instantiate the DUT
    bypassUnit dut (
        .IM_RS2(IM_RS2),
        .IX_RS1(IX_RS1),
        .IX_RS2(IX_RS2),
        .IX_RD(IX_RD),
        .IM_RD(IM_RD),
        .IW_RD(IW_RD),
        .a_sel_mux(a_sel_mux),
        .b_sel_mux(b_sel_mux),
        .data_sel_mux(data_sel_mux)
    );

    // Test sequence
    initial begin
        $display("=== Starting bypassUnit Testbench ===");

        // Test Case 1: No matches
        IM_RS2 = 5'd1; IX_RS1 = 5'd2; IX_RS2 = 5'd3;
        IM_RD = 5'd4; IW_RD = 5'd5;
        #10;
        $display("Case 1: a_sel_mux = %b, b_sel_mux = %b, data_sel_mux = %b", a_sel_mux, b_sel_mux, data_sel_mux);

        // Test Case 2: IX_RS1 == IM_RD
        IX_RS1 = 5'd4;
        #10;
        $display("Case 2: a_sel_mux = %b (expected 01)", a_sel_mux);

        // Test Case 3: IX_RS1 == IW_RD
        IX_RS1 = 5'd5;
        #10;
        $display("Case 3: a_sel_mux = %b (expected 10)", a_sel_mux);

        // Test Case 4: IX_RS2 == IM_RD
        IX_RS2 = 5'd4;
        #10;
        $display("Case 4: b_sel_mux = %b (expected 01)", b_sel_mux);

        // Test Case 5: IX_RS2 == IW_RD
        IX_RS2 = 5'd5;
        #10;
        $display("Case 5: b_sel_mux = %b (expected 10)", b_sel_mux);

        // Test Case 6: IM_RS2 == IW_RD
        IM_RS2 = 5'd5;
        #10;
        $display("Case 6: data_sel_mux = %b (expected 1)", data_sel_mux);

        // Test Case 7: All conditions hit
        IM_RS2 = 5'd9; IX_RS1 = 5'd6; IX_RS2 = 5'd7;
        IM_RD = 5'd6; IW_RD = 5'd7;
        #10;
        $display("Case 7: a_sel_mux = %b (expected 01), b_sel_mux = %b (expected 10)", a_sel_mux, b_sel_mux);

        $display("=== Testbench Completed ===");
        $finish;
    end

endmodule