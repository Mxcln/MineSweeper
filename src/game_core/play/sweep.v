`include "../../parameter.v"

//决定扫当前方格雷/插旗的操作
//输出三个信号：
//一是 play_end_fail_o ，游戏失败的信号（当前方格扫到地雷）
//二是 map_shown_o ，游戏中显示出来的方格。1 表示显示出来，0 表示仍然隐藏
//三是 map_flag_o ，方格是否插旗的信号。1 表示插了旗子，0 表示没有

module sweep(
    input   wire                                        clk             ,
    input   wire                                        rst_n           ,
    input   wire    [2:0]                               screen_state_i  ,   //屏幕状态输入 
    input   wire    [2:0]                               x_pos_i         ,
    input   wire    [5:0]                               position_i      ,   //当前选定方格输入
    input   wire                                        mid_button_i    ,   //中间的按键输入（即扫雷的操作）
    input   wire                                        fm_switch_i     ,   //功能切换输入，1 为插旗，0 为扫雷

    input   wire    [`MAP_CELL_LENGTH * (`MAP_HEIGHT * `MAP_WIDTH ) - 1 : 0]  map_i ,   //总地图输入

    output  reg     [`MAP_HEIGHT * `MAP_WIDTH - 1 : 0]  map_shown_o     ,   //显示地图输出
    output  reg     [`MAP_HEIGHT * `MAP_WIDTH - 1 : 0]  map_flag_o          //插旗地图输出                 
    );

    //插旗地图信号驱动
    always@(posedge clk) begin
        if(!rst_n | screen_state_i != `GAME_PLAY)   //复位或者不在游戏状态时，插旗地图信号清零
            map_flag_o <= 0;
        else if(fm_switch_i & mid_button_i & !map_shown_o[position_i])  //插旗状态且按下按键时，插/取消插旗
            map_flag_o[position_i] <= !map_flag_o[position_i];
        else if(!fm_switch_i & mid_button_i & map_flag_o[position_i])
            map_flag_o[position_i] <= 0;
    end

    //显示地图的驱动
    genvar pos_index;
    generate
        for(pos_index = 0; pos_index < `MAP_HEIGHT*`MAP_WIDTH ; pos_index = pos_index + 1) begin
            always@(posedge clk) begin
                //复位或者在开始状态时，显示地图信号清零
                if(!rst_n | screen_state_i == `GAME_START)  
                    map_shown_o[pos_index] <= 0;

                //胜利或者失败时，全部显示
                else if(screen_state_i == `GAME_VICTORY | screen_state_i == `GAME_FAIL) 
                    map_shown_o[pos_index] <= 1'b1;
                
                //成功扫这个方格的条件：处于扫雷状态而不是插旗状态，按下按键，当前方格未插旗
                else if(!fm_switch_i & mid_button_i & !map_flag_o[position_i] & (pos_index == position_i))
                        map_shown_o[pos_index] <= 1'b1;
                        
                //如果在已经显示的方格按下按键：把周围不是旗子的方格全部显示
                else if(mid_button_i & map_shown_o[position_i] & !map_flag_o[pos_index]) begin
                    //左上角的方格
                    if(position_i == 0)         
                        map_shown_o[pos_index] <= (pos_index == 1 | pos_index == `MAP_WIDTH | pos_index == `MAP_WIDTH + 1 | map_shown_o[pos_index]) ;
                    
                    //右上角的方格
                    else if(position_i  == `MAP_WIDTH - 1)  
                        map_shown_o[pos_index] <= (pos_index == `MAP_WIDTH - 2 | pos_index == 2*`MAP_WIDTH - 2 | pos_index == 2*`MAP_WIDTH - 1 | map_shown_o[pos_index]);

                    //左下角的方格
                    else if(position_i == `MAP_WIDTH * (`MAP_HEIGHT - 1)) 
                        map_shown_o[pos_index] <= (pos_index == (`MAP_HEIGHT-2) * `MAP_WIDTH | pos_index == (`MAP_HEIGHT-2) * `MAP_WIDTH + 1
                                                    | pos_index == (`MAP_HEIGHT-1) * `MAP_WIDTH + 1 | map_shown_o[pos_index]);

                    //右下角的方格
                    else if(position_i == `MAP_WIDTH * `MAP_HEIGHT - 1)
                        map_shown_o[pos_index] <= (pos_index == `MAP_WIDTH*`MAP_HEIGHT - 1 - `MAP_WIDTH | pos_index == `MAP_WIDTH*`MAP_HEIGHT - 2 - `MAP_WIDTH
                                                    | pos_index == `MAP_WIDTH*`MAP_HEIGHT - 2 | map_shown_o[pos_index]);

                    //上面一行
                    else if(position_i < `MAP_WIDTH)
                        map_shown_o[pos_index] <= (pos_index == position_i - 1 | pos_index == position_i + 1 | pos_index == position_i - 1 + `MAP_WIDTH
                                                    | pos_index == position_i + `MAP_WIDTH | pos_index == position_i + 1 + `MAP_WIDTH | map_shown_o[pos_index]);
                    
                    //下面一行
                    else if(position_i > `MAP_WIDTH * (`MAP_HEIGHT - 1))
                        map_shown_o[pos_index] <= (pos_index == position_i - 1 | pos_index == position_i + 1 | pos_index == position_i - 1 - `MAP_WIDTH
                                                    | pos_index == position_i - `MAP_WIDTH | pos_index == position_i + 1 - `MAP_WIDTH | map_shown_o[pos_index]);

                    //左边一列
                    else if(x_pos_i == 0)
                        map_shown_o[pos_index] <= (pos_index == position_i - `MAP_WIDTH | pos_index == position_i + 1 - `MAP_WIDTH | pos_index == position_i + 1
                                                    | pos_index == position_i + `MAP_WIDTH | pos_index == position_i + 1 + `MAP_WIDTH | map_shown_o[pos_index]);
                    
                    //右边一列
                    else if(x_pos_i == `MAP_WIDTH - 1)
                        map_shown_o[pos_index] <= (pos_index == position_i - `MAP_WIDTH | pos_index == position_i - 1 - `MAP_WIDTH | pos_index == position_i - 1
                                                    | pos_index == position_i + `MAP_WIDTH | pos_index == position_i - 1 + `MAP_WIDTH | map_shown_o[pos_index]);

                    //中间
                    else
                        map_shown_o[pos_index] <= (pos_index == position_i - 1 - `MAP_WIDTH | pos_index == position_i - `MAP_WIDTH | pos_index == position_i + 1 - `MAP_WIDTH
                                                    | pos_index == position_i - 1 | pos_index == position_i + 1 
                                                    | pos_index == position_i - 1 + `MAP_WIDTH | pos_index == position_i + `MAP_WIDTH | pos_index == position_i + 1 + `MAP_WIDTH | map_shown_o[pos_index]);
                end

                else begin
                    //是否显示的推导：看周围8个格子之中是否存在显示的zero_cell,有则一定显示，否则保持原状
                    //非常繁琐！因为需要对不同位置的方格讨论，不同位置的方格周围的方格数量不相等。
                    //这里的推导有延时，但是实际的按键不会影响，在仿真的时候应该注意

                    //左上角的方格
                    if(pos_index == 0)      
                        map_shown_o[pos_index] <= (map_i[( 1                            ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ 1              ])
                                                | (map_i[( `MAP_WIDTH                   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ `MAP_WIDTH     ])
                                                | (map_i[( `MAP_WIDTH + 1               ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ `MAP_WIDTH + 1 ])
                                                | map_shown_o[pos_index];

                    //右上角的方格
                    else if(pos_index == `MAP_WIDTH - 1)    
                        map_shown_o[pos_index] <= (map_i[( pos_index - 1                ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index - 1              ]) 
                                                | (map_i[( pos_index - 1 +  `MAP_WIDTH  ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index - 1 + `MAP_WIDTH ])
                                                | (map_i[( pos_index     +  `MAP_WIDTH  ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index     + `MAP_WIDTH ])
                                                | map_shown_o[pos_index];

                    //左下角的方格
                    else if(pos_index == `MAP_WIDTH * (`MAP_HEIGHT - 1))    
                        map_shown_o[pos_index] <= (map_i[( pos_index     - `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index     - `MAP_WIDTH ]) 
                                                | (map_i[( pos_index + 1 - `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index + 1 - `MAP_WIDTH ])
                                                | (map_i[( pos_index + 1                ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index + 1              ])
                                                | map_shown_o[pos_index];

                    //右下角
                    else if(pos_index == `MAP_WIDTH * `MAP_HEIGHT - 1)      
                        map_shown_o[pos_index] <= (map_i[( pos_index     - `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index     - `MAP_WIDTH ]) 
                                                | (map_i[( pos_index - 1 - `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index - 1 - `MAP_WIDTH ])
                                                | (map_i[( pos_index - 1                ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index - 1              ])
                                                | map_shown_o[pos_index];

                    //上面一行的方格（除了两个角落）
                    else if(pos_index < `MAP_WIDTH)         
                        map_shown_o[pos_index] <= (map_i[( pos_index - 1                ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index - 1              ]) 
                                                | (map_i[( pos_index - 1 + `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index - 1 + `MAP_WIDTH ])
                                                | (map_i[( pos_index     + `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index     + `MAP_WIDTH ])
                                                | (map_i[( pos_index + 1 + `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index + 1 + `MAP_WIDTH ])
                                                | (map_i[( pos_index + 1                ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index + 1              ])
                                                | map_shown_o[pos_index];

                    //下面一行的方格（除了两个角落）
                    else if(pos_index > `MAP_WIDTH * (`MAP_HEIGHT - 1))     
                        map_shown_o[pos_index] <= (map_i[( pos_index - 1                ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index - 1              ]) 
                                                | (map_i[( pos_index - 1 - `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index - 1 - `MAP_WIDTH ])
                                                | (map_i[( pos_index     - `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index     - `MAP_WIDTH ])
                                                | (map_i[( pos_index + 1 - `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index + 1 - `MAP_WIDTH ])
                                                | (map_i[( pos_index + 1                ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index + 1              ])
                                                | map_shown_o[pos_index];

                    //左边一列的方格（除了两个角落）
                    else if(pos_index % `MAP_WIDTH == 0)        
                        map_shown_o[pos_index] <= (map_i[( pos_index     - `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index     - `MAP_WIDTH ]) 
                                                | (map_i[( pos_index + 1 - `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index + 1 - `MAP_WIDTH ])
                                                | (map_i[( pos_index + 1                ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index + 1              ])
                                                | (map_i[( pos_index + 1 + `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index + 1 + `MAP_WIDTH ])
                                                | (map_i[( pos_index     + `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index     + `MAP_WIDTH ])
                                                | map_shown_o[pos_index];

                    //右边一列的方格（除了两个角落）
                    else if(pos_index % `MAP_WIDTH == 7)        
                        map_shown_o[pos_index] <= (map_i[( pos_index     - `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index     - `MAP_WIDTH ]) 
                                                | (map_i[( pos_index - 1 - `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index - 1 - `MAP_WIDTH ])
                                                | (map_i[( pos_index - 1                ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index - 1              ])
                                                | (map_i[( pos_index - 1 + `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index - 1 + `MAP_WIDTH ])
                                                | (map_i[( pos_index     + `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index     + `MAP_WIDTH ])
                                                | map_shown_o[pos_index];
                    
                    //中间的方格，周围有8个方格，最完整
                    else 
                        map_shown_o[pos_index] <= (map_i[( pos_index - 1 - `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index - 1 - `MAP_WIDTH ])
                                                | (map_i[( pos_index     - `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index     - `MAP_WIDTH ]) 
                                                | (map_i[( pos_index + 1 - `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index + 1 - `MAP_WIDTH ])
                                                | (map_i[( pos_index - 1                ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index - 1              ])
                                                | (map_i[( pos_index + 1                ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index + 1              ])
                                                | (map_i[( pos_index - 1 + `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index - 1 + `MAP_WIDTH ])
                                                | (map_i[( pos_index     + `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index     + `MAP_WIDTH ])
                                                | (map_i[( pos_index + 1 + `MAP_WIDTH   ) * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_ZERO & map_shown_o[ pos_index + 1 + `MAP_WIDTH ])
                                                | map_shown_o[pos_index];
                end
            end
        end
    endgenerate

endmodule