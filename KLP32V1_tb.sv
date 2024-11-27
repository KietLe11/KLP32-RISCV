`timescale 1ns/1ps
module KLP32V1_tb();

    logic clk, reset;

    KLP32V1 KLP32(.clk(clk), .reset(reset));

    // Generate clock
    initial clk = 0;
    always #10 clk = ~clk; // 20 ns clock period

	initial begin
        reset = 1;
        #10;
        reset = 0;
    end

endmodule
