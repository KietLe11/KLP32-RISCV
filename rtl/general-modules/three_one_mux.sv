module three_one_mux #parameter(BIT_WIDTH)( 
    input logic [BIT_WIDTH-1: 0] in0, 
    input logic [BIT_WIDTH-1: 0] in1, 
    input logic [BIT_WIDTH-1: 0] in2, 
    input logic [1:0] control, 
    output logic mux_out,
); 

always_comb
    begin 
        if(control == 2'b00)
            mux_out = in0; 
        end 
        if(control == 2'b01)
            mux_out = in1; 
        end 
        if(control == 2'b10)
            mux_out = in2; 
        end 

    end 

endmodule