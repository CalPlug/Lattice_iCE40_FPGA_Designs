module urx(clk, rx, tcmd, idle)
input clk;
input rx;
output tcmd;   //1: has data to send   0: no data to send
output idle;   //1: busy   0: idle

reg idle, rx;
reg [7:0] data_stored; //data coming in from computer to fpga

parameter state_idle = 0;
//parameter state_initialbit = 1; //don't need intitial bit
parameter state_receive = 1;
parameter state_end = 2;
reg [1:0] crtstate;
reg [2:0] bitcnt;
reg initialsent;
reg start;
reg receive;

always @(posedge clk) begin
	if (rst) begin
		// reset
		crtstate <= state_idle;
		idle <= 1'b0;
	end
	else begin
		case(crtstate)
			state_idle: begin        //wait for receiving
				if (start == 1 && (!idle)) begin
					crtstate <= state_receive;
					idle <= 1'b1;
				end
				else begin
					crtstate <= state_idle;
				end
			end
			state_receive: begin     //receive data
				if(receive == 1) begin
					crtstate <= state_end;	
				end
				else begin
					crtstate <= state_receive;
				end
			end
			state_end: begin        //finish receiving
				crtstate <= state_idle;
				idle <= 1'b0;
			end
			default: crtstate <= state_idle;
		endcase
	end
end