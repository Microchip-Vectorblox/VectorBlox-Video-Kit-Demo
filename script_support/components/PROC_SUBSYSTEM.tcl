# Creating SmartDesign "PROC_SUBSYSTEM"
set sd_name {PROC_SUBSYSTEM}
create_smartdesign -sd_name ${sd_name}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Scalar Ports
sd_create_scalar_port -sd_name ${sd_name} -port_name {ACLK} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {ARESETN} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM_SEL} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {DI} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {FLASH} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {IFACE} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PCLK} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PREADYS9} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PRESETN} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PSLVERRS9} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SLAVE2_ARREADY_0} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SLAVE2_AWREADY_0} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SLAVE2_BVALID_0} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SLAVE2_RLAST_0} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SLAVE2_RVALID_0} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SLAVE2_WREADY_0} -port_direction {IN}
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
sd_create_scalar_port -sd_name ${sd_name} -port_name {vbx_clk_2x} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {vbx_clk} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {vbx_resetn} -port_direction {IN}

sd_create_scalar_port -sd_name ${sd_name} -port_name {APB_CLK} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {APB_Reset} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM1_RST} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM2_RST} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {DO} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {GPIO_OUT} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {HDMI_RST} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PENABLES} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PSELS9} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PWRITES} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SLAVE2_ARVALID_0} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SLAVE2_AWVALID_0} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SLAVE2_BREADY_0} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SLAVE2_RREADY_0} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SLAVE2_WLAST_0} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SLAVE2_WVALID_0} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TDO} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TRNG_RST_N} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TX} -port_direction {OUT}

sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM1_SCL} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM1_SDA} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM2_SCL} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM2_SDA} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CLK} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {HDMI_SCL} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {HDMI_SDA} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SS} -port_direction {INOUT} -port_is_pad {1}

