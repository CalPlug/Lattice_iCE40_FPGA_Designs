`timescale 1ns / 1ps
// Created By: Tritai Nguyen
// Create Date:    03/07/2020
// Module Name:    slaveSelect

//  ===================================================================================
//  								Define Module, Inputs and Outputs
//  ===================================================================================
module slaveSelect(
		rst,
		clk,
		transmit,
		done,
		ss
);

// ====================================================================================
// 										Port Declarations
// ====================================================================================
   input   rst;
   input   clk;
   input   transmit;
   input   done;
   output  ss;
   reg     ss = 1'b1;
   
   
//  ===================================================================================
// 							  				Implementation
//  ===================================================================================
   
   
		//-----------------------------------------------
		//			  Generates Slave Select Signal
		//-----------------------------------------------
		always @(posedge clk)
		begin: ssprocess
			
			begin
				//reset state, ss goes high ( disabled )
				if (rst == 1'b1)
					ss <= 1'b1;
				//if transmitting, then ss goes low ( enabled )
				else if (transmit == 1'b1)
					ss <= 1'b0;
				//if done, then ss goes high ( disabled )
				else if (done == 1'b1)
					ss <= 1'b1;
			end
		end
   
endmodule


