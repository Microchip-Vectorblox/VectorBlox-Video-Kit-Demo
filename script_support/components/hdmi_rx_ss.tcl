# Creating SmartDesign "hdmi_rx_ss"
set sd_name {hdmi_rx_ss}
create_smartdesign -sd_name ${sd_name}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Scalar Ports
sd_create_scalar_port -sd_name ${sd_name} -port_name {HPD_I} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LANE0_RXD_N} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LANE0_RXD_P} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LANE1_RXD_N} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LANE1_RXD_P} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LANE2_RXD_N} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LANE2_RXD_P} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {REF_CLK_0} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {REF_CLK_PAD_N} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {REF_CLK_PAD_P} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {RESET_N_I_0} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {RESET_N_I} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SCL_I} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {ddr_clk_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {reset_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {save_frame_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {write_ackn_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {write_done_i} -port_direction {IN}

sd_create_scalar_port -sd_name ${sd_name} -port_name {HPD_O} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {rdata_rdy_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {write_req_o} -port_direction {OUT}

sd_create_scalar_port -sd_name ${sd_name} -port_name {SDA_hdmi_rx} -port_direction {INOUT} -port_is_pad {1}

# Create top level Bus Ports
sd_create_bus_port -sd_name ${sd_name} -port_name {beats_to_write_o} -port_direction {OUT} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {display_frame_addr_o} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {processing_frame_addr_o} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {processing_next_frame_addr_o} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {processing_next_next_frame_addr_o} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {rdata_o} -port_direction {OUT} -port_range {[255:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {write_start_addr_o} -port_direction {OUT} -port_range {[31:0]}


sd_invert_pins -sd_name ${sd_name} -pin_names {HPD_I}
sd_invert_pins -sd_name ${sd_name} -pin_names {HPD_O}
# Add BIBUF_0 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {BIBUF} -instance_name {BIBUF_0}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {BIBUF_0:D} -value {GND}



# Add CCC_EDID_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CCC_EDID} -instance_name {CCC_EDID_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CCC_EDID_0:PLL_LOCK_0}



# Add DDR_Write_HDMI_RX_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {DDR_Write_HDMI_RX} -instance_name {DDR_Write_HDMI_RX_0}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {DDR_Write_HDMI_RX_0:data_i} -pin_slices {[15:8]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {DDR_Write_HDMI_RX_0:data_i} -pin_slices {[23:16]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {DDR_Write_HDMI_RX_0:data_i} -pin_slices {[31:24]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {DDR_Write_HDMI_RX_0:data_i[31:24]} -value {GND}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {DDR_Write_HDMI_RX_0:data_i} -pin_slices {[7:0]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {DDR_Write_HDMI_RX_0:frame_ddr_addr_i} -value {01110000}



# Add HDMI_RX_C1_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {HDMI_RX_C1} -instance_name {HDMI_RX_C1_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {HDMI_RX_C1_0:H_SYNC_O}



# Add PF_XCVR_ERM_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {PF_XCVR_ERM_C0} -instance_name {PF_XCVR_ERM_C0_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_XCVR_ERM_C0_0:LANE0_RX_IDLE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_XCVR_ERM_C0_0:LANE0_RX_READY}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_XCVR_ERM_C0_0:LANE0_RX_BYPASS_DATA}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_XCVR_ERM_C0_0:LANE1_RX_IDLE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_XCVR_ERM_C0_0:LANE1_RX_READY}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_XCVR_ERM_C0_0:LANE1_RX_BYPASS_DATA}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_XCVR_ERM_C0_0:LANE2_RX_IDLE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_XCVR_ERM_C0_0:LANE2_RX_READY}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_XCVR_ERM_C0_0:LANE2_RX_BYPASS_DATA}



# Add PF_XCVR_REF_CLK_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {PF_XCVR_REF_CLK_C0} -instance_name {PF_XCVR_REF_CLK_C0_0}



# Add scalar net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_0:E" "HDMI_RX_C1_0:SDA_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_0:PAD" "SDA_hdmi_rx" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_0:Y" "HDMI_RX_C1_0:SDA_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CCC_EDID_0:OUT0_FABCLK_0" "HDMI_RX_C1_0:EDID_CLK_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CCC_EDID_0:REF_CLK_0" "REF_CLK_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_HDMI_RX_0:data_valid_i" "HDMI_RX_C1_0:DATA_VALID_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_HDMI_RX_0:ddr_clk_i" "ddr_clk_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_HDMI_RX_0:frame_valid_i" "HDMI_RX_C1_0:V_SYNC_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_HDMI_RX_0:parallel_clk_i" "HDMI_RX_C1_0:B_RX_CLK_I" "PF_XCVR_ERM_C0_0:LANE1_RX_CLK_R" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_HDMI_RX_0:rdata_rdy_o" "rdata_rdy_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_HDMI_RX_0:reset_i" "reset_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_HDMI_RX_0:save_frame_i" "save_frame_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_HDMI_RX_0:write_ackn_i" "write_ackn_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_HDMI_RX_0:write_done_i" "write_done_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_HDMI_RX_0:write_req_o" "write_req_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HDMI_RX_C1_0:BIT_SLIP_B_O" "PF_XCVR_ERM_C0_0:LANE1_RX_SLIP" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HDMI_RX_C1_0:BIT_SLIP_G_O" "PF_XCVR_ERM_C0_0:LANE2_RX_SLIP" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HDMI_RX_C1_0:BIT_SLIP_R_O" "PF_XCVR_ERM_C0_0:LANE0_RX_SLIP" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HDMI_RX_C1_0:B_RX_VALID_I" "PF_XCVR_ERM_C0_0:LANE1_RX_VAL" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HDMI_RX_C1_0:G_RX_CLK_I" "PF_XCVR_ERM_C0_0:LANE2_RX_CLK_R" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HDMI_RX_C1_0:G_RX_VALID_I" "PF_XCVR_ERM_C0_0:LANE2_RX_VAL" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HDMI_RX_C1_0:HPD_I" "HPD_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HDMI_RX_C1_0:HPD_O" "HPD_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HDMI_RX_C1_0:RESET_N_I" "RESET_N_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HDMI_RX_C1_0:R_RX_CLK_I" "PF_XCVR_ERM_C0_0:LANE0_RX_CLK_R" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HDMI_RX_C1_0:R_RX_VALID_I" "PF_XCVR_ERM_C0_0:LANE0_RX_VAL" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HDMI_RX_C1_0:SCL_I" "SCL_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"LANE0_RXD_N" "PF_XCVR_ERM_C0_0:LANE0_RXD_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"LANE0_RXD_P" "PF_XCVR_ERM_C0_0:LANE0_RXD_P" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"LANE1_RXD_N" "PF_XCVR_ERM_C0_0:LANE1_RXD_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"LANE1_RXD_P" "PF_XCVR_ERM_C0_0:LANE1_RXD_P" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"LANE2_RXD_N" "PF_XCVR_ERM_C0_0:LANE2_RXD_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"LANE2_RXD_P" "PF_XCVR_ERM_C0_0:LANE2_RXD_P" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_XCVR_ERM_C0_0:LANE0_CDR_REF_CLK_0" "PF_XCVR_ERM_C0_0:LANE1_CDR_REF_CLK_0" "PF_XCVR_ERM_C0_0:LANE2_CDR_REF_CLK_0" "PF_XCVR_REF_CLK_C0_0:REF_CLK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_XCVR_ERM_C0_0:LANE0_PCS_ARST_N" "PF_XCVR_ERM_C0_0:LANE0_PMA_ARST_N" "PF_XCVR_ERM_C0_0:LANE1_PCS_ARST_N" "PF_XCVR_ERM_C0_0:LANE1_PMA_ARST_N" "PF_XCVR_ERM_C0_0:LANE2_PCS_ARST_N" "PF_XCVR_ERM_C0_0:LANE2_PMA_ARST_N" "RESET_N_I_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_XCVR_REF_CLK_C0_0:REF_CLK_PAD_N" "REF_CLK_PAD_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_XCVR_REF_CLK_C0_0:REF_CLK_PAD_P" "REF_CLK_PAD_P" }

# Add bus net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_HDMI_RX_0:beats_to_write_o" "beats_to_write_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_HDMI_RX_0:data_i[15:8]" "HDMI_RX_C1_0:G_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_HDMI_RX_0:data_i[23:16]" "HDMI_RX_C1_0:R_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_HDMI_RX_0:data_i[7:0]" "HDMI_RX_C1_0:B_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_HDMI_RX_0:display_frame_addr_o" "display_frame_addr_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_HDMI_RX_0:process_frame_addr_o" "processing_frame_addr_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_HDMI_RX_0:process_next_frame_addr_o" "processing_next_frame_addr_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_HDMI_RX_0:process_next_next_frame_addr_o" "processing_next_next_frame_addr_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_HDMI_RX_0:rdata_o" "rdata_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_HDMI_RX_0:write_start_addr_o" "write_start_addr_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HDMI_RX_C1_0:DATA_B_I" "PF_XCVR_ERM_C0_0:LANE1_RX_DATA" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HDMI_RX_C1_0:DATA_G_I" "PF_XCVR_ERM_C0_0:LANE2_RX_DATA" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HDMI_RX_C1_0:DATA_R_I" "PF_XCVR_ERM_C0_0:LANE0_RX_DATA" }


# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Save the SmartDesign 
save_smartdesign -sd_name ${sd_name}
# Generate SmartDesign "hdmi_rx_ss"
generate_component -component_name ${sd_name}
