module Clock (
    input wire clk_in,

    output reg clk_out
);

parameter DIVISOR = 25_000_000;
reg [25:0] counter;

always @(posedge clk_in) begin
	if (counter == DIVISOR - 1) begin
		clk_out <= ~clk_out; // Toggle output Clock
		counter <= 0;
	end else begin
		counter <= counter + 1; // Increment counter
	end
end

endmodule