`timescale  1ns / 1ps

module random_seq_tb;

// random_seq Parameters
parameter PERIOD  = 10;
parameter LENGTH  = 4;

// random_seq Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;

// random_seq Outputs
wire  [LENGTH - 1 : 0]  ram_seq_o          ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

random_seq #(
    .LENGTH ( LENGTH ))
 u_random_seq (
    .clk                     ( clk          ),
    .rst_n                   ( rst_n        ),

    .ram_seq_o               ( ram_seq_o    )
);

endmodule