// --------------------------------------------------------------------------------------
// Organization: CALPLUG-FPGA
// Project Name:
// Date: Winter 2019
// FPGA Board: iCE40 UltraPlus SG48I
// --------------------------------------------------------------------------------------
// File Name: top.v
// File Description: This is the top module implementing the internal logic of FPGA
// --------------------------------------------------------------------------------------
// IMPORTANT NOTE FOR SYNTHESIS!!!
// Please Use the Following command to synthesize the top module:
// /*  yosys -p "read_verilog baudgen_tx.v; read_verilog uart_tx.v; read_verilog top.v; synth_ice40 -blif top.blif"    */
// /*  arachne-pnr -d 5k -p ice40_top.pcf -o top.txt top.blif                                                          */

module top(
	input [7:0] adin_data,
	output adclk,
	/*output daclk,*/
	output reg serial_data
	/*output [7:0] daout_data*/
);


wire hfosc_clk;


// hfosc_clk frequency =    48 MHz if CLKHF_DIV = "0b00"
//                           24 MHz if CLKHF_DIV = "0b01"
//                           12 MHz if CLKHF_DIV = "0b10"
//                           6  MHz if CLKHF_DIV = "0b11"                       
SB_HFOSC 
#(
  .CLKHF_DIV("0b01")
)
inthosc
(
  .CLKHFPU(1'b1),
  .CLKHFEN(1'b1),
  .CLKHF(hfosc_clk)
);
/*
SB_PLL40_PAD #(
  .FEEDBACK_PATH("SIMPLE"),
  .DELAY_ADJUSTMENT_MODE_FEEDBACK("FIXED"),
  .DELAY_ADJUSTMENT_MODE_RELATIVE("FIXED"),
  .PLLOUT_SELECT("GENCLK"),
  .FDA_FEEDBACK(4'b1111),
  .FDA_RELATIVE(4'b1111),
  .DIVR(4'b0011),
  .DIVF(7'b0101000),
  .DIVQ(3'b101),
  .FILTER_RANGE(3'b010)
) pll (
  .PACKAGEPIN(clk_100mhz),
  .PLLOUTGLOBAL(clk_32mhz),
  .LOCK(pll_locked),
  .BYPASS(1'b0),
  .RESETB(1'b1)
);
*/

wire reset;
wire start;
reg start_reg;
reg serial_data;
reg ready;

uart_tx transmitter
(
	.clk(hfosc_clk),
	.rstn(reset),
	.start(start),
	.data(adin_data),
	.tx(serial_data),
	.ready(ready)
);


assign adclk = hfosc_clk;
/*assign daclk = hfosc_clk;*/
/*assign daout_data = adin_data;*/

assign start = start_reg;

always @(posedge hfosc_clk)
begin
	if (ready == 1) begin
		start_reg <= 1;
	end
	else begin
		start_reg <= 0;
	end

end

endmodule