# Create top level Bus Ports
sd_create_bus_port -sd_name ${sd_name} -port_name {PRDATAS9} -port_direction {IN} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_BID_0} -port_direction {IN} -port_range {[5:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_BRESP_0} -port_direction {IN} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_BUSER_0} -port_direction {IN} -port_range {[0:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_RDATA_0} -port_direction {IN} -port_range {[255:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_RID_0} -port_direction {IN} -port_range {[5:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_RRESP_0} -port_direction {IN} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_RUSER_0} -port_direction {IN} -port_range {[0:0]}

sd_create_bus_port -sd_name ${sd_name} -port_name {GPIO_OUT_0} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {PADDRS} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {PWDATAS} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_ARADDR_0} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_ARBURST_0} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_ARCACHE_0} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_ARID_0} -port_direction {OUT} -port_range {[5:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_ARLEN_0} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_ARLOCK_0} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_ARPROT_0} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_ARQOS_0} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_ARREGION_0} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_ARSIZE_0} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_ARUSER_0} -port_direction {OUT} -port_range {[0:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_AWADDR_0} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_AWBURST_0} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_AWCACHE_0} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_AWID_0} -port_direction {OUT} -port_range {[5:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_AWLEN_0} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_AWLOCK_0} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_AWPROT_0} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_AWQOS_0} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_AWREGION_0} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_AWSIZE_0} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_AWUSER_0} -port_direction {OUT} -port_range {[0:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_WDATA_0} -port_direction {OUT} -port_range {[255:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_WSTRB_0} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {SLAVE2_WUSER_0} -port_direction {OUT} -port_range {[0:0]}


# Create top level Bus interface Ports
sd_create_bif_port -sd_name ${sd_name} -port_name {APBmslave9} -port_bif_vlnv {AMBA:AMBA2:APB:r0p0} -port_bif_role {mirroredSlave} -port_bif_mapping {\
"PADDR:PADDRS" \
"PSELx:PSELS9" \
"PENABLE:PENABLES" \
"PWRITE:PWRITES" \
"PRDATA:PRDATAS9" \
"PWDATA:PWDATAS" \
"PREADY:PREADYS9" \
"PSLVERR:PSLVERRS9" } 

sd_create_bif_port -sd_name ${sd_name} -port_name {AXI4mslave2_0} -port_bif_vlnv {AMBA:AMBA4:AXI4:r0p0_0} -port_bif_role {mirroredSlave} -port_bif_mapping {\
"AWID:SLAVE2_AWID_0" \
"AWADDR:SLAVE2_AWADDR_0" \
"AWLEN:SLAVE2_AWLEN_0" \
"AWSIZE:SLAVE2_AWSIZE_0" \
"AWBURST:SLAVE2_AWBURST_0" \
"AWLOCK:SLAVE2_AWLOCK_0" \
"AWCACHE:SLAVE2_AWCACHE_0" \
"AWPROT:SLAVE2_AWPROT_0" \
"AWQOS:SLAVE2_AWQOS_0" \
"AWREGION:SLAVE2_AWREGION_0" \
"AWVALID:SLAVE2_AWVALID_0" \
"AWREADY:SLAVE2_AWREADY_0" \
"WDATA:SLAVE2_WDATA_0" \
"WSTRB:SLAVE2_WSTRB_0" \
"WLAST:SLAVE2_WLAST_0" \
"WVALID:SLAVE2_WVALID_0" \
"WREADY:SLAVE2_WREADY_0" \
"BID:SLAVE2_BID_0" \
"BRESP:SLAVE2_BRESP_0" \
"BVALID:SLAVE2_BVALID_0" \
"BREADY:SLAVE2_BREADY_0" \
"ARID:SLAVE2_ARID_0" \
"ARADDR:SLAVE2_ARADDR_0" \
"ARLEN:SLAVE2_ARLEN_0" \
"ARSIZE:SLAVE2_ARSIZE_0" \
"ARBURST:SLAVE2_ARBURST_0" \
"ARLOCK:SLAVE2_ARLOCK_0" \
"ARCACHE:SLAVE2_ARCACHE_0" \
"ARPROT:SLAVE2_ARPROT_0" \
"ARQOS:SLAVE2_ARQOS_0" \
"ARREGION:SLAVE2_ARREGION_0" \
"ARVALID:SLAVE2_ARVALID_0" \
"ARREADY:SLAVE2_ARREADY_0" \
"RID:SLAVE2_RID_0" \
"RDATA:SLAVE2_RDATA_0" \
"RRESP:SLAVE2_RRESP_0" \
"RLAST:SLAVE2_RLAST_0" \
"RVALID:SLAVE2_RVALID_0" \
"RREADY:SLAVE2_RREADY_0" \
"AWUSER:SLAVE2_AWUSER_0" \
"WUSER:SLAVE2_WUSER_0" \
"BUSER:SLAVE2_BUSER_0" \
"ARUSER:SLAVE2_ARUSER_0" \
"RUSER:SLAVE2_RUSER_0" } 

# Add axi_master_scale_updown_bilinear_top_0 instance
sd_instantiate_hdl_core -sd_name ${sd_name} -hdl_core_name {axi_master_scale_updown_bilinear_top} -instance_name {axi_master_scale_updown_bilinear_top_0}
sd_invert_pins -sd_name ${sd_name} -pin_names {axi_master_scale_updown_bilinear_top_0:reset}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {axi_master_scale_updown_bilinear_top_0:start} -value {GND}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {axi_master_scale_updown_bilinear_top_0:ready}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {axi_master_scale_updown_bilinear_top_0:finish}



# Add axi_master_warpPerspective_top_0 instance
sd_instantiate_hdl_core -sd_name ${sd_name} -hdl_core_name {axi_master_warpPerspective_top} -instance_name {axi_master_warpPerspective_top_0}
sd_invert_pins -sd_name ${sd_name} -pin_names {axi_master_warpPerspective_top_0:reset}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {axi_master_warpPerspective_top_0:start} -value {GND}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {axi_master_warpPerspective_top_0:ready}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {axi_master_warpPerspective_top_0:finish}



# Add axi_passthru_0 instance
sd_instantiate_hdl_core -sd_name ${sd_name} -hdl_core_name {axi_passthru} -instance_name {axi_passthru_0}
# Exporting Parameters of instance axi_passthru_0
sd_configure_core_instance -sd_name ${sd_name} -instance_name {axi_passthru_0} -params {\
"ADDR_WIDTH:32" \
"DATA_WIDTH:256" \
"ID_WIDTH:3" }\
-validate_rules 0
sd_save_core_instance_config -sd_name ${sd_name} -instance_name {axi_passthru_0}
sd_update_instance -sd_name ${sd_name} -instance_name {axi_passthru_0}



# Add BIBUF_0 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {BIBUF} -instance_name {BIBUF_0}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {BIBUF_0:D} -value {GND}
sd_invert_pins -sd_name ${sd_name} -pin_names {BIBUF_0:E}



# Add BIBUF_1 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {BIBUF} -instance_name {BIBUF_1}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {BIBUF_1:D} -value {GND}
sd_invert_pins -sd_name ${sd_name} -pin_names {BIBUF_1:E}



# Add BIBUF_2 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {BIBUF} -instance_name {BIBUF_2}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {BIBUF_2:D} -value {GND}
sd_invert_pins -sd_name ${sd_name} -pin_names {BIBUF_2:E}



# Add BIBUF_3 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {BIBUF} -instance_name {BIBUF_3}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {BIBUF_3:D} -value {GND}
sd_invert_pins -sd_name ${sd_name} -pin_names {BIBUF_3:E}



# Add BIBUF_4 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {BIBUF} -instance_name {BIBUF_4}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {BIBUF_4:D} -value {GND}
sd_invert_pins -sd_name ${sd_name} -pin_names {BIBUF_4:E}



# Add BIBUF_5 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {BIBUF} -instance_name {BIBUF_5}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {BIBUF_5:D} -value {GND}
sd_invert_pins -sd_name ${sd_name} -pin_names {BIBUF_5:E}



# Add core_vectorblox_C1_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {core_vectorblox_C1} -instance_name {core_vectorblox_C1_0}



# Add CoreAHBLite_0 instance
sd_instantiate_core -sd_name ${sd_name} -core_vlnv {Actel:DirectCore:CoreAHBLite:6.1.101} -instance_name {CoreAHBLite_0}
# Exporting Parameters of instance CoreAHBLite_0
sd_configure_core_instance -sd_name ${sd_name} -instance_name {CoreAHBLite_0} -params {\
"FAMILY:26" \
"HADDR_SHG_CFG:1" \
"M0_AHBSLOT0ENABLE:false" \
"M0_AHBSLOT1ENABLE:false" \
"M0_AHBSLOT2ENABLE:false" \
"M0_AHBSLOT3ENABLE:false" \
"M0_AHBSLOT4ENABLE:false" \
"M0_AHBSLOT5ENABLE:false" \
"M0_AHBSLOT6ENABLE:false" \
"M0_AHBSLOT7ENABLE:true" \
"M0_AHBSLOT8ENABLE:false" \
"M0_AHBSLOT9ENABLE:false" \
"M0_AHBSLOT10ENABLE:false" \
"M0_AHBSLOT11ENABLE:false" \
"M0_AHBSLOT12ENABLE:false" \
"M0_AHBSLOT13ENABLE:false" \
"M0_AHBSLOT14ENABLE:false" \
"M0_AHBSLOT15ENABLE:false" \
"M0_AHBSLOT16ENABLE:false" \
"M1_AHBSLOT0ENABLE:false" \
"M1_AHBSLOT1ENABLE:false" \
"M1_AHBSLOT2ENABLE:false" \
"M1_AHBSLOT3ENABLE:false" \
"M1_AHBSLOT4ENABLE:false" \
"M1_AHBSLOT5ENABLE:false" \
"M1_AHBSLOT6ENABLE:false" \
"M1_AHBSLOT7ENABLE:false" \
"M1_AHBSLOT8ENABLE:false" \
"M1_AHBSLOT9ENABLE:false" \
"M1_AHBSLOT10ENABLE:false" \
"M1_AHBSLOT11ENABLE:false" \
"M1_AHBSLOT12ENABLE:false" \
"M1_AHBSLOT13ENABLE:false" \
"M1_AHBSLOT14ENABLE:false" \
"M1_AHBSLOT15ENABLE:false" \
"M1_AHBSLOT16ENABLE:false" \
"M2_AHBSLOT0ENABLE:false" \
"M2_AHBSLOT1ENABLE:false" \
"M2_AHBSLOT2ENABLE:false" \
"M2_AHBSLOT3ENABLE:false" \
"M2_AHBSLOT4ENABLE:false" \
"M2_AHBSLOT5ENABLE:false" \
"M2_AHBSLOT6ENABLE:false" \
"M2_AHBSLOT7ENABLE:false" \
"M2_AHBSLOT8ENABLE:false" \
"M2_AHBSLOT9ENABLE:false" \
"M2_AHBSLOT10ENABLE:false" \
"M2_AHBSLOT11ENABLE:false" \
"M2_AHBSLOT12ENABLE:false" \
"M2_AHBSLOT13ENABLE:false" \
"M2_AHBSLOT14ENABLE:false" \
"M2_AHBSLOT15ENABLE:false" \
"M2_AHBSLOT16ENABLE:false" \
"M3_AHBSLOT0ENABLE:false" \
"M3_AHBSLOT1ENABLE:false" \
"M3_AHBSLOT2ENABLE:false" \
"M3_AHBSLOT3ENABLE:false" \
"M3_AHBSLOT4ENABLE:false" \
"M3_AHBSLOT5ENABLE:false" \
"M3_AHBSLOT6ENABLE:false" \
"M3_AHBSLOT7ENABLE:false" \
"M3_AHBSLOT8ENABLE:false" \
"M3_AHBSLOT9ENABLE:false" \
"M3_AHBSLOT10ENABLE:false" \
"M3_AHBSLOT11ENABLE:false" \
"M3_AHBSLOT12ENABLE:false" \
"M3_AHBSLOT13ENABLE:false" \
"M3_AHBSLOT14ENABLE:false" \
"M3_AHBSLOT15ENABLE:false" \
"M3_AHBSLOT16ENABLE:false" \
"MASTER0_INTERFACE:1" \
"MASTER1_INTERFACE:1" \
"MASTER2_INTERFACE:1" \
"MASTER3_INTERFACE:1" \
"MEMSPACE:1" \
"SC_0:false" \
"SC_1:false" \
"SC_2:false" \
"SC_3:false" \
"SC_4:false" \
"SC_5:false" \
"SC_6:false" \
"SC_7:false" \
"SC_8:false" \
"SC_9:false" \
"SC_10:false" \
"SC_11:false" \
"SC_12:false" \
"SC_13:false" \
"SC_14:false" \
"SC_15:false" \
"SLAVE0_INTERFACE:1" \
"SLAVE1_INTERFACE:1" \
"SLAVE2_INTERFACE:1" \
"SLAVE3_INTERFACE:1" \
"SLAVE4_INTERFACE:1" \
"SLAVE5_INTERFACE:1" \
"SLAVE6_INTERFACE:1" \
"SLAVE7_INTERFACE:1" \
"SLAVE8_INTERFACE:1" \
"SLAVE9_INTERFACE:1" \
"SLAVE10_INTERFACE:1" \
"SLAVE11_INTERFACE:1" \
"SLAVE12_INTERFACE:1" \
"SLAVE13_INTERFACE:1" \
"SLAVE14_INTERFACE:1" \
"SLAVE15_INTERFACE:1" \
"SLAVE16_INTERFACE:1" \
"testbench:User" }\
-validate_rules 0
sd_save_core_instance_config -sd_name ${sd_name} -instance_name {CoreAHBLite_0}



# Add COREAHBTOAPB3_0 instance
sd_instantiate_core -sd_name ${sd_name} -core_vlnv {Actel:DirectCore:COREAHBTOAPB3:3.2.101} -instance_name {COREAHBTOAPB3_0}
# Exporting Parameters of instance COREAHBTOAPB3_0
sd_configure_core_instance -sd_name ${sd_name} -instance_name {COREAHBTOAPB3_0} -params {\
"FAMILY:26" \
"HDL_license:O" \
"testbench:User" }\
-validate_rules 0
sd_save_core_instance_config -sd_name ${sd_name} -instance_name {COREAHBTOAPB3_0}



# Add CoreAPB3_0 instance
sd_instantiate_core -sd_name ${sd_name} -core_vlnv {Actel:DirectCore:CoreAPB3:4.2.100} -instance_name {CoreAPB3_0}
# Exporting Parameters of instance CoreAPB3_0
sd_configure_core_instance -sd_name ${sd_name} -instance_name {CoreAPB3_0} -params {\
"APB_DWIDTH:32" \
"APBSLOT0ENABLE:false" \
"APBSLOT1ENABLE:true" \
"APBSLOT2ENABLE:true" \
"APBSLOT3ENABLE:true" \
"APBSLOT4ENABLE:true" \
"APBSLOT5ENABLE:true" \
"APBSLOT6ENABLE:true" \
"APBSLOT7ENABLE:true" \
"APBSLOT8ENABLE:true" \
"APBSLOT9ENABLE:true" \
"APBSLOT10ENABLE:false" \
"APBSLOT11ENABLE:false" \
"APBSLOT12ENABLE:false" \
"APBSLOT13ENABLE:false" \
"APBSLOT14ENABLE:false" \
"APBSLOT15ENABLE:false" \
"FAMILY:26" \
"HDL_license:U" \
"IADDR_OPTION:0" \
"MADDR_BITS:16" \
"SC_0:false" \
"SC_1:false" \
"SC_2:false" \
"SC_3:false" \
"SC_4:false" \
"SC_5:false" \
"SC_6:false" \
"SC_7:false" \
"SC_8:false" \
"SC_9:false" \
"SC_10:false" \
"SC_11:false" \
"SC_12:false" \
"SC_13:false" \
"SC_14:false" \
"SC_15:false" \
"testbench:User" \
"UPR_NIBBLE_POSN:6" }\
-validate_rules 0
sd_save_core_instance_config -sd_name ${sd_name} -instance_name {CoreAPB3_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CoreAPB3_0:APBmslave1}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CoreAPB3_0:APBmslave2}



# Add COREAXITOAHBL_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {COREAXITOAHBL_C0} -instance_name {COREAXITOAHBL_C0_0}



# Add CoreGPIO_OUT instance
sd_instantiate_core -sd_name ${sd_name} -core_vlnv {Actel:DirectCore:CoreGPIO:3.2.102} -instance_name {CoreGPIO_OUT}
# Exporting Parameters of instance CoreGPIO_OUT
sd_configure_core_instance -sd_name ${sd_name} -instance_name {CoreGPIO_OUT} -params {\
"APB_WIDTH:32" \
"FIXED_CONFIG_0:true" \
"FIXED_CONFIG_1:true" \
"FIXED_CONFIG_2:true" \
"FIXED_CONFIG_3:true" \
"FIXED_CONFIG_4:true" \
"FIXED_CONFIG_5:true" \
"FIXED_CONFIG_6:true" \
"FIXED_CONFIG_7:true" \
"FIXED_CONFIG_8:true" \
"FIXED_CONFIG_9:true" \
"FIXED_CONFIG_10:true" \
"FIXED_CONFIG_11:true" \
"FIXED_CONFIG_12:true" \
"FIXED_CONFIG_13:true" \
"FIXED_CONFIG_14:true" \
"FIXED_CONFIG_15:true" \
"FIXED_CONFIG_16:true" \
"FIXED_CONFIG_17:true" \
"FIXED_CONFIG_18:true" \
"FIXED_CONFIG_19:true" \
"FIXED_CONFIG_20:true" \
"FIXED_CONFIG_21:true" \
"FIXED_CONFIG_22:true" \
"FIXED_CONFIG_23:true" \
"FIXED_CONFIG_24:true" \
"FIXED_CONFIG_25:true" \
"FIXED_CONFIG_26:true" \
"FIXED_CONFIG_27:true" \
"FIXED_CONFIG_28:true" \
"FIXED_CONFIG_29:true" \
"FIXED_CONFIG_30:true" \
"FIXED_CONFIG_31:true" \
"INT_BUS:0" \
"IO_INT_TYPE_0:7" \
"IO_INT_TYPE_1:7" \
"IO_INT_TYPE_2:7" \
"IO_INT_TYPE_3:7" \
"IO_INT_TYPE_4:7" \
"IO_INT_TYPE_5:7" \
"IO_INT_TYPE_6:7" \
"IO_INT_TYPE_7:7" \
"IO_INT_TYPE_8:7" \
"IO_INT_TYPE_9:7" \
"IO_INT_TYPE_10:7" \
"IO_INT_TYPE_11:7" \
"IO_INT_TYPE_12:7" \
"IO_INT_TYPE_13:7" \
"IO_INT_TYPE_14:7" \
"IO_INT_TYPE_15:7" \
"IO_INT_TYPE_16:7" \
"IO_INT_TYPE_17:7" \
"IO_INT_TYPE_18:7" \
"IO_INT_TYPE_19:7" \
"IO_INT_TYPE_20:7" \
"IO_INT_TYPE_21:7" \
"IO_INT_TYPE_22:7" \
"IO_INT_TYPE_23:7" \
"IO_INT_TYPE_24:7" \
"IO_INT_TYPE_25:7" \
"IO_INT_TYPE_26:7" \
"IO_INT_TYPE_27:7" \
"IO_INT_TYPE_28:7" \
"IO_INT_TYPE_29:7" \
"IO_INT_TYPE_30:7" \
"IO_INT_TYPE_31:7" \
"IO_NUM:32" \
"IO_TYPE_0:1" \
"IO_TYPE_1:1" \
"IO_TYPE_2:1" \
"IO_TYPE_3:1" \
"IO_TYPE_4:1" \
"IO_TYPE_5:1" \
"IO_TYPE_6:1" \
"IO_TYPE_7:1" \
"IO_TYPE_8:1" \
"IO_TYPE_9:1" \
"IO_TYPE_10:0" \
"IO_TYPE_11:0" \
"IO_TYPE_12:0" \
"IO_TYPE_13:0" \
"IO_TYPE_14:0" \
"IO_TYPE_15:0" \
"IO_TYPE_16:0" \
"IO_TYPE_17:1" \
"IO_TYPE_18:1" \
"IO_TYPE_19:1" \
"IO_TYPE_20:1" \
"IO_TYPE_21:1" \
"IO_TYPE_22:1" \
"IO_TYPE_23:1" \
"IO_TYPE_24:1" \
"IO_TYPE_25:1" \
"IO_TYPE_26:1" \
"IO_TYPE_27:1" \
"IO_TYPE_28:1" \
"IO_TYPE_29:1" \
"IO_TYPE_30:1" \
"IO_TYPE_31:1" \
"IO_VAL_0:0" \
"IO_VAL_1:0" \
"IO_VAL_2:0" \
"IO_VAL_3:0" \
"IO_VAL_4:0" \
"IO_VAL_5:0" \
"IO_VAL_6:0" \
"IO_VAL_7:0" \
"IO_VAL_8:0" \
"IO_VAL_9:0" \
"IO_VAL_10:0" \
"IO_VAL_11:0" \
"IO_VAL_12:0" \
"IO_VAL_13:0" \
"IO_VAL_14:0" \
"IO_VAL_15:0" \
"IO_VAL_16:0" \
"IO_VAL_17:0" \
"IO_VAL_18:0" \
"IO_VAL_19:0" \
"IO_VAL_20:0" \
"IO_VAL_21:0" \
"IO_VAL_22:0" \
"IO_VAL_23:0" \
"IO_VAL_24:0" \
"IO_VAL_25:0" \
"IO_VAL_26:0" \
"IO_VAL_27:0" \
"IO_VAL_28:0" \
"IO_VAL_29:0" \
"IO_VAL_30:0" \
"IO_VAL_31:0" \
"OE_TYPE:1" \
"testbench:User" }\
-validate_rules 0
sd_save_core_instance_config -sd_name ${sd_name} -instance_name {CoreGPIO_OUT}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CoreGPIO_OUT:GPIO_IN} -pin_slices {[10:10]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CoreGPIO_OUT:GPIO_IN} -pin_slices {[11:11]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CoreGPIO_OUT:GPIO_IN} -pin_slices {[12:12]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CoreGPIO_OUT:GPIO_IN} -pin_slices {[13:13]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CoreGPIO_OUT:GPIO_IN} -pin_slices {[14:14]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CoreGPIO_OUT:GPIO_IN} -pin_slices {[15:15]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CoreGPIO_OUT:GPIO_IN} -pin_slices {[16:16]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CoreGPIO_OUT:GPIO_IN} -pin_slices {[31:17]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CoreGPIO_OUT:GPIO_IN[31:17]} -value {GND}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CoreGPIO_OUT:GPIO_IN} -pin_slices {[9:0]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CoreGPIO_OUT:GPIO_IN[9:0]} -value {GND}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CoreGPIO_OUT:GPIO_OUT} -pin_slices {[31:10]}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CoreGPIO_OUT:GPIO_OUT[31:10]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CoreGPIO_OUT:GPIO_OUT} -pin_slices {[3:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CoreGPIO_OUT:GPIO_OUT} -pin_slices {[4:4]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CoreGPIO_OUT:GPIO_OUT} -pin_slices {[6:5]}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CoreGPIO_OUT:GPIO_OUT[6:5]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CoreGPIO_OUT:GPIO_OUT} -pin_slices {[7:7]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CoreGPIO_OUT:GPIO_OUT} -pin_slices {[8:8]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CoreGPIO_OUT:GPIO_OUT} -pin_slices {[9:9]}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CoreGPIO_OUT:INT}



