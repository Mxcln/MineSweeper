
# SEG
set_property -dict {PACKAGE_PIN W7 IOSTANDARD LVCMOS33} [get_ports {seg[6]}]
set_property -dict {PACKAGE_PIN W6 IOSTANDARD LVCMOS33} [get_ports {seg[5]}]
set_property -dict {PACKAGE_PIN U8 IOSTANDARD LVCMOS33} [get_ports {seg[4]}]
set_property -dict {PACKAGE_PIN V8 IOSTANDARD LVCMOS33} [get_ports {seg[3]}]
set_property -dict {PACKAGE_PIN U5 IOSTANDARD LVCMOS33} [get_ports {seg[2]}]
set_property -dict {PACKAGE_PIN V5 IOSTANDARD LVCMOS33} [get_ports {seg[1]}]
set_property -dict {PACKAGE_PIN U7 IOSTANDARD LVCMOS33} [get_ports {seg[0]}]

set_property -dict {PACKAGE_PIN W4 IOSTANDARD LVCMOS33} [get_ports {display_digit[3]}]
set_property -dict {PACKAGE_PIN V4 IOSTANDARD LVCMOS33} [get_ports {display_digit[2]}]
set_property -dict {PACKAGE_PIN U4 IOSTANDARD LVCMOS33} [get_ports {display_digit[1]}]
set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports {display_digit[0]}]

#CLK
create_clock -period 10.000 -waveform {0.000 5.000} [get_ports clk]
set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports clk]

#BUTTON
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {button_i[4]}]
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports {button_i[3]}]
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS33} [get_ports {button_i[1]}]
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS33} [get_ports {button_i[2]}]
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33} [get_ports {button_i[0]}]

#SWITCH: 0 for the right
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports rst_n]
# set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports {switch[1]}]
# set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports {switch[2]}]
# set_property -dict {PACKAGE_PIN W17 IOSTANDARD LVCMOS33} [get_ports {switch[3]}]
# set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS33} [get_ports {switch[4]}]
# set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33} [get_ports {switch[5]}]
# set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33} [get_ports {switch[6]}]
# set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33} [get_ports {switch[7]}]
# set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS33} [get_ports {switch[8]}]
# set_property -dict {PACKAGE_PIN T3 IOSTANDARD LVCMOS33} [get_ports {switch[9]}]
set_property -dict {PACKAGE_PIN T2 IOSTANDARD LVCMOS33} [get_ports {difficulty[0]}]
set_property -dict {PACKAGE_PIN R3 IOSTANDARD LVCMOS33} [get_ports {difficulty[1]}]
set_property -dict {PACKAGE_PIN W2 IOSTANDARD LVCMOS33} [get_ports {difficulty[2]}]
set_property -dict {PACKAGE_PIN U1 IOSTANDARD LVCMOS33} [get_ports {difficulty[3]}]
# set_property -dict {PACKAGE_PIN T1 IOSTANDARD LVCMOS33} [get_ports {switch[14]}]
set_property -dict {PACKAGE_PIN R2 IOSTANDARD LVCMOS33} [get_ports fm_switch]

#LED
# set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports {led[0]}]
# set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports {led[1]}]
# set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports {led[2]}]
# set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS33} [get_ports {led[3]}]
# set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports {led[4]}]
# set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports {led[5]}]
# set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports {led[6]}]
# set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33} [get_ports {led[7]}]
# set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33} [get_ports {led[8]}]
# set_property -dict {PACKAGE_PIN V3 IOSTANDARD LVCMOS33} [get_ports {led[9]}]
# set_property -dict {PACKAGE_PIN W3 IOSTANDARD LVCMOS33} [get_ports {led[10]}]
# set_property -dict {PACKAGE_PIN U3 IOSTANDARD LVCMOS33} [get_ports {led[11]}]
# set_property -dict {PACKAGE_PIN P3 IOSTANDARD LVCMOS33} [get_ports {led[12]}]
# set_property -dict {PACKAGE_PIN N3 IOSTANDARD LVCMOS33} [get_ports {led[13]}]
# set_property -dict {PACKAGE_PIN P1 IOSTANDARD LVCMOS33} [get_ports {led[14]}]
# set_property -dict {PACKAGE_PIN L1 IOSTANDARD LVCMOS33} [get_ports {led[15]}]


#VGA
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS33} [get_ports {rgb_r[0]}]
set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVCMOS33} [get_ports {rgb_r[1]}]
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports {rgb_r[2]}]
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS33} [get_ports {rgb_r[3]}]

set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS33} [get_ports {rgb_g[0]}]
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {rgb_g[1]}]
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports {rgb_g[2]}]
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS33} [get_ports {rgb_g[3]}]

set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS33} [get_ports {rgb_b[0]}]
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports {rgb_b[1]}]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports {rgb_b[2]}]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports {rgb_b[3]}]

set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS33} [get_ports h_sync]
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS33} [get_ports v_sync]


# set_false_path -from [get_clocks clk] -to [get_clocks -of_objects [get_pins u_vga_top/instance_name/inst/mmcm_adv_inst/CLKOUT0]]
