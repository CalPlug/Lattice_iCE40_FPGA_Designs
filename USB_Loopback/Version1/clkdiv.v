module clkdiv(clk, rst, clkout);
input clk;
input rst;
output clkout;
reg clkout;
reg [7:0] cnt;      //78 = 12M/9600/16
// baud rate: 9600
always @(posedge clk)
begin
	if(!rst)
	begin
		if (cnt == 8'd38)     // 0.5*78-1
		begin
			clkout <= 1'b1;
			cnt <= cnt + 8'd1;
		end
		else if(cnt == 8'd77)   // 78-1
		begin
			clkout <= 1'b0;
			cnt <= 16'd0;
		end
		else
		begin
			cnt <= cnt + 8'd1;
		end
	end
end
endmodule





