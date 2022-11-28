
//随机数获取模块：使用lfsr（线性反馈移位寄存器）
//这个模块在map_generate中被调用，注意这个模块会一直运行。

module random_seq #(
    parameter   LENGTH = 4
)(
    input   wire            clk,
    input   wire            rst_n,

    output  wire    [LENGTH - 1 : 0]   ram_seq_o
);

    reg     [31:0]      seq;

    always@(posedge clk) begin
        if(!rst_n)
            seq <= 32'h1000_0001;
        else begin
            seq <= {seq[30:0],seq[0]^seq[2]^seq[3]^seq[5]^seq[8]^seq[31]};
        end
    end

    assign ram_seq_o = seq[LENGTH-1 : 0];

endmodule