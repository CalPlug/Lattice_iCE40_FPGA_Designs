`default_nettype none

`include "baudgen.vh"

module uart_tx #(
         parameter BAUDRATE = `B115200
)(
         input wire clk,       
         input wire rstn,     
         input wire start,   
         input wire [7:0] data,
         output reg tx,       
         output reg ready    
);


wire clk_baud;

reg [3:0] bitc;

reg [7:0] data_r;

reg load; 
reg baud_en;

always @(posedge clk)
  if (start == 1 && state == IDLE)
    data_r <= data;

reg [9:0] shifter;

always @(posedge clk)
  if (rstn == 0)
    shifter <= 10'b11_1111_1111;

  else if (load == 1)
    shifter <= {data_r,2'b01};

  else if (load == 0 && clk_baud == 1)
    shifter <= {1'b1, shifter[9:1]};

always @(posedge clk)
  if (!rstn)
    bitc <= 0;

  else if (load == 1)
    bitc <= 0;
  else if (load == 0 && clk_baud == 1)
    bitc <= bitc + 1;

always @(posedge clk)
  tx <= shifter[0];

baudgen_tx #( .BAUDRATE(BAUDRATE))
BAUD0 (
    .rstn(rstn),
    .clk(clk),
    .clk_ena(baud_en),
    .clk_out(clk_baud)
  );

localparam IDLE  = 0;
localparam START = 1;
localparam TRANS = 2;

reg [1:0] state;
reg [1:0] next_state;

always @(posedge clk)
  if (!rstn)
    state <= IDLE;
  else
    state <= next_state;

always @(*) begin
  next_state = state;
  load = 0;
  baud_en = 0;
  case (state)
    IDLE: begin
      ready = 1;
      if (start == 1)
        next_state = START;
    end

    START: begin
      load = 1;
      baud_en = 1;
      ready = 0;
      next_state = TRANS;
    end

    TRANS: begin
      baud_en = 1;
      ready = 0;
      if (bitc == 11)
        next_state = IDLE;
    end

    default:
      ready = 0;

  endcase
end

endmodule
