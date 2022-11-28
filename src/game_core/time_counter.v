`include "../parameter.v"

//计时模块：计算游戏所用的时间，从进入游玩状态`GAME_PLAY开始
//通过计数器获得1Hz的脉冲 time_count_flag

module time_counter(
    input   wire                    clk             ,
    input   wire                    rst_n           ,
    input   wire    [3:0]           screen_state_i  ,       //屏幕状态输入，决定什么时候开始计数

    output  wire    [7:0]           seconds_o       ,       //秒输出，8421码，用于七段显示模块的显示
    output  wire    [7:0]           minutes_o               //分输出，8421码，用于七段显示模块的显示
    );

    reg     [26:0]      counter         ;           //计数器，计算系统时钟上升沿个数
    wire                time_count_flag ;           //秒表跳动允许信号，1Hz，有效时，秒开始跳动

    reg     [7:0]       seconds;            //秒
    reg     [7:0]       minutes;            //分

    assign  seconds_o = seconds ;
    assign  minutes_o = minutes ;

    //计数器：记录当前系统时钟上升沿个数
    always@(posedge clk) begin
        if(!rst_n | counter == 27'd99_999_999 | screen_state_i != `GAME_PLAY)
            counter <= 0;
        else if(screen_state_i == `GAME_PLAY)
            counter <= counter + 1 ;
    end

    assign time_count_flag = (rst_n & counter == 27'd99_999_999) ;  //计数器计数到27'd99_999_999时，秒计一次数

    //第一位七段显示码：秒的个位
    always@(posedge clk) begin
        if(!rst_n | seconds[3:0] == 4'd10 | screen_state_i != `GAME_PLAY)
            seconds[3:0] <= 0;
        else if(time_count_flag)
            seconds[3:0] <= seconds[3:0] + 1 ;
    end
    //第二位七段显示码：秒的十位
    always@(posedge clk) begin
        if(!rst_n | seconds[7:4] == 4'd6 | screen_state_i != `GAME_PLAY)
            seconds[7:4] <= 0;
        else if(seconds[3:0] == 4'd10)
            seconds[7:4] <= seconds[7:4] + 1 ;
        else
            seconds[7:4] <= seconds[7:4] ;
    end

    //第三位七段显示码：分的个位
    always@(posedge clk) begin
        if(!rst_n | minutes[3:0] == 4'd10 | screen_state_i != `GAME_PLAY)
            minutes[3:0] <= 0;
        else if(seconds[7:4] == 4'd6)
            minutes[3:0] <= minutes[3:0] + 1 ;
        else
            minutes[3:0] <= minutes[3:0] ;
    end
    //第四位七段显示码：分的十位
    always@(posedge clk) begin
        if(!rst_n | minutes[7:4] == 4'd6 | screen_state_i != `GAME_PLAY)
            minutes[7:4] <= 0;
        else if(minutes[3:0] == 4'd10)
            minutes[7:4] <= minutes[7:4] + 1 ;
        else
            minutes[7:4] <= minutes[7:4] ;
    end

endmodule
