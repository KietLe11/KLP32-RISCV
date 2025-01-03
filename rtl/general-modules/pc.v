module pc (clk, reset, pc_in, pc_out);

    parameter integer n = 32;
    input wire [n-1:0] pc_in;
    input wire clk, reset;
    output reg [n-1:0] pc_out;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out <= 32'd0;
        end else begin
            pc_out <= pc_in;
        end
    end

endmodule
