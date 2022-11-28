`include "../parameter.v"

module game_top(
    input   wire            clk             ,
    input   wire            rst_n           ,
    input   wire    [4:0]   button_i        ,       //按键输入，从[4]到[0]分别为：中，左，右，上，下
    input   wire            fm_switch_i     ,       //功能选择输入：1插旗，0扫雷
    input   wire    [3:0]   difficulty_i    ,       //难度选择

    output  wire    [2:0]                               x_pos_o             ,   //当前选定的方格的x坐标输出
    output  wire    [2:0]                               y_pos_o             ,   //当前选定的方格的y坐标输出
    output  wire    [2:0]                               screen_state_o      ,   //当前屏幕状态输出   
    
    output  wire    [`MAP_CELL_LENGTH * (`MAP_HEIGHT * `MAP_WIDTH ) - 1 : 0]    map_o       ,   //游戏地图，包括地雷和数字
    output  wire    [`MAP_HEIGHT * `MAP_WIDTH - 1 : 0]                          map_shown_o ,   //显示地图。 1 表示方格在游戏中已经显示
    output  wire    [`MAP_HEIGHT * `MAP_WIDTH - 1 : 0]                          map_flag_o  ,   //插旗地图。


    output  wire    [15:0]                              time_count_o        //游戏进行时间（8421）[15:8]是分钟，[7:0]是秒
    );

    wire    [1:0]   play_end;               //游戏结束标志；[1]胜利，[0]失败

    //调用屏幕显示状态机模块
    screen_machine  u_screen_machine (
        .clk                     ( clk            ),
        .rst_n                   ( rst_n          ),
        .mid_button_i            ( button_i[4]    ),
        .difficulty_i            ( difficulty_i   ),
        .play_end_i              ( play_end       ),    //游戏结束的信号。[1]表示胜利，[0]表示失败，均为1有效

        .screen_state_o          ( screen_state_o )     //屏幕状态输出
    );

    //地图生成模块
    map_genarate  u_map_genarate (
        .clk                     ( clk              ),
        .rst_n                   ( rst_n            ),
        .screen_state_i          ( screen_state_o   ),  //屏幕状态输入

        .map_o                   ( map_o            )
    );

    //核心游戏模块
    play_top  u_play_top (
        .clk                     ( clk                  ),    
        .rst_n                   ( rst_n                ),
        .screen_state_i          ( screen_state_o       ),    
        .button_i                ( button_i             ),
        .fm_switch_i             ( fm_switch_i          ),
        .map_i                   ( map_o                ),  

        .x_pos_o                 ( x_pos_o              ),
        .y_pos_o                 ( y_pos_o              ),
        .play_end                ( play_end             ),
        .map_shown_o             ( map_shown_o          ),
        .map_flag_o              ( map_flag_o           )
    );

    //计时器模块
    time_counter  u_time_counter (
        .clk                     ( clk                  ),
        .rst_n                   ( rst_n                ),
        .screen_state_i          ( screen_state_o       ),

        .seconds_o               ( time_count_o[7:0]    ),
        .minutes_o               ( time_count_o[15:8]    ) 
    );
endmodule
