`timescale  1ns / 1ps
`include "../src/parameter.v"

module game_top_tb;

// game_top Parameters
parameter PERIOD  = 10;


// game_top Inputs
reg   clk                                  = 0 ;       
reg   rst_n                                = 0 ;       
reg   [4:0]  button_i                      = 0 ;       

// game_top Outputs
wire    [2:0]  x_pos_o                       ;
wire    [2:0]  y_pos_o                       ;
wire    [`MAP_CELL_LENGTH * (`MAP_HEIGHT * `MAP_WIDTH ) - 1 : 0]  map_o ;      
wire    [`MAP_HEIGHT * `MAP_WIDTH - 1 : 0]  map_shown_o ;
wire    [2:0]  screen_state_o                ;
wire    [15:0]  time_count_o                    ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;

    //screen_state进入map_gen状态，地图开始生成,生成后开始游戏
    #(PERIOD*2) button_i = `BUTTON_MID;
    #(PERIOD)   button_i = `BUTTON_NONE;

    //游戏开始
    #(PERIOD*15) button_i = `BUTTON_DOWN;
    #(PERIOD) button_i = `BUTTON_NONE;

    #(PERIOD*2) button_i = `BUTTON_RIGHT;
    #(PERIOD) button_i = `BUTTON_NONE;

    #(PERIOD*2) button_i = `BUTTON_MID;
    #(PERIOD) button_i = `BUTTON_NONE;

    #(PERIOD*2) button_i = `BUTTON_DOWN;
    #(PERIOD) button_i = `BUTTON_NONE;

    #(PERIOD*2) button_i = `BUTTON_DOWN;
    #(PERIOD) button_i = `BUTTON_NONE;

    #(PERIOD*2) button_i = `BUTTON_DOWN;
    #(PERIOD) button_i = `BUTTON_NONE;

    #(PERIOD*2) button_i = `BUTTON_DOWN;
    #(PERIOD) button_i = `BUTTON_NONE;

    #(PERIOD*2) button_i = `BUTTON_RIGHT;
    #(PERIOD) button_i = `BUTTON_NONE;

    #(PERIOD*2) button_i = `BUTTON_MID;
    #(PERIOD) button_i = `BUTTON_NONE;

    #(PERIOD*2) button_i = `BUTTON_DOWN;
    #(PERIOD) button_i = `BUTTON_NONE;

    #(PERIOD*2) button_i = `BUTTON_LEFT;
    #(PERIOD) button_i = `BUTTON_NONE;

    //碰到地雷了！
    #(PERIOD*2) button_i = `BUTTON_MID;
    #(PERIOD) button_i = `BUTTON_NONE;

    //重新开始吧
    #(PERIOD*3) button_i = `BUTTON_MID;
    #(PERIOD) button_i = `BUTTON_NONE;
end

game_top  u_game_top (
    .clk                     ( clk                      ),
    .rst_n                   ( rst_n                    ),
    .button_i                ( button_i                 ),

    .x_pos_o                 ( x_pos_o                  ),
    .y_pos_o                 ( y_pos_o                  ),
    .map_o                   ( map_o                    ),
    .map_shown_o             ( map_shown_o              ),
    .screen_state_o          ( screen_state_o           ),
    .time_count_o            ( time_count_o             )
);

endmodule