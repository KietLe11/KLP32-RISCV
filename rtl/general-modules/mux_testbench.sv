`timescale 1ns/1ps
module mux_testbench;

    parameter BIT_WIDTH = 32;

    // Signals for 3-to-1 MUX
    logic [BIT_WIDTH-1:0] in0_3, in1_3, in2_3;
    logic [1:0]           sel_3;
    logic [BIT_WIDTH-1:0] out_3;

    // Signals for 2-to-1 MUX
    logic [BIT_WIDTH-1:0] in0_2, in1_2;
    logic                 sel_2;
    logic [BIT_WIDTH-1:0] out_2;

    // Instantiate 3-to-1 MUX
    three_one_mux  u_three_one_mux (
        .in0(in0_3),
        .in1(in1_3),
        .in2(in2_3),
        .control(sel_3),
        .mux_out(out_3)
    );

    // Instantiate 2-to-1 MUX
    two_one_mux  u_two_one_mux (
        .in0(in0_2),
        .in1(in1_2),
        .control(sel_2),
        .mux_out(out_2)
    );

    // Test sequence
    initial begin
        $display("Starting MUX testbench...");
        // Initialize inputs
        in0_3 = 8'hAA; in1_3 = 8'hBB; in2_3 = 8'hCC;
        in0_2 = 8'h11; in1_2 = 8'h22; in0_2 =8'h12;

        // Test 3-to-1 mux
        sel_3 = 2'b00; #10;
        $display("3-to-1 MUX: sel=%b -> out=%h (expected %h)", sel_3, out_3, in0_3);
        sel_3 = 2'b01; #10;
        $display("3-to-1 MUX: sel=%b -> out=%h (expected %h)", sel_3, out_3, in1_3);
        sel_3 = 2'b10; #10;
        $display("3-to-1 MUX: sel=%b -> out=%h (expected %h)", sel_3, out_3, in2_3);
        sel_3 = 2'b11; #10;
        $display("3-to-1 MUX: sel=%b -> out=%h (expected %h)", sel_3, out_3, '0);

        // Test 2-to-1 mux
        sel_2 = 1'b0; #10;
        $display("2-to-1 MUX: sel=%b -> out=%h (expected %h)", sel_2, out_2, in0_2);
        sel_2 = 1'b1; #10;
        $display("2-to-1 MUX: sel=%b -> out=%h (expected %h)", sel_2, out_2, in1_2);

        $display("Testbench completed.");
        $finish;
    end

endmodule

