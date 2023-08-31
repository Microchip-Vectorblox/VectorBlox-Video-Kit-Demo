#JTAG

set_clock_groups -asynchronous -group [ get_clocks { PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT2 } ] -group [ get_clocks { TCK } ]
