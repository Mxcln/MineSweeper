`include "../parameter.v"

//生成地图，并且在游戏过程中不会改变


module map_genarate(
    input   wire                                        clk,
    input   wire                                        rst_n,                                     
    input   wire    [2:0]                               screen_state_i,

    output  reg     [`MAP_CELL_LENGTH * (`MAP_HEIGHT * `MAP_WIDTH ) - 1 : 0]    map_o   //生成的地图

    );
      
    wire    [2:0]                               x_ram;              //x的随机信号
    wire    [2:0]                               y_ram;              //y的随机信号
    reg     [`MAP_HEIGHT * `MAP_WIDTH - 1 : 0]  map_mine;

    //由于什么时候进入地雷生成模块是由玩家什么时候按下按键决定的，因此是可以说是完全的随机。
    always@(posedge clk) begin
        if(!rst_n | screen_state_i == `GAME_START)
            map_mine <= 'b0;
        else if(screen_state_i == `GAME_MAP_GEN)
            map_mine[x_ram + y_ram * `MAP_WIDTH] <= 1'b1;        //产生一个地雷。
    end

    //根据地雷地图推导出游戏总地图。
    //非常复杂，因为每个方格位置不同，周围的方格的个数也不相同，需要分类讨论
    genvar pos_index;
    generate
        for(pos_index = 0; pos_index < `MAP_HEIGHT*`MAP_WIDTH ; pos_index = pos_index + 1) begin
            always@(posedge clk) begin
                if(!rst_n)
                    map_o[`MAP_CELL_LENGTH * (pos_index + 1) - 1 : `MAP_CELL_LENGTH * pos_index] <= 0;
                else begin
                    //是地雷的情况
                    if(map_mine[pos_index])
                        map_o[`MAP_CELL_LENGTH * (pos_index + 1) - 1 : `MAP_CELL_LENGTH * pos_index] <= `IS_MINE;
                    else begin
                        //左上角的方格
                        if(pos_index == 0)
                            map_o[3:0] <= map_mine[1] + map_mine[`MAP_WIDTH] + map_mine[`MAP_WIDTH + 1] ;

                        //右上角的方格
                        else if(pos_index == `MAP_WIDTH - 1)
                            map_o[`MAP_CELL_LENGTH * (pos_index + 1) - 1 : `MAP_CELL_LENGTH * pos_index] 
                                <= map_mine[`MAP_WIDTH - 2] + map_mine[`MAP_WIDTH*2 - 2] + map_mine[`MAP_WIDTH*2 - 1] ;

                        //左下角的方格
                        else if(pos_index == `MAP_WIDTH * (`MAP_HEIGHT - 1))
                            map_o[`MAP_CELL_LENGTH * (pos_index + 1) - 1 : `MAP_CELL_LENGTH * pos_index]
                                <= map_mine[(`MAP_HEIGHT-2) * `MAP_WIDTH] + map_mine[(`MAP_HEIGHT-2) * `MAP_WIDTH + 1] 
                                    + map_mine[(`MAP_HEIGHT-1) * `MAP_WIDTH + 1] ;

                        //右下角的方格
                        else if(pos_index == `MAP_WIDTH * `MAP_HEIGHT - 1)
                            map_o[`MAP_CELL_LENGTH * (pos_index + 1) - 1 : `MAP_CELL_LENGTH * pos_index]
                                <= map_mine[`MAP_WIDTH*`MAP_HEIGHT - 1 - `MAP_WIDTH ] + map_mine[`MAP_WIDTH*`MAP_HEIGHT - 2 - `MAP_WIDTH]
                                    + map_mine[`MAP_WIDTH*`MAP_HEIGHT - 2] ;

                        //上面一行的方格（不包括角落）
                        else if(pos_index < `MAP_WIDTH)
                            map_o[`MAP_CELL_LENGTH * (pos_index + 1) - 1 : `MAP_CELL_LENGTH * pos_index]
                                <= map_mine[pos_index - 1] + map_mine[pos_index + 1] + map_mine[pos_index - 1 + `MAP_WIDTH]
                                    + map_mine[pos_index + 1 + `MAP_WIDTH] + map_mine[pos_index + `MAP_WIDTH];

                        //下面一行的方格（不包括角落）
                        else if(pos_index > `MAP_WIDTH * (`MAP_HEIGHT - 1))
                            map_o[`MAP_CELL_LENGTH * (pos_index + 1) - 1 : `MAP_CELL_LENGTH * pos_index]
                                <= map_mine[pos_index - 1] + map_mine[pos_index + 1] + map_mine[pos_index - 1 - `MAP_WIDTH]
                                + map_mine[pos_index + 1 - `MAP_WIDTH] + map_mine[pos_index - `MAP_WIDTH];

                        //左边一列的方格（不包括角落）
                        else if(pos_index % `MAP_WIDTH == 0)        
                            map_o[`MAP_CELL_LENGTH * (pos_index + 1) - 1 : `MAP_CELL_LENGTH * pos_index]
                                <= map_mine[pos_index - `MAP_WIDTH] + map_mine[pos_index - `MAP_WIDTH + 1] + map_mine[pos_index + 1]
                                + map_mine[pos_index + 1 + `MAP_WIDTH] + map_mine[pos_index + `MAP_WIDTH];

                        else if(pos_index % `MAP_WIDTH == 7)        //右边一列
                            map_o[`MAP_CELL_LENGTH * (pos_index + 1) - 1 : `MAP_CELL_LENGTH * pos_index]
                                <= map_mine[pos_index - `MAP_WIDTH] + map_mine[pos_index - `MAP_WIDTH - 1] + map_mine[pos_index - 1]
                                + map_mine[pos_index - 1 + `MAP_WIDTH] + map_mine[pos_index + `MAP_WIDTH];
                        
                        else //中间
                            map_o[`MAP_CELL_LENGTH * (pos_index + 1) - 1 : `MAP_CELL_LENGTH * pos_index]
                                <= map_mine[pos_index - `MAP_WIDTH - 1] + map_mine[pos_index - `MAP_WIDTH] + map_mine[pos_index - `MAP_WIDTH + 1]
                                    + map_mine[pos_index - 1] + map_mine[pos_index + 1]
                                    + map_mine[pos_index + `MAP_WIDTH - 1] + map_mine[pos_index + `MAP_WIDTH] + map_mine[pos_index + `MAP_WIDTH + 1];
                    end
                end
            end
        end
    endgenerate

    //调用随机序列产生模块：生成x和y的随机数
    random_seq #(
        .LENGTH ( 6 ))
    u_random_seq_1 (
        .clk                     ( clk              ),
        .rst_n                   ( rst_n            ),

        .ram_seq_o               ( {x_ram,y_ram}    ) 
    );   

endmodule

