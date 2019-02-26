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

`include "OV7670_Camera/camera_config.v"
`include "OV7670_Camera/I2C_Interface.v"
`include "OV7670_Camera/camera_controller.v"



module top(
	input wire [7:0] PIXEL		,
	input wire VSYNC			,
	input wire HREF				,
	input wire PCLK				,
	output wire SIOC			,
	inout wire SIOD				,
	output wire XCLK			
	
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
assign XCLK = global_clk;



wire reset_cam = 1'b0;
wire config_finished;
CAMERA_CONTROLLER cam(
	.GLOBAL_CLK(global_clk),
	.RESET(reset_cam),
	.SIOD(SIOD),
	.SIOC(SIOC),
	.CONFIG_FINISHED(config_finished)
);



endmodule
