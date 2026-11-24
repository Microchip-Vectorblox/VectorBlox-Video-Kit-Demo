# Creating SmartDesign "VIDEO_KIT_TOP"
set sd_name {VIDEO_KIT_TOP}
create_smartdesign -sd_name ${sd_name}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Scalar Ports
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM1_RX_CLK_N} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM1_RX_CLK_P} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CLK_IN} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {DI} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {FLASH} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {HPD_I} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {IFACE} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LANE0_RXD_N} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LANE0_RXD_P} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LANE1_RXD_N} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LANE1_RXD_P} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LANE2_RXD_N} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LANE2_RXD_P} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {REF_CLK_PAD_N} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {REF_CLK_PAD_P} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SCL_hdmi_rx} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SW1} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SW2} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SW3} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SW4} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SW5} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SW6} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TCK} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TDI} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TMS} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TRSTB} -port_direction {IN}

sd_create_scalar_port -sd_name ${sd_name} -port_name {ACT_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {BG} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM1_RST} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM1_XMASTER} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM2_RST} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM2_XMASTER} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAMERA_CLK} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM_CLK_EN} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM_INCK} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAS_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CK0_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CK0} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CKE} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CS_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {DO} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {HDMIO_PD} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {HPD_O} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {ODT} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {RAS_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {RESET_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SHIELD0} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SHIELD1} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SHIELD2} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SHIELD3} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SHIELD4} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SHIELD5} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SHIELD6} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SHIELD7} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TDO} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TX} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {WE_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {data_enable_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {hdmi_clk} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {horz_sync_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {line_valid_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {vert_sync_o} -port_direction {OUT}

sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM1_SCL} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM1_SDA} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM2_SCL} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM2_SDA} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CLK} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {HDMI_SCL} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {HDMI_SDA} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SDA_hdmi_rx} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SS} -port_direction {INOUT} -port_is_pad {1}

# Create top level Bus Ports
sd_create_bus_port -sd_name ${sd_name} -port_name {CAM1_RXD_N} -port_direction {IN} -port_range {[3:0]} -port_is_pad {1}
sd_create_bus_port -sd_name ${sd_name} -port_name {CAM1_RXD} -port_direction {IN} -port_range {[3:0]} -port_is_pad {1}

sd_create_bus_port -sd_name ${sd_name} -port_name {A} -port_direction {OUT} -port_range {[13:0]} -port_is_pad {1}
sd_create_bus_port -sd_name ${sd_name} -port_name {BA} -port_direction {OUT} -port_range {[1:0]} -port_is_pad {1}
sd_create_bus_port -sd_name ${sd_name} -port_name {B_out_o} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {DM_N} -port_direction {OUT} -port_range {[7:0]} -port_is_pad {1}
sd_create_bus_port -sd_name ${sd_name} -port_name {GPIO_OUT_0} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {G_out_o} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {R_out_o} -port_direction {OUT} -port_range {[7:0]}

sd_create_bus_port -sd_name ${sd_name} -port_name {DQS_N} -port_direction {INOUT} -port_range {[7:0]} -port_is_pad {1}
sd_create_bus_port -sd_name ${sd_name} -port_name {DQS} -port_direction {INOUT} -port_range {[7:0]} -port_is_pad {1}
sd_create_bus_port -sd_name ${sd_name} -port_name {DQ} -port_direction {INOUT} -port_range {[63:0]} -port_is_pad {1}

sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CAM1_XMASTER} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CAM2_XMASTER} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CAM_INCK} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {HDMIO_PD} -value {GND}
# Add AND2_0 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {AND2} -instance_name {AND2_0}



# Add AND2_2 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {AND2} -instance_name {AND2_2}



# Add AND2_2_0 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {AND2} -instance_name {AND2_2_0}



# Add AND4_0 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {AND4} -instance_name {AND4_0}



# Add AND4_1 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {AND4} -instance_name {AND4_1}



