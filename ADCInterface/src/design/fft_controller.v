// --------------------------------------------------------------------------------------
// Organization: CALPLUG-FPGA
// Project Name:
// Date: Winter 2019
// FPGA Board: iCE40 UltraPlus SG48I
// --------------------------------------------------------------------------------------
// File Name: fft_controller.v
// File Description: This is the controller of the cf_fft_256_8 module
// --------------------------------------------------------------------------------------

`include "cf_fft_256_8.v"
`include "clock_divider.v"

module fft_controller(	
	input wire global_clk,
	input wire start,
	input wire [7:0] sampled_in_0,
	input wire [7:0] sampled_in_1,
	output reg [7:0] fft_out_0,
	output reg [7:0] fft_out_1,
	output wire fft_out_clk,
	output wire sync_i_out,
	output wire sync_o
);


wire enable = 1'b1;
reg reset = 1'b0;
reg sync_i = 1'b0;

assign sync_i_out = sync_i;

CLOCK_DIVIDER
#(
	.DIVISOR(4'b1111)  // divide the clk frequency by 12
)
clk_div
(
	.INPUT_CLK(global_clk),
	.DIVIDED_CLK(fft_clk)
);


reg [15:0] curr_sampled_in_0;
reg [15:0] curr_sampled_in_1;
wire [15:0] curr_sampled_out_0;
wire [15:0] curr_sampled_out_1;

cf_fft_256_8 fft_core
(
	.clock_c(fft_clk),
	.enable_i(enable),
	.reset_i(reset),
	.sync_i(sync_i),
	.data_0_i(curr_sampled_in_0),
	.data_1_i(curr_sampled_in_1),
	.sync_o(sync_o),
	.data_0_o(curr_sampled_out_0),
	.data_1_o(curr_sampled_out_1)
);

reg calculating = 1'b0;

always @(posedge fft_clk)
begin
    if (calculating == 1'b0 && start == 1'b1)
        sync_i <= 1'b1;
end

always @(negedge fft_clk)
begin
    if (calculating == 1'b0 && sync_i == 1'b1)
        calculating <= 1'b1;
end

always @(posedge fft_clk)
begin
    if (calculating == 1'b1) begin
        sync_i <= 1'b0;
        curr_sampled_in_0 <= {sampled_in_0, 8'b00000000};
	    curr_sampled_in_1 <= {sampled_in_1, 8'b00000000};
    end
end

always @(posedge fft_clk)
begin
    fft_out_0 <= curr_sampled_out_0[15:8];
	fft_out_1 <= curr_sampled_out_1[15:8];
end


/*
	assign fft_out_clk = ~fft_clk;
*/


/*
always @(posedge global_clk)
begin
	if (enable == 1'b1)
	begin
		if (reset == 1'b1)
		begin
			calculating <= 1'b0;
			sync_i <= 1'b0;
		end
		else if (calculating == 1'b0 && sync_i == 1'b0 && start == 1'b1)
		begin
			sync_i <= 1'b1;
		end
	end
end
*/

/*
always @(posedge fft_clk)
begin
	fft_out_0 <= curr_sampled_out_0[15:8];
	fft_out_1 <= curr_sampled_out_1[15:8];
    
    if (calculating== 1'b0 && sync_i == 1'b1)
	begin
	    calculating = 1'b1;
	end
	else if (calculating == 1'b1)
	begin
	    sync_i = 1'b0;
	    curr_sampled_in_0 <= {sampled_in_0, 8'b00000000};
	    curr_sampled_in_1 <= {sampled_in_1, 8'b00000000};
	end
end
*/

/*
always @(negedge fft_clk)
begin
     if (sync_i == 1'b1)
         sync_i <= 1'b0;
end
*/



endmodule

