// --------------------------------------------------------------------------------------
// Organization: CALPLUG-FPGA
// Project Name:
// Date: Winter 2019
// FPGA Board: iCE40 UltraPlus SG48I
// --------------------------------------------------------------------------------------
// File Name: I2C_Interface.v
// File Description: This is the camera module that implements the communication protocol, I2C
// --------------------------------------------------------------------------------------


module I2C_INTERFACE
#(	
	parameter write_ID = 8'h42,
	parameter read_ID = 8'h43
)
(
	input wire GLOBAL_CLK		,
	input wire START_TRANSFER 	,
	input wire [7:0] SUBADDRESS ,
	input wire [7:0] VALUE		,
	inout wire SIOD				,
	output reg SIOC				,
	output reg READY
);


reg transmitting = 1'b0;
reg [5:0] counter = 6'b0;
reg [4:0] bits_sent = 4'b0;
reg [26:0] q_data;

reg SIOD_temp;
assign SIOD = SIOD_temp;

always @(*)
begin
	if (!transmitting) begin
		READY = 1'b1;
		counter = 6'b0;
		bits_sent = 5'b0;
		SIOC = 1'b1;
		SIOD_temp = 1'b1;
		if (START_TRANSFER) begin
			transmitting = 1'b1;
			SIOD_temp = 1'b0;
			q_data = {write_ID, 1'b0 ,SUBADDRESS, 1'b0 , VALUE , 1'b0};
			READY = 1'b0;
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

reg loaded = 1'b0;
always @(negedge GLOBAL_CLK)
begin
	if (bits_sent == 5'b11011 && SIOC == 1'b1) begin	// 27 bits are all sent out through SIOD
		SIOD_temp = 1'b1;
		transmitting = 1'b0;
	end
	else if (SIOC == 1'b0 && loaded == 1'b0) begin
		if (transmitting) begin
			SIOD_temp = q_data[26];
			q_data = q_data << 1;
			bits_sent = bits_sent + 1;
			loaded = 1'b1;
		end
	end
end

always @(posedge SIOC)
begin
	loaded <= 1'b0;
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