# Add COREI2C_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {COREI2C_C0} -instance_name {COREI2C_C0_0}



# Add COREI2C_C0_1 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {COREI2C_C0} -instance_name {COREI2C_C0_1}



# Add COREI2C_C0_2 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {COREI2C_C0} -instance_name {COREI2C_C0_2}



# Add COREJTAGDEBUG_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {COREJTAGDEBUG_C0} -instance_name {COREJTAGDEBUG_C0_0}



# Add CORESPI_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CORESPI_C0} -instance_name {CORESPI_C0_0}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CORESPI_C0_0:SPISS} -pin_slices {[0:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {CORESPI_C0_0:SPISS} -pin_slices {[7:1]}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORESPI_C0_0:SPISS[7:1]}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORESPI_C0_0:SPIINT}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORESPI_C0_0:SPIRXAVAIL}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORESPI_C0_0:SPITXRFM}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORESPI_C0_0:SPIMODE}



# Add CoreUARTapb_MiV_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CoreUARTapb_MiV} -instance_name {CoreUARTapb_MiV_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CoreUARTapb_MiV_0:TXRDY}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CoreUARTapb_MiV_0:RXRDY}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CoreUARTapb_MiV_0:PARITY_ERR}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CoreUARTapb_MiV_0:OVERFLOW}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CoreUARTapb_MiV_0:RX} -value {GND}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CoreUARTapb_MiV_0:FRAMING_ERR}



