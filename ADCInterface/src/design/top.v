// --------------------------------------------------------------------------------------
// Organization: CALPLUG-FPGA
// Project Name:
// Date: Winter 2019
// FPGA Board: iCE40 UltraPlus SG48I
// --------------------------------------------------------------------------------------
// File Name: top.v
// File Description: This is the top module implementing the internal logic of FPGA
// --------------------------------------------------------------------------------------

`include "fft_controller.v"


module top(
	input wire [7:0] adin_data,
    input wire rst;
	output wire [7:0] daout_data,
	output wire adclk,
	output wire daclk, 
    output wire txline,
);


wire hfosc_clk;
// hfosc_clk frequency =    48 MHz if CLKHF_DIV = "0b00"
//                           24 MHz if CLKHF_DIV = "0b01"
//                           12 MHz if CLKHF_DIV = "0b10"
//                           6  MHz if CLKHF_DIV = "0b11"
// WARNING: Other clock in the modules has dependency on the hfosc_clk. 
// WARNING: BE CAREFUL if attempt to change the hfosc_clk.                        
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
  .PLLOUTGLOBAL(global_clk),
  .PLLOUTCORE(core_clk),
  .LOCK(pll_locked),
  .BYPASS(1'b0),
  .RESETB(1'b1)
);

wire start = 1'b0;
wire [7:0] fft_out_0;
wire [7:0] fft_out_1;
wire fft_clk;

fft_controller fft
(
	.global_clk(global_clk),
	.start(start),
	.sampled_in_0(8'b00000001),
	.sampled_in_1(8'b00000001),
	.fft_out_0(fft_out_0),
	.fft_out_1(fft_out_1),
	.fft_clk(fft_clk)

);


assign adclk = hfosc_clk;
assign daclk = hfosc_clk;
assign doout_data = ~adin_data;

wire rdy;
reg start;

uart_tx uart_tx1(
    .clk (hfosc_clk) ,
    .rst (rst)    ,
    .start (start)  ,
    .data (//from buffer)  ,
    .tx (txline)  ,
    .ready (rdy)  ,
);


endmodule
