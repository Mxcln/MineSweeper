`timescale  1ns / 1ps
`include "../src/parameter.v"

// mine_map:
// 0 0 0 1 _ 1 1 2 9
// 0 0 0 1 _ 9 1 2 9
// 1 1 0 2 _ 2 3 3 2
// 9 2 2 2 _ 9 9 2 9
// 4 9 5 9 _ 5 3 3 2
// 9 9 9 9 _ 9 2 3 9
// 9 9 8 9 _ 5 4 9 9
// 9 9 9 9 _ 3 9 9 3

module sweep_tb;

// sweep Parameters
parameter PERIOD  = 10;


// sweep Inputs
reg             clk                 = 0             ;       
reg             rst_n               = 0             ;       
reg   [5:0]     position_i          = 0             ;            
reg             mid_button_i        = 0             ; 
reg   [2:0]     screen_state_i      = `GAME_START   ;      

reg   [`MAP_CELL_LENGTH * (`MAP_HEIGHT * `MAP_WIDTH ) - 1 : 0]  map_i = 256'h3993_9999_9945_9899_9329_9999_2335_9594_9299_2229_2332_2011_9219_1000_9211_1000 ;  

// sweep Outputs
wire  [`MAP_HEIGHT * `MAP_WIDTH - 1 : 0]    map_shown_o     ;
wire                                        play_end_fail_o ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
    #(PERIOD*2) screen_state_i  =  `GAME_PLAY;

    #(PERIOD*2) ;
    position_i = 3'd1 + 3'd0 * `MAP_WIDTH;
    mid_button_i = 1;
    #(PERIOD) mid_button_i = 0;

    // #(PERIOD) ;
    // position_i = 3'd4 + 3'd2 * `MAP_WIDTH;
    // mid_button_i = 1;
    // #(PERIOD) mid_button_i = 0;

    // #(PERIOD) ;
    // position_i = 3'd2 + 3'd4 * `MAP_WIDTH;
    // mid_button_i = 1;
    // #(PERIOD) mid_button_i = 0;

    // #(PERIOD) ;
    // position_i = 3'd4 + 3'd5 * `MAP_WIDTH;
    // mid_button_i = 1;
    // #(PERIOD) mid_button_i = 0;

end

// sweep  u_sweep (
//     .clk                     ( clk                  ),
//     .rst_n                   ( rst_n                ),
//     .map_i                   ( map_i                ),
//     .position_i              ( position_i           ),
//     .mid_button_i            ( mid_button_i         ),

//     .map_shown_o             ( map_shown_o          ),
//     .play_end_fail_o         ( play_end_fail_o      )
// );

sweep  u_sweep (
    .clk                     ( clk               ),   
    .rst_n                   ( rst_n             ),   
    .screen_state_i          ( screen_state_i    ),   
    .position_i              ( position_i        ),   
    .mid_button_i            ( mid_button_i      ),   
    .map_i                   ( map_i             ),   

    .map_shown_o             ( map_shown_o       ),   
    .play_end_fail_o         ( play_end_fail_o   )    
);

endmodule