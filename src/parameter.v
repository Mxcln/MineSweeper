`default_nettype none
`timescale 1ns/1ps

`define     MAP_WIDTH       8           //地图宽度，8个方格              
`define     MAP_HEIGHT      8           //地图长度，8个方格

`define     MAP_CELL_LENGTH     4       //在地图向量map中，一个方格所占的位宽

`define     IS_ZERO         0           //这个方格周围没有地雷
`define     IS_ONE          1           //这个方格周围有1个地雷
`define     IS_TWO          2           //这个方格周围有2个地雷
`define     IS_THREE        3           //这个方格周围有3个地雷
`define     IS_FOUR         4           //这个方格周围有4个地雷
`define     IS_FIVE         5           //这个方格周围有5个地雷
`define     IS_SIX          6           //这个方格周围有6个地雷
`define     IS_SEVEN        7           //这个方格周围有7个地雷
`define     IS_EIGHT        8           //这个方格周围有8个地雷
`define     IS_MINE         9           //这个方格是地雷

`define     MINE_NUM        9           //游戏中地雷的个数

//难度
`define     EASY            9           //简单难度
`define     MIDIUM          15          //中等难度
`define     HARD            20          //困难难度
`define     HELL            30          //地狱难度

//使用独热码标记按键参数
`define     BUTTON_MID      5'b10000        //中间按键
`define     BUTTON_LEFT     5'b01000        //左边按键
`define     BUTTON_RIGHT    5'b00100        //右边按键
`define     BUTTON_UP       5'b00010        //上面按键
`define     BUTTON_DOWN     5'b00001        //下面按键
`define     BUTTON_NONE     5'b00000        //没有按键被按下

//屏幕状态参数
`define     GAME_START      3'b000          //开始状态
`define     GAME_MAP_GEN    3'b001          //生成地图状态
`define     GAME_PLAY       3'b010          //游戏状态
`define     GAME_VICTORY    3'b011          //胜利状态
`define     GAME_FAIL       3'b100          //失败状态
`define     GAME_ERROR      3'b101          //错误状态


`define     BLACK           16'h0000        //黑色的rgb值
`define     WHITE           16'hffff        //白色的rgb值

`define     CELL_BORDER_WIDTH      3        //如果当前方格被选中，方格周围用一圈白色显示。这是白色圈的宽度

//VGA parameter

// 640 * 480 60HZ
`define	    H_FRONT         16          // 行同步前沿信号周期长
`define	    H_SYNC          96          // 行同步信号周期长
`define	    H_BLACK         48          // 行同步后沿信号周期长
`define	    H_ACT           640         // 行显示周期长

`define	    V_FRONT         10          // 场同步前沿信号周期长
`define	    V_SYNC          2           // 场同步信号周期长
`define	    V_BLACK         29          // 场同步后沿信号周期长
`define	    V_ACT           480         // 场显示周期长

`define	    H_TOTAL         (`H_FRONT + `H_SYNC + `H_BLACK + `H_ACT)    // 行周期 800
`define	    V_TOTAL         (`V_FRONT + `V_SYNC + `V_BLACK + `V_ACT)    // 列周期 521


`define     CELL_WIDTH          32              //每个方格的像素宽
`define     CELL_HEIGHT         32              //每个方格的像素高
`define     CELL_POS_WIDTH      (`MAP_POS_WIDTH + curr_cell_x * `CELL_WIDTH)    //当前扫描到的方格距左边框长度
`define     CELL_POS_HEIGHT     (`MAP_POS_HEIGHT + curr_cell_y * `CELL_HEIGHT)  //当前扫描到的方格距上边框长度

`define     MAP_PIXEL_WIDTH     (`CELL_WIDTH*`MAP_WIDTH)            //地图像素宽
`define     MAP_PIXEL_HEIGHT    (`CELL_HEIGHT*`MAP_HEIGHT)          //地图像素高
`define     MAP_POS_WIDTH       ((`H_ACT - `MAP_PIXEL_WIDTH)/2)     //地图距左边框长度(居中)
`define     MAP_POS_HEIGHT      194                                 //地图距上边框长度    

`define     PIC_WIDTH           160                             //图片的像素宽
`define     PIC_HEIGHT          60                              //图片的像素高
`define     PIC_POS_WIDTH       ((`H_ACT - `PIC_WIDTH)/2)       //图片距左边框长度
`define     PIC_POS_HEIGHT      30                              //图片距上边框长度   

