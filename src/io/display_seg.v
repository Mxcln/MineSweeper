`timescale 1ns / 1ps

module display_seg (
    input   wire                    clk             ,
    input   wire                    rst_n           ,
    input   wire    [15:0]          seg_8421_code   ,   // 8421码下需要显示的4个十进制数，[15:12]在最左边显示

    output  reg     [6:0]           seg             ,   // 7 segments {a,b,c,d,e,f,g}
    output  reg     [3:0]           display_digit       // 与开发板上的位选择端口连接，选择当前时刻需要显示的位(0有效)
);         

    parameter   LIMIT   =   50000;          //count的周期，决定每一位数字点亮的时间(LIMIT个时钟周期)

    reg     [3:0]   sel_num ;               //当前时刻需要显示的数字
    reg     [19:0]  count   ;               //计数器，用在每一位数字的显示时间上
    reg     [2:0]   sel     ;               //0-3的计数器，用来决定display_digit
        
    always@(posedge clk) begin
        if(!rst_n)
            count <= 0 ;
        else begin
            count <= count + 1;
            if(count == LIMIT) begin                //当count计数到LIMIT时，改变sel的值
                count <= 0;
                sel <= sel + 1 ;
                if(sel == 4)
                    sel <= 0;
            end
        end
    end

    //根据sel来决定当前时刻需要输出的数字位置以及数字的8421码
    always@(posedge clk) begin
        if(!rst_n) begin
            sel_num <= 0;
            display_digit <= 0;
        end
        else begin
            case(sel)
                0:begin
                    sel_num <= seg_8421_code[3:0];
                    display_digit <= 4'b1110;
                end
                1:begin
                    sel_num <= seg_8421_code[7:4];
                    display_digit <= 4'b1101;
                end
                2:begin
                    sel_num <= seg_8421_code[11:8];
                    display_digit <= 4'b1011;
                end
                3:begin
                    sel_num <= seg_8421_code[15:12]; 
                    display_digit <= 4'b0111;
                end
            endcase
        end
    end

    //根据当前时刻的sel_num显示一位数字(将8421码转换成7段显示码)
    always@(*) begin
        case(sel_num)
            4'd0: seg[6:0] = 7'b0000001;
            4'd1: seg[6:0] = 7'b1001111;
            4'd2: seg[6:0] = 7'b0010010;
            4'd3: seg[6:0] = 7'b0000110;
            4'd4: seg[6:0] = 7'b1001100;
            4'd5: seg[6:0] = 7'b0100100;
            4'd6: seg[6:0] = 7'b0100000;
            4'd7: seg[6:0] = 7'b0001111;
            4'd8: seg[6:0] = 7'b0000000;
            4'd9: seg[6:0] = 7'b0000100;
        endcase
    end

endmodule



