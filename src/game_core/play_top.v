`include "../parameter.v"

//游戏状态下的核心游玩模块

module play_top(
    input   wire                                        clk             ,
    input   wire                                        rst_n           ,
    input   wire    [2:0]                               screen_state_i  ,   //屏幕状态输入
    input   wire    [4:0]                               button_i        ,   //按键输入
    input   wire                                        fm_switch_i     ,   //插/扫功能切换输入

    input   wire    [`MAP_CELL_LENGTH * (`MAP_HEIGHT * `MAP_WIDTH ) - 1 : 0]  map_i ,   //总地图输入

    output  wire    [2:0]                               x_pos_o         ,   //当前选定方格的x坐标输出
    output  wire    [2:0]                               y_pos_o         ,   //当前选定方格的y坐标输出
    output  wire    [1:0]                               play_end        ,   //游戏结束信号输出，[1]是胜利，[0]是失败
    output  wire    [`MAP_HEIGHT * `MAP_WIDTH - 1 : 0]  map_shown_o     ,   //显示地图输出
    output  wire    [`MAP_HEIGHT * `MAP_WIDTH - 1 : 0]  map_flag_o          //插旗地图输出
    );

    wire    [5:0]   position        ;                   //当前选定的位置的接线                     

    //选定方格移动模块
    move  u_move (
        .clk                     ( clk              ),
        .rst_n                   ( rst_n            ),
        .screen_state_i          ( screen_state_i   ),  //屏幕状态输入
        .button_i                ( button_i         ),  //按键输入

        .x_pos_o                 ( x_pos_o          ),  //当前选定方格的x坐标输出
        .y_pos_o                 ( y_pos_o          ),  //当前选定方格的y坐标输出
        .position_o              ( position         )   //当前选定的位置输出
    );

    //扫雷、插旗模块（包括游戏失败信号输出）
    sweep  u_sweep (
        .clk                     ( clk                ),  
        .rst_n                   ( rst_n              ),
        .screen_state_i          ( screen_state_i     ),    //屏幕状态输入
        .x_pos_i                 ( x_pos_o            ),
        .position_i              ( position           ),    //当前选定的位置输入
        .mid_button_i            ( button_i[4]        ),    //按键输入
        .fm_switch_i             ( fm_switch_i        ),    //插/扫功能切换输入
        .map_i                   ( map_i              ),    //游戏总地图输入

        .map_shown_o             ( map_shown_o        ),    //显示地图输出
        .map_flag_o              ( map_flag_o         )     //插旗地图输出
    );

    //游戏结束条件判断模块
    end_condition  u_end_condition (
        .map_i                   ( map_i          ),        //总地图输入    
        .map_shown_i             ( map_shown_o    ),        //显示地图输入

        .play_end_o              ( play_end       )         //游戏胜利输出信号
    );

endmodule