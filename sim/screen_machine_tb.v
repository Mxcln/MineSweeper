`timescale  1ns / 1ps
`include "../src/parameter.v"

module screen_machine_tb;

// screen_machine Parameters
parameter PERIOD  = 10;


// screen_machine Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   mid_button_i                         = 0 ;
reg   [1:0]  play_end_i                    = 0 ;

// screen_machine Outputs
wire  [2:0]  screen_state_o                ;    


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;

    //开始生成地图，生成完之后自动进入游戏状态
    #(PERIOD*2) mid_button_i = 1;
    #(PERIOD)   mid_button_i = 0;


    #(PERIOD*15) mid_button_i = 1;  //这里的按键没有用：游戏状态的mid按键不会影响状态机
    #(PERIOD)   mid_button_i = 0;
    play_end_i = 2'b01;             //但是游戏结束信号会，这里游戏失败。

    //重开
    #(PERIOD*2) mid_button_i = 1;
    #(PERIOD)   mid_button_i = 0;
    play_end_i = 2'b00;

    //地图生成，之后开始游戏
    #(PERIOD*2) mid_button_i = 1;
    #(PERIOD)   mid_button_i = 0;

    #(PERIOD*15) mid_button_i = 1;
    #(PERIOD)   mid_button_i = 0;
    play_end_i = 2'b10;

    #(PERIOD*2) mid_button_i = 1;
    #(PERIOD)   mid_button_i = 0;
end

screen_machine  u_screen_machine (
    .clk                     ( clk                   ),
    .rst_n                   ( rst_n                 ),
    .mid_button_i            ( mid_button_i          ),
    .play_end_i              ( play_end_i      [1:0] ),

    .screen_state_o          ( screen_state_o  [2:0] )
);

endmodule