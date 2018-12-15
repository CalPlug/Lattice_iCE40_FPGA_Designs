module utx(clk, rst, datain, tcmd, tx);   //idle
input clk;
input rst;
input [7:0] datain;
input tcmd;   //1: has data to send   0: no data to send
output tx;

reg idle, tx;

parameter state_idle = 0;
parameter state_initialbit = 1;
parameter state_send = 2;
parameter state_end = 3;
reg [1:0] crtstate;
reg [3:0] bitcnt;
reg initialsent;
reg sentall;

reg [3:0] clkcnt;


//states transformation
always @(posedge clk) begin
	if (rst) begin
		// reset
		crtstate <= state_idle;
		idle <= 1'b0; 
	end
	else begin
	case(crtstate)
		state_idle: begin        //wait for sending
			if(tcmd && (!idle)) begin
				crtstate <= state_initialbit;
				idle <= 1'b1;
			end
			else begin
				crtstate <= state_idle;
			end
		end	
		state_initialbit: begin   //sending start bit
			if(initialsent == 1) begin
				crtstate <= state_send;
			end
			else begin
				crtstate <= state_initialbit;
			end
		end
		state_send: begin      //sending data
			if(sentall == 1) begin
				crtstate <= state_end;
			end
			else begin
				crtstate <= state_send;
			end
		end
		state_end: begin       //sending finished
			crtstate <= state_idle;
			idle <= 1'b0;
		end
		default: crtstate <= state_idle;
	endcase
	end
end

//data transiting
always @(posedge clk) begin
	if (rst) begin
		tx <= 1;
		clkcnt <= 4'd0;
		bitcnt <= 4'd0;
	end
	else begin
		case(crtstate)
			state_idle: begin
				tx <= 1;
			end
			state_initialbit: begin
				if(clkcnt == 15) begin    //send the start bit
					initialsent <= 1;
					bitcnt <= 4'd0;
					clkcnt <= 4'd0;
				end
				else begin
					tx <= 1'b0;
					clkcnt <= clkcnt + 4'd1;	
				end
			end
			state_send: begin
				if(bitcnt == 8) begin     //send all data bit by bit
					sentall <= 1;
					bitcnt <= 4'd0;
				end
				else begin
					if(clkcnt == 15) begin
						bitcnt <= bitcnt + 4'd1;
					end
					else begin
						tx <= datain[bitcnt];
						clkcnt <= clkcnt + 4'd1;	
					end					
				end
			end
			state_end: begin
				tx <= 1;
			end
		endcase	
	end
end
endmodule


