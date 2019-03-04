# Lattice_iCE40_FPGA_Designs

##### Development by Brandon Lam, Taleen Sarkissian, and Tianyu Zhao
##### University of California, Irvine (UC Irvine) 
##### Project Leaders: Dr. Michael J. Klopfer & Prof. G.P. Li 

## California Plug Load Research Center (CalPlug)
Copyright The Regents of the University of California, 2018
Built with open source software and released into the public domain under GNU License for permissive use.  

## UART Loop-back Program
Example UART program to loop-back serial data. Built in verilog and tested on UpDuino v2.0 using Project IceStorm workflow. An example of how to upload a program onto the UpDuino v2.0 FPGA can be found here: https://www.youtube.com/watch?v=dTL0qrzme4g&t=478s&frags=pl%2Cwn, for more detailed instructions, see the installation details below. Program can be modified to provide applications in debugging.

## INSTALLATION DETAILS  
1) Ensure the required prerequesite software is installed. (Required Software: IceStorm, Arachne-PNR and Yosys. Installation details can be found at: http://www.clifford.at/icestorm/)

2) Download one of the project folders found in this directory. All of them have been tested and working on the UpDuino v2.0 FPGA.


3) Begin by typing:
    yosys -p "read_verilog [filename].v; synth_ice40 -blif [filename].blif"
  This will create .blif file using yosys. This file contains the logic-level circuit in textual form.
  
4) Then type:
    arachne-pnr -d 5k -p [filename].pcf -o [filename].txt [filename].blif
  This will create a .txt file from the .blif file using arachne. This performs the  place and route step of the hardware compilation process for FPGAs.

5) Afterwards, type:
    icepack [filename].txt [filename].bin
  This will convert the ASCII file that contains config bits for the chip into an iCE40 .bin file

6) Finally type:
    iceprog [filename].bin 
   To upload bitstream onto the Lattice iCE 40 FPGA (Note: sudo iceprog [filename].bin required if user does not have appropriate permissions. If such is the case, error will be: “Can’t find iCE FTDI USB Device” if this is the case)

## INSTRUCTIONS FOR USE  
1) 	Upload the program onto the FPGA.

2) 	Connect a UART device onto the Tx and Rx lines defined in the .pcf file of the FPGA

3) Open a terminal program such as PuTTy and output a character. The same character should appear on the terminal signifying sucessful loopback
