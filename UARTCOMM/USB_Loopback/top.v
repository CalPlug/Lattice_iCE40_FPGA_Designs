module top(
	input wire rx,
	output wire tx
	);

wire clk;

SB_HFOSC inthosc (
  .CLKHFPU(1'b1),
  .CLKHFEN(1'b1),
  .CLKHF(clk)
);                            //internal clock

wire         tx_done;
wire  [7:0] datapool;
wire  senden;
wire  txtemp;
	
    uart_rx u_uart_rx(
        .clk    (clk    ),
	    .rx     (rx     ),
	    .data_o (datapool),
	    .rx_done(senden)
    );

    uart_tx u_uart_tx(
        .clk    ( clk    ),
	    .data_i ( datapool ),
	    .send_en(senden),
	    .tx     ( txtemp     ),
	    .tx_done( tx_done)
    );	
assign tx = txtemp;
    
endmodule
