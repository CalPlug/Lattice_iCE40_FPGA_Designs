module top(
	input wire rx,
	output wire tx
	);

wire clk;

SB_HFOSC inthosc (
  .CLKHFPU(1'b1),
  .CLKHFEN(1'b1),
  .CLKHF(clk)
);

//reg          clk    ;
//reg   [7:0]  data_i ;
//wire         tx     ;
wire         tx_done;
wire         rx_done;
//wire         rx     ;
//wire  [7:0]  data_o ;
wire  [7:0] datapool;
wire  txtemp;
    
	//assign          rx = tx;// 
	
    uart_rx u_uart_rx(
        .clk    (clk    ),
	    .rx     (rx     ),
	    .data_o (datapool),
	    .rx_done(rx_done)
    );

    //assign data_i = data_o;

    uart_tx u_uart_tx(
        .clk    ( clk    ),
	    .data_i ( datapool ),
	    .tx     ( txtemp     ),
	    .tx_done( tx_done)
    );	
assign tx = txtemp;
    
endmodule

