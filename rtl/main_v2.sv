module main_v2 (clk, reset_in);

    input clk, reset_in;
    logic reset;

    // Button on DE10 lite is default high unpressed
    // Change according to needs
    assign reset = ~reset_in;

    KLP32V2 processor(
        .clk(second_clk),
        .reset(reset)
    );

endmodule
