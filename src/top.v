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
// --------------------------------------------------------------------------------------

`include "baudgen.vh"


module top(
	input [7:0] adin_data,
	output adclk,
	/*output daclk,*/
	output wire serial_data,
	output wire rts,
	output wire cts
	
	/*output [7:0] daout_data*/
);


wire hfosc_clk;
// hfosc_clk frequency =    48 MHz if CLKHF_DIV = "0b00"
//                           24 MHz if CLKHF_DIV = "0b01"
//                           12 MHz if CLKHF_DIV = "0b10"
//                           6  MHz if CLKHF_DIV = "0b11"                       
SB_HFOSC 
#(
  .CLKHF_DIV("0b10")
)
inthosc
(
  .CLKHFPU(1'b1),
  .CLKHFEN(1'b1),
  .CLKHF(hfosc_clk)
);


wire global_hfosc_clk;
SB_GB gbu_hfosc(
  .USER_SIGNAL_TO_GLOBAL_BUFFER(hfosc_clk),
  .GLOBAL_BUFFER_OUTPUT(global_hfosc_clk)
);



wire output_clk_global;
wire output_clk_core;
wire pll_locked;
SB_PLL40_CORE #(
  .FEEDBACK_PATH("SIMPLE"),
  .DELAY_ADJUSTMENT_MODE_FEEDBACK("FIXED"),
  .DELAY_ADJUSTMENT_MODE_RELATIVE("FIXED"),
  .PLLOUT_SELECT("GENCLK"),
  .FDA_FEEDBACK(4'b1111),
  .FDA_RELATIVE(4'b1111),
  .DIVR(1'b0),
  .DIVF(1'b1),
  .DIVQ(1'b1),
  .FILTER_RANGE(3'b010)
) pll (
  .REFERENCECLK(global_hfosc_clk),
  .PLLOUTGLOBAL(output_clk_global),
  .PLLOUTCORE(output_clk_core),
  .LOCK(pll_locked),
  .BYPASS(1'b0),
  .RESETB(1'b1)
);


wire reset = 1'b1;
wire start = 1'b1;
wire serial_data;
wire ready;
wire test = 8'b10010011;
uart_tx transmitter
(
  .clk(output_clk_core),
  .rstn(reset),
  .start(start),
  .data(test),
  .tx(serial_data),
  .ready(ready)
);


assign adclk = output_clk_global;
assign rts = 1'b1;
assign cts = 1'b1;

/*assign daclk = hfosc_clk;*/
/*assign daout_data = adin_data;*/


/*
always @(posedge output_clk_core)
begin
	if (ready == 1) begin
		start <= 1;
	end
	else begin
		start <= 0;
	end

end
*/

endmodule
