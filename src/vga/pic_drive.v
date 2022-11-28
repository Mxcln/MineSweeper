`include "../parameter.v"

//调用所有图片的ip核来获取图片的 颜色信息

module pic_drive(

    input   wire            vga_clk             ,
    input	wire	[11:0]	addr_h              ,       //行地址
    input	wire	[11:0]	addr_v              ,       //列地址
    input   wire    [2:0]   curr_cell_x         ,       //当前扫描到的地图方格的x坐标
    input   wire    [2:0]   curr_cell_y         ,       //当前扫描到的地图方格的y坐标

    output  wire    [15:0]  start_pic_data      ,       //开始图片的扫描颜色数据
    output  wire    [15:0]  victory_pic_data    ,       //胜利图片的扫描颜色数据
    output  wire    [15:0]  fail_pic_data       ,       //失败图片的扫描颜色数据

    output  wire    [15:0]  zero_cell_data      ,       //0个地雷的扫描颜色数据，以下同理
    output  wire    [15:0]  one_cell_data       ,
    output  wire    [15:0]  two_cell_data       ,
    output  wire    [15:0]  three_cell_data     ,
    output  wire    [15:0]  four_cell_data      ,
    output  wire    [15:0]  five_cell_data      ,
    output  wire    [15:0]  six_cell_data       ,
    output  wire    [15:0]  seven_cell_data     ,
    output  wire    [15:0]  eight_cell_data     ,
    output  wire    [15:0]  mine_cell_data      ,
    output  wire    [15:0]  flag_cell_data      ,
    output  wire    [15:0]  unshown_cell_data   

);

    wire    [13:0]  pic_addr            ;   //图片的扫描输出地址
    wire    [9:0]  cell_addr           ;   //方格的扫描输出地址

    //开始、胜利、失败图片ip核的地址输入
    assign  pic_addr    =   ( addr_h - `PIC_POS_WIDTH + (addr_v - `PIC_POS_HEIGHT) * `PIC_WIDTH )   ;  
    //方格图片ip核的地址输入 
    assign  cell_addr   =   ( addr_h - `CELL_POS_WIDTH + (addr_v - `CELL_POS_HEIGHT) * `CELL_WIDTH );   

    //图片显示的ip

    start_pic u_start_pic (
        .clka   ( vga_clk           ),  // input wire clka
        .addra  ( pic_addr          ),  // input wire [15 : 0] addra

        .douta  ( start_pic_data    )   // output wire [15 : 0] douta
    );

    victory_pic u_victory_pic (
        .clka   ( vga_clk               ),  // input wire clka
        .addra  ( pic_addr              ),  // input wire [15 : 0] addra

        .douta  ( victory_pic_data      )   // output wire [15 : 0] douta
    );

    fail_pic u_fail_pic (
        .clka   ( vga_clk           ),  // input wire clka
        .addra  ( pic_addr          ),  // input wire [15 : 0] addra

        .douta  ( fail_pic_data     )   // output wire [15 : 0] douta
    );

    //方格显示的ip

    zero_cell u_zero_cell (
        .clka   ( vga_clk           ),  // vga时钟信号
        .addra  ( cell_addr         ),  // 图片地址信号

        .douta  ( zero_cell_data    )   // 输入地址对应的图片数据
    );

    one_cell u_one_cell (
        .clka   ( vga_clk           ),  // vga时钟信号
        .addra  ( cell_addr         ),  // 图片地址信号

        .douta  ( one_cell_data     )   // 输入地址对应的图片数据
    );

    two_cell u_two_cell (
        .clka   ( vga_clk           ),  // vga时钟信号
        .addra  ( cell_addr         ),  // 图片地址信号

        .douta  ( two_cell_data     )   // 输入地址对应的图片数据
    );

    three_cell u_three_cell (
        .clka   ( vga_clk           ),  // vga时钟信号
        .addra  ( cell_addr         ),  // 图片地址信号

        .douta  ( three_cell_data   )   // 输入地址对应的图片数据
    );

    four_cell u_four_cell (
        .clka   ( vga_clk           ),  // vga时钟信号
        .addra  ( cell_addr         ),  // 图片地址信号

        .douta  ( four_cell_data    )   // 输入地址对应的图片数据
    );

    five_cell u_five_cell (
        .clka   ( vga_clk           ),  // vga时钟信号
        .addra  ( cell_addr         ),  // 图片地址信号

        .douta  ( five_cell_data    )   // 输入地址对应的图片数据
    );

    six_cell u_six_cell (
        .clka   ( vga_clk           ),  // vga时钟信号
        .addra  ( cell_addr         ),  // 图片地址信号

        .douta  ( six_cell_data     )   // 输入地址对应的图片数据
    );

    seven_cell u_seven_cell (
        .clka   ( vga_clk           ),  // vga时钟信号
        .addra  ( cell_addr         ),  // 图片地址信号

        .douta  ( seven_cell_data   )   // 输入地址对应的图片数据
    );

    eight_cell u_eight_cell (
        .clka   ( vga_clk           ),  // vga时钟信号
        .addra  ( cell_addr         ),  // 图片地址信号

        .douta  ( eight_cell_data   )   // 输入地址对应的图片数据
    );

    mine_cell u_mine_cell (
        .clka   ( vga_clk           ),  // vga时钟信号
        .addra  ( cell_addr         ),  // 图片地址信号

        .douta  ( mine_cell_data    )   // 输入地址对应的图片数据
    );

    flag_cell u_flag_cell (
        .clka   ( vga_clk           ),  // vga时钟信号
        .addra  ( cell_addr         ),  // 图片地址信号
        
        .douta  ( flag_cell_data    )   // 输入地址对应的图片数据
    );

    unshown_cell u_unshown_cell (
        .clka   ( vga_clk           ),  // vga时钟信号
        .addra  ( cell_addr         ),  // 图片地址信号

        .douta  ( unshown_cell_data )   // 输入地址对应的图片数据
    );

endmodule
