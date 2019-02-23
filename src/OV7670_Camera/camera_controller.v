// --------------------------------------------------------------------------------------
// Organization: CALPLUG-FPGA
// Project Name:
// Date: Winter 2019
// FPGA Board: iCE40 UltraPlus SG48I
// --------------------------------------------------------------------------------------
// File Name: camera_interface.v
// File Description: This is the camera module implementing the interface between the OV7670 camera and the FPGA
// --------------------------------------------------------------------------------------


module CAMERA_CONTROLLER(
	input wire GLOBAL_CLK	,
	input wire RESET		,
	input wire VSYNC		,
	input wire HREF			,
	input wire PCLK			,
	inout wire SIOD			,	// Serial Data
	output wire SIOC		,	// Serial Clock
	
);



wire [7:0] ctrl_addr;
wire [7:0] ctrl_value;
reg next;
reg start_config;
CAMERA_CONFIG cfg_inst
(
	.START_CONFIG(start_config),
	.NEXT(next),
	.CTRL_ADDR(ctrl_addr),
	.CTRL_VALUE(ctrl_value)
);

reg start_transfer;
wire ready;
I2C_INTERFACE i2c_inst
(
	.GLOBAL_CLK(GLOBAL_CLK),
	.START_TRANSFER(start_transfer),
	.SDATA(),
	.SIOD(SIOD),
	.SIOC(SIOC),
	.READY(ready)
);

reg resetting = 1'b0;
always @(*)
begin
	next = 1'b0;
	if (!resetting and RESET)
		start_config = 1'b1;
		start_transfer = 1'b1;
		resetting = 1'b1;
	else if (resetting)
		start_config = 1'b0;
		start_transfer = 1'b0;
end

always @(posedge ready)
begin
	
end



endmodule