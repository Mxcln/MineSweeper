`include "../parameter.v"

module vga_control (
    input	wire					vga_clk,  //vga时钟，25MHz
    input	wire					rst_n,    //异步复位
    input	wire	[ 15:0 ]		rgb_data, //16位RGB对应值

    output	reg						h_sync,   //行同步信号
    output	reg						v_sync,   //场同步信号
    output	reg		[ 11:0 ]		addr_h,   //行地址
    output	reg		[ 11:0 ]		addr_v,   //列地址
    output	wire	[ 3:0 ]		    rgb_r,    //红基色
    output	wire	[ 3:0 ]			rgb_g,    //绿基色
    output	wire	[ 3:0 ]			rgb_b     //蓝基色
);

    reg			[ 11:0 ]			cnt_h			; // 行计数器
    reg			[ 11:0 ]			cnt_v			; // 场计数器
    reg			[ 15:0 ]			rgb			    ; // 对应显示颜色值

    // 对应计数器开始、结束、计数信号
    wire		flag_enable_cnt_h			;   //行计数器计数信号
    wire		flag_clear_cnt_h			;   //行计数器清零信号
    wire		flag_enable_cnt_v			;   //场计数器计数信号
    wire		flag_clear_cnt_v			;   //场计数器清零信号
    wire		flag_add_cnt_v  			;

    //区域有效信号
    wire		valid_area      			;

    //截取16位颜色信号，变成每种颜色4位
    assign      rgb_r = rgb[ 15:12 ]    ;   
    assign      rgb_g = rgb[ 10:7 ]     ;
    assign      rgb_b = rgb[ 4:1 ]      ;


    // 行计数
    always @( posedge vga_clk or negedge rst_n ) begin
        if ( !rst_n ) begin
            cnt_h <= 0;
        end
        else if ( flag_enable_cnt_h ) begin
            if ( flag_clear_cnt_h ) begin
                cnt_h <= 0;
            end
            else begin
                cnt_h <= cnt_h + 1;
            end
        end
        else begin
            cnt_h <= 0;
        end
    end
    assign flag_enable_cnt_h = 1;
    assign flag_clear_cnt_h  = (cnt_h == `H_TOTAL - 1);

    // 行同步信号
    always @( posedge vga_clk or negedge rst_n ) begin
        if ( !rst_n ) begin
            h_sync <= 0;
        end
        else if ( cnt_h == `H_SYNC - 1 ) begin // 同步周期时为1
            h_sync <= 1;
        end
        else if ( flag_clear_cnt_h ) begin // 其余为0
            h_sync <= 0;
        end
        else begin
            h_sync <= h_sync;
        end
    end

    // 场计数
    always @( posedge vga_clk or negedge rst_n ) begin
        if ( !rst_n ) begin
            cnt_v <= 0;
        end
        else if ( flag_enable_cnt_v ) begin
            if ( flag_clear_cnt_v ) begin
                cnt_v <= 0;
            end
            else if ( flag_add_cnt_v ) begin
                cnt_v <= cnt_v + 1;
            end
            else begin
                cnt_v <= cnt_v;
            end
        end
        else begin
            cnt_v <= 0;
        end
    end
    assign flag_enable_cnt_v = flag_enable_cnt_h;
    assign flag_clear_cnt_v  = (cnt_v == `V_TOTAL - 1);
    assign flag_add_cnt_v    = flag_clear_cnt_h;

    // 场同步信号
    always @( posedge vga_clk or negedge rst_n ) begin
        if ( !rst_n ) begin
            v_sync <= 0;
        end
        else if ( cnt_v == `V_SYNC - 1 ) begin
            v_sync <= 1;
        end
            else if ( flag_clear_cnt_v ) begin
            v_sync <= 0;
            end
        else begin
            v_sync <= v_sync;
        end
    end

    // 对应有效区域行地址 1-640
    always @( posedge vga_clk or negedge rst_n ) begin
        if ( !rst_n ) begin
            addr_h <= 0;
        end
        else if ( valid_area ) begin
            addr_h <= cnt_h - `H_SYNC - `H_BLACK + 1;
        end
        else begin
            addr_h <= 0;
        end
    end
    // 对应有效区域列地址 1-480
    always @( posedge vga_clk or negedge rst_n ) begin
        if ( !rst_n ) begin
            addr_v <= 0;
        end
        else if ( valid_area ) begin
            addr_v <= cnt_v - `V_SYNC - `V_BLACK + 1;
        end
        else begin
            addr_v <= 0;
        end
    end

    // 有效显示区域
    assign valid_area = (cnt_h >= `H_SYNC + `H_BLACK) && (cnt_h <= `H_SYNC + `H_BLACK + `H_ACT) 
                        && (cnt_v >= `V_SYNC + `V_BLACK) && (cnt_v <= `V_SYNC + `V_BLACK + `V_ACT);


    // 显示颜色
    always @( posedge vga_clk or negedge rst_n ) begin
        if ( !rst_n ) begin
            rgb <= `BLACK   ;
        end
        else if ( valid_area ) begin
            rgb <= rgb_data ;
        end
        else begin
            rgb <= `BLACK   ;
        end
    end


endmodule


