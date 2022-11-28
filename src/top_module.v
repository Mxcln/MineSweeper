`include "parameter.v"

module top_module(
    input   wire                    clk         ,
    input   wire                    rst_n       ,   //同步复位，低电平有效，在开发板上：最右边的开关
    input   wire    [4:0]           button_i    ,   //按键，从4到0，依次是：中，左，右，上，下
    input   wire                    fm_switch   ,   //插旗、扫雷功能切换，1：插旗，0：扫雷  在开发板上：最左边的开关
    input   wire    [3:0]           difficulty  ,   //难度，从左到右为：地狱、困难、中等、简单，[4]的优先级最高。在开发板：第3~6个开关

    //VGA 输出
    output	wire					h_sync  ,       //行同步信号
    output	wire					v_sync  ,       //场同步信号
    output	wire	[3:0]			rgb_r   ,       //红色
    output	wire	[3:0]			rgb_g   ,       //绿色
    output	wire	[3:0]			rgb_b   ,       //蓝色

    //数码管输出
    output  wire    [6:0]           seg             ,   //7段数码管
    output  wire    [3:0]           display_digit       //数码管位选信号
);

    wire    [4:0]                               button          ;   //处理后的按键输入
    
    wire    [2:0]                                                       x_pos, y_pos        ;   //游戏当前选定的方格的x坐标
    wire    [`MAP_HEIGHT * `MAP_WIDTH - 1 : 0]                          map_flag, map_shown ;   //游戏当前选定的方格的y坐标
    wire    [`MAP_CELL_LENGTH * (`MAP_HEIGHT * `MAP_WIDTH ) - 1 : 0]    map;                    //游戏总地图：包括地雷和数字
    wire    [2:0]                                                       screen_state    ;       //当前屏幕状态
    wire    [15:0]                                                      time_count      ;       //计时器计数的8421码，[15:8]是分钟，[7:0]是秒


    io_process_top  u_io_process_top (
        .clk                     ( clk               ),
        .rst_n                   ( rst_n             ),
        .button_i                ( button_i          ),
        .seg_8421_code_i         ( time_count        ),

        .button_o                ( button            ),
        .seg_o                   ( seg               ),
        .display_digit_o         ( display_digit     ) 
    );

    //游戏顶层模块
    game_top  u_game_top (
        .clk                     ( clk              ),
        .rst_n                   ( rst_n            ),
        .button_i                ( button           ),
        .fm_switch_i             ( fm_switch        ),
        .difficulty_i            ( difficulty       ),

        .x_pos_o                 ( x_pos            ),
        .y_pos_o                 ( y_pos            ),
        .screen_state_o          ( screen_state     ),
        .map_o                   ( map              ),
        .map_shown_o             ( map_shown        ),
        .map_flag_o              ( map_flag         ),
        .time_count_o            ( time_count       )
    );

    //vga顶层模块
    vga_top  u_vga_top (
        .clk                     ( clk              ),
        .rst_n                   ( rst_n            ),
        .x_pos_i                 ( x_pos            ),
        .y_pos_i                 ( y_pos            ),
        .screen_state_i          ( screen_state     ),
        .map_i                   ( map              ),
        .map_shown_i             ( map_shown        ),
        .map_flag_i              ( map_flag         ),

        .h_sync                  ( h_sync           ),
        .v_sync                  ( v_sync           ),
        .rgb_r                   ( rgb_r            ),
        .rgb_g                   ( rgb_g            ),
        .rgb_b                   ( rgb_b            )
    );

endmodule