`timescale  1ns / 1ps
`include "../src/parameter.v"

module deduce_mine_num_tb;

// deduce_mine_num Parameters
parameter PERIOD  = 10;


// deduce_mine_num Inputs
reg   clk                                       = 0 ;
reg   rst_n                                     = 0 ;
reg   [`MAP_HEIGHT * `MAP_WIDTH - 1 : 0]  map_i = 64'h6fcb_9f0a_b100_9080 ;
reg   [2:0]  x_pos_i                            = 0 ;
reg   [2:0]  y_pos_i                            = 0 ;
reg   [7:0]  position_i                         = 0 ;

// deduce_mine_num Outputs
wire  [3:0]  round_mine_num_o              ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n   =  1;

    //左上角
    #(PERIOD*2); 
    x_pos_i = 3'd0;
    y_pos_i = 3'd0;
    position_i = 8'd0;

    //右上角
     #(PERIOD*2); 
    x_pos_i = `MAP_WIDTH-1;
    y_pos_i = 3'd0;
    position_i = `MAP_WIDTH-1;

    //左下角
    #(PERIOD*2); 
    x_pos_i = 3'd0;
    y_pos_i = `MAP_HEIGHT-1;
    position_i = (`MAP_HEIGHT-1)*`MAP_WIDTH;

    //右下角
    #(PERIOD*2); 
    x_pos_i = `MAP_WIDTH-1;
    y_pos_i = `MAP_HEIGHT-1;
    position_i = `MAP_WIDTH * `MAP_HEIGHT - 1;

    //上方一行
    #(PERIOD*2); 
    x_pos_i = 3'd4;
    y_pos_i = 3'd0;
    position_i = 8'd4;

    //下方一行
    #(PERIOD*2); 
    x_pos_i = 3'd4;
    y_pos_i = `MAP_HEIGHT-1;
    position_i = 8'd4 + (`MAP_HEIGHT-1)*`MAP_WIDTH;

    //左边一列
    #(PERIOD*2); 
    x_pos_i = 3'd0;
    y_pos_i = 3'd4;
    position_i = 3'd4*`MAP_WIDTH;

    //右边一列
    #(PERIOD*2); 
    x_pos_i = `MAP_WIDTH-1;
    y_pos_i = 3'd4;
    position_i = `MAP_WIDTH-1 + 3'd4*`MAP_WIDTH;

    //中间
    #(PERIOD*2); 
    x_pos_i = 3'd4;
    y_pos_i = 3'd4;
    position_i = 3'd4*`MAP_WIDTH + 3'd4;

    //中间
    #(PERIOD*2); 
    x_pos_i = 3'd2;
    y_pos_i = 3'd6;
    position_i = 3'd6*`MAP_WIDTH + 3'd2;
end

deduce_mine_num  u_deduce_mine_num (
    .clk                     ( clk                                                  ),  
    .rst_n                   ( rst_n                                                ),  
    .map_i                   ( map_i             [`MAP_HEIGHT * `MAP_WIDTH - 1 : 0] ),  
    .x_pos_i                 ( x_pos_i           [2:0]                              ),  
    .y_pos_i                 ( y_pos_i           [2:0]                              ),  
    .position_i              ( position_i        [7:0]                              ),  

    .round_mine_num_o        ( round_mine_num_o  [3:0]                              )   
);

endmodule
