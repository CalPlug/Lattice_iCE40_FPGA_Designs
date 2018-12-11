
module  uart_tx (
/*i*/   input    wire             clk            , 
        input    wire    [7:0]    data_i         ,
/*o*/   output   wire             tx             ,
        output   wire             tx_done 
);
reg send_en_reg0;
reg send_en_reg1;
reg [7:0] data_i_reg;
reg bps_clk;
reg bps_en;
reg [10:0] bps_cnt;   //G
reg [3:0] cnt;
reg tx_done_reg;
reg tx_reg;

parameter bps = 11'd1250; //G
parameter send_en = 1'b1; //G

wire rst_n;
reg [6:0] rststate = 0;
assign rst_n = &rststate;
always @(posedge clk) rststate <= rststate + !rst_n;

//bps
always @(posedge clk or negedge rst_n) begin //bps_cnt;
    if (~rst_n) begin
        bps_cnt <= 0;
    end 
    else begin
        if (bps_en == 1'b1) begin
            bps_cnt <= (bps_cnt == bps) ? 11'd0 : bps_cnt + 1'b1;  //G
        end
        else begin
            bps_cnt <= 0;        
        end    
    end 
end 
//
always @(posedge clk or negedge rst_n) begin //bps_clk;
    if (~rst_n) begin
        bps_clk <= 0;
    end 
    else begin
        if (bps_cnt == 11'd1) begin   //G
            bps_clk <= 1'b1;
        end 
        else begin
            bps_clk <= 1'b0;       
        end   
    end 
end 

always @(posedge clk or negedge rst_n) begin //send_en syn;
    if (~rst_n) begin
        send_en_reg0 <= 0;
        send_en_reg1 <= 0;
    end 
    else begin
        send_en_reg0 <= send_en;
        send_en_reg1 <= send_en_reg0;    
    end 
end

always @(posedge clk or negedge rst_n) begin //data refresh;
    if (~rst_n) begin
        data_i_reg <= 0;
    end 
    else begin
        data_i_reg <= (send_en_reg1) ? data_i : data_i_reg;    
    end 
end 

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        bps_en <= 1'b0;
    end 
    else begin
        if (send_en_reg1 == 1'b1) begin
            bps_en <= 1'b1;
        end    
        else begin
            bps_en <= (cnt == 4'd10) ? 1'b0 : bps_en;
        end
    end 
end 
//

//
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
    end 
    else begin
        if (cnt == 4'd10) begin
            cnt <= 0;
        end    
        else begin
            cnt <= (bps_clk == 1'b1) ? cnt + 1'b1 : cnt;
        end
    end 
end 
//
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        tx_done_reg <= 1'b0;
        tx_reg <= 1'b1;
    end 
    else begin
        case (cnt)
                0 : begin tx_done_reg <= 1'b0;tx_reg <= 1'b1; end
                1 : begin tx_reg <= 1'b0; end
                2 : begin tx_reg <= data_i_reg[0]; end
                3 : begin tx_reg <= data_i_reg[1]; end
                4 : begin tx_reg <= data_i_reg[2]; end
                5 : begin tx_reg <= data_i_reg[3]; end
                6 : begin tx_reg <= data_i_reg[4]; end
                7 : begin tx_reg <= data_i_reg[5]; end
                8 : begin tx_reg <= data_i_reg[6]; end
                9 : begin tx_reg <= data_i_reg[7]; end
                10: begin tx_done_reg <= 1'b1;tx_reg <= 1'b1; end
                default:  begin tx_done_reg <= 1'b0;tx_reg <= 1'b1; end
            endcase    
    end 
end 

assign tx_done = tx_done_reg;
assign tx = tx_reg;

endmodule