`timescale 1ns / 1ps
// Created By: Tritai Nguyen
// Create Date:    03/07/2020
// Module Name:    SPIcomponent

//  ===================================================================================
//  								  Define Module, Inputs and Outputs
//  ===================================================================================
module SPIcomponent(
		CLK,
		RST,
		START,
		SDI,
		SDO,
		SCLK,
		SS,
		xAxis,
		yAxis,
		zAxis
);

// ====================================================================================
// 										Port Declarations
// ====================================================================================
   input        CLK;
   input        RST;
   input        START;
   input        SDI;
   output       SDO;
   output       SCLK;
   output       SS;
   output [9:0] xAxis;
   output [9:0] yAxis;
   output [9:0] zAxis;
   
// ====================================================================================
// 								Parameters, Register, and Wires
// ====================================================================================
	wire [9:0] 	 xAxis;
	wire [9:0] 	 yAxis;
	wire [9:0] 	 zAxis;

   wire [15:0]  TxBuffer;
   wire [7:0]   RxBuffer;
   wire         doneConfigure;
   wire         done;
   wire         transmit;
   
//  ===================================================================================
// 							  				Implementation
//  ===================================================================================
   
		//-------------------------------------------------------------------------
		//	Controls SPI Interface, Stores Received Data, and Controls Data to Send
		//-------------------------------------------------------------------------
		SPImaster C0(
					.rst(RST),
					.start(START),
					.clk(CLK),
					.transmit(transmit),
					.txdata(TxBuffer),
					.rxdata(RxBuffer),
					.done(done),
					.x_axis_data(xAxis),
					.y_axis_data(yAxis),
					.z_axis_data(zAxis)
		);
		
		//-------------------------------------------------------------------------
		//		 Produces Timing Signal, Reads ACL Data, and Writes Data to ACL
		//-------------------------------------------------------------------------
		SPIinterface C1(
					.sdi(SDI),
					.sdo(SDO),
					.rst(RST),
					.clk(CLK),
					.sclk(SCLK),
					.txbuffer(TxBuffer),
					.rxbuffer(RxBuffer),
					.done_out(done),
					.transmit(transmit)
		);
		
		//-------------------------------------------------------------------------
		//		 			 	Enables/Disables PmodACL Communication
		//-------------------------------------------------------------------------
		slaveSelect C2(
					.clk(CLK),
					.ss(SS),
					.done(done),
					.transmit(transmit),
					.rst(RST)
		);
   
endmodule
