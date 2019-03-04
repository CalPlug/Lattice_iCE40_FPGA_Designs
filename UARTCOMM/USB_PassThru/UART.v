module UART(
	input clk,
	input rst,
	output RX,
	output TX
	);
wire tcmd1;
wire clkout1;
wire [7:0] data1;

clkdiv clkdiv1(
	.clk(clk),
	.rst(rst),
	.clkout(clkout1)
	);

utx utx1(
	.clk(clkout1),
	.rst(rst),
	.datain(data1),
	.tcmd(tcmd1),
	.tx(TX)
	);

urx urx1(
	.clk(clkout1),
	.rst(rst),
	.rx(RX),
	.tcmd(tcmd1),
	.datapool(data1)
	);

endmodule