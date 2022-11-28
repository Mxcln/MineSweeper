`timescale 1ns / 1ps

//按键消抖，同时把按键输入处理为一个时钟周期的脉冲

module button_process(       
    input   wire                clk,
    input   wire                rst_n,
    input   wire    [4:0]       button_prev_i,          //需要按键防抖的信号
    output  reg     [4:0]       button_ac_o             //产生的实际有效的信号
    );         

    parameter Wait_Time = 32'd10_000_000;

    reg [32 : 0] btCount;                           //按键按下后计数
    reg [4 : 0] delay_input;                        //输入延迟一个时钟周期，用来检测输入的上升沿
    reg count_flag;                                 //计数标志，检测到输入button_prev的上升沿时开始计数
    
    always@(posedge clk) begin
        if(!rst_n)
            delay_input <= 'b0;
        else 
            delay_input <= button_prev_i;
    end

    always@(posedge clk) begin
        if(!rst_n)
            count_flag <= 0;
        else if(delay_input != button_prev_i)       //检测 button_prev 上升与下降沿
            count_flag <= 1;
        else if (btCount == Wait_Time)              //计数到指定值后置零
            count_flag <= 0;
    end

    always@(posedge clk) begin
        if(!rst_n)
            btCount <= 0;
        else if(count_flag)                         //若有计数标志，则计数
            btCount <= btCount + 1;
        else
            btCount <= 0;                           //否则清零
    end

    //计数器到达 Wait_Time 后执行操作
    always@(posedge clk) begin 
        if(!rst_n)
            button_ac_o <= 'b0;                     
        else if(btCount == Wait_Time )
            button_ac_o <= button_prev_i;                //产生一个时钟周期的1信号,即按键脉冲
        else
            button_ac_o <= 0;     
    end
endmodule