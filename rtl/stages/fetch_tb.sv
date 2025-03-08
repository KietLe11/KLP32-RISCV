`timescale 1ns/1ps
module fetch_tb();

    logic clk, reset;
    logic [31:0] alu_in;
    logic pc_select;

    logic [31:0] pc_inc_out, pc_out, inst;

    fetch F(.clk(clk),
            .reset(reset),
            .i_alu_in(alu_in),
            .i_pc_sel(pc_select),
            .o_fetch_pc_inc(pc_inc_out),
            .o_fetch_pc(pc_out),
            .o_fetch_inst(inst)
            );

    initial clk = 0;
    always #10 clk = ~clk;

    initial begin
        reset = 1'b1;
        alu_in = 32'b0;
        pc_select = 1'b0;
        @(posedge clk);

        reset = 1'b0;
        @(posedge clk);

        #500;

    end

endmodule