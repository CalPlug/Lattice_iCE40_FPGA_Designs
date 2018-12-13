# Example UART Read in active loopback for the UpDuino board (Lattice iCE40)

The project consists of top file(top.v), receiver(uart_rx.v), and transmitter(uart_tx.v).
A possible simulation file is shown as tb_uart.v 

Note:
1. iCE40 UP has its internal clock. Seeing usage in the reference a).
2. Upduino does not have one global reset. The internal global reset can be designed according to the reference b).
3. Use whatever toolchains you familiar with. If you would like to use an open source toolchain, you might consider the reference c).
4. Basic UART concepts are in the reference e). 

******************************
Known bug:
Some of the characters may has wrong outputs. They follow the below regularity:
All wrong outputs caused by some 0 bits turning into 1 & Most of them happened in lower bits;
E.g. 0001->1111; 0100->1100; 0101->0111; 1101->1111
******************************

reference:
a)Oscillator usage guide: https://www.latticesemi.com/-/media/LatticeSemi/Documents/ApplicationNotes/IK/iCE40OscillatorUsageGuide.ashx?document_id=50670

b)Global reset: https://stackoverflow.com/questions/38030768/icestick-yosys-using-the-global-set-reset-gsr

c)Programming w/ Open Source Tools: https://www.youtube.com/watch?v=dTL0qrzme4g

d)Usage for iCEcube2 & Diamond Programmer: https://hsel.co.uk/2018/05/21/lattice-ice40-ultra-plus-fpga-gnarly-grey-upduino-tutorial-1-the-basics/

e)Concepts about UART on FPGA: https://www.researchgate.net/publication/282030059_Design_and_FPGA_Implementation_of_UART_Using_Microprogrammed_Controller


Developed by Tianyu Zhao
