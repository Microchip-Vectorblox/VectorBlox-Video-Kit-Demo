# Creating SmartDesign Vectorblox_ss
set sd_name {Vectorblox_ss}
create_smartdesign -sd_name ${sd_name}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Scalar Ports
sd_create_scalar_port -sd_name ${sd_name} -port_name {EXT_RST_N} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {INIT_DONE} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_arready} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_awready} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_bvalid} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_rlast} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_rvalid} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_wready} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {REF_CLK_0} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {s_axi_arvalid} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {s_axi_awvalid} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {s_axi_bready} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {s_axi_rready} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {s_axi_wvalid} -port_direction {IN}

sd_create_scalar_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_arvalid} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_awvalid} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_bready} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_rready} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_wlast} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_wvalid} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {vbx_clk} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {vbx_resetn} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {s_axi_arready} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {s_axi_awready} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {s_axi_bvalid} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {s_axi_rvalid} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {s_axi_wready} -port_direction {OUT}


# Create top level Bus Ports
sd_create_bus_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_bid} -port_direction {IN} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_bresp} -port_direction {IN} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_rdata} -port_direction {IN} -port_range {[255:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_rid} -port_direction {IN} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_rresp} -port_direction {IN} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {s_axi_araddr} -port_direction {IN} -port_range {[11:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {s_axi_awaddr} -port_direction {IN} -port_range {[11:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {s_axi_wdata} -port_direction {IN} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {s_axi_wstrb} -port_direction {IN} -port_range {[3:0]}

sd_create_bus_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_araddr} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_arburst} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_arcache} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_arid} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_arlen} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_arprot} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_arsize} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_awaddr} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_awburst} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_awcache} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_awid} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_awlen} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_awprot} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_awsize} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_wdata} -port_direction {OUT} -port_range {[255:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {M_AXI_m_axi_wstrb} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {s_axi_bresp} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {s_axi_rdata} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {s_axi_rresp} -port_direction {OUT} -port_range {[1:0]}


# Create top level Bus interface Ports
sd_create_bif_port -sd_name ${sd_name} -port_name {S_control} -port_bif_vlnv {AMBA:AMBA4:AXI4:r0p0_0} -port_bif_role {slave} -port_bif_mapping {\
"AWADDR:s_axi_awaddr" \
"AWVALID:s_axi_awvalid" \
"AWREADY:s_axi_awready" \
"WDATA:s_axi_wdata" \
"WSTRB:s_axi_wstrb" \
"WVALID:s_axi_wvalid" \
"WREADY:s_axi_wready" \
"BRESP:s_axi_bresp" \
"BVALID:s_axi_bvalid" \
"BREADY:s_axi_bready" \
"ARADDR:s_axi_araddr" \
"ARVALID:s_axi_arvalid" \
"ARREADY:s_axi_arready" \
"RDATA:s_axi_rdata" \
"RRESP:s_axi_rresp" \
"RVALID:s_axi_rvalid" \
"RREADY:s_axi_rready" } 

sd_create_bif_port -sd_name ${sd_name} -port_name {M_AXI} -port_bif_vlnv {AMBA:AMBA4:AXI4:r0p0_0} -port_bif_role {master} -port_bif_mapping {\
"AWID:M_AXI_m_axi_awid" \
"AWADDR:M_AXI_m_axi_awaddr" \
"AWLEN:M_AXI_m_axi_awlen" \
"AWSIZE:M_AXI_m_axi_awsize" \
"AWBURST:M_AXI_m_axi_awburst" \
"AWCACHE:M_AXI_m_axi_awcache" \
"AWPROT:M_AXI_m_axi_awprot" \
"AWVALID:M_AXI_m_axi_awvalid" \
"AWREADY:M_AXI_m_axi_awready" \
"WDATA:M_AXI_m_axi_wdata" \
"WSTRB:M_AXI_m_axi_wstrb" \
"WLAST:M_AXI_m_axi_wlast" \
"WVALID:M_AXI_m_axi_wvalid" \
"WREADY:M_AXI_m_axi_wready" \
"BID:M_AXI_m_axi_bid" \
"BRESP:M_AXI_m_axi_bresp" \
"BVALID:M_AXI_m_axi_bvalid" \
"BREADY:M_AXI_m_axi_bready" \
"ARID:M_AXI_m_axi_arid" \
"ARADDR:M_AXI_m_axi_araddr" \
"ARLEN:M_AXI_m_axi_arlen" \
"ARSIZE:M_AXI_m_axi_arsize" \
"ARBURST:M_AXI_m_axi_arburst" \
"ARCACHE:M_AXI_m_axi_arcache" \
"ARPROT:M_AXI_m_axi_arprot" \
"ARVALID:M_AXI_m_axi_arvalid" \
"ARREADY:M_AXI_m_axi_arready" \
"RID:M_AXI_m_axi_rid" \
"RDATA:M_AXI_m_axi_rdata" \
"RRESP:M_AXI_m_axi_rresp" \
"RLAST:M_AXI_m_axi_rlast" \
"RVALID:M_AXI_m_axi_rvalid" \
"RREADY:M_AXI_m_axi_rready" } 

# Add core_vectorblox_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {core_vectorblox_C0} -instance_name {core_vectorblox_C0_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {core_vectorblox_C0_0:output_valid}



# Add PF_CCC_C1_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {PF_CCC_C1} -instance_name {PF_CCC_C1_0}



# Add slow_reset instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CORERESET_PF_C4} -instance_name {slow_reset}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {slow_reset:BANK_x_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {slow_reset:BANK_y_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {slow_reset:SS_BUSY} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {slow_reset:FF_US_RESTORE} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {slow_reset:FPGA_POR_N} -value {VCC}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {slow_reset:PLL_POWERDOWN_B}



# Add scalar net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"EXT_RST_N" "slow_reset:EXT_RST_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"INIT_DONE" "slow_reset:INIT_DONE" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_CCC_C1_0:OUT1_FABCLK_0" "vbx_clk" "core_vectorblox_C0_0:clk" "slow_reset:CLK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_CCC_C1_0:OUT0_FABCLK_0" "core_vectorblox_C0_0:clk_2x" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_CCC_C1_0:PLL_LOCK_0" "slow_reset:PLL_LOCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_CCC_C1_0:REF_CLK_0" "REF_CLK_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"core_vectorblox_C0_0:resetn" "slow_reset:FABRIC_RESET_N" "vbx_resetn" }


# Add bus interface net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"M_AXI" "core_vectorblox_C0_0:M_AXI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"S_control" "core_vectorblox_C0_0:S_control" }

# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Save the smartDesign
save_smartdesign -sd_name ${sd_name}
# Generate SmartDesign Vectorblox_ss
generate_component -component_name ${sd_name}
