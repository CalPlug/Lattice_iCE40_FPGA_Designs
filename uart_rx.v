`default_nettype none

`include "baudgen.vh"

module uart_rx #(parameter BAUDRATE = `B115200)(
         input wire clk,   
         input wire rstn, 
         input wire rx,  
         output reg rcv,
         output reg [7:0] data 
);

wire clk_baud;

reg bauden;  
reg clear;  
reg load;  

/*----------------------------------------------------------------------------*/
/*Rx register*/
reg rx_r;
always @(posedge clk)
  rx_r <= rx;

/*Baud generator*/
baudgen_rx #(BAUDRATE)
  baudgen0 (
    .rstn(rstn),
    .clk(clk),
    .clk_ena(bauden),
    .clk_out(clk_baud)
);

/*Bit counter*/
reg [3:0] bitc;
always @(posedge clk)
  if (clear)
    bitc <= 4'd0;	/*clear the bit counter 4 bits all 0*/
  else if (clear == 0 && clk_baud == 1)
    bitc <= bitc + 1;


/*shift register*/
reg [9:0] raw_data;
always @(posedge clk)
  if (clk_baud == 1)
    raw_data <= {rx_r, raw_data[9:1]}; /*curly braces = concatenation*/

/*Data register*/
always @(posedge clk)
  if (rstn == 0)
    data <= 0;
  else if (load)
    data <= raw_data[8:1];


/*----------------------------------------------------------------------------*/
/*Declate the states*/
localparam IDLE = 2'd0;
localparam RECV = 2'd1;
localparam LOAD = 2'd2;
localparam DAV = 2'd3;

/*State storage*/
reg [1:0] state;
reg [1:0] next_state;

/*Rst*/
always @(posedge clk)
  if (!rstn)
    state <= IDLE;
  else
    state <= next_state;

always @(*) begin /*Create sensitivity list to curr_state*/
  next_state = curr_state;
  bauden = 0;
  clear = 0;
  load = 0;

  case(curr_state)
	  IDLE: begin
		  clear = 1;
		  rcv = 0;
		  load = 0;
		  baud_en = 0;
		  if (rx_r == 0)
			  next_state = RECV;
	  end
	ECV: begin
		clear = 0;
      		rcv = 0;
		load = 0;
		baud_en = 1;
      		if (bitc == 4'd10)
        		next_state = LOAD;
		else
			next_state = ECV;
	end

	LOAD: begin
		clear = 0;
      		rcv = 0;
		load = 1;
		baud_en = 0;
      		next_state = DAV;
    	end

    	DAV: begin
		clear = 0;
      		rcv = 1;
		load = 0;
		baud_en = 0;
      		next_state = IDLE;
    	end

    	default:
      	rcv = 0;

  endcase

end

endmodule
