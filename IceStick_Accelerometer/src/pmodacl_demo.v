`timescale 1ns / 1ps
// Created By: Tritai Nguyen
// Create Date:    03/07/2020
// Module Name:    PmodACL_Demo

// ====================================================================================
//    Define Module
// ====================================================================================
module PmodACL_Demo(
    clk_in,
    SDI,
    SDO,
    SCLK,
    SS,
    test1,
    test2,
    LED_PLUS,
    LED_MINUS,
    LED
);

// ====================================================================================
//    Port Declarations
// ====================================================================================
   input        clk_in ;
   output       test1  ;
   output       test2  ;
   input        SDI    ;
   output       SDO    ;
   output       SCLK   ;
   output       SS     ;
   
   output [1:0]   LED_PLUS ;
   output [1:0]   LED_MINUS;
   output         LED;
   
// ====================================================================================
//    Parameters, Register, and Wires
// ====================================================================================

// parameters (constants)
   parameter clk_freq = 27'd12000000;  // in Hz for 12MHz clock
   reg [26:0]   count   ;
   wire         RST     ;
   wire [9:0]   xAxis   ;  // x-axis data from PmodACL
   wire [9:0]   yAxis   ;  // y-axis data from PmodACL
   wire [9:0]   zAxis   ;  // z-axis data from PmodACL
   wire [9:0]   selData ;  // Data selected to display
   wire         START   ;  // Data Transfer Request Signal
   wire         CLK     ;
   
   wire plus_0, plus_1, plus_2, plus_3 ;
   wire minus_0, minus_1, minus_2, minus_3 ;
   
//  ===================================================================================
//    Implementation
//  ===================================================================================

//// Internal Oscillator
//// defparam OSCH_inst.NOM_FREQ = "2.08";// This is the default frequency
//defparam OSCH_inst.NOM_FREQ = "88.67";
//OSCH OSCH_inst( .STDBY(1'b0), // 0=Enabled, 1=Disabled
//// also Disabled with Bandgap=OFF
//.OSC(osc_clk),
//.SEDSTDBY()); // this signal is not required if not using SED

// PLL instantiation
ice_pll ice_pll_inst(
     .REFERENCECLK ( clk_in        ),    // input 12MHz
     .PLLOUTCORE   ( osc_clk       ),    // output 88MHz
     .PLLOUTGLOBAL ( PLLOUTGLOBAL  ),
     .RESET        ( 1'b1          )
     );

assign CLK = osc_clk ;

// internal reset generation
always @ (posedge clk_in)
    begin
        if (count >= (clk_freq/2)) begin
        end else                       
            count <= count + 1;
    end

assign RST = ~count[19] ;

//-----------------------------------------------
//    Interfaces PmodACL
//-----------------------------------------------
SPIcomponent SPI(
    .CLK   (CLK   ),
    .RST   (RST   ),
    .START (START ),
    .SDI   (SDI   ),
    .SDO   (SDO   ),
    .SCLK  (SCLK  ),
    .SS    (SS    ),
    .xAxis (xAxis ),
    .yAxis (yAxis ),
    .zAxis (zAxis )
);

//-----------------------------------------------
//    Generates a 5Hz Data Transfer Request Signal
//-----------------------------------------------
ClkDiv_5Hz genStart(
    .CLK    (CLK   ),
    .RST    (RST   ),
    .CLKOUT (START )
);

  wire plus_0, plus_1, plus_2, plus_3 ;
  wire minus_0, minus_1, minus_2, minus_3 ;
  
  assign plus_0 = xAxis[8:5] > 0 ;
  assign plus_1 = xAxis[8:5] > 1 ;
  
  assign minus_0 = (16 - xAxis[8:5]) > 0 ;
  assign minus_1 = (16 - xAxis[8:5]) > 1 ;

// Z direction
  wire z_plus_0, z_minus_0 ;
  assign z_plus_0  = zAxis[8:5] > 0 ;
  assign z_minus_0 = (16 - zAxis[8:5]) > 0 ;
  assign z_plus_1  = zAxis[8:5] > 1 ;
  assign z_minus_1 = (16 - zAxis[8:5]) > 1 ;
 
  assign  LED_PLUS[0]  = (xAxis[9]==0) ? ~plus_0 : 1'b1 ;
  assign  LED_MINUS[0] = (xAxis[9]==1) ? ~minus_0 : 1'b1 ;
  assign  LED_PLUS[1]  = (xAxis[9]==0) ? ~plus_1 : 1'b1 ;
  assign  LED_MINUS[1] = (xAxis[9]==1) ? ~minus_1 : 1'b1 ;  

  assign  LED_PLUS[1]  = (zAxis[9]==0) ? ~z_plus_0 : 1'b1 ;  
  assign  LED_MINUS[1] = (zAxis[9]==1) ? ~z_minus_0 : 1'b1 ;
  
  // middle led if flat
  assign LED = LED_PLUS[0] & LED_MINUS[0] & LED_PLUS[1] & LED_MINUS[1] ;
  
// debug
  assign test1 = osc_clk ;
  assign test2 = RST ;

endmodule
