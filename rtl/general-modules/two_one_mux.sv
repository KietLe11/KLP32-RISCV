module two_one_mux #parameter(BIT_WIDTH)(
    input logic [BIT_WIDTH-1: 0] in0, 
    input logic [BIT_WIDTH-1: 0] in1, 
    output logic mux_out, 
); 

always_comb
    begin
    mux_out = (control) ? in1 : in0;
    end 

endmodule