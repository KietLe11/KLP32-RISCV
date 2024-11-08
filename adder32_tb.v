`timescale 1 ns/1 ps

module adder32_tb();

reg [31:0] a;
reg [31:0] b;

wire [31:0] c;
wire d;

adder32 dut(.carryin(0), .X(a), .Y(b), .S(c), .carryout(d));

initial
begin

    $display("Testing adder32 module");

    a = 0;
    b = 0;
    #20; // 20 ns

    if (c != 0)
        $display("0 + 0 should be 0");

    a = 1;
    b = 1;
    #20; // 20 ns

    if (c != 32'd2)
        $display("1 + 1 should be 0");

    a = 32'd0;
    b = 32'd1;
    #20; // 20 ns

    if (c != 32'd1)
        $display("0 + 1 should be 1");

end

endmodule
