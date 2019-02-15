# iCE40 UltraPlus SG48I FPGA Source Code

### Using Project ICESTORM to Synthesize:
You **MUST!!** use the following commands to synthesize the verilog source codes:
1. yosys -p "read\_verilog baudgen\_tx.v; read\_verilog uart\_tx.v; read\_verilog top.v; synth\_ice40 -blif top.blif"
2. arachne-pnr -d 5k -p ice40\_top.pcf -o top.txt top.blif
3. icepack top.txt top.bin
4. iceprog top.bin