# Add DDR_Interconnect_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {DDR_Interconnect} -instance_name {DDR_Interconnect_0}



# Add draw_assist_0 instance
sd_instantiate_hdl_core -sd_name ${sd_name} -hdl_core_name {draw_assist} -instance_name {draw_assist_0}
# Exporting Parameters of instance draw_assist_0
sd_configure_core_instance -sd_name ${sd_name} -instance_name {draw_assist_0} -params {\
"M_AXI_DATA_WIDTH:256" \
"MAX_LOG2_BURSTLENGTH:6" }\
-validate_rules 0
sd_save_core_instance_config -sd_name ${sd_name} -instance_name {draw_assist_0}
sd_update_instance -sd_name ${sd_name} -instance_name {draw_assist_0}



# Add MiV_Interconnect_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {MiV_Interconnect} -instance_name {MiV_Interconnect_0}



# Add MIV_RV32IMA_L1_AXI_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {MIV_RV32IMA_L1_AXI_C0} -instance_name {MIV_RV32IMA_L1_AXI_C0_0}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_RV32IMA_L1_AXI_C0_0:IRQ} -pin_slices {[25:0]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {MIV_RV32IMA_L1_AXI_C0_0:IRQ[25:0]} -value {GND}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_RV32IMA_L1_AXI_C0_0:IRQ} -pin_slices {[26:26]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_RV32IMA_L1_AXI_C0_0:IRQ} -pin_slices {[27:27]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_RV32IMA_L1_AXI_C0_0:IRQ} -pin_slices {[28:28]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_RV32IMA_L1_AXI_C0_0:IRQ} -pin_slices {[29:29]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_RV32IMA_L1_AXI_C0_0:IRQ} -pin_slices {[30:30]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {MIV_RV32IMA_L1_AXI_C0_0:IRQ[30:30]} -value {GND}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {MIV_RV32IMA_L1_AXI_C0_0:DRV_TDO}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {MIV_RV32IMA_L1_AXI_C0_0:EXT_RESETN}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {MIV_RV32IMA_L1_AXI_C0_0:MEM_AXI_WID}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {MIV_RV32IMA_L1_AXI_C0_0:MMIO_AXI_WID}



