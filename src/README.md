# FPGA Source Code

### Procedures to Synthesize:
You MUST!! use the following command to synthesize the verilog source code:
1. yosys -p "read\_verilog baudgen\_tx.v; read\_verilog uart\_tx.v; read\_verilog top.v; synth\_ice40 -blif top.blif"
2. arachne-pnr -d 5k -p ice40\_top.pcf -o top.txt
