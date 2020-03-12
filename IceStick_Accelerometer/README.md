# IceStick-Accelerometer

Loads SPI controller onto IceStick and reads accelerometer data. Leds will turn on/off according to orientation.

Using open source toolchain, (Yosys, arachne-pnr, and IceStorm) load verilog files onto Icestick, and connect accelerometer. The leds on the IceStick should turn on/off to indicate the direction of tilt with respect to gravity.