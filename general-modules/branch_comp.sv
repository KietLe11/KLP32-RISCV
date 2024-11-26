module branch_comp(data1, data2, BrUn, BrEq, BrLT);

    parameter n = 32;
    input logic [n-1:0] data1, data2;
    input logic BrUn;
    output logic BrEq, BrLT;

    logic [n-1:0] slt_u_out, slt_out;

    slt slt_Signed(.X(data1), .Y(data2), .result(slt_out));
    slt_u slt_Unsigned(.X(data1), .Y(data2), .result(slt_u_out));

    assign BrEq = (data1 == data2);
    assign BrLT = (BrUn) ? slt_u_out[0] : slt_out[0];

endmodule
