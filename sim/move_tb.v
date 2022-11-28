`timescale  1ns / 1ps
`include "../src/parameter.v"
module move_tb;

// move Parameters
parameter PERIOD  = 10;


// move Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [4:0]  button_i                      = `BUTTON_NONE ;

// move Outputs
wire  [2:0]  x_pos_o                       ;    
wire  [2:0]  y_pos_o                       ;    
wire  [7:0]  position_o                    ;    


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end


initial
begin
    #(PERIOD*2) rst_n  =  1;
    #(PERIOD*2) button_i = `BUTTON_DOWN;
    #(PERIOD*2) button_i = `BUTTON_RIGHT;
    #(PERIOD*2) button_i = `BUTTON_UP;
    #(PERIOD*2) button_i = `BUTTON_LEFT;
    #(PERIOD*2) button_i = `BUTTON_DOWN;
    #(PERIOD*2) button_i = `BUTTON_DOWN;
    #(PERIOD*2) button_i = `BUTTON_RIGHT;
    #(PERIOD*2) button_i = `BUTTON_RIGHT;
    #(PERIOD*2) button_i = `BUTTON_RIGHT;
    #(PERIOD*2) button_i = `BUTTON_DOWN;
end

move  u_move (
    .clk                     ( clk               ),
    .rst_n                   ( rst_n             ),
    .button_i                ( button_i    [4:0] ),

    .x_pos_o                 ( x_pos_o     [2:0] ),
    .y_pos_o                 ( y_pos_o     [2:0] ),
    .position_o              ( position_o  [7:0] )
);

endmodule