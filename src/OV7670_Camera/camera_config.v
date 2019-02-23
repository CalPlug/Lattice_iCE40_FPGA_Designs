// --------------------------------------------------------------------------------------
// Organization: CALPLUG-FPGA
// Project Name:
// Date: Winter 2019
// FPGA Board: iCE40 UltraPlus SG48I
// --------------------------------------------------------------------------------------
// File Name: camera_config.v
// File Description: This is the camera module setup the start-up configuration for the camera
// --------------------------------------------------------------------------------------

module CAMERA_CONFIG(
	input wire START_CONFIG				,
	input wire NEXT						,
	output reg [7:0] CTRL_ADDR			,	// specify the control register address in the camera chip
	output reg [7:0] CTRL_VALUE  		,	// specify the control value in the camera chip
);

reg [7:0] address;

always @(posedge NEXT)
begin
	if (START_CONFIG == 1'b1)
		address = 8'b0;
	else
		address = address + 1;
		
		
	case (address)
		0:	begin
				CTRL_ADDR <= 8'h12;
				CTRL_VALUE <= 8'h80;
			end
			
		/* More Control Features can be added here if wanted */
		
		default: begin
					CTRL_ADDR <= 8'hFF
					CTRL_VALUE <= 8'hFF
				end
		
			
			
end


	
endmodule