# iCE40 UltraPlus SG48I FPGA Source Code

### Using Project ICESTORM to Synthesize:
You **MUST!!** use the following commands to synthesize the verilog source codes:
1. yosys -p "read\_verilog top.v; synth\_ice40 -blif syn/top.blif"
2. arachne-pnr -d 5k -p upduino\_top.pcf -o syn/top.txt syn/top.blif
3. icepack top.txt top.bin
4. iceprog top.bin
