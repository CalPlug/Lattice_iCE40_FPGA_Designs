`timescale 1ns/1ns

// Created By: Tritai Nguyen
// up_spram.v
// Date : 03/07/2020

module up_spram (
  input           reset_n,
  
  input           wr_clk,
  input  [16:0]   wr_addr,
  input  [7:0]    wr_data,  
  input           wr_en,
  
  input           rd_clk,
  input  [16:0]   rd_addr,
  output [7:0]    rd_data
  );

  wire   [15:0]   ram_rdata;  
  wire   [15:0]   ram_rdata0, ram_rdata1, ram_rdata2, ram_rdata3;  
  wire   [16:0]   w_addr;
  assign          w_addr = wr_en ? wr_addr : rd_addr;
  wire   [3:0]    w_mask;
  assign          w_mask = w_addr[16] ? 4'b1100 : 4'b0011;
  wire   [3:0]    wr_ram;
  assign          wr_ram[0] = ~w_addr[15] & ~w_addr[14] & wr_en;
  assign          wr_ram[1] = ~w_addr[15] &  w_addr[14] & wr_en;
  assign          wr_ram[2] =  w_addr[15] & ~w_addr[14] & wr_en;
  assign          wr_ram[3] =  w_addr[15] &  w_addr[14] & wr_en;
  
  assign          ram_rdata = (w_addr[16:14]==3'd0) ? ram_rdata0[7:0] : 
                              (w_addr[16:14]==3'd1) ? ram_rdata1[7:0] : 
                              (w_addr[16:14]==3'd2) ? ram_rdata2[7:0] : 
                              (w_addr[16:14]==3'd3) ? ram_rdata3[7:0] :
                              (w_addr[16:14]==3'd4) ? ram_rdata0[15:8] : 
                              (w_addr[16:14]==3'd5) ? ram_rdata1[15:8] : 
                              (w_addr[16:14]==3'd6) ? ram_rdata2[15:8] : 
                              (w_addr[16:14]==3'd7) ? ram_rdata3[15:8] : 0; 
                                                  
  assign          rd_data = ram_rdata[7:0];
    
  //RAM instantiations
  SB_SPRAM256KA u_spram0 (
    .ADDRESS      ( w_addr[13:0 ]       ),
    .DATAIN       ( {wr_data,wr_data}   ),
    .MASKWREN     ( w_mask              ),
    .WREN         ( wr_ram[0]           ),
    .CHIPSELECT   ( 1'b1                ),
    .CLOCK        ( rd_clk              ),
    .STANDBY      ( 1'b0                ),
    .SLEEP        ( 1'b0                ),
    .POWEROFF     ( 1'b1                ),
    .DATAOUT      ( ram_rdata0          )
    );
    
  SB_SPRAM256KA u_spram1 (
    .ADDRESS      ( w_addr[13:0]        ),
    .DATAIN       ( {wr_data,wr_data}   ),
    .MASKWREN     ( w_mask              ),
    .WREN         ( wr_ram[1]           ),
    .CHIPSELECT   ( 1'b1                ),
    .CLOCK        ( rd_clk              ),
    .STANDBY      ( 1'b0                ),
    .SLEEP        ( 1'b0                ),
    .POWEROFF     ( 1'b1                ),
    .DATAOUT      ( ram_rdata1          )
    );

  SB_SPRAM256KA u_spram2 (
    .ADDRESS      ( w_addr[13:0]        ),
    .DATAIN       ( {wr_data,wr_data}   ),
    .MASKWREN     ( w_mask              ),
    .WREN         ( wr_ram[2]           ),
    .CHIPSELECT   ( 1'b1                ),
    .CLOCK        ( rd_clk              ),
    .STANDBY      ( 1'b0                ),
    .SLEEP        ( 1'b0                ),
    .POWEROFF     ( 1'b1                ),
    .DATAOUT      ( ram_rdata2          )
    );

  SB_SPRAM256KA u_spram3 (
    .ADDRESS      ( w_addr[13:0]        ),
    .DATAIN       ( {wr_data,wr_data}   ),
    .MASKWREN     ( w_mask              ),
    .WREN         ( wr_ram[3]           ),
    .CHIPSELECT   ( 1'b1                ),
    .CLOCK        ( rd_clk              ),
    .STANDBY      ( 1'b0                ),
    .SLEEP        ( 1'b0                ),
    .POWEROFF     ( 1'b1                ),
    .DATAOUT      ( ram_rdata3          )
    );  

endmodule  