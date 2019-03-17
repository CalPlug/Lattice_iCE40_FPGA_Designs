`default_nettype none
`include "baudgen.vh"

module baudgen_tx #(
          parameter BAUDRATE = `B115200  //-- Default baudrate
)(
          input wire rstn,              //-- Reset (active low)
          input wire clk,               //-- System clock
          input wire clk_ena,           //-- Clock enable
          output wire clk_out           //-- Bitrate Clock output
);

localparam N = $clog2(BAUDRATE);

reg [N-1:0] divcounter = 0;

always @(posedge clk)

  if (!rstn)
    divcounter <= 0;

  else if (clk_ena)
    divcounter <= (divcounter == BAUDRATE - 1) ? 0 : divcounter + 1;
  else
    divcounter <= BAUDRATE - 1;

assign clk_out = (divcounter == 0) ? clk_ena : 0;


endmodule
