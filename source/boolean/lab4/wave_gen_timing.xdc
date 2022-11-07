# MIT License
#
# Copyright (c) 2022 Advanced Micro Devices, Inc. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# define clock and period
create_clock -period 10.000 -name clk_pin -waveform {0.000 5.000} [get_ports clk_pin]


# Global timing constraints
set clk_rx [get_clocks -of [get_nets clk_rx] ]
set clk_tx [get_clocks -of [get_nets clk_tx] ]
set_input_delay   -clock clk_pin 0  [get_ports {lb_sel_pin rst_pin rxd_pin}]
set_input_delay   -clock clk_pin -min -0.5 [get_ports {lb_sel_pin rst_pin rxd_pin}]
set_output_delay  -clock clk_pin 0 [all_outputs]

# Path specific timing constraints
set_output_delay -clock clk_pin -clock_fall 0.000 [get_ports spi_clk_pin] -add_delay
set_false_path -rise_from $clk_tx -through [get_ports spi_clk_pin] -fall_to [get_clocks clk_pin]
set_false_path -fall_from $clk_tx -through [get_ports spi_clk_pin] -rise_to [get_clocks clk_pin]

set_multicycle_path -from [get_cells {cmd_parse_i0/send_resp_data_reg[*]}] -to [get_cells {resp_gen_i0/to_bcd_i0/bcd_out_reg[*]}] 2
set_multicycle_path -from [get_cells {cmd_parse_i0/send_resp_data_reg[*]}] -to [get_cells {resp_gen_i0/to_bcd_i0/bcd_out_reg[*]}] -hold 1

set_multicycle_path -from [get_cells "uart_rx_i0/uart_rx_ctl_i0/*" -filter {IS_SEQUENTIAL == 1}] -to [get_cells "uart_rx_i0/uart_rx_ctl_i0/*" -filter {IS_SEQUENTIAL == 1}] 108 
set_multicycle_path -from [get_cells "uart_rx_i0/uart_rx_ctl_i0/*" -filter {IS_SEQUENTIAL == 1}] -to [get_cells "uart_rx_i0/uart_rx_ctl_i0/*" -filter {IS_SEQUENTIAL == 1}] -hold 107 

set_multicycle_path -from [get_cells "uart_tx_i0/uart_tx_ctl_i0/*" -filter {IS_SEQUENTIAL == 1}] -to [get_cells "uart_tx_i0/uart_tx_ctl_i0/*" -filter {IS_SEQUENTIAL == 1}] 108 
set_multicycle_path -from [get_cells "uart_tx_i0/uart_tx_ctl_i0/*" -filter {IS_SEQUENTIAL == 1}] -to [get_cells "uart_tx_i0/uart_tx_ctl_i0/*" -filter {IS_SEQUENTIAL == 1}] -hold 107 

create_generated_clock -name clk_samp -source [get_pins {clk_gen_i0/clk_wiz_i0/clk_out2}] -divide_by 32 [get_pins {clk_gen_i0/BUFHCE_clk_samp_i0/O}]

set_max_delay -from clkx_nsamp_i0/meta_harden_bus_new_i0/signal_meta_reg            -to clkx_nsamp_i0/meta_harden_bus_new_i0/signal_dst_reg 2 
set_max_delay -from clkx_pre_i0/meta_harden_bus_new_i0/signal_meta_reg              -to clkx_pre_i0/meta_harden_bus_new_i0/signal_dst_reg 2 
set_max_delay -from clkx_spd_i0/meta_harden_bus_new_i0/signal_meta_reg              -to clkx_spd_i0/meta_harden_bus_new_i0/signal_dst_reg 2 
set_max_delay -from lb_ctl_i0/debouncer_i0/meta_harden_signal_in_i0/signal_meta_reg -to lb_ctl_i0/debouncer_i0/meta_harden_signal_in_i0/signal_dst_reg 2 
set_max_delay -from samp_gen_i0/meta_harden_samp_gen_go_i0/signal_meta_reg          -to samp_gen_i0/meta_harden_samp_gen_go_i0/signal_dst_reg 2 
set_max_delay -from uart_rx_i0/meta_harden_rxd_i0/signal_meta_reg                   -to uart_rx_i0/meta_harden_rxd_i0/signal_dst_reg 2 

set_max_delay -from rst_gen_i0/reset_bridge_clk_rx_i0/rst_meta_reg                  -to rst_gen_i0/reset_bridge_clk_rx_i0/rst_dst_reg 2 
set_max_delay -from rst_gen_i0/reset_bridge_clk_tx_i0/rst_meta_reg                  -to rst_gen_i0/reset_bridge_clk_tx_i0/rst_dst_reg 2 
set_max_delay -from rst_gen_i0/reset_bridge_clk_samp_i0/rst_meta_reg                -to rst_gen_i0/reset_bridge_clk_samp_i0/rst_dst_reg 2 

set_false_path -from [get_ports rst_pin]
