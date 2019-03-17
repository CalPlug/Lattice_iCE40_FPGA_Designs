// --------------------------------------------------------------------------------------
// Organization: CALPLUG-FPGA
// Project Name:
// Date: Winter 2019
// FPGA Board: iCE40 UltraPlus SG48I
// --------------------------------------------------------------------------------------
// File Name: clock_divider.v
// File Description: This is a clock divider module
// --------------------------------------------------------------------------------------
//	FORMULA:
//		divided_clk.frequency = input_clk.frequency / (2*divisor)
// --------------------------------------------------------------------------------------

module CLOCK_DIVIDER
#(
	parameter DIVISOR = 4'b0000
)
(
	input wire INPUT_CLK,
	output reg DIVIDED_CLK
);


reg [3:0] counter = 4'b0000; // Initialization
reg DIVIDED_CLK = 1'b0; // Initialization

always @(posedge INPUT_CLK)
begin
	counter <= counter + 1;
end

always @(counter)
begin
	if (counter == DIVISOR)
	begin
		DIVIDED_CLK <= ~DIVIDED_CLK;
		counter <= 4'b0000;
	end
end




endmodule
