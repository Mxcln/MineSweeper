`timescale 1ns / 1ps

//按键防抖以及七段数码管的显示

module io_process_top(
    input   wire                    clk             ,
    input   wire                    rst_n           ,
    input   wire    [4:0]           button_i        ,
    input   wire    [15:0]          seg_8421_code_i ,           

    output  wire    [4:0]           button_o        ,
    output  wire    [6:0]           seg_o           ,
    output  wire    [3:0]           display_digit_o   

    );

    button_process u_button_process (
        .clk                     ( clk             ),
        .rst_n                   ( rst_n           ),
        .button_prev_i           ( button_i        ),

        .button_ac_o             ( button_o        ) 
    );

    display_seg u_display_seg (
        .clk                     ( clk             ),
        .rst_n                   ( rst_n           ),
        .seg_8421_code           ( seg_8421_code_i ),

        .seg                     ( seg_o           ),
        .display_digit           ( display_digit_o )
    );


endmodule
