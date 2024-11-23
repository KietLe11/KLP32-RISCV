module pc_increment (pc_in, pc_out);

    parameter n = 32;
    input [n-1:0] pc_in;
    output [n-1:0] pc_out;

    assign pc_out = pc_in + 32'd4;

endmodule
