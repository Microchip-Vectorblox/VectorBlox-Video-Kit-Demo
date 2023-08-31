#Constrain TCK
create_clock -name {TCK} -period 33.33 [ get_ports { TCK } ]

## SET ASYNCHRONOUS CLOCK GROUPS
#27MHZ On-board CLK_IN is an independent clock domain 
set_clock_groups -name {clk_grp_clk_in} -asynchronous -group [ get_clocks { CLK_IN } ]
set_clock_groups -name {clk_grp_cam1_clk} -asynchronous -group [ get_clocks { CAM1_RX_CLK_P } ]
##set_clock_groups -name {clk_grp_cam2_clk} -asynchronous -group [ get_clocks { CAM2_RX_CLK_P } ]

##IMX
## This clock group is from CSI2 block to DDR Write and cdc fifo is present in the data path
set_clock_groups -name {clk_grp_cam_ccc_o0} -asynchronous -group [ get_clocks { IMX334_IF_TOP_0/PF_CCC_C2_0/PF_CCC_C2_0/pll_inst_0/OUT0 } ]
set_clock_groups -name {clk_grp_cam_ccc_ydiv0} -asynchronous -group [ get_clocks { IMX334_IF_TOP_0/PF_IOD_GENERIC_RX_C0_0/PF_IOD_0/PF_CLK_DIV_FIFO/I_CDD/Y_DIV } ]
##set_clock_groups -name {clk_grp_cam_ccc_ydiv1} -asynchronous -group [ get_clocks { IMX334_IF_TOP_0/PF_IOD_GENERIC_RX_C0_1/PF_IOD_0/PF_CLK_DIV_FIFO/I_CDD/Y_DIV } ]

##CCC
## This clock group is from PF_CCC_C0 to APB and MIV, cdc fifo present in the data path
set_clock_groups -name {clk_grp_cam_ccc_c0o2} -asynchronous -group [ get_clocks { PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT2 } ] 
## This clock group is from PF_CCC_C1 to TX_PLL and PF_XCVR, cdc fifo present in the data path
set_clock_groups -name {clk_grp_cam_ccc_c1o0} -asynchronous \
    -group [ get_clocks { PF_CCC_C1_0/PF_CCC_C1_0/pll_inst_0/OUT0 } ] \
    -group [ get_clocks { PF_CCC_C1_0/PF_CCC_C1_0/pll_inst_0/OUT1 } ] \
    -group [ get_clocks { PF_DDR4_C0_0/CCC_0/pll_inst_0/OUT1 } ]
##DDR
## This clock group is from DDR to Core_Lite_Axi, cdc fifo present in the data path
set_clock_groups -name {clk_grp_cam_ddr_o1} -asynchronous -group [ get_clocks { PF_DDR4_C0_0/CCC_0/pll_inst_0/OUT1 } ]
set_clock_groups -name {clk_grp_cam_ddr_o2} -asynchronous -group [ get_clocks { PF_DDR4_C0_0/CCC_0/pll_inst_0/OUT2 } ]
set_clock_groups -name {clk_grp_cam_ddr_o0} -asynchronous -group [ get_clocks { PF_DDR4_C0_0/CCC_0/pll_inst_0/OUT0 } ]
set_clock_groups -name {clk_grp_cam_ddr_o3} -asynchronous -group [ get_clocks { PF_DDR4_C0_0/CCC_0/pll_inst_0/OUT3 } ]


#Setup time of 1ns and hold time of 0.7ns for HDMI signals to ADV7511 with respect to HDMI_CLK
#-3.2 ns
set_output_delay -max -2.2 -clock {PF_CCC_C1_0/PF_CCC_C1_0/pll_inst_0/OUT0} [ get_ports {B_out_o[0] B_out_o[1] B_out_o[2] B_out_o[3] B_out_o[4] B_out_o[5] B_out_o[6] B_out_o[7] G_out_o[0] G_out_o[1] G_out_o[2] G_out_o[3] G_out_o[4] G_out_o[5] G_out_o[6] G_out_o[7] R_out_o[0] R_out_o[1] R_out_o[2] R_out_o[3] R_out_o[4] R_out_o[5] R_out_o[6] R_out_o[7] data_enable_o horz_sync_o vert_sync_o hdmi_clk} ]
set_output_delay -min -2.5 -clock {PF_CCC_C1_0/PF_CCC_C1_0/pll_inst_0/OUT0} [ get_ports {B_out_o[0] B_out_o[1] B_out_o[2] B_out_o[3] B_out_o[4] B_out_o[5] B_out_o[6] B_out_o[7] G_out_o[0] G_out_o[1] G_out_o[2] G_out_o[3] G_out_o[4] G_out_o[5] G_out_o[6] G_out_o[7] R_out_o[0] R_out_o[1] R_out_o[2] R_out_o[3] R_out_o[4] R_out_o[5] R_out_o[6] R_out_o[7] data_enable_o horz_sync_o vert_sync_o hdmi_clk} ]


