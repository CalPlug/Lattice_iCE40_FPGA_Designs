// Created By: Tritai Nguyen
// top.v
// Date : 03/07/2020

module top (
 
  output          xclk,
  input           pclk,
  input           vsync,
  input           href,
  input  [7:0]    pdata,
  output          cam_reset_n,
  output          cam_pwrdn,
  
  output          sioc,
  inout           siod,
  
  input           sclk,
  input           mosi,
  output          miso,
  input           ssel  

  );
  
  wire            clk_24m /* synthesis syn_keep=1 */;
  
  reg    [17:0]   pixel_cnt;
  reg             pixel_wr_disable;
  wire            cam_config_done;
  
  wire   [16:0]   mem_rd_addr;
  wire   [7:0]    mem_rd_data;
  wire            reset_n = 1'b1;
  reg             q_vsync, q_href;
  //considering two bytes per pixel, taking only one byte out of two by having condition (pixel_cnt[0] == 1'b0)
  wire            pixel_wr = q_href && (!pixel_wr_disable) && (pixel_cnt[0]==0);
  wire            xclk_in;  
  
  reg    [7:0]    q_pdata;

  reg    [15:0]   pix_per_line;
  
  always @(posedge pclk)
    begin
      q_pdata <= pdata;
      q_vsync <= vsync;
      q_href  <= href & (pix_per_line < (320*2));  
    end

  assign          xclk = clk_24m;

  always @ (posedge pclk)
    begin
      pix_per_line <= href ? pix_per_line+1 : 0;
    end

  //Manage address for writing in DPRAM through pixel counter
  always @ (posedge pclk)
    begin
      if (!reset_n)
        begin
          pixel_cnt    <= 18'h00000;
        end
      else
      if (q_vsync)
        begin
          pixel_cnt    <= 18'h00000;
        end
      else
      if (q_href) 
        begin
          pixel_cnt    <= (pixel_cnt<(320*400*2))    ?  pixel_cnt + 18'h00001 : pixel_cnt;
        end
      else
        begin
          pixel_cnt <= pixel_cnt;     
        end  
    end    
    
	
  //Disable pixel data write from next frame if SPI transfer has been initiated
  always @ (posedge pclk)
    begin
      if (q_vsync)
        pixel_wr_disable <= !ssel;
      else
        pixel_wr_disable <= pixel_wr_disable;
    end
  
  SB_HFOSC  u_SB_HFOSC (
    .CLKHFPU  (1'b1), 
    .CLKHFEN  (1'b1), 
    .CLKHF    (xclk_in)
  ); 
  defparam u_SB_HFOSC.CLKHF_DIV = "0b01";  

  assign clk_24m = xclk_in;

  up_spram cam_buf (
    .reset_n  (reset_n),
    
    .wr_clk   (pclk ),
    .wr_addr  ({pixel_cnt[17:1]}),
    .wr_data  (q_pdata ),  
    .wr_en    (pixel_wr),
    
    .rd_clk   (pclk ),
    .rd_addr  (mem_rd_addr),
    .rd_data  (mem_rd_data)
    );  
  
  OV7670_Controller u_OV7670_Controller(
    .clk             (clk_24m),          // 24Mhz clock signal
    .resend          (1'b0),             // Reset signal
    .config_finished (cam_config_done),  // Flag to indicate that the configuration is finished
    .sioc            (sioc),             // SCCB interface - clock signal
    .siod            (siod),             // SCCB interface - data signal
    .reset           (cam_reset_n),      // RESET signal for OV7670
    .pwdn            (cam_pwrdn)         // PWDN signal for OV7670
  );  
  
  spi_slave esp32_spi (
    .clk      (pclk ),
    .reset_n  (reset_n),

    .sclk     (sclk),
    .mosi     (mosi),
    .ssel     (ssel),
    .miso     (miso),

    .mem_addr (mem_rd_addr),
    .mem_data (mem_rd_data)  
  );
  
endmodule  