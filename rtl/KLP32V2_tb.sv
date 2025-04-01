`timescale 1ns/1ps
module KLP32V2_tb();

    logic clk, reset;

    KLP32V2 processor(
        .clk(clk),
        .reset(reset)
    );

    initial clk = 0;
    always #10 clk = ~clk;

    initial begin

        reset = 1;
        #10;
        reset = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);

        #700;

    end

endmodule
