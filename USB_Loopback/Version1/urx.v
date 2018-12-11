module urx(clk, rst, rx, tcmd, datapool);
input clk;
input rst;
input rx;
output tcmd;
output [7:0] datapool;

reg idle;
reg tcmd;

reg [7:0] rdata;
reg [7:0] datapool;

parameter rstate_idle = 0;
parameter rstate_receive = 1;
parameter rstate_end = 2;

reg [2:0] crtstate;
reg [3:0] clkcnt;
reg [2:0] bitcnt;

reg truestart;
reg receiveall;

always @(posedge clk) begin
	if (rst) begin
		// reset
	crtstate <= rstate_idle;	
	idle <= 1'b0;
	end
	else begin
		case(crtstate)
			rstate_idle: begin        //wait for receiving
				if (truestart == 1 && (!idle)) begin
					crtstate <= rstate_receive;
					idle <= 1'b1;
				end
				else begin
					crtstate <= rstate_idle;
				end
			end
			rstate_receive: begin     //receiving data
				if(receiveall == 1) begin
					crtstate <= rstate_end;	
				end
				else begin
					crtstate <= rstate_receive;
				end
			end
			rstate_end: begin        //receiving finished
				crtstate <= rstate_idle;
				idle <= 1'b0;
			end
			default: crtstate <= rstate_idle;
		endcase
	end
end

always @(posedge clk) begin
	if (rst) begin
		// reset
		rdata <= 8'd0;
		clkcnt <= 4'd0;
		bitcnt <= 4'd0;
		tcmd <= 1'b0;
	end
	else begin
		case(crtstate)
			rstate_idle: begin
				if (!rx) begin
					if (clkcnt == 8) begin  //to make sure it's a stable start bit
						truestart <= 1'b1;
						tcmd <= 1'b0;
						bitcnt <= 0;
						clkcnt <= 0;
						rdata <= 0;
						tcmd <= 1'b0;
					end
					else begin
						clkcnt <= clkcnt + 4'd1;
					end
				end
				else begin
					clkcnt <= 4'd0;
				end
			end
			rstate_receive: begin
				if (bitcnt == 8) begin        // receive all data bit by bit
					receiveall <= 1'b0;
					clkcnt <= 0;
					bitcnt <= 0;
					datapool <= rdata;
				end
				else begin
					if (clkcnt == 15) begin       //pick the center of one bit as the value of this bit
						bitcnt <= bitcnt + 1'd1;
						rdata[bitcnt] <= rx;
					end
					else begin
						clkcnt <= clkcnt + 1'd1;
					end
				end
			end
			rstate_end: begin
				tcmd <= 1'b1;
			end
		endcase
	end
end
endmodule


