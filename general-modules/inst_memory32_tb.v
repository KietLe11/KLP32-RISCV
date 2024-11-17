`timescale 1 ns/1 ps
module inst_memory32_tb();

    parameter n = 32;
    reg [n-1:0] addr;
    wire [n-1:0] inst;
    reg clk;

    inst_memory32 dut(.addr(addr), .inst(inst));

    always begin
        clk = 1'b1;
        #10;
        clk = 1'b0;
        #10;
    end

    integer i;
    initial begin
        $display("Starting memory test...");
        for (i = 0; i < 20; i = i + 1) begin
            addr = i;
            #1; // Wait for data_out to update
            $display("address %0d: value = %h", i, inst);
        end
    end

endmodule
