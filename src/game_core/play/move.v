`include "../../parameter.v"

//状态机：根据按钮按下的按键，移动当前选定的方格坐标
//移动条件：只有在PLAY状态才能够移动

module move(
    input   wire            clk             ,
    input   wire            rst_n           ,
    input   wire    [2:0]   screen_state_i  ,   //屏幕状态输入
    input   wire    [4:0]   button_i        ,   //按键输入

    output  wire    [2:0]   x_pos_o         ,   //游戏中当前选定的方格的x坐标的输出
    output  wire    [2:0]   y_pos_o         ,   //游戏中当前选定的方格的y坐标的输出
    output  wire    [5:0]   position_o          //游戏中的当前位置输出，0-63
    );

    reg [2:0] curr_x,curr_y,next_x,next_y;

    //状态转移
    always@(posedge clk) begin
        if(!rst_n | screen_state_i == `GAME_START) begin    //游戏开始时重置当前位置状态
            {curr_x,curr_y} <= 'b0;
        end
        else if(screen_state_i == `GAME_PLAY)               //只有在`GAME_PLAY状态时才允许移动
            {curr_x,curr_y} <= {next_x,next_y};
    end

    //次态规律
    always@(posedge clk) begin
        if(!rst_n )
            {next_x,next_y} <= 0;
        else begin 
            case(button_i)
                `BUTTON_LEFT :  begin
                                    next_y <= next_y;
                                    if(curr_x == 2'b0)
                                        next_x <= `MAP_WIDTH - 1;        //x=0的情况下，按左键则直接到达最右端，后面同理
                                    else
                                        next_x <= curr_x - 1;            //否则向左移动一个方格
                                end
                `BUTTON_RIGHT : begin
                                    next_y <= next_y;
                                    if(curr_x == `MAP_WIDTH - 1)
                                        next_x <= 2'b0;
                                    else
                                        next_x <= curr_x + 1;
                                end
                `BUTTON_UP :    begin
                                    next_x <= next_x;
                                    if(curr_y == 2'b0)
                                        next_y <= `MAP_HEIGHT - 1;
                                    else
                                        next_y <= curr_y - 1;
                                end
                `BUTTON_DOWN :  begin
                                    next_x <= next_x;
                                    if(curr_y == `MAP_HEIGHT - 1)
                                        next_y <= 2'b0;
                                    else
                                        next_y <= curr_y + 1;
                                end
            endcase
        end
    end

    //输出：即为状态机当前状态
    assign {x_pos_o,y_pos_o} = {curr_x,curr_y};
    assign position_o = curr_x + curr_y * `MAP_WIDTH ;

endmodule