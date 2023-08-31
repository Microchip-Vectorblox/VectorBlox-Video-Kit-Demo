# Creating SmartDesign VIDEO_KIT_TOP
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
sd_create_scalar_port -sd_name ${sd_name} -port_name {TDO} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TX} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {WE_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {data_enable_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {hdmi_clk} -port_direction {OUT}
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
sd_create_bus_port -sd_name ${sd_name} -port_name {DM_N} -port_direction {OUT} -port_range {[3:0]} -port_is_pad {1}
sd_create_bus_port -sd_name ${sd_name} -port_name {GPIO_OUT_0} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {G_out_o} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {R_out_o} -port_direction {OUT} -port_range {[7:0]}

sd_create_bus_port -sd_name ${sd_name} -port_name {DQS_N} -port_direction {INOUT} -port_range {[3:0]} -port_is_pad {1}
sd_create_bus_port -sd_name ${sd_name} -port_name {DQS} -port_direction {INOUT} -port_range {[3:0]} -port_is_pad {1}
sd_create_bus_port -sd_name ${sd_name} -port_name {DQ} -port_direction {INOUT} -port_range {[31:0]} -port_is_pad {1}

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
"DATA_WIDTH:256" \
"S_ID_WIDTH:5" }\
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
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Bayer_Interpolation_C0_0:BAYER_FORMAT} -value {10}



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



