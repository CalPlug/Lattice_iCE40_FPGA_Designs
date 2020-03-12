# FPGA-Camera
Loads SPI controller onto Upduino board and sends image to ESP32, where file contents are stored and uploaded to serial monitor.

Use open-source toolchain to load verilog files onto Upduino. Use Yosys to convert verilog to BLIF file, Arachne-pnr as place and route tool, and Icestorm 
to flash Upduino. 

Connect Upduino board and ESP32. Upload ino file to ESP32 and open serial monitor to recieve data stream. Copy data stream into HxD program and save as .bmp.