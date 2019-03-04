/*TOP LEVEL DESIGN*/

`default_nettype none
`include "baudgen.vh"

module echo #(
         parameter BAUDRATE = `B115200
)(
         input wire rx,
         output wire tx
);

wire clk;
SB_HFOSC inthosc (
  .CLKHFPU(1'b1),
  .CLKHFEN(1'b1),
  .CLKHF(clk)
);

wire rcv;
wire [7:0] data;
reg rstn = 0;
wire ready;

always @(posedge clk)
  rstn <= 1;

uart_rx #(.BAUDRATE(BAUDRATE))
  RX0 (.clk(clk),
       .rstn(rstn),
       .rx(rx),
       .rcv(rcv),
       .data(data)
      );

uart_tx #(.BAUDRATE(BAUDRATE))
  TX0 ( .clk(clk),
         .rstn(rstn),
         .start(rcv),
         .data(data),
         .tx(tx),
         .ready(ready)
       );


endmodule
