// --------------------------------------------------------------------------------------
// Organization: CALPLUG-FPGA
// Project Name:
// Date: Winter 2019
// FPGA Board: iCE40 UltraPlus SG48I
// --------------------------------------------------------------------------------------
// File Name: I2C_Interface.v
// File Description: This is the camera module that implements the communication protocol, I2C
// --------------------------------------------------------------------------------------


module I2C_INTERFACE(
	input wire GLOBAL_CLK		,
	input wire START_TRANSFER 	,
	input wire [7:0] SDATA 		,
	inout reg SIOD				,
	output reg SIOC				,
	output reg READY
);


reg transmitting = 1'b0;
reg [5:0] counter = 6'b0;
reg [3:0] bits_sent = 4'b0;
reg [7:0] q_data;

always @(*)
begin
	if (!transmitting) begin
		READY = 1'b1;
		counter = 6'b0;
		bits_sent = 4'b0;
		SIOC = 1'b1;
		SIOD = 1'bz;
		if (START_TRANSFER) begin
			transmitting = 1'b1;
			SIOD = 1'b0;
			q_data = SDATA;
			READY = 1'b0;
		end
	end
end


always @(negedge SIOC)
begin
	if (bits_sent == 4'b1000)
		transmitting = 1'b0;
		READY = 1'b1;
	else begin
		if (transmitting) begin
			SIOD = q_data[0];
			q_data = q_data >> 1;
			bits_sent = bits_sent + 1;
		end
	end
end


always @(posedge GLOBAL_CLK)
begin
	if (transmitting) begin
		if (counter == 6'b111111)
			counter = 6'b0;
		else
			counter = counter + 1;	
	end
end

// Create a 187.5 KHz SIOC serial clock in the following block
always @(*)
begin
	if (transmitting) begin
		if (counter == 6'b0)
			SIOC <= 1'b1;
		else if (counter == 6'b100000)
			SIOC <= 1'b0;
	end
end

endmodule