# Add PF_SPI_0 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {PF_SPI} -instance_name {PF_SPI_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PF_SPI_0:FAB_SPI_OWNER}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {PF_SPI_0:CLK_OE} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {PF_SPI_0:SS_OE} -value {VCC}



# Add PF_SRAM_AHBL_AXI_C1_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {PF_SRAM_AHBL_AXI_C1} -instance_name {PF_SRAM_AHBL_AXI_C1_0}



# Add scalar net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"ACLK" "DDR_Interconnect_0:ACLK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"APB_CLK" "COREAHBTOAPB3_0:HCLK" "COREAXITOAHBL_C0_0:ACLK" "COREAXITOAHBL_C0_0:HCLK" "COREI2C_C0_0:PCLK" "COREI2C_C0_1:PCLK" "COREI2C_C0_2:PCLK" "CORESPI_C0_0:PCLK" "CoreAHBLite_0:HCLK" "CoreGPIO_OUT:PCLK" "CoreUARTapb_MiV_0:PCLK" "DDR_Interconnect_0:M_CLK1" "MIV_RV32IMA_L1_AXI_C0_0:CLK" "MiV_Interconnect_0:ACLK" "PCLK" "PF_SRAM_AHBL_AXI_C1_0:ACLK" "axi_master_scale_updown_bilinear_top_0:clk" "axi_master_warpPerspective_top_0:clk" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"APB_Reset" "COREAHBTOAPB3_0:HRESETN" "COREAXITOAHBL_C0_0:ARESETN" "COREAXITOAHBL_C0_0:HRESETN" "COREI2C_C0_0:PRESETN" "COREI2C_C0_1:PRESETN" "COREI2C_C0_2:PRESETN" "CORESPI_C0_0:PRESETN" "CoreAHBLite_0:HRESETN" "CoreGPIO_OUT:PRESETN" "CoreUARTapb_MiV_0:PRESETN" "HDMI_RST" "MIV_RV32IMA_L1_AXI_C0_0:RESETN" "MiV_Interconnect_0:ARESETN" "PF_SRAM_AHBL_AXI_C1_0:ARESETN" "PRESETN" "axi_master_scale_updown_bilinear_top_0:reset" "axi_master_warpPerspective_top_0:reset" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ARESETN" "DDR_Interconnect_0:ARESETN" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_0:E" "COREI2C_C0_2:SCLO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_0:PAD" "CAM1_SCL" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_0:Y" "COREI2C_C0_2:SCLI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_1:E" "COREI2C_C0_2:SDAO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_1:PAD" "CAM1_SDA" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_1:Y" "COREI2C_C0_2:SDAI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_2:E" "COREI2C_C0_1:SCLO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_2:PAD" "HDMI_SCL" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_2:Y" "COREI2C_C0_1:SCLI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_3:E" "COREI2C_C0_1:SDAO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_3:PAD" "HDMI_SDA" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_3:Y" "COREI2C_C0_1:SDAI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_4:E" "COREI2C_C0_0:SCLO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_4:PAD" "CAM2_SCL" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_4:Y" "COREI2C_C0_0:SCLI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_5:E" "COREI2C_C0_0:SDAO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_5:PAD" "CAM2_SDA" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_5:Y" "COREI2C_C0_0:SDAI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CAM1_RST" "CoreGPIO_OUT:GPIO_OUT[8:8]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CAM2_RST" "CoreGPIO_OUT:GPIO_OUT[7:7]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CAM_SEL" "CoreGPIO_OUT:GPIO_IN[16:16]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLK" "PF_SPI_0:CLK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREI2C_C0_0:INT" "MIV_RV32IMA_L1_AXI_C0_0:IRQ[29:29]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREI2C_C0_1:INT" "MIV_RV32IMA_L1_AXI_C0_0:IRQ[27:27]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREI2C_C0_2:INT" "MIV_RV32IMA_L1_AXI_C0_0:IRQ[28:28]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREJTAGDEBUG_C0_0:TCK" "TCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREJTAGDEBUG_C0_0:TDI" "TDI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREJTAGDEBUG_C0_0:TDO" "TDO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREJTAGDEBUG_C0_0:TGT_TCK_0" "MIV_RV32IMA_L1_AXI_C0_0:TCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREJTAGDEBUG_C0_0:TGT_TDI_0" "MIV_RV32IMA_L1_AXI_C0_0:TDI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREJTAGDEBUG_C0_0:TGT_TDO_0" "MIV_RV32IMA_L1_AXI_C0_0:TDO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREJTAGDEBUG_C0_0:TGT_TMS_0" "MIV_RV32IMA_L1_AXI_C0_0:TMS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREJTAGDEBUG_C0_0:TGT_TRST_0" "MIV_RV32IMA_L1_AXI_C0_0:TRST" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREJTAGDEBUG_C0_0:TMS" "TMS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREJTAGDEBUG_C0_0:TRSTB" "TRSTB" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORESPI_C0_0:SPICLKI" "PF_SPI_0:CLK_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORESPI_C0_0:SPIOEN" "PF_SPI_0:D_OE" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORESPI_C0_0:SPISCLKO" "PF_SPI_0:CLK_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORESPI_C0_0:SPISDI" "PF_SPI_0:D_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORESPI_C0_0:SPISDO" "PF_SPI_0:D_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORESPI_C0_0:SPISSI" "PF_SPI_0:SS_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORESPI_C0_0:SPISS[0:0]" "PF_SPI_0:SS_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreGPIO_OUT:GPIO_IN[10:10]" "SW1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreGPIO_OUT:GPIO_IN[11:11]" "SW2" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreGPIO_OUT:GPIO_IN[12:12]" "SW3" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreGPIO_OUT:GPIO_IN[13:13]" "SW4" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreGPIO_OUT:GPIO_IN[14:14]" "SW5" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreGPIO_OUT:GPIO_IN[15:15]" "SW6" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreGPIO_OUT:GPIO_OUT[4:4]" "TRNG_RST_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreGPIO_OUT:GPIO_OUT[9:9]" "GPIO_OUT" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreUARTapb_MiV_0:TX" "TX" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Interconnect_0:M_CLK0" "DDR_Interconnect_0:M_CLK2" "MiV_Interconnect_0:S_CLK3" "MiV_Interconnect_0:S_CLK4" "core_vectorblox_C1_0:clk" "draw_assist_0:clk" "vbx_clk" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DI" "PF_SPI_0:DI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DO" "PF_SPI_0:DO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"FLASH" "PF_SPI_0:FLASH" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"IFACE" "PF_SPI_0:IFACE" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_RV32IMA_L1_AXI_C0_0:IRQ[26:26]" "core_vectorblox_C1_0:output_valid" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_SPI_0:SS" "SS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"core_vectorblox_C1_0:clk_2x" "vbx_clk_2x" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"core_vectorblox_C1_0:resetn" "draw_assist_0:resetn" "vbx_resetn" }

