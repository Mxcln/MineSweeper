`timescale  1ns / 1ps
`include "../src/parameter.v"

// mine_map:
// 0 0 0 0 _ 0 0 0 1
// 0 0 0 0 _ 1 0 0 1
// 0 0 0 0 _ 0 0 0 0
// 1 0 0 0 _ 1 1 0 1
// 0 1 0 1 _ 0 0 0 0
// 1 1 1 1 _ 1 0 0 1
// 1 1 0 1 _ 0 0 1 1
// 1 1 1 1 _ 0 1 1 0

module play_top_tb;

// play_top Parameters
parameter PERIOD  = 10;


// play_top Inputs
reg   clk                                       = 0 ;       
reg   rst_n                                     = 0 ;       
reg   [4:0]  button_i                           = `BUTTON_NONE ;       
reg   [2:0]  screen_state_i                     = `GAME_START ;       
reg   [`MAP_HEIGHT * `MAP_WIDTH - 1 : 0]  map_i = 64'h6fcb_9f0a_b100_9080 ;  

// play_top Outputs
wire  [2:0]  x_pos_o                       ;
wire  [2:0]  y_pos_o                       ;
wire  [1:0]  play_end                      ;
wire  [`MAP_HEIGHT * `MAP_WIDTH - 1 : 0]  map_shown_o ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD) rst_n  =  1;
    screen_state_i = `GAME_PLAY;

    #(PERIOD*2) button_i = `BUTTON_DOWN;
    #(PERIOD) button_i = `BUTTON_NONE;

    #(PERIOD*2) button_i = `BUTTON_RIGHT;
    #(PERIOD) button_i = `BUTTON_NONE;

    #(PERIOD*2) button_i = `BUTTON_MID;
    #(PERIOD) button_i = `BUTTON_NONE;

    #(PERIOD*2) button_i = `BUTTON_DOWN;
    #(PERIOD) button_i = `BUTTON_NONE;

    #(PERIOD*2) button_i = `BUTTON_DOWN;
    #(PERIOD) button_i = `BUTTON_NONE;

    #(PERIOD*2) button_i = `BUTTON_MID;
    #(PERIOD) button_i = `BUTTON_NONE;

    #(PERIOD*2) button_i = `BUTTON_DOWN;
    #(PERIOD) button_i = `BUTTON_NONE;

    #(PERIOD*2) button_i = `BUTTON_MID;
    #(PERIOD) button_i = `BUTTON_NONE;
    
end

play_top  u_play_top (
    .clk                     ( clk                                                ),
    .rst_n                   ( rst_n                                              ),
    .button_i                ( button_i        [4:0]                              ),
    .screen_state_i          ( screen_state_i  [2:0]                              ),
    .map_i                   ( map_i           [`MAP_HEIGHT * `MAP_WIDTH - 1 : 0] ),

    .x_pos_o                 ( x_pos_o         [2:0]                              ),
    .y_pos_o                 ( y_pos_o         [2:0]                              ),
    .play_end                ( play_end        [1:0]                              ),
    .map_shown_o             ( map_shown_o     [`MAP_HEIGHT * `MAP_WIDTH - 1 : 0] )
);

endmodule