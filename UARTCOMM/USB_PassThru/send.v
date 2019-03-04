module utx(clk, datain, tcmd, idle, tx)
input clk;
input [7:0] datain; //data to send to computer from fpga
input tcmd;   //1: has data to send   0: no data to send
output idle;  //1: busy   0: idle
output tx;

reg idle, tx;

parameter state_idle = 0;
parameter state_initialbit = 1;
parameter state_send = 2;
parameter state_end = 3;
reg [1:0] crtstate;
reg [2:0] bitcnt;
reg initialsent;

always @(posedge clk) begin
    if (rst) begin
        // reset
        crtstate <= state_idle
        bitcnt <= 4'd0;
        idle <= 1'b0;
    end
    else begin
    case(crtstate)
        state_idle: begin
            if(tcmd && (!idle))begin
                crtstate <= state_initialbit;
                idle <= 1'b1;
            end
            else begin
                crtstate <= state_idle;
            end
        end    
        state_initialbit: begin
            if(initialsent == 1) begin
                crtstate <= state_send;
                bitcnt <= 3'b0;
            end
            else begin
                crtstate <= state_initialbit
            end
        end
		state_send: begin      //send data
			if(sentall == 1) begin
				crtstate <= state_end;
			end
			else begin
				crtstate <= state_send;
			end
		end
		state_end: begin       //finish sending
			crtstate <= state_idle;
			idle <= 1'b0;
		end
		default: crtstate <= state_idle;
	endcase		
    end
end