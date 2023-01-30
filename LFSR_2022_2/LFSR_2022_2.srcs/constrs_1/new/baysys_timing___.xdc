// timing contstraints for basys3 board
create_generated_clock -name clk_gen_1/clk -source [get_ports CLK100MHZ] -divide_by 2 [get_pins clk_gen_1/clk1_reg/Q]
create_generated_clock -name debounce_1/CLK -source [get_pins clk_gen_1/clk1_reg/Q] -divide_by 2 [get_pins debounce_1/db_out_reg/Q]