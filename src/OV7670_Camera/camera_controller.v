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
	inout wire SIOD			,	// Serial Data
	output wire SIOC		,	// Serial Clock
	output wire CONFIG_FINISHED
	
);



wire [7:0] ctrl_addr;
wire [7:0] ctrl_value;
reg next;
reg start_config;
wire config_ready;
wire CONFIG_FINISHED;
CAMERA_CONFIG cfg_inst(
	.START_CONFIG(start_config),
	.NEXT(next),
	.CTRL_ADDR(ctrl_addr),
	.CTRL_VALUE(ctrl_value),
	.READY(config_ready),
	.FINISHED(CONFIG_FINISHED)
);



reg start_transfer;
wire I2C_ready;
I2C_INTERFACE i2c_inst(
	.GLOBAL_CLK(GLOBAL_CLK),
	.START_TRANSFER(start_transfer),
	.SUBADDRESS(ctrl_addr),
	.VALUE(ctrl_value),
	.SIOD(SIOD),
	.SIOC(SIOC),
	.READY(I2C_ready)
);



reg resetting = 1'b0;
always @(*)
begin
	next = 1'b0;
	start_config = 1'b0;
	start_transfer = 1'b0;
	if (!resetting && RESET) begin
		start_config = 1'b1;
		next = 1'b1;
		resetting = 1'b1;
	end
end

always @(posedge config_ready)
begin
	start_config <= 1'b0;
	next <= 1'b0;
	start_transfer <= 1'b1;
end

always @(negedge I2C_ready)
begin
	start_transfer = 1'b0;
end

always @(posedge I2C_ready)
begin
	if (!CONFIG_FINISHED) begin
		next <= 1'b1;
	end
end





endmodule