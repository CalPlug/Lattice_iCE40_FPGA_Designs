// --------------------------------------------------------------------------------------
// Organization: CALPLUG-FPGA
// Project Name:
// Date: Winter 2019
// FPGA Board: iCE40 UltraPlus SG48I
// --------------------------------------------------------------------------------------
// File Name: camera_image.v
// File Description: This is the camera module that implements the algorithm for capturing image from the camera
// --------------------------------------------------------------------------------------

module CAMERA_IMAGE
#(
	parameter RESOLUTION_W = 640;
	parameter RESOLUTION_H = 480;
)
(
	input wire [7:0] PIXEL		,		// 8 bits pixel data
	input wire VSYNC			,		// if VSYNC is high, that means all ENTIRE image pixels have been captured 
	input wire HREF				,		// if HREF is high, that means ONE SEPARATE ROW of the image pixels have been captured
	input wire PCLK				
);

wire capturing_image = !VSYNC;













endmodule;