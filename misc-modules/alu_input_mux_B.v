module alu_input_mux_B(data2, immGenData, B_select, out);

    parameter n = 32;
    input wire [n-1:0] data2, immGenData;
    input wire B_select;
    output wire [n-1:0] out;

    // Select = 0 => output is data2 from register file
    // Select = 1 => output is result from immediate generator
    assign out = (B_select == 0) ? data2 : immGenData;

endmodule