# Add DDR_Read_Camera instance
sd_instantiate_component -sd_name ${sd_name} -component_name {DDR_Read} -instance_name {DDR_Read_Camera}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {DDR_Read_Camera:frame_start_addr_i} -pin_slices {[23:0]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {DDR_Read_Camera:frame_start_addr_i[23:0]} -value {GND}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {DDR_Read_Camera:frame_start_addr_i} -pin_slices {[31:24]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {DDR_Read_Camera:data_o} -pin_slices {[15:8]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {DDR_Read_Camera:data_o} -pin_slices {[23:16]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {DDR_Read_Camera:data_o} -pin_slices {[31:24]}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {DDR_Read_Camera:data_o[31:24]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {DDR_Read_Camera:data_o} -pin_slices {[7:0]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {DDR_Read_Camera:line_gap_i} -value {0010000000000000}



# Add DDR_Write_Camera instance
sd_instantiate_component -sd_name ${sd_name} -component_name {DDR_Write} -instance_name {DDR_Write_Camera}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {DDR_Write_Camera:data_i} -pin_slices {[119:96]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {DDR_Write_Camera:data_i} -pin_slices {[127:120]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {DDR_Write_Camera:data_i[127:120]} -value {GND}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {DDR_Write_Camera:data_i} -pin_slices {[23:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {DDR_Write_Camera:data_i} -pin_slices {[31:24]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {DDR_Write_Camera:data_i[31:24]} -value {GND}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {DDR_Write_Camera:data_i} -pin_slices {[55:32]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {DDR_Write_Camera:data_i} -pin_slices {[63:56]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {DDR_Write_Camera:data_i[63:56]} -value {GND}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {DDR_Write_Camera:data_i} -pin_slices {[87:64]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {DDR_Write_Camera:data_i} -pin_slices {[95:88]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {DDR_Write_Camera:data_i[95:88]} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {DDR_Write_Camera:frame_ddr_addr_i} -value {01110000}



# Add Display_Controller_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {Display_Controller_C0} -instance_name {Display_Controller_C0_0}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Display_Controller_C0_0:ENABLE_I} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Display_Controller_C0_0:ENABLE_EXT_SYNC_I} -value {VCC}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {Display_Controller_C0_0:H_ACTIVE_O}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {Display_Controller_C0_0:V_ACTIVE_O}



# Add ff_bus_0 instance
sd_instantiate_hdl_core -sd_name ${sd_name} -hdl_core_name {ff_bus} -instance_name {ff_bus_0}
# Exporting Parameters of instance ff_bus_0
sd_configure_core_instance -sd_name ${sd_name} -instance_name {ff_bus_0} -params {\
"BUS_WIDTH:28" }\
-validate_rules 0
sd_save_core_instance_config -sd_name ${sd_name} -instance_name {ff_bus_0}
sd_update_instance -sd_name ${sd_name} -instance_name {ff_bus_0}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_in} -pin_slices {[15:8]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_in} -pin_slices {[23:16]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_in} -pin_slices {[24:24]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_in} -pin_slices {[25:25]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_in} -pin_slices {[26:26]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_in} -pin_slices {[27:27]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_in} -pin_slices {[7:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_out} -pin_slices {[15:8]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_out} -pin_slices {[23:16]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_out} -pin_slices {[24:24]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_out} -pin_slices {[25:25]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_out} -pin_slices {[26:26]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_out} -pin_slices {[27:27]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {ff_bus_0:bus_out} -pin_slices {[7:0]}



# Add hdmi_rx_ss_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {hdmi_rx_ss} -instance_name {hdmi_rx_ss_0}



# Add image_enhance_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {image_enhance} -instance_name {image_enhance_0}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {image_enhance_0:DATA_I} -pin_slices {[15:8]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {image_enhance_0:DATA_I} -pin_slices {[23:16]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {image_enhance_0:DATA_I} -pin_slices {[31:24]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {image_enhance_0:DATA_I} -pin_slices {[39:32]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {image_enhance_0:DATA_I} -pin_slices {[47:40]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {image_enhance_0:DATA_I} -pin_slices {[55:48]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {image_enhance_0:DATA_I} -pin_slices {[63:56]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {image_enhance_0:DATA_I} -pin_slices {[71:64]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {image_enhance_0:DATA_I} -pin_slices {[79:72]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {image_enhance_0:DATA_I} -pin_slices {[7:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {image_enhance_0:DATA_I} -pin_slices {[87:80]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {image_enhance_0:DATA_I} -pin_slices {[95:88]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {image_enhance_0:DATA_O} -pin_slices {[23:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {image_enhance_0:DATA_O} -pin_slices {[47:24]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {image_enhance_0:DATA_O} -pin_slices {[71:48]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {image_enhance_0:DATA_O} -pin_slices {[95:72]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {image_enhance_0:ENABLE_I} -value {VCC}



# Add IMX334_IF_TOP_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {IMX334_IF_TOP} -instance_name {IMX334_IF_TOP_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {IMX334_IF_TOP_0:c1_frame_start_o}



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



# Add PROC_SUBSYSTEM_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {PROC_SUBSYSTEM} -instance_name {PROC_SUBSYSTEM_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PROC_SUBSYSTEM_0:HDMI_RST}



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



# Add vector_mux_2 instance
sd_instantiate_hdl_core -sd_name ${sd_name} -hdl_core_name {vector_mux} -instance_name {vector_mux_2}
# Exporting Parameters of instance vector_mux_2
sd_configure_core_instance -sd_name ${sd_name} -instance_name {vector_mux_2} -params {\
"VEC_LENGTH:32" }\
-validate_rules 0
sd_save_core_instance_config -sd_name ${sd_name} -instance_name {vector_mux_2}
sd_update_instance -sd_name ${sd_name} -instance_name {vector_mux_2}



# Add vector_mux_3 instance
sd_instantiate_hdl_core -sd_name ${sd_name} -hdl_core_name {vector_mux} -instance_name {vector_mux_3}
# Exporting Parameters of instance vector_mux_3
sd_configure_core_instance -sd_name ${sd_name} -instance_name {vector_mux_3} -params {\
"VEC_LENGTH:32" }\
-validate_rules 0
sd_save_core_instance_config -sd_name ${sd_name} -instance_name {vector_mux_3}
sd_update_instance -sd_name ${sd_name} -instance_name {vector_mux_3}



# Add Video_arbiter_top_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {Video_arbiter_top} -instance_name {Video_arbiter_top_0}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:r1_req_i} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:r2_req_i} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:r3_req_i} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:w2_data_valid_i} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:w2_req_i} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:w3_data_valid_i} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:w3_req_i} -value {GND}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:r1_ack_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:r1_data_valid_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:r1_done_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:r2_ack_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:r2_data_valid_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:r2_done_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:r3_ack_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:r3_data_valid_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:r3_done_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:w2_ack_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:w2_done_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:w3_ack_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:w3_done_o}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:r1_burst_size_i} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:r1_rstart_addr_i} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:r2_burst_size_i} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:r2_rstart_addr_i} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:r3_burst_size_i} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:r3_rstart_addr_i} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:w2_burst_size_i} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:w2_data_i} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:w2_wstart_addr_i} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:w3_burst_size_i} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:w3_data_i} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {Video_arbiter_top_0:w3_wstart_addr_i} -value {GND}



# Add scalar net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"ACT_N" "PF_DDR4_C0_0:ACT_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:A" "AND4_1:Y" "CORERESET_PF_C1_2:PLL_LOCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:B" "AND4_0:Y" "CORERESET_PF_C1_0:PLL_LOCK" "CORERESET_PF_C1_1:PLL_LOCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:Y" "CORERESET_PF_C1_3:PLL_LOCK" "CORERESET_PF_C1_4:PLL_LOCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_2:A" "IMX334_IF_TOP_0:c1_frame_valid_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_2:B" "AND2_2_0:B" "HPD_I" "PROC_SUBSYSTEM_0:CAM_SEL" "hdmi_rx_ss_0:HPD_I" "vector_mux_0:sel" "vector_mux_1:sel" "vector_mux_2:sel" "vector_mux_3:sel" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_2:Y" "DDR_Write_Camera:frame_valid_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_2_0:A" "image_enhance_0:DATA_VALID_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_2_0:Y" "DDR_Write_Camera:data_valid_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND4_0:A" "AND4_1:B" "PF_CCC_C0_0:PLL_LOCK_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND4_0:B" "PF_DDR4_C0_0:PLL_LOCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND4_0:C" "PF_DDR4_C0_0:CTRLR_READY" "Video_arbiter_top_0:ddr_ctrl_ready" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND4_0:D" "PF_CCC_C1_0:PLL_LOCK_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND4_1:A" "PF_INIT_MONITOR_C0_0:DEVICE_INIT_DONE" "hdmi_rx_ss_0:RESET_N_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND4_1:C" "PF_INIT_MONITOR_C0_0:BANK_0_CALIB_STATUS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND4_1:D" "PF_INIT_MONITOR_C0_0:BANK_7_CALIB_STATUS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BG" "PF_DDR4_C0_0:BG" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:DATA_VALID_I" "IMX334_IF_TOP_0:c1_line_valid_o" "line_valid_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:EOF_I" "IMX334_IF_TOP_0:frame_end_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:EOF_O" "image_enhance_0:eof_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:RESETN_I" "DDR_Write_Camera:reset_i" "IMX334_IF_TOP_0:CAMCLK_RESET_N" "image_enhance_0:RESETN_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:RGB_VALID_O" "image_enhance_0:DATA_VALID_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:SYS_CLK_I" "DDR_Write_Camera:parallel_clk_i" "IMX334_IF_TOP_0:PARALLEL_CLOCK" "image_enhance_0:SYS_CLK_I" }
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
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_PF_C1_0:CLK" "DDR_Read_Camera:sys_clk_i" "DDR_Write_Camera:ddr_clock_i" "PF_CCC_C1_0:REF_CLK_0" "PF_DDR4_C0_0:SYS_CLK" "PROC_SUBSYSTEM_0:ACLK" "Video_arbiter_top_0:sys_clk_i" "axi_arbiter_0:clk" "hdmi_rx_ss_0:ddr_clk_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_PF_C1_0:FABRIC_RESET_N" "DDR_Read_Camera:reset_i" "PROC_SUBSYSTEM_0:ARESETN" "Video_arbiter_top_0:reset_i" "axi_arbiter_0:resetn" "hdmi_rx_ss_0:reset_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_PF_C1_1:CLK" "DDR_Read_Camera:disp_clk_i" "Display_Controller_C0_0:SYS_CLK_I" "PF_CCC_C1_0:OUT1_FABCLK_0" "ff_bus_0:bus_in[27:27]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_PF_C1_1:FABRIC_RESET_N" "Display_Controller_C0_0:RESETN_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_PF_C1_2:CLK" "CORERESET_PF_C1_3:CLK" "PF_CCC_C0_0:OUT2_FABCLK_0" "PF_DDR4_C0_0:PLL_REF_CLK" "PROC_SUBSYSTEM_0:PCLK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_PF_C1_2:FABRIC_RESET_N" "PF_DDR4_C0_0:SYS_RESET_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_PF_C1_3:FABRIC_RESET_N" "PROC_SUBSYSTEM_0:PRESETN" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_PF_C1_4:CLK" "PF_CCC_C0_0:OUT1_FABCLK_0" "PROC_SUBSYSTEM_0:vbx_clk" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_PF_C1_4:FABRIC_RESET_N" "PROC_SUBSYSTEM_0:vbx_resetn" "hdmi_rx_ss_0:RESET_N_I_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CS_N" "PF_DDR4_C0_0:CS_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_Camera:data_valid_o" "Display_Controller_C0_0:EXT_SYNC_SIGNAL_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_Camera:ddr_data_valid_i" "Video_arbiter_top_0:r0_data_valid_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_Camera:frame_end_i" "Display_Controller_C0_0:FRAME_END_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_Camera:read_ackn_i" "Video_arbiter_top_0:r0_ack_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_Camera:read_done_i" "Video_arbiter_top_0:r0_done_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_Camera:read_en_i" "Display_Controller_C0_0:DATA_TRIGGER_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_Camera:read_req_o" "Video_arbiter_top_0:r0_req_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_Camera:rdata_rdy_o" "Video_arbiter_top_0:w0_data_valid_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_Camera:save_frame_i" "apb3_if_0:SWAP_SAVED_FB_O" "hdmi_rx_ss_0:save_frame_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_Camera:write_ackn_i" "Video_arbiter_top_0:w0_ack_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_Camera:write_done_i" "Video_arbiter_top_0:w0_done_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_Camera:write_req_o" "Video_arbiter_top_0:w0_req_i" }
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
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_CCC_C1_0:OUT0_FABCLK_0" "ff_bus_0:clk" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_DDR4_C0_0:RAS_N" "RAS_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_DDR4_C0_0:RESET_N" "RESET_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_DDR4_C0_0:SHIELD0" "SHIELD0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_DDR4_C0_0:SHIELD1" "SHIELD1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_DDR4_C0_0:SHIELD2" "SHIELD2" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_DDR4_C0_0:SHIELD3" "SHIELD3" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_DDR4_C0_0:WE_N" "WE_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PROC_SUBSYSTEM_0:APB_CLK" "apb3_if_0:pclk_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PROC_SUBSYSTEM_0:APB_Reset" "apb3_if_0:preset_i" }
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
sd_connect_pins -sd_name ${sd_name} -pin_names {"Video_arbiter_top_0:w1_ack_o" "hdmi_rx_ss_0:write_ackn_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Video_arbiter_top_0:w1_data_valid_i" "hdmi_rx_ss_0:rdata_rdy_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Video_arbiter_top_0:w1_done_o" "hdmi_rx_ss_0:write_done_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Video_arbiter_top_0:w1_req_i" "hdmi_rx_ss_0:write_req_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"data_enable_o" "ff_bus_0:bus_out[26:26]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ff_bus_0:bus_out[24:24]" "horz_sync_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ff_bus_0:bus_out[25:25]" "vert_sync_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ff_bus_0:bus_out[27:27]" "hdmi_clk" }

# Add bus net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"A" "PF_DDR4_C0_0:A" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BA" "PF_DDR4_C0_0:BA" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"B_out_o" "ff_bus_0:bus_out[7:0]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:B_O[15:8]" "image_enhance_0:DATA_I[31:24]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:B_O[23:16]" "image_enhance_0:DATA_I[55:48]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:B_O[31:24]" "image_enhance_0:DATA_I[79:72]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:B_O[7:0]" "image_enhance_0:DATA_I[7:0]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:DATA_I" "IMX334_IF_TOP_0:c1_data_out_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:G_O[15:8]" "image_enhance_0:DATA_I[39:32]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:G_O[23:16]" "image_enhance_0:DATA_I[63:56]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:G_O[31:24]" "image_enhance_0:DATA_I[87:80]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:G_O[7:0]" "image_enhance_0:DATA_I[15:8]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:R_O[15:8]" "image_enhance_0:DATA_I[47:40]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:R_O[23:16]" "image_enhance_0:DATA_I[71:64]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:R_O[31:24]" "image_enhance_0:DATA_I[95:88]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C0_0:R_O[7:0]" "image_enhance_0:DATA_I[23:16]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CAM1_RXD" "IMX334_IF_TOP_0:CAM1_RXD" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CAM1_RXD_N" "IMX334_IF_TOP_0:CAM1_RXD_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_Camera:beats_to_read_o" "Video_arbiter_top_0:r0_burst_size_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_Camera:data_o[15:8]" "ff_bus_0:bus_in[15:8]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_Camera:data_o[23:16]" "ff_bus_0:bus_in[23:16]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_Camera:data_o[7:0]" "ff_bus_0:bus_in[7:0]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_Camera:frame_start_addr_i[31:24]" "vector_mux_0:out_vec" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_Camera:horz_resl_i" "Display_Controller_C0_0:H_RES_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_Camera:read_start_addr_o" "Video_arbiter_top_0:r0_rstart_addr_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_Camera:wdata_i" "Video_arbiter_top_0:rdata_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_Camera:beats_to_write_o" "Video_arbiter_top_0:w0_burst_size_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_Camera:data_i[119:96]" "image_enhance_0:DATA_O[95:72]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_Camera:data_i[23:0]" "image_enhance_0:DATA_O[23:0]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_Camera:data_i[55:32]" "image_enhance_0:DATA_O[47:24]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_Camera:data_i[87:64]" "image_enhance_0:DATA_O[71:48]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_Camera:display_frame_addr_o" "vector_mux_0:in_vec1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_Camera:process_frame_addr_o" "vector_mux_2:in_vec1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_Camera:process_next_next_frame_addr_o" "vector_mux_3:in_vec1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_Camera:process_next_frame_addr_o" "vector_mux_1:in_vec1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_Camera:rdata_o" "Video_arbiter_top_0:w0_data_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_Camera:write_start_addr_o" "Video_arbiter_top_0:w0_wstart_addr_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DM_N" "PF_DDR4_C0_0:DM_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DQ" "PF_DDR4_C0_0:DQ" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DQS" "PF_DDR4_C0_0:DQS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DQS_N" "PF_DDR4_C0_0:DQS_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"GPIO_OUT_0" "PROC_SUBSYSTEM_0:GPIO_OUT_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"G_out_o" "ff_bus_0:bus_out[15:8]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"R_out_o" "ff_bus_0:bus_out[23:16]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Video_arbiter_top_0:w1_burst_size_i" "hdmi_rx_ss_0:beats_to_write_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Video_arbiter_top_0:w1_data_i" "hdmi_rx_ss_0:rdata_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Video_arbiter_top_0:w1_wstart_addr_i" "hdmi_rx_ss_0:write_start_addr_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:BLU_MEAN_I" "image_enhance_0:blue_mean_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:BLU_VAR_I" "image_enhance_0:blue_var_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:GRN_MEAN_I" "image_enhance_0:green_mean_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:GRN_VAR_I" "image_enhance_0:green_var_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:PROCESSING_NEXT_NEXT_FB_ADDR_I" "vector_mux_3:out_vec" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:PROCESSING_FB_ADDR_I" "vector_mux_2:out_vec" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:PROCESSING_NEXT_FB_ADDR_I" "vector_mux_1:out_vec" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:RED_MEAN_I" "image_enhance_0:red_mean_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:RED_VAR_I" "image_enhance_0:red_var_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:bconst_o" "image_enhance_0:B_CONST_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:gconst_o" "image_enhance_0:G_CONST_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:rconst_o" "image_enhance_0:R_CONST_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb3_if_0:second_const_o" "image_enhance_0:COMMON_CONST_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"hdmi_rx_ss_0:display_frame_addr_o" "vector_mux_0:in_vec0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"hdmi_rx_ss_0:processing_next_next_frame_addr_o" "vector_mux_3:in_vec0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"hdmi_rx_ss_0:processing_frame_addr_o" "vector_mux_2:in_vec0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"hdmi_rx_ss_0:processing_next_frame_addr_o" "vector_mux_1:in_vec0" }

# Add bus interface net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_DDR4_C0_0:AXI4slave0" "axi_arbiter_0:BIF_3" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PROC_SUBSYSTEM_0:APBmslave9" "apb3_if_0:APB_IF" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PROC_SUBSYSTEM_0:AXI4mslave2_0" "axi_arbiter_0:be" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Video_arbiter_top_0:BIF_1" "axi_arbiter_0:rt" }

# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Save the smartDesign
save_smartdesign -sd_name ${sd_name}
# Generate SmartDesign VIDEO_KIT_TOP
generate_component -component_name ${sd_name}
