`include "../parameter.v"

//决定当前扫描到的像素的颜色。
//调用了多个储存图片ip核，根据扫描位置决定输出颜色。

module vga_drive (
    input	wire					                    vga_clk             ,
    input	wire					                    rst_n               ,
    input   wire    [2:0]                               x_pos_i             ,
    input   wire    [2:0]                               y_pos_i             ,
    input   wire    [2:0]                               screen_state_i      ,

    input   wire    [`MAP_CELL_LENGTH * (`MAP_HEIGHT * `MAP_WIDTH ) - 1 : 0]    map_i       ,
    input   wire    [`MAP_HEIGHT * `MAP_WIDTH - 1 : 0]                          map_shown_i ,
    input   wire    [`MAP_HEIGHT * `MAP_WIDTH - 1 : 0]                          map_flag_i ,

    input	wire	[11:0]	addr_h,     //行有效地址
    input	wire	[11:0]	addr_v,     //列有效地址
    
    output	reg 	[15:0]		rgb_data    //16位RGB值
);

    wire            pic_area        ;       //图片像素区域
    wire            map_area        ;       //地图像素区域
    wire            blank_area      ;       //空白区域（黑色）
    wire            cell_border     ;
    wire    [2:0]   curr_cell_x     ;       //当前扫描位置处在的方格的x坐标
    wire    [2:0]   curr_cell_y     ;       //当前扫描位置处在的方格的y坐标
    wire    [5:0]   curr_cell_pos   ;       //当前扫描方格的位置
    wire    [3:0]   round_mine_num  ;       //当前扫描位置处在的方格周围的地雷数


    wire    [15:0]  start_pic_data      ;   //开始图片的扫描颜色数据
    wire    [15:0]  victory_pic_data    ;   //胜利图片的扫描颜色数据
    wire    [15:0]  fail_pic_data       ;   //失败图片的扫描颜色数据

    wire    [15:0]  zero_cell_data      ;   //0个地雷的扫描颜色数据，以下同理
    wire    [15:0]  one_cell_data       ;
    wire    [15:0]  two_cell_data       ;
    wire    [15:0]  three_cell_data     ;
    wire    [15:0]  four_cell_data      ;
    wire    [15:0]  five_cell_data      ;
    wire    [15:0]  six_cell_data       ;
    wire    [15:0]  seven_cell_data     ;
    wire    [15:0]  eight_cell_data     ;
    wire    [15:0]  mine_cell_data      ;
    wire    [15:0]  flag_cell_data      ;
    wire    [15:0]  unshown_cell_data   ;

    //扫描到图片显示区域，pic_area = 1
    assign  pic_area = (addr_h >= `PIC_POS_WIDTH) && (addr_h < `PIC_POS_WIDTH + `PIC_WIDTH)
                    &&(addr_v >= `PIC_POS_HEIGHT) && (addr_v < `PIC_POS_HEIGHT + `PIC_HEIGHT); 
    //扫描到地图显示区域，map_area = 1
    assign  map_area = (addr_h >= `MAP_POS_WIDTH) && (addr_h < `MAP_POS_WIDTH + `MAP_PIXEL_WIDTH)
                    &&(addr_v >= `MAP_POS_HEIGHT) && (addr_v < `MAP_POS_HEIGHT + `MAP_PIXEL_HEIGHT);
    //扫描到空白显示区域，blank_area = 1
    assign  blank_area = ~( pic_area | map_area );

    //是否处在方格边框之内，是则为1
    assign cell_border = (
                            ((addr_h - `CELL_POS_WIDTH) < `CELL_BORDER_WIDTH) |
                            ((addr_h - `CELL_POS_WIDTH) > (`CELL_WIDTH - `CELL_BORDER_WIDTH - 1)) |
                            ((addr_v - `CELL_POS_HEIGHT) < `CELL_BORDER_WIDTH) |
                            ((addr_v - `CELL_POS_HEIGHT) > (`CELL_HEIGHT - `CELL_BORDER_WIDTH - 1)) 
    );

    //当前扫描到的像素所在的方格的x,y坐标，用移位实现，相当于除以32（每个方格的像素宽度）
    assign  curr_cell_x = (addr_h - `MAP_POS_WIDTH) >> 5            ;
    assign  curr_cell_y = (addr_v - `MAP_POS_HEIGHT) >> 5           ;
    assign  curr_cell_pos = curr_cell_x + curr_cell_y * `MAP_WIDTH  ;

    //rgb_data驱动
    always@(posedge vga_clk) begin
        if(!rst_n)
            rgb_data <= `BLACK;

        else if (blank_area)            //空白区域：都为黑色
            rgb_data <= `BLACK;
        
        else if (pic_area) begin        //图片区域
            case(screen_state_i)
                `GAME_START     : rgb_data <= start_pic_data    ;   //开始状态：显示开始图片
                `GAME_VICTORY   : rgb_data <= victory_pic_data  ;   //胜利状态：显示胜利图片
                `GAME_FAIL      : rgb_data <= fail_pic_data     ;   //失败状态：显示失败图片
                default         : rgb_data <= `BLACK;
            endcase 
        end

        else if (map_area) begin        //地图区域
            //是旗子的情况
            if(map_flag_i[curr_cell_pos]) begin 
                //如果是当前选中的方格，加上白色边框,以下同理            
                if((curr_cell_x == x_pos_i) & (curr_cell_y == y_pos_i) & cell_border)
                    rgb_data <= `WHITE ;
                else
                    rgb_data <= flag_cell_data   ;
            end

            //当前扫描到的方格游戏中没显示的情况
            else if(!map_shown_i[curr_cell_pos]) begin      
                if((curr_cell_x == x_pos_i) & (curr_cell_y == y_pos_i) & cell_border)   
                    rgb_data <= `WHITE ;
                else
                    rgb_data <= unshown_cell_data   ;
            end

            //是地雷的情况
            else if(map_i[curr_cell_pos * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH] == `IS_MINE) begin          
                if((curr_cell_x == x_pos_i) & (curr_cell_y == y_pos_i) & cell_border)
                    rgb_data <= `WHITE ;
                else
                    rgb_data <= mine_cell_data      ;
            end

            //根据周围地雷数决定使用哪张方格图片的颜色信息
            else begin
                case(map_i[curr_cell_pos * `MAP_CELL_LENGTH +: `MAP_CELL_LENGTH])           
                    `IS_ZERO : begin
                            if((curr_cell_x == x_pos_i) & (curr_cell_y == y_pos_i) & cell_border)
                                rgb_data <= `WHITE ;
                            else
                                rgb_data <= zero_cell_data  ;
                        end
                    `IS_ONE : begin
                            if((curr_cell_x == x_pos_i) & (curr_cell_y == y_pos_i) & cell_border)
                                rgb_data <= `WHITE ;
                            else
                                rgb_data <= one_cell_data   ;
                        end
                    `IS_TWO : begin
                            if((curr_cell_x == x_pos_i) & (curr_cell_y == y_pos_i) & cell_border)
                                rgb_data <= `WHITE ;
                            else
                                rgb_data <= two_cell_data   ;
                        end
                    `IS_THREE : begin
                            if((curr_cell_x == x_pos_i) & (curr_cell_y == y_pos_i) & cell_border)
                                rgb_data <= `WHITE ;
                            else
                                rgb_data <= three_cell_data ;
                        end
                    `IS_FOUR : begin
                            if((curr_cell_x == x_pos_i) & (curr_cell_y == y_pos_i) & cell_border)
                                rgb_data <= `WHITE ;
                            else
                                rgb_data <= four_cell_data ;
                        end
                    `IS_FIVE : begin
                            if((curr_cell_x == x_pos_i) & (curr_cell_y == y_pos_i) & cell_border)
                                rgb_data <= `WHITE ;
                            else
                                rgb_data <= five_cell_data ;
                        end
                    `IS_SIX : begin
                            if((curr_cell_x == x_pos_i) & (curr_cell_y == y_pos_i) & cell_border)
                                rgb_data <= `WHITE ;
                            else
                                rgb_data <= six_cell_data ;
                        end
                    `IS_SEVEN : begin
                            if((curr_cell_x == x_pos_i) & (curr_cell_y == y_pos_i) & cell_border)
                                rgb_data <= `WHITE ;
                            else
                                rgb_data <= seven_cell_data ;
                        end
                    `IS_EIGHT : begin
                            if((curr_cell_x == x_pos_i) & (curr_cell_y == y_pos_i) & cell_border)
                                rgb_data <= `WHITE ;
                            else
                                rgb_data <= eight_cell_data ;
                        end
                    default : rgb_data <= `BLACK    ;
                endcase
            end
        end

        else
            rgb_data <= `BLACK;
    end

    //该模块实例化了所有储存图片的ip核
    //调用ip核，导入图片的颜色信息
    pic_drive  u_pic_drive (
        .vga_clk                 ( vga_clk             ),
        .addr_h                  ( addr_h              ),
        .addr_v                  ( addr_v              ),
        .curr_cell_x             ( curr_cell_x         ),
        .curr_cell_y             ( curr_cell_y         ),

        .start_pic_data          ( start_pic_data      ),
        .victory_pic_data        ( victory_pic_data    ),
        .fail_pic_data           ( fail_pic_data       ),
        .zero_cell_data          ( zero_cell_data      ),
        .one_cell_data           ( one_cell_data       ),
        .two_cell_data           ( two_cell_data       ),
        .three_cell_data         ( three_cell_data     ),
        .four_cell_data          ( four_cell_data      ),
        .five_cell_data          ( five_cell_data      ),
        .six_cell_data           ( six_cell_data       ),
        .seven_cell_data         ( seven_cell_data     ),
        .eight_cell_data         ( eight_cell_data     ),
        .mine_cell_data          ( mine_cell_data      ),
        .flag_cell_data          ( flag_cell_data      ),
        .unshown_cell_data       ( unshown_cell_data   )
    );

endmodule