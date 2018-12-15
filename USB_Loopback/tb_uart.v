`timescale 1ns / 1ns 

module       tb_uart;

reg          clk    ;
reg   [7:0]  data_i ;
wire         tx     ;
wire         tx_done;
wire         rx_done;
wire         rx     ;
wire  [7:0]  data_o ;

parameter    T = 84;    //G	

    initial
    begin
        clk     = 1'b0;
		data_i  = 8'haa;

		//#1_000_000 $stop;
    end
    //
	always begin clk = 1'b0; #(T/2) clk = 1'b1; #(T/2); end
	 
	/* 
	 initial    
   begin
                #(500000000*T);
                data_i  = 8'haa;
                // #(500*T);
                // data_i  = 8'hcc;    
    end
    */
    
    uart_tx u_uart_tx(
        .clk    ( clk    ),
	    .data_i ( data_i ),
	    .tx     ( tx     ),
	    .tx_done( tx_done)
    );	
    
	assign          rx = tx;// 
	
    uart_rx u_uart_rx(
        .clk    (clk    ),
	    .rx     (rx     ),
	    .data_o (data_o ),
	    .rx_done(rx_done)
    );
    //
    //
	always@(posedge rx_done)
	begin
	    if(data_o == data_i) $display("uart test pass");
		else $display("uart test fail");
	end 
endmodule      