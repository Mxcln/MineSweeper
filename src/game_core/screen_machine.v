`include "../parameter.v"

// 游戏屏幕的状态机：输出当前游戏进行屏幕的状态。
// 处于GAME_START状态时，若按下中间按钮，进入地图生成状态。
// 处于GAME_MAP_GEN状态时，经过`MINE_NUM个时钟周期，自动进入游戏状态。
// 处于GAME_PLAY状态时，根据play_end信号，决定进入胜利状态还是失败状态，还是保持不变
// 处于GAME_VICTORY状态时，若按下中间按钮，进入开始状态GAME_START。 
// 处于GAME_FAIL状态时，若按下中间按钮，进入开始状态GAME_START。


module screen_machine(
    input   wire            clk,
    input   wire            rst_n,
    input   wire            mid_button_i,           //中间的按钮，用来刷新屏幕状态
    input   wire    [3:0]   difficulty_i,           //难度输入，决定雷的个数
    input   wire    [1:0]   play_end_i,             //游戏结束的信号,[1]胜利，[0]失败

    output  wire    [2:0]   screen_state_o          //屏幕状态输出
    );

    reg [2:0] curr_screen_state, next_screen_state;

    reg [5:0] map_gen_counter;

    reg [4:0] mine_num;

    always@(posedge clk) begin
        //根据难度开关来决定地雷的个数：
        casez(difficulty_i)
            4'b1zzz : mine_num <= `HELL;
            4'b01zz : mine_num <= `HARD;
            4'b001z : mine_num <= `MIDIUM;
            4'b0001 : mine_num <= `EASY;
            default : mine_num <= `EASY;    //默认难度为简单  
        endcase
        //注意：这里的个数并不是实际游戏中地雷的个数，而是生成地雷的次数，有可能会重复导致地雷数变少。
    end

    //地图生成计数
    always@(posedge clk) begin
        if(!rst_n)
            map_gen_counter <= 0;
        else if(curr_screen_state == `GAME_MAP_GEN)
            map_gen_counter <= map_gen_counter + 1;
        else 
            map_gen_counter <= 0; 
    end

    //状态转移
    always@(posedge clk) begin
        if(!rst_n) begin
            curr_screen_state <= `GAME_START;           //初始状态为开始状态
        end
        else begin
            curr_screen_state <= next_screen_state;
        end
    end

    //次态规律
    always@(*) begin
        case(curr_screen_state)
            `GAME_START     : next_screen_state = mid_button_i ? `GAME_MAP_GEN : `GAME_START;
            `GAME_MAP_GEN   : next_screen_state = (map_gen_counter==mine_num - 1) ? `GAME_PLAY : `GAME_MAP_GEN;
            `GAME_PLAY      : case(play_end_i)
                                  2'b00 : next_screen_state = `GAME_PLAY;
                                  2'b01 : next_screen_state = `GAME_FAIL;
                                  2'b10 : next_screen_state = `GAME_VICTORY;
                                  default: next_screen_state = `GAME_ERROR;
                              endcase 
            `GAME_VICTORY   : next_screen_state = mid_button_i ? `GAME_START : `GAME_VICTORY;
            `GAME_FAIL      : next_screen_state = mid_button_i ? `GAME_START : `GAME_FAIL;
        endcase
    end

    assign screen_state_o = curr_screen_state;

endmodule
