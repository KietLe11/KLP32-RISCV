module alu_input_mux_A(pc_in, data1, A_select, out);

    parameter integer n = 32;
    input wire [n-1:0] pc_in, data1;
    input wire A_select;
    output wire [n-1:0] out;

    // Select = 0 => output is data1 from register file
    // Select = 1 => output is result from PC
    assign out = (A_select == 0) ? data1 : pc_in;

endmodule
