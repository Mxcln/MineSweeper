`include "../../parameter.v"

//胜利条件：
//是地雷的方格全部不能显示（插旗或者空着都可以），不是地雷的方格全部都要显示
//失败条件
//存在一个方格，是地雷而且显示

module end_condition(
    input   wire    [`MAP_CELL_LENGTH * (`MAP_HEIGHT * `MAP_WIDTH ) - 1 : 0]    map_i,          //游戏总地图输入
    input   wire    [`MAP_HEIGHT * `MAP_WIDTH - 1 : 0]                          map_shown_i,    //显示地图输入。 1 表示显示 

    output  wire    [1:0]   play_end_o          //游戏结束信号输出
    );

    wire    [`MAP_HEIGHT * `MAP_WIDTH - 1 : 0]  condition_vic   ;  //储存每个方格的胜利条件
    wire    [`MAP_HEIGHT * `MAP_WIDTH - 1 : 0]  condition_fail  ;  //储存每个方格的失败条件

    genvar pos_index;
    generate
        for(pos_index = 0; pos_index < `MAP_WIDTH * `MAP_HEIGHT; pos_index = pos_index + 1) begin
            //使用异或：是地雷 异或 是显示 ，二者不能相同，temp才为 1
            assign  condition_vic[pos_index] = (map_i[pos_index * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_MINE) ^ map_shown_i[pos_index];
            assign  condition_fail[pos_index] = (map_i[pos_index * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_MINE) & map_shown_i[pos_index];
        end
    endgenerate

    assign play_end_o[1] = &condition_vic;       //只有所有的方格的胜利条件都满足才算胜利
    assign play_end_o[0] = |condition_fail;       //只要有一个方格的失败条件满足就失败

endmodule
