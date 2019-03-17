`timescale 1ns / 1ps

module tb_top;
   reg tb_clk;
   reg start;
   wire [7:0] fft_out_0;
   wire [7:0] fft_out_1;
   wire fft_clk;
	
   reg [7:0] data_in_0;
   reg [7:0] data_in_1;
   
   wire sync_i;
   wire sync_o;

   

  fft_controller fft(
      .global_clk(tb_clk),
      .start(start),
      .sampled_in_0(data_in_0),
      .sampled_in_1(data_in_1),
      .fft_out_0(fft_out_0),
      .fft_out_1(fft_out_1),
      .fft_clk(fft_clk),
      .sync_i_out(sync_i),
      .sync_o(sync_o)
     );

//clock and reset signal declaration
    //clock generation
  always #10 tb_clk = ~tb_clk;
  
  //reset Generation
  initial begin
    
    tb_clk = 0;
    start = 0;
    #1000 start = 1;
    #1000 start =0;
  end
  
   
   initial begin
        #10000000;
        $finish;
   end
   
   integer output_file;
   integer input_file;
   integer input1, input2;

////// FILE IO system task takes place in the XSIM folder !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   always @(posedge sync_i)
   begin
        input_file = $fopen("input_data.txt", "r");
        if (input_file != 0) begin
            
            repeat (128) begin
                @(negedge fft_clk);
                #1 $fscanf(input_file, "%b\n", data_in_0);
			    $display("Got: %b", data_in_0);
                #1 $fscanf(input_file, "%b\n", data_in_1);
			    $display("Got: %b", data_in_1);
            end
            
        end
        $fclose(input_file);
        
   end
   
   always @(posedge sync_o)
   begin
        output_file = $fopen("output_data.txt", "w+");
        repeat (1) begin
            @(posedge fft_clk);
        end
   
        repeat (256) begin
            @(posedge fft_clk);
            #1 $fwrite(output_file, "%d\n",$unsigned(fft_out_0));
            #1 $fwrite(output_file, "%d\n",$unsigned(fft_out_1));
        end
        
        $fclose(output_file);
        
   end

   
endmodule
