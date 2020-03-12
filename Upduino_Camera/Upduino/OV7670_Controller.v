// Created By: Tritai Nguyen
// OV7670_Controller.v
// Date : 03/07/2020

module OV7670_Controller (
    input clk,                              // 50Mhz clock signal
    input resend,                           // Reset signal
    output config_finished,                 // Flag to indicate that the configuration is finished
    output sioc,                            // SCCB interface - clock signal
    inout siod,                             // SCCB interface - data signal
    output reset,                           // RESET signal for OV7670
    output pwdn                             // PWDN signal for OV7670
);

    // Internal signals
    wire [15:0] command;
    wire finished;
    wire taken;
    reg send = 0;
   
    // Signal for testing
    assign config_finished = finished;
    
    // Signals for RESET and PWDN OV7670
    assign reset = 1;
    assign pwdn = 0;
    
    // Signal to indicate that the configuration is finshied    
    always @ (finished) begin
        send = ~finished;
    end
    
    // Create an instance of a LUT table 
    OV7670_Registers LUT(
        .clk(clk),                          // 50Mhz clock signal
        .advance(taken),                    // Flag to advance to next register
        .command(command),                  // register value and data for OV7670
        .finished(finished),                // Flag to indicate the configuration is finshed
        .resend(resend)                     // Re-configure flag for OV7670
    );
    
    // Create an instance of a SCCB interface
    I2C_Interface I2C(
        .clk(clk),                          // 50Mhz clock signal
        .taken(taken),                      // Flag to advance to next register
        .siod(siod),                        // Clock signal for SCCB interface
        .sioc(sioc),                        // Data signal for SCCB interface 
        .send(send),                        // Continue to configure OV7670
        .rega(command[15:8]),               // Register address
        .value(command[7:0])                // Data to write into register
    );
    
endmodule
