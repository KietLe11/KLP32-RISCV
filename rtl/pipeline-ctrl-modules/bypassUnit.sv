module bypassUnit (
    input  logic [4:0] IM_RS2,
    input  logic [4:0] IX_RS1,
    input  logic [4:0] IX_RS2,
    input  logic [4:0] IX_RD,
    input  logic [4:0] IM_RD,
    input  logic [4:0] IW_RD,
    output logic [1:0] a_sel_mux,
    output logic [1:0] b_sel_mux,
    output logic data_sel_mux
);

    always_comb begin
        a_sel_mux = 2'b00;
        b_sel_mux = 2'b00;
        data_sel_mux = 1'b0;

        if (IX_RS1 == IM_RD)
            a_sel_mux = 2'b01;
        if (IX_RS1 == IW_RD)
            a_sel_mux = 2'b10;
        if (IX_RS2 == IM_RD)
            b_sel_mux = 2'b01;
        if (IX_RS2 == IW_RD)
            b_sel_mux = 2'b10;
        if (IM_RS2 == IW_RD)
            data_sel_mux = 1'b1;
    end

endmodule
