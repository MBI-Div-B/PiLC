## Generated SDC file "PiLC.sdc"

## Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus II License Agreement,
## the Altera MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Altera and sold by Altera or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 15.0.0 Build 145 04/22/2015 SJ Full Version"

## DATE    "Fri Dec 11 09:26:46 2015"

##
## DEVICE  "EP4CE22F17C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {inst2|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {inst2|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 3 -master_clock {clk} [get_pins { inst2|altpll_component|auto_generated|pll1|clk[0] }] 
create_generated_clock -name {inst2|altpll_component|auto_generated|pll1|clk[1]} -source [get_pins {inst2|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 2 -master_clock {clk} [get_pins {inst2|altpll_component|auto_generated|pll1|clk[1]}] 
create_generated_clock -name {dram_clk} -source [get_nets {inst2|altpll_component|auto_generated|wire_pll1_clk[1]}] -master_clock {inst2|altpll_component|auto_generated|pll1|clk[1]} [get_ports {DRAM_CLK}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {dram_clk}] -rise_to [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[1]}]  0.110  
set_clock_uncertainty -rise_from [get_clocks {dram_clk}] -fall_to [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[1]}]  0.110  
set_clock_uncertainty -fall_from [get_clocks {dram_clk}] -rise_to [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[1]}]  0.110  
set_clock_uncertainty -fall_from [get_clocks {dram_clk}] -fall_to [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[1]}]  0.110  
set_clock_uncertainty -rise_from [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {dram_clk}]  0.110  
set_clock_uncertainty -rise_from [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {dram_clk}]  0.110  
set_clock_uncertainty -rise_from [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {dram_clk}]  0.110  
set_clock_uncertainty -fall_from [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {dram_clk}]  0.110  
set_clock_uncertainty -fall_from [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[0]}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -max -clock [get_clocks {dram_clk}]  5.400 [get_ports {DRAM_DQ[0]}]
set_input_delay -add_delay -min -clock [get_clocks {dram_clk}]  2.700 [get_ports {DRAM_DQ[0]}]
set_input_delay -add_delay -max -clock [get_clocks {dram_clk}]  5.400 [get_ports {DRAM_DQ[1]}]
set_input_delay -add_delay -min -clock [get_clocks {dram_clk}]  2.700 [get_ports {DRAM_DQ[1]}]
set_input_delay -add_delay -max -clock [get_clocks {dram_clk}]  5.400 [get_ports {DRAM_DQ[2]}]
set_input_delay -add_delay -min -clock [get_clocks {dram_clk}]  2.700 [get_ports {DRAM_DQ[2]}]
set_input_delay -add_delay -max -clock [get_clocks {dram_clk}]  5.400 [get_ports {DRAM_DQ[3]}]
set_input_delay -add_delay -min -clock [get_clocks {dram_clk}]  2.700 [get_ports {DRAM_DQ[3]}]
set_input_delay -add_delay -max -clock [get_clocks {dram_clk}]  5.400 [get_ports {DRAM_DQ[4]}]
set_input_delay -add_delay -min -clock [get_clocks {dram_clk}]  2.700 [get_ports {DRAM_DQ[4]}]
set_input_delay -add_delay -max -clock [get_clocks {dram_clk}]  5.400 [get_ports {DRAM_DQ[5]}]
set_input_delay -add_delay -min -clock [get_clocks {dram_clk}]  2.700 [get_ports {DRAM_DQ[5]}]
set_input_delay -add_delay -max -clock [get_clocks {dram_clk}]  5.400 [get_ports {DRAM_DQ[6]}]
set_input_delay -add_delay -min -clock [get_clocks {dram_clk}]  2.700 [get_ports {DRAM_DQ[6]}]
set_input_delay -add_delay -max -clock [get_clocks {dram_clk}]  5.400 [get_ports {DRAM_DQ[7]}]
set_input_delay -add_delay -min -clock [get_clocks {dram_clk}]  2.700 [get_ports {DRAM_DQ[7]}]
set_input_delay -add_delay -max -clock [get_clocks {dram_clk}]  5.400 [get_ports {DRAM_DQ[8]}]
set_input_delay -add_delay -min -clock [get_clocks {dram_clk}]  2.700 [get_ports {DRAM_DQ[8]}]
set_input_delay -add_delay -max -clock [get_clocks {dram_clk}]  5.400 [get_ports {DRAM_DQ[9]}]
set_input_delay -add_delay -min -clock [get_clocks {dram_clk}]  2.700 [get_ports {DRAM_DQ[9]}]
set_input_delay -add_delay -max -clock [get_clocks {dram_clk}]  5.400 [get_ports {DRAM_DQ[10]}]
set_input_delay -add_delay -min -clock [get_clocks {dram_clk}]  2.700 [get_ports {DRAM_DQ[10]}]
set_input_delay -add_delay -max -clock [get_clocks {dram_clk}]  5.400 [get_ports {DRAM_DQ[11]}]
set_input_delay -add_delay -min -clock [get_clocks {dram_clk}]  2.700 [get_ports {DRAM_DQ[11]}]
set_input_delay -add_delay -max -clock [get_clocks {dram_clk}]  5.400 [get_ports {DRAM_DQ[12]}]
set_input_delay -add_delay -min -clock [get_clocks {dram_clk}]  2.700 [get_ports {DRAM_DQ[12]}]
set_input_delay -add_delay -max -clock [get_clocks {dram_clk}]  5.400 [get_ports {DRAM_DQ[13]}]
set_input_delay -add_delay -min -clock [get_clocks {dram_clk}]  2.700 [get_ports {DRAM_DQ[13]}]
set_input_delay -add_delay -max -clock [get_clocks {dram_clk}]  5.400 [get_ports {DRAM_DQ[14]}]
set_input_delay -add_delay -min -clock [get_clocks {dram_clk}]  2.700 [get_ports {DRAM_DQ[14]}]
set_input_delay -add_delay -max -clock [get_clocks {dram_clk}]  5.400 [get_ports {DRAM_DQ[15]}]
set_input_delay -add_delay -min -clock [get_clocks {dram_clk}]  2.700 [get_ports {DRAM_DQ[15]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_ADDR[0]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_ADDR[0]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_ADDR[1]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_ADDR[1]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_ADDR[2]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_ADDR[2]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_ADDR[3]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_ADDR[3]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_ADDR[4]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_ADDR[4]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_ADDR[5]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_ADDR[5]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_ADDR[6]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_ADDR[6]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_ADDR[7]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_ADDR[7]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_ADDR[8]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_ADDR[8]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_ADDR[9]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_ADDR[9]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_ADDR[10]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_ADDR[10]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_ADDR[11]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_ADDR[11]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_ADDR[12]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_ADDR[12]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_BA[0]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_BA[0]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_BA[1]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_BA[1]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_CAS_N}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_CAS_N}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_CKE}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_CKE}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_CS_N}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_CS_N}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_DQM[0]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_DQM[0]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_DQM[1]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_DQM[1]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_DQ[0]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_DQ[0]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_DQ[1]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_DQ[1]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_DQ[2]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_DQ[2]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_DQ[3]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_DQ[3]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_DQ[4]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_DQ[4]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_DQ[5]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_DQ[5]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_DQ[6]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_DQ[6]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_DQ[7]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_DQ[7]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_DQ[8]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_DQ[8]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_DQ[9]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_DQ[9]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_DQ[10]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_DQ[10]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_DQ[11]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_DQ[11]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_DQ[12]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_DQ[12]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_DQ[13]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_DQ[13]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_DQ[14]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_DQ[14]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_DQ[15]}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_DQ[15]}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_RAS_N}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_RAS_N}]
set_output_delay -add_delay -max -clock [get_clocks {dram_clk}]  1.500 [get_ports {DRAM_WE_N}]
set_output_delay -add_delay -min -clock [get_clocks {dram_clk}]  -0.800 [get_ports {DRAM_WE_N}]


#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -exclusive -group [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[0]}] -group [get_clocks {inst2|altpll_component|auto_generated|pll1|clk[1]}] 


#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_gd9:dffpipe15|dffe16a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_fd9:dffpipe12|dffe13a*}]
set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_jd9:dffpipe11|dffe12a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_hd9:dffpipe6|dffe7a*}]
set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_ed9:dffpipe15|dffe16a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_dd9:dffpipe12|dffe13a*}]
set_false_path -to [get_ports {DRAM_CLK}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

