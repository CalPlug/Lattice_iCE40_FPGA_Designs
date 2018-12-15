
module  uart_rx (
input               clk                  ,
input               rx                   ,   //input
output     [7:0]    data_o               ,   //output data for tx
output              rx_done              
);

reg                 rx_reg0;
reg                 rx_reg1;
reg                 rx_temp0;
reg                 rx_temp1;
reg                 bps_clk;
reg                 bps_en;

wire                rx_neg;

reg        [6:0]    bps_cnt;   
reg        [7:0]    cnt;
reg                 rx_done_reg;
reg        [7:0]    data_o_reg;
reg        [7:0]    data_o_reg1;

parameter bps = 7'd78;                        //78=12M/9600/16  dividing every bit into 16 subclk   

wire rst_n;
reg [6:0] rststate = 0;

assign rst_n = &rststate;                     //internal global reset
always @(posedge clk) rststate <= rststate + !rst_n; 


always @(posedge clk or negedge rst_n) begin  
    if (~rst_n) begin
        rx_reg0 <= 0;
        rx_reg1 <= 0;
    end 
    else begin
        rx_reg0 <= rx;
        rx_reg1 <= rx_reg0;    
    end 
end 

always @(posedge clk or negedge rst_n) begin 
    if (~rst_n) begin
        rx_temp0 <= 0;
        rx_temp1 <= 0;
    end 
    else begin
        rx_temp0 <= rx_reg1;
        rx_temp1 <= rx_temp0;    
    end 
end 

assign rx_neg = (~rx_temp0)&&rx_temp1;         //detecting the rx neg edge

always @(posedge clk or negedge rst_n) begin   // bps_cnt period: 1/16 of a bit
    if (~rst_n) begin
        bps_cnt <= 0;
    end 
    else begin
        if (bps_en == 1'b1) begin
            bps_cnt <= (bps_cnt == bps) ? 7'd0 : bps_cnt + 1'b1;    
        end
        else begin
            bps_cnt <= 0;        
        end    
    end 
end 

always @(posedge clk or negedge rst_n) begin  // counting once for every 1/16 bit        
    if (~rst_n) begin
        bps_clk <= 0;
    end 
    else begin
        if (bps_cnt == 7'd1) begin    
            bps_clk <= 1'b1;
        end 
        else begin
            bps_clk <= 1'b0;       
        end   
    end 
end 

always @(posedge clk or negedge rst_n) begin  //cnt: 16*10 = 160 bps_cnt period
    if (~rst_n) begin
        cnt <= 0;
    end 
    else begin
        if (bps_en == 1'b1) begin
            cnt <= (bps_clk == 1'b1) ? cnt + 1'b1 : cnt;      
        end
        else begin
            cnt <= 0;        
        end    
    end 
end 

always @(posedge clk or negedge rst_n) begin  //setting bps_en according neg edge
    if (~rst_n) begin                         //setting back 0 when receiving finished or a fake starting
        bps_en <= 0;
    end 
    else begin
        if (rx_neg == 1'b1) begin
            bps_en <= 1'b1;
        end    
        else begin
            bps_en <= (cnt == 8'd159 || (cnt == 8'd7 && (rx_reg1))) ? 1'b0 : bps_en;
        end
    end 
end 

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        rx_done_reg <= 1'b0;                  //If receiving is unfinished/idle, rxdonereg is 0; Set 1 when finished
        data_o_reg  <= 0;                     //rx_done is a internal signal to control transmitting
    end 
    else begin
        case (cnt)
            0  : begin rx_done_reg   <= 1'b0; end 
            23 : begin data_o_reg[0] <= rx_reg1; end 
            39 : begin data_o_reg[1] <= rx_reg1; end 
            55 : begin data_o_reg[2] <= rx_reg1; end 
            71 : begin data_o_reg[3] <= rx_reg1; end 
            87 : begin data_o_reg[4] <= rx_reg1; end 
            103: begin data_o_reg[5] <= rx_reg1; end 
            119: begin data_o_reg[6] <= rx_reg1; end 
            135: begin data_o_reg[7] <= rx_reg1; end 
            159: begin rx_done_reg   <= 1'b1; end 
            default: ;
        endcase    
    end 
end 

always @(posedge clk or negedge rst_n) begin  //data refresh; outputting data when receiving finished
    if (~rst_n) begin
        data_o_reg1 <= 0; 
    end 
    else begin
        data_o_reg1 <= (cnt == 8'd159) ? data_o_reg : data_o_reg1;    
    end 
end 

assign rx_done = rx_done_reg;
assign data_o  = data_o_reg1;

endmodule

//below for testing
/*
            0  : begin rx_done_reg   <= 1'b0; end 
            23 : begin data_o_reg[0] <= rx_reg1; end 
            39 : begin data_o_reg[1] <= rx_reg1; end 
            55 : begin data_o_reg[2] <= rx_reg1; end 
            71 : begin data_o_reg[3] <= rx_reg1; end 
            87 : begin data_o_reg[4] <= (~rx_reg1); end 
            103: begin data_o_reg[5] <= rx_reg1; end 
            119: begin data_o_reg[6] <= rx_reg1; end 
            135: begin data_o_reg[7] <= rx_reg1; end 
            159: begin rx_done_reg   <= 1'b1; end 

            0  : begin rx_done_reg   <= 1'b0; end 
            23 : begin data_o_reg[0] <= 0; end 
            39 : begin data_o_reg[1] <= 1; end 
            55 : begin data_o_reg[2] <= 1; end 
            71 : begin data_o_reg[3] <= 0; end 
            87 : begin data_o_reg[4] <= 0; end 
            103: begin data_o_reg[5] <= 0; end 
            119: begin data_o_reg[6] <= 0; end 
            135: begin data_o_reg[7] <= 1; end 
            159: begin rx_done_reg   <= 1'b1; end 
*/