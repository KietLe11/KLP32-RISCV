module three_one_mux(
    input  logic [31:0] in0,
    input  logic [31:0] in1,
    input  logic [31:0] in2,
    input  logic [1:0] control,
    output logic [31:0] mux_out
);

    always_comb begin
        case (control)
            2'b00: mux_out = in0;
            2'b01: mux_out = in1;
            2'b10: mux_out = in2;
            default: mux_out = '0; // Default to zero if control is invalid
        endcase
    end

endmodule