# Add apb3_if_0 instance
sd_instantiate_hdl_core -sd_name ${sd_name} -hdl_core_name {apb3_if} -instance_name {apb3_if_0}
# Exporting Parameters of instance apb3_if_0
sd_configure_core_instance -sd_name ${sd_name} -instance_name {apb3_if_0} -params {\
"g_APB3_IF_DATA_WIDTH:32" \
"g_CONST_WIDTH:12" }\
-validate_rules 0
sd_save_core_instance_config -sd_name ${sd_name} -instance_name {apb3_if_0}
sd_update_instance -sd_name ${sd_name} -instance_name {apb3_if_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {apb3_if_0:DDR_READ_FRAME_START_ADDR_O}



# Add axi_arbiter_0 instance
sd_instantiate_hdl_core -sd_name ${sd_name} -hdl_core_name {axi_arbiter} -instance_name {axi_arbiter_0}
# Exporting Parameters of instance axi_arbiter_0
sd_configure_core_instance -sd_name ${sd_name} -instance_name {axi_arbiter_0} -params {\
"ADDR_WIDTH:32" \
"DATA_WIDTH:512" \
"S_ID_WIDTH:6" }\
-validate_rules 0
sd_save_core_instance_config -sd_name ${sd_name} -instance_name {axi_arbiter_0}
sd_update_instance -sd_name ${sd_name} -instance_name {axi_arbiter_0}



# Add Bayer_Interpolation_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {Bayer_Interpolation_C0} -instance_name {Bayer_Interpolation_C0_0}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {Bayer_Interpolation_C0_0:R_O} -pin_slices {[15:8]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {Bayer_Interpolation_C0_0:R_O} -pin_slices {[23:16]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {Bayer_Interpolation_C0_0:R_O} -pin_slices {[31:24]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {Bayer_Interpolation_C0_0:R_O} -pin_slices {[7:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {Bayer_Interpolation_C0_0:G_O} -pin_slices {[15:8]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {Bayer_Interpolation_C0_0:G_O} -pin_slices {[23:16]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {Bayer_Interpolation_C0_0:G_O} -pin_slices {[31:24]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {Bayer_Interpolation_C0_0:G_O} -pin_slices {[7:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {Bayer_Interpolation_C0_0:B_O} -pin_slices {[15:8]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {Bayer_Interpolation_C0_0:B_O} -pin_slices {[23:16]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {Bayer_Interpolation_C0_0:B_O} -pin_slices {[31:24]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {Bayer_Interpolation_C0_0:B_O} -pin_slices {[7:0]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Bayer_Interpolation_C0_0:BAYER_FORMAT} -value {00}



# Add CORERESET_PF_C1_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CORERESET_PF_C1} -instance_name {CORERESET_PF_C1_0}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_0:EXT_RST_N} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_0:BANK_x_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_0:BANK_y_VDDI_STATUS} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_0:SS_BUSY} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_0:INIT_DONE} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_0:FF_US_RESTORE} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_0:FPGA_POR_N} -value {VCC}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_0:PLL_POWERDOWN_B}



# Add CORERESET_PF_C1_1 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CORERESET_PF_C1} -instance_name {CORERESET_PF_C1_1}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_1:EXT_RST_N} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_1:BANK_x_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_1:BANK_y_VDDI_STATUS} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_1:SS_BUSY} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_1:INIT_DONE} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_1:FF_US_RESTORE} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_1:FPGA_POR_N} -value {VCC}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_1:PLL_POWERDOWN_B}



# Add CORERESET_PF_C1_2 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CORERESET_PF_C1} -instance_name {CORERESET_PF_C1_2}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_2:EXT_RST_N} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_2:BANK_x_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_2:BANK_y_VDDI_STATUS} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_2:SS_BUSY} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_2:INIT_DONE} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_2:FF_US_RESTORE} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_2:FPGA_POR_N} -value {VCC}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_2:PLL_POWERDOWN_B}



# Add CORERESET_PF_C1_3 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CORERESET_PF_C1} -instance_name {CORERESET_PF_C1_3}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_3:EXT_RST_N} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_3:BANK_x_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_3:BANK_y_VDDI_STATUS} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_3:SS_BUSY} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_3:INIT_DONE} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_3:FF_US_RESTORE} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_3:FPGA_POR_N} -value {VCC}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_3:PLL_POWERDOWN_B}



# Add CORERESET_PF_C1_4 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CORERESET_PF_C1} -instance_name {CORERESET_PF_C1_4}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_4:EXT_RST_N} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_4:BANK_x_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_4:BANK_y_VDDI_STATUS} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_4:SS_BUSY} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_4:INIT_DONE} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_4:FF_US_RESTORE} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_4:FPGA_POR_N} -value {VCC}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORERESET_PF_C1_4:PLL_POWERDOWN_B}



# Add DDR_AXI4_ARBITER_PF_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {DDR_AXI4_ARBITER_PF_C0} -instance_name {DDR_AXI4_ARBITER_PF_C0_0}



# Add ddr_dma_write_bif_0 instance
sd_instantiate_hdl_core -sd_name ${sd_name} -hdl_core_name {ddr_dma_write_bif} -instance_name {ddr_dma_write_bif_0}
# Exporting Parameters of instance ddr_dma_write_bif_0
sd_configure_core_instance -sd_name ${sd_name} -instance_name {ddr_dma_write_bif_0} -params {\
"ADDRESS_WIDTH:32" \
"AXI_ADDRESS_WIDTH:32" \
"AXI_DATA_WIDTH:512" \
"AXI_ID_WIDTH:7" \
"DATA_WIDTH:128" \
"MAX_BURST_LENGTH:256" \
"MAX_LINE_SIZE:480" \
"STRIDE_ISBYTES:1" }\
-validate_rules 0
sd_save_core_instance_config -sd_name ${sd_name} -instance_name {ddr_dma_write_bif_0}
sd_update_instance -sd_name ${sd_name} -instance_name {ddr_dma_write_bif_0}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ddr_dma_write_bif_0:config_frame_address_i} -pin_slices {[23:0]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {ddr_dma_write_bif_0:config_frame_address_i[23:0]} -value {GND}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ddr_dma_write_bif_0:config_frame_address_i} -pin_slices {[31:24]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ddr_dma_write_bif_0:target_data_i} -pin_slices {[103:96]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ddr_dma_write_bif_0:target_data_i} -pin_slices {[111:104]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ddr_dma_write_bif_0:target_data_i} -pin_slices {[119:112]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ddr_dma_write_bif_0:target_data_i} -pin_slices {[127:120]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {ddr_dma_write_bif_0:target_data_i[127:120]} -value {GND}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ddr_dma_write_bif_0:target_data_i} -pin_slices {[15:8]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ddr_dma_write_bif_0:target_data_i} -pin_slices {[23:16]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ddr_dma_write_bif_0:target_data_i} -pin_slices {[31:24]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {ddr_dma_write_bif_0:target_data_i[31:24]} -value {GND}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ddr_dma_write_bif_0:target_data_i} -pin_slices {[39:32]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ddr_dma_write_bif_0:target_data_i} -pin_slices {[47:40]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ddr_dma_write_bif_0:target_data_i} -pin_slices {[55:48]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ddr_dma_write_bif_0:target_data_i} -pin_slices {[63:56]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {ddr_dma_write_bif_0:target_data_i[63:56]} -value {GND}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ddr_dma_write_bif_0:target_data_i} -pin_slices {[71:64]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ddr_dma_write_bif_0:target_data_i} -pin_slices {[79:72]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ddr_dma_write_bif_0:target_data_i} -pin_slices {[7:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ddr_dma_write_bif_0:target_data_i} -pin_slices {[87:80]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ddr_dma_write_bif_0:target_data_i} -pin_slices {[95:88]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {ddr_dma_write_bif_0:target_data_i[95:88]} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {ddr_dma_write_bif_0:config_line_stride_i} -value {00000000000000000010000000000000}



# Add DDR_Read_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {DDR_Read_C0} -instance_name {DDR_Read_C0_0}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {DDR_Read_C0_0:data_o} -pin_slices {[15:8]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {DDR_Read_C0_0:data_o} -pin_slices {[23:16]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {DDR_Read_C0_0:data_o} -pin_slices {[31:24]}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {DDR_Read_C0_0:data_o[31:24]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {DDR_Read_C0_0:data_o} -pin_slices {[7:0]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {DDR_Read_C0_0:line_gap_i} -value {0010000000000000}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {DDR_Read_C0_0:h_offset_i} -value {000000000000}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {DDR_Read_C0_0:v_offset_i} -value {000000000000}



# Add Display_Controller_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {Display_Controller_C0} -instance_name {Display_Controller_C0_0}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Display_Controller_C0_0:ENABLE_I} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Display_Controller_C0_0:ENABLE_EXT_SYNC_I} -value {VCC}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {Display_Controller_C0_0:V_ACTIVE_O}



# Add ff_bus_0 instance
sd_instantiate_hdl_core -sd_name ${sd_name} -hdl_core_name {ff_bus} -instance_name {ff_bus_0}
# Exporting Parameters of instance ff_bus_0
sd_configure_core_instance -sd_name ${sd_name} -instance_name {ff_bus_0} -params {\
"BUS_WIDTH:27" }\
-validate_rules 0
sd_save_core_instance_config -sd_name ${sd_name} -instance_name {ff_bus_0}
sd_update_instance -sd_name ${sd_name} -instance_name {ff_bus_0}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_in} -pin_slices {[15:8]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_in} -pin_slices {[23:16]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_in} -pin_slices {[24:24]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_in} -pin_slices {[25:25]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_in} -pin_slices {[26:26]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_in} -pin_slices {[7:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_out} -pin_slices {[15:8]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_out} -pin_slices {[23:16]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_out} -pin_slices {[24:24]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_out} -pin_slices {[25:25]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_out} -pin_slices {[26:26]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_out} -pin_slices {[7:0]}



# Add frame_buffer_mgr_0 instance
sd_instantiate_hdl_module -sd_name ${sd_name} -hdl_module_name {frame_buffer_mgr} -hdl_file {hdl\frame_buffer_mgr.vhd} -instance_name {frame_buffer_mgr_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {frame_buffer_mgr_0:swap_new_frame_o}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {frame_buffer_mgr_0:frame_base_addr_i} -value {0111}



# Add frame_buffer_mgr_1 instance
sd_instantiate_hdl_module -sd_name ${sd_name} -hdl_module_name {frame_buffer_mgr} -hdl_file {hdl\frame_buffer_mgr.vhd} -instance_name {frame_buffer_mgr_1}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {frame_buffer_mgr_1:swap_new_frame_o}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {frame_buffer_mgr_1:frame_base_addr_i} -value {0111}



# Add hdmi_rx_ss_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {hdmi_rx_ss} -instance_name {hdmi_rx_ss_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {hdmi_rx_ss_0:display_frame_addr_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {hdmi_rx_ss_0:processing_frame_addr_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {hdmi_rx_ss_0:processing_next_frame_addr_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {hdmi_rx_ss_0:processing_next_next_frame_addr_o}



# Add image_enhance_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {image_enhance} -instance_name {image_enhance_0}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {image_enhance_0:ENABLE_I} -value {VCC}



# Add IMX334_IF_TOP_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {IMX334_IF_TOP} -instance_name {IMX334_IF_TOP_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {IMX334_IF_TOP_0:c1_frame_valid_o}



# Add PF_CCC_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {PF_CCC_C0} -instance_name {PF_CCC_C0_0}



# Add PF_CCC_C1_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {PF_CCC_C1} -instance_name {PF_CCC_C1_0}



# Add PF_DDR4_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {PF_DDR4_C0} -instance_name {PF_DDR4_C0_0}



# Add PF_INIT_MONITOR_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {PF_INIT_MONITOR_C0} -instance_name {PF_INIT_MONITOR_C0_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_INIT_MONITOR_C0_0:FABRIC_POR_N}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_INIT_MONITOR_C0_0:PCIE_INIT_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_INIT_MONITOR_C0_0:USRAM_INIT_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_INIT_MONITOR_C0_0:SRAM_INIT_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_INIT_MONITOR_C0_0:XCVR_INIT_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_INIT_MONITOR_C0_0:USRAM_INIT_FROM_SNVM_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_INIT_MONITOR_C0_0:USRAM_INIT_FROM_UPROM_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_INIT_MONITOR_C0_0:USRAM_INIT_FROM_SPI_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_INIT_MONITOR_C0_0:SRAM_INIT_FROM_SNVM_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_INIT_MONITOR_C0_0:SRAM_INIT_FROM_UPROM_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_INIT_MONITOR_C0_0:SRAM_INIT_FROM_SPI_DONE}



# Add PF_IO_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {PF_IO_C0} -instance_name {PF_IO_C0_0}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {PF_IO_C0_0:DF} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {PF_IO_C0_0:DR} -value {VCC}



# Add PROC_SUBSYSTEM_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {PROC_SUBSYSTEM} -instance_name {PROC_SUBSYSTEM_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PROC_SUBSYSTEM_0:HDMI_RST}



# Add pulse_extend_0 instance
sd_instantiate_hdl_module -sd_name ${sd_name} -hdl_module_name {pulse_extend} -hdl_file {hdl\pulse_extend.sv} -instance_name {pulse_extend_0}



# Add vector_mux_0 instance
sd_instantiate_hdl_core -sd_name ${sd_name} -hdl_core_name {vector_mux} -instance_name {vector_mux_0}
# Exporting Parameters of instance vector_mux_0
sd_configure_core_instance -sd_name ${sd_name} -instance_name {vector_mux_0} -params {\
"VEC_LENGTH:8" }\
-validate_rules 0
sd_save_core_instance_config -sd_name ${sd_name} -instance_name {vector_mux_0}
sd_update_instance -sd_name ${sd_name} -instance_name {vector_mux_0}



# Add vector_mux_1 instance
sd_instantiate_hdl_core -sd_name ${sd_name} -hdl_core_name {vector_mux} -instance_name {vector_mux_1}
# Exporting Parameters of instance vector_mux_1
sd_configure_core_instance -sd_name ${sd_name} -instance_name {vector_mux_1} -params {\
"VEC_LENGTH:32" }\
-validate_rules 0
sd_save_core_instance_config -sd_name ${sd_name} -instance_name {vector_mux_1}
sd_update_instance -sd_name ${sd_name} -instance_name {vector_mux_1}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {vector_mux_1:in_vec0} -pin_slices {[23:0]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {vector_mux_1:in_vec0[23:0]} -value {GND}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {vector_mux_1:in_vec0} -pin_slices {[31:24]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {vector_mux_1:in_vec1} -pin_slices {[23:0]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {vector_mux_1:in_vec1[23:0]} -value {GND}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {vector_mux_1:in_vec1} -pin_slices {[31:24]}



# Add vector_mux_2 instance
sd_instantiate_hdl_core -sd_name ${sd_name} -hdl_core_name {vector_mux} -instance_name {vector_mux_2}
# Exporting Parameters of instance vector_mux_2
sd_configure_core_instance -sd_name ${sd_name} -instance_name {vector_mux_2} -params {\
"VEC_LENGTH:32" }\
-validate_rules 0
sd_save_core_instance_config -sd_name ${sd_name} -instance_name {vector_mux_2}
sd_update_instance -sd_name ${sd_name} -instance_name {vector_mux_2}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {vector_mux_2:in_vec0} -pin_slices {[23:0]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {vector_mux_2:in_vec0[23:0]} -value {GND}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {vector_mux_2:in_vec0} -pin_slices {[31:24]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {vector_mux_2:in_vec1} -pin_slices {[23:0]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {vector_mux_2:in_vec1[23:0]} -value {GND}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {vector_mux_2:in_vec1} -pin_slices {[31:24]}



# Add scalar net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"ACT_N" "PF_DDR4_C0_0:ACT_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:A" "AND4_1:Y" "CORERESET_PF_C1_2:PLL_LOCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:B" "AND4_0:Y" "CORERESET_PF_C1_0:PLL_LOCK" "CORERESET_PF_C1_1:PLL_LOCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:Y" "CORERESET_PF_C1_3:PLL_LOCK" "CORERESET_PF_C1_4:PLL_LOCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_2:A" "pulse_extend_0:sync_out" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_2:B" "AND2_2_0:B" "HPD_I" "PROC_SUBSYSTEM_0:CAM_SEL" "hdmi_rx_ss_0:HPD_I" "vector_mux_0:sel" "vector_mux_1:sel" "vector_mux_2:sel" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_2:Y" "ddr_dma_write_bif_0:target_frame_sync_i" "frame_buffer_mgr_0:vid_frame_sync_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_2_0:A" "image_enhance_0:DATA_VALID_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_2_0:Y" "ddr_dma_write_bif_0:target_data_valid_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND4_0:A" "AND4_1:B" "PF_CCC_C0_0:PLL_LOCK_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND4_0:B" "PF_DDR4_C0_0:PLL_LOCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND4_0:C" "DDR_AXI4_ARBITER_PF_C0_0:ddr_ctrl_ready_i" "PF_DDR4_C0_0:CTRLR_READY" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND4_0:D" "PF_CCC_C1_0:PLL_LOCK_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND4_1:A" "PF_INIT_MONITOR_C0_0:DEVICE_INIT_DONE" "hdmi_rx_ss_0:RESET_N_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND4_1:C" "PF_INIT_MONITOR_C0_0:BANK_0_CALIB_STATUS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND4_1:D" "PF_INIT_MONITOR_C0_0:BANK_7_CALIB_STATUS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BG" "PF_DDR4_C0_0:BG" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:DATA_VALID_I" "IMX334_IF_TOP_0:c1_line_valid_o" "line_valid_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:EOF_I" "IMX334_IF_TOP_0:c1_frame_start_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:EOF_O" "pulse_extend_0:sync_in" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:RESETN_I" "IMX334_IF_TOP_0:CAMCLK_RESET_N" "ddr_dma_write_bif_0:resetn" "frame_buffer_mgr_0:vid_resetn_i" "image_enhance_0:RESETN_I" "pulse_extend_0:resetn" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:RGB_VALID_O" "image_enhance_0:DATA_VALID_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:SYS_CLK_I" "IMX334_IF_TOP_0:PARALLEL_CLOCK" "ddr_dma_write_bif_0:clk" "frame_buffer_mgr_0:vid_clk_i" "image_enhance_0:SYS_CLK_I" "pulse_extend_0:clk" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CAM1_RST" "PROC_SUBSYSTEM_0:CAM1_RST" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CAM1_RX_CLK_N" "IMX334_IF_TOP_0:CAM1_RX_CLK_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CAM1_RX_CLK_P" "IMX334_IF_TOP_0:CAM1_RX_CLK_P" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CAM1_SCL" "PROC_SUBSYSTEM_0:CAM1_SCL" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CAM1_SDA" "PROC_SUBSYSTEM_0:CAM1_SDA" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CAM2_RST" "PROC_SUBSYSTEM_0:CAM2_RST" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CAM2_SCL" "PROC_SUBSYSTEM_0:CAM2_SCL" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CAM2_SDA" "PROC_SUBSYSTEM_0:CAM2_SDA" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CAMERA_CLK" "IMX334_IF_TOP_0:CAMERA_CLK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CAM_CLK_EN" "PROC_SUBSYSTEM_0:GPIO_OUT" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CAS_N" "PF_DDR4_C0_0:CAS_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CK0" "PF_DDR4_C0_0:CK0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CK0_N" "PF_DDR4_C0_0:CK0_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CKE" "PF_DDR4_C0_0:CKE" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLK" "PROC_SUBSYSTEM_0:CLK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLK_IN" "PF_CCC_C0_0:REF_CLK_0" "hdmi_rx_ss_0:REF_CLK_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_PF_C1_0:CLK" "DDR_AXI4_ARBITER_PF_C0_0:sys_clk_i" "DDR_Read_C0_0:ddr_clk_i" "PF_CCC_C1_0:REF_CLK_0" "PF_DDR4_C0_0:SYS_CLK" "PROC_SUBSYSTEM_0:ACLK" "axi_arbiter_0:clk" "ddr_dma_write_bif_0:aclk" "frame_buffer_mgr_0:ddr_clk_i" "frame_buffer_mgr_1:ddr_clk_i" "hdmi_rx_ss_0:ddr_clk_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_PF_C1_0:FABRIC_RESET_N" "DDR_AXI4_ARBITER_PF_C0_0:reset_i" "DDR_Read_C0_0:reset_i" "PROC_SUBSYSTEM_0:ARESETN" "axi_arbiter_0:resetn" "ddr_dma_write_bif_0:aresetn" "frame_buffer_mgr_0:ddr_resetn_i" "frame_buffer_mgr_1:ddr_resetn_i" "hdmi_rx_ss_0:reset_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_PF_C1_1:CLK" "DDR_Read_C0_0:pixel_clk_i" "Display_Controller_C0_0:SYS_CLK_I" "PF_CCC_C1_0:OUT1_FABCLK_0" "PF_IO_C0_0:TX_CLK" "ff_bus_0:clk" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_PF_C1_1:FABRIC_RESET_N" "Display_Controller_C0_0:RESETN_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_PF_C1_2:CLK" "CORERESET_PF_C1_3:CLK" "PF_CCC_C0_0:OUT2_FABCLK_0" "PF_DDR4_C0_0:PLL_REF_CLK" "PROC_SUBSYSTEM_0:PCLK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_PF_C1_2:FABRIC_RESET_N" "PF_DDR4_C0_0:SYS_RESET_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_PF_C1_3:FABRIC_RESET_N" "PROC_SUBSYSTEM_0:PRESETN" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_PF_C1_4:CLK" "PF_CCC_C0_0:OUT1_FABCLK_0" "PROC_SUBSYSTEM_0:vbx_clk" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_PF_C1_4:FABRIC_RESET_N" "PROC_SUBSYSTEM_0:vbx_resetn" "hdmi_rx_ss_0:RESET_N_I_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CS_N" "PF_DDR4_C0_0:CS_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_C0_0:data_valid_o" "Display_Controller_C0_0:EXT_SYNC_SIGNAL_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_C0_0:frame_start_i" "Display_Controller_C0_0:FRAME_END_O" "frame_buffer_mgr_0:disp_frame_end_i" "frame_buffer_mgr_1:disp_frame_end_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_C0_0:read_en_i" "Display_Controller_C0_0:DATA_TRIGGER_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DI" "PROC_SUBSYSTEM_0:DI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DO" "PROC_SUBSYSTEM_0:DO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Display_Controller_C0_0:DATA_ENABLE_O" "ff_bus_0:bus_in[26:26]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Display_Controller_C0_0:H_SYNC_O" "ff_bus_0:bus_in[24:24]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Display_Controller_C0_0:V_SYNC_O" "ff_bus_0:bus_in[25:25]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"FLASH" "PROC_SUBSYSTEM_0:FLASH" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HDMI_SCL" "PROC_SUBSYSTEM_0:HDMI_SCL" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HDMI_SDA" "PROC_SUBSYSTEM_0:HDMI_SDA" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HPD_O" "hdmi_rx_ss_0:HPD_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"IFACE" "PROC_SUBSYSTEM_0:IFACE" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"IMX334_IF_TOP_0:ARST_N" "IMX334_IF_TOP_0:INIT_DONE" "PF_INIT_MONITOR_C0_0:AUTOCALIB_DONE" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"IMX334_IF_TOP_0:TRNG_RST_N" "PROC_SUBSYSTEM_0:TRNG_RST_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"LANE0_RXD_N" "hdmi_rx_ss_0:LANE0_RXD_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"LANE0_RXD_P" "hdmi_rx_ss_0:LANE0_RXD_P" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"LANE1_RXD_N" "hdmi_rx_ss_0:LANE1_RXD_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"LANE1_RXD_P" "hdmi_rx_ss_0:LANE1_RXD_P" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"LANE2_RXD_N" "hdmi_rx_ss_0:LANE2_RXD_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"LANE2_RXD_P" "hdmi_rx_ss_0:LANE2_RXD_P" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ODT" "PF_DDR4_C0_0:ODT" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_CCC_C0_0:OUT0_FABCLK_0" "PROC_SUBSYSTEM_0:vbx_clk_2x" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_DDR4_C0_0:RAS_N" "RAS_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_DDR4_C0_0:RESET_N" "RESET_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_DDR4_C0_0:SHIELD0" "SHIELD0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_DDR4_C0_0:SHIELD1" "SHIELD1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_DDR4_C0_0:SHIELD2" "SHIELD2" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_DDR4_C0_0:SHIELD3" "SHIELD3" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_DDR4_C0_0:SHIELD4" "SHIELD4" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_DDR4_C0_0:SHIELD5" "SHIELD5" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_DDR4_C0_0:SHIELD6" "SHIELD6" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_DDR4_C0_0:SHIELD7" "SHIELD7" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_DDR4_C0_0:WE_N" "WE_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_IO_C0_0:PADO" "hdmi_clk" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PROC_SUBSYSTEM_0:APB_CLK" "apb3_if_0:pclk_i" "frame_buffer_mgr_0:mgt_clk_i" "frame_buffer_mgr_1:mgt_clk_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PROC_SUBSYSTEM_0:APB_Reset" "apb3_if_0:preset_i" "frame_buffer_mgr_0:mgt_resetn_i" "frame_buffer_mgr_1:mgt_resetn_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PROC_SUBSYSTEM_0:SS" "SS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PROC_SUBSYSTEM_0:SW1" "SW1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PROC_SUBSYSTEM_0:SW2" "SW2" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PROC_SUBSYSTEM_0:SW3" "SW3" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PROC_SUBSYSTEM_0:SW4" "SW4" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PROC_SUBSYSTEM_0:SW5" "SW5" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PROC_SUBSYSTEM_0:SW6" "SW6" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PROC_SUBSYSTEM_0:TCK" "TCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PROC_SUBSYSTEM_0:TDI" "TDI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PROC_SUBSYSTEM_0:TDO" "TDO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PROC_SUBSYSTEM_0:TMS" "TMS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PROC_SUBSYSTEM_0:TRSTB" "TRSTB" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PROC_SUBSYSTEM_0:TX" "TX" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"REF_CLK_PAD_N" "hdmi_rx_ss_0:REF_CLK_PAD_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"REF_CLK_PAD_P" "hdmi_rx_ss_0:REF_CLK_PAD_P" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"SCL_hdmi_rx" "hdmi_rx_ss_0:SCL_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"SDA_hdmi_rx" "hdmi_rx_ss_0:SDA_hdmi_rx" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:SWAP_SAVED_FB_O" "frame_buffer_mgr_0:swap_toggle_i" "frame_buffer_mgr_1:swap_toggle_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"data_enable_o" "ff_bus_0:bus_out[26:26]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ff_bus_0:bus_out[24:24]" "horz_sync_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ff_bus_0:bus_out[25:25]" "vert_sync_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"frame_buffer_mgr_1:vid_clk_i" "hdmi_rx_ss_0:vid_clk" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"frame_buffer_mgr_1:vid_frame_sync_i" "hdmi_rx_ss_0:vid_frame_sync" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"frame_buffer_mgr_1:vid_resetn_i" "hdmi_rx_ss_0:vid_resetn" }

# Add bus net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"A" "PF_DDR4_C0_0:A" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BA" "PF_DDR4_C0_0:BA" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"B_out_o" "ff_bus_0:bus_out[7:0]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:B_O[15:8]" "image_enhance_0:B_I_1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:B_O[23:16]" "image_enhance_0:B_I_2" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:B_O[31:24]" "image_enhance_0:B_I_3" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:B_O[7:0]" "image_enhance_0:B_I_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:DATA_I" "IMX334_IF_TOP_0:c1_data_out_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:G_O[15:8]" "image_enhance_0:G_I_1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:G_O[23:16]" "image_enhance_0:G_I_2" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:G_O[31:24]" "image_enhance_0:G_I_3" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:G_O[7:0]" "image_enhance_0:G_I_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:R_O[15:8]" "image_enhance_0:R_I_1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:R_O[23:16]" "image_enhance_0:R_I_2" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:R_O[31:24]" "image_enhance_0:R_I_3" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:R_O[7:0]" "image_enhance_0:R_I_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CAM1_RXD" "IMX334_IF_TOP_0:CAM1_RXD" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CAM1_RXD_N" "IMX334_IF_TOP_0:CAM1_RXD_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_C0_0:data_o[15:8]" "ff_bus_0:bus_in[15:8]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_C0_0:data_o[23:16]" "ff_bus_0:bus_in[23:16]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_C0_0:data_o[7:0]" "ff_bus_0:bus_in[7:0]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_C0_0:frame_start_addr_i" "vector_mux_0:out_vec" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_C0_0:horz_resl_i" "Display_Controller_C0_0:H_RES_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DM_N" "PF_DDR4_C0_0:DM_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DQ" "PF_DDR4_C0_0:DQ" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DQS" "PF_DDR4_C0_0:DQS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DQS_N" "PF_DDR4_C0_0:DQS_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"GPIO_OUT_0" "PROC_SUBSYSTEM_0:GPIO_OUT_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"G_out_o" "ff_bus_0:bus_out[15:8]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"R_out_o" "ff_bus_0:bus_out[23:16]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:BLU_MEAN_I" "image_enhance_0:blue_mean_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:BLU_VAR_I" "image_enhance_0:blue_var_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:GRN_MEAN_I" "image_enhance_0:green_mean_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:GRN_VAR_I" "image_enhance_0:green_var_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:PROCESSING_FB_ADDR_I" "vector_mux_2:out_vec" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:PROCESSING_NEXT_FB_ADDR_I" "apb3_if_0:PROCESSING_NEXT_NEXT_FB_ADDR_I" "vector_mux_1:out_vec" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:RED_MEAN_I" "image_enhance_0:red_mean_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:RED_VAR_I" "image_enhance_0:red_var_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:bconst_o" "image_enhance_0:B_CONST_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:gconst_o" "image_enhance_0:G_CONST_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:rconst_o" "image_enhance_0:R_CONST_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:second_const_o" "image_enhance_0:COMMON_CONST_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_dma_write_bif_0:config_frame_address_i[31:24]" "frame_buffer_mgr_0:vid_write_addr_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_dma_write_bif_0:target_data_i[103:96]" "image_enhance_0:B_O_3" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_dma_write_bif_0:target_data_i[111:104]" "image_enhance_0:G_O_3" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_dma_write_bif_0:target_data_i[119:112]" "image_enhance_0:R_O_3" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_dma_write_bif_0:target_data_i[15:8]" "image_enhance_0:G_O_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_dma_write_bif_0:target_data_i[23:16]" "image_enhance_0:R_O_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_dma_write_bif_0:target_data_i[39:32]" "image_enhance_0:B_O_1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_dma_write_bif_0:target_data_i[47:40]" "image_enhance_0:G_O_1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_dma_write_bif_0:target_data_i[55:48]" "image_enhance_0:R_O_1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_dma_write_bif_0:target_data_i[71:64]" "image_enhance_0:B_O_2" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_dma_write_bif_0:target_data_i[79:72]" "image_enhance_0:G_O_2" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_dma_write_bif_0:target_data_i[7:0]" "image_enhance_0:B_O_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_dma_write_bif_0:target_data_i[87:80]" "image_enhance_0:R_O_2" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"frame_buffer_mgr_0:disp_read_addr_o" "vector_mux_0:in_vec1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"frame_buffer_mgr_0:process_frame_addr_o" "vector_mux_2:in_vec1[31:24]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"frame_buffer_mgr_0:process_next_addr_o" "vector_mux_1:in_vec1[31:24]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"frame_buffer_mgr_1:disp_read_addr_o" "vector_mux_0:in_vec0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"frame_buffer_mgr_1:process_frame_addr_o" "vector_mux_2:in_vec0[31:24]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"frame_buffer_mgr_1:process_next_addr_o" "vector_mux_1:in_vec0[31:24]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"frame_buffer_mgr_1:vid_write_addr_o" "hdmi_rx_ss_0:config_frame_address_i" }

# Add bus interface net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:MASTER_AXI4" "axi_arbiter_0:rt" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:Read_channel_0" "DDR_Read_C0_0:Read_channel" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:Write_channel_0" "ddr_dma_write_bif_0:Write_Channel" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:Write_channel_1" "hdmi_rx_ss_0:Write_Channel" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_DDR4_C0_0:AXI4slave0" "axi_arbiter_0:BIF_3" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PROC_SUBSYSTEM_0:APBmslave9" "apb3_if_0:APB_IF" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PROC_SUBSYSTEM_0:AXI4mslave2_0" "axi_arbiter_0:be" }

# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Save the SmartDesign 
save_smartdesign -sd_name ${sd_name}
# Generate SmartDesign "VIDEO_KIT_TOP"
generate_component -component_name ${sd_name}