# Add bus net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreGPIO_OUT:GPIO_OUT[3:0]" "GPIO_OUT_0" }

# Add bus interface net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"APBmslave9" "CoreAPB3_0:APBmslave9" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AXI4mslave2_0" "DDR_Interconnect_0:AXI4mslave0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREAHBTOAPB3_0:AHBslave" "CoreAHBLite_0:AHBmslave7" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREAHBTOAPB3_0:APBmaster" "CoreAPB3_0:APB3mmaster" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREAXITOAHBL_C0_0:AHBMasterIF" "CoreAHBLite_0:AHBmmaster0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREAXITOAHBL_C0_0:AXISlaveIF" "MiV_Interconnect_0:AXI3mslave1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREI2C_C0_0:APBslave" "CoreAPB3_0:APBmslave4" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREI2C_C0_1:APBslave" "CoreAPB3_0:APBmslave8" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREI2C_C0_2:APBslave" "CoreAPB3_0:APBmslave7" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORESPI_C0_0:APB_bif" "CoreAPB3_0:APBmslave6" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreAPB3_0:APBmslave3" "CoreUARTapb_MiV_0:APB_bif" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreAPB3_0:APBmslave5" "CoreGPIO_OUT:APB_bif" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Interconnect_0:AXI4mmaster0" "core_vectorblox_C1_0:M_AXI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Interconnect_0:AXI4mmaster1" "axi_passthru_0:m_axi" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Interconnect_0:AXI4mmaster2" "draw_assist_0:m_axi" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_RV32IMA_L1_AXI_C0_0:MEM_MST_AXI4" "MiV_Interconnect_0:AXI4mmaster0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_RV32IMA_L1_AXI_C0_0:MMIO_MST_AXI4" "MiV_Interconnect_0:AXI4mmaster1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MiV_Interconnect_0:AXI4mmaster2" "axi_master_scale_updown_bilinear_top_0:master" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MiV_Interconnect_0:AXI4mmaster3" "axi_master_warpPerspective_top_0:master" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MiV_Interconnect_0:AXI4mslave0" "PF_SRAM_AHBL_AXI_C1_0:AXI4_Slave" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MiV_Interconnect_0:AXI4mslave2" "axi_passthru_0:s_axi" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MiV_Interconnect_0:AXI4mslave3" "core_vectorblox_C1_0:S_control" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MiV_Interconnect_0:AXI4mslave4" "draw_assist_0:s_axi" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MiV_Interconnect_0:AXI4mslave5" "axi_master_scale_updown_bilinear_top_0:axi_s" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MiV_Interconnect_0:AXI4mslave6" "axi_master_warpPerspective_top_0:axi_s" }

# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Save the SmartDesign 
save_smartdesign -sd_name ${sd_name}
# Generate SmartDesign "PROC_SUBSYSTEM"
generate_component -component_name ${sd_name}
