`timescale  1ns / 1ps
`include "../src/parameter.v"

module map_genarate_tb;

// map_genarate Parameters
parameter PERIOD  = 10;

// map_genarate Inputs
reg   clk                                  = 0 ; 
reg   rst_n                                = 0 ; 
reg   [2:0]  screen_state_i                = 0 ; 

// map_genarate Outputs
wire  [`MAP_CELL_LENGTH*( `MAP_HEIGHT * `MAP_WIDTH) - 1 : 0]  map_o ;  
wire  [`MAP_HEIGHT * `MAP_WIDTH - 1 : 0]  map_mine_o ;  

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

initial
begin
    #(PERIOD*3) screen_state_i = 1;
    #(PERIOD*5) screen_state_i = 2;
end

map_genarate  u_map_genarate (
    .clk                     ( clk              ),
    .rst_n                   ( rst_n            ),
    .screen_state_i          ( screen_state_i   ),

    .map_o                   ( map_o            ),
    .map_mine_o              ( map_mine_o       )
);

endmodule