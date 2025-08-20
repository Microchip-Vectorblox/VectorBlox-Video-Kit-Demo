# Creating SmartDesign "Video_arbiter_top"
set sd_name {Video_arbiter_top}
create_smartdesign -sd_name ${sd_name}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Scalar Ports
sd_create_scalar_port -sd_name ${sd_name} -port_name {arready_0} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {awready_0} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {bvalid_0} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {ddr_ctrl_ready} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {r0_req_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {r1_req_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {r2_req_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {r3_req_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {reset_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {rlast_0} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {rvalid_0} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {sys_clk_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {w0_data_valid_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {w0_req_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {w1_data_valid_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {w1_req_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {w2_data_valid_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {w2_req_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {w3_data_valid_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {w3_req_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {wready_0} -port_direction {IN}

sd_create_scalar_port -sd_name ${sd_name} -port_name {arvalid_0} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {awvalid_0} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {bready_0} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {r0_ack_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {r0_data_valid_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {r0_done_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {r1_ack_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {r1_data_valid_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {r1_done_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {r2_ack_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {r2_data_valid_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {r2_done_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {r3_ack_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {r3_data_valid_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {r3_done_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {rready_0} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {w0_ack_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {w0_done_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {w1_ack_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {w1_done_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {w2_ack_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {w2_done_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {w3_ack_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {w3_done_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {wlast_0} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {wvalid_0} -port_direction {OUT}


# Create top level Bus Ports
sd_create_bus_port -sd_name ${sd_name} -port_name {bid_0} -port_direction {IN} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {bresp_0} -port_direction {IN} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {r0_burst_size_i} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {r0_rstart_addr_i} -port_direction {IN} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {r1_burst_size_i} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {r1_rstart_addr_i} -port_direction {IN} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {r2_burst_size_i} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {r2_rstart_addr_i} -port_direction {IN} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {r3_burst_size_i} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {r3_rstart_addr_i} -port_direction {IN} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {rdata_0} -port_direction {IN} -port_range {[255:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {rid_0} -port_direction {IN} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {rresp_0} -port_direction {IN} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {w0_burst_size_i} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {w0_data_i} -port_direction {IN} -port_range {[255:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {w0_wstart_addr_i} -port_direction {IN} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {w1_burst_size_i} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {w1_data_i} -port_direction {IN} -port_range {[255:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {w1_wstart_addr_i} -port_direction {IN} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {w2_burst_size_i} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {w2_data_i} -port_direction {IN} -port_range {[255:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {w2_wstart_addr_i} -port_direction {IN} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {w3_burst_size_i} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {w3_data_i} -port_direction {IN} -port_range {[255:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {w3_wstart_addr_i} -port_direction {IN} -port_range {[31:0]}

sd_create_bus_port -sd_name ${sd_name} -port_name {araddr_0} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {arburst_0} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {arcache_0} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {arid_0} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {arlen_0} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {arlock_0} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {arprot_0} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {arsize_0} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {awaddr_0} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {awburst_0} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {awcache_0} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {awid_0} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {awlen_0} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {awlock_0} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {awprot_0} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {awsize_0} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {rdata_o} -port_direction {OUT} -port_range {[255:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {wdata_0} -port_direction {OUT} -port_range {[255:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {wstrb_0} -port_direction {OUT} -port_range {[31:0]}


# Create top level Bus interface Ports
sd_create_bif_port -sd_name ${sd_name} -port_name {BIF_1} -port_bif_vlnv {AMBA:AMBA4:AXI4:r0p0_0} -port_bif_role {master} -port_bif_mapping {\
"AWID:awid_0" \
"AWADDR:awaddr_0" \
"AWLEN:awlen_0" \
"AWSIZE:awsize_0" \
"AWBURST:awburst_0" \
"AWLOCK:awlock_0" \
"AWCACHE:awcache_0" \
"AWPROT:awprot_0" \
"AWVALID:awvalid_0" \
"AWREADY:awready_0" \
"WDATA:wdata_0" \
"WSTRB:wstrb_0" \
"WLAST:wlast_0" \
"WVALID:wvalid_0" \
"WREADY:wready_0" \
"BID:bid_0" \
"BRESP:bresp_0" \
"BVALID:bvalid_0" \
"BREADY:bready_0" \
"ARID:arid_0" \
"ARADDR:araddr_0" \
"ARLEN:arlen_0" \
"ARSIZE:arsize_0" \
"ARBURST:arburst_0" \
"ARLOCK:arlock_0" \
"ARCACHE:arcache_0" \
"ARPROT:arprot_0" \
"ARVALID:arvalid_0" \
"ARREADY:arready_0" \
"RID:rid_0" \
"RDATA:rdata_0" \
"RRESP:rresp_0" \
"RLAST:rlast_0" \
"RVALID:rvalid_0" \
"RREADY:rready_0" } 

# Add ddr_rw_arbiter_0 instance
sd_instantiate_hdl_core -sd_name ${sd_name} -hdl_core_name {ddr_rw_arbiter} -instance_name {ddr_rw_arbiter_0}
# Exporting Parameters of instance ddr_rw_arbiter_0
sd_configure_core_instance -sd_name ${sd_name} -instance_name {ddr_rw_arbiter_0} -params {\
"AXI_ADDR_WIDTH:32" \
"AXI_DATA_WIDTH:256" \
"AXI_ID_WIDTH:4" \
"AXI_LEN_WIDTH:8" \
"VIDEO_BUS_ASIZE:36" \
"VIDEO_BUS_DSIZE:256" }\
-validate_rules 0
sd_save_core_instance_config -sd_name ${sd_name} -instance_name {ddr_rw_arbiter_0}
sd_update_instance -sd_name ${sd_name} -instance_name {ddr_rw_arbiter_0}



# Add read_top_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {read_top} -instance_name {read_top_0}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {read_top_0:burst_size_o} -pin_slices {[15:8]}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {read_top_0:burst_size_o[15:8]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {read_top_0:burst_size_o} -pin_slices {[7:0]}



# Add write_top_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {write_top} -instance_name {write_top_0}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {write_top_0:burst_size_o} -pin_slices {[15:8]}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {write_top_0:burst_size_o[15:8]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {write_top_0:burst_size_o} -pin_slices {[7:0]}



# Add scalar net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_ctrl_ready" "ddr_rw_arbiter_0:ddr_ctrl_ready_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_rw_arbiter_0:ddr_clk_i" "read_top_0:sys_clk_i" "sys_clk_i" "write_top_0:sys_clk_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_rw_arbiter_0:rack_o" "read_top_0:ack_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_rw_arbiter_0:rdata_valid_o" "read_top_0:data_valid_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_rw_arbiter_0:rdone_o" "read_top_0:done_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_rw_arbiter_0:resetn_i" "read_top_0:reset_i" "reset_i" "write_top_0:reset_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_rw_arbiter_0:rreq_i" "read_top_0:req_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_rw_arbiter_0:wack_o" "write_top_0:ack_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_rw_arbiter_0:wdata_valid_i" "write_top_0:data_valid_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_rw_arbiter_0:wdone_o" "write_top_0:done_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_rw_arbiter_0:wreq_i" "write_top_0:req_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r0_ack_o" "read_top_0:r0_ack_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r0_data_valid_o" "read_top_0:r0_data_valid_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r0_done_o" "read_top_0:r0_done_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r0_req_i" "read_top_0:req0_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r1_ack_o" "read_top_0:r1_ack_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r1_data_valid_o" "read_top_0:r1_data_valid_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r1_done_o" "read_top_0:r1_done_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r1_req_i" "read_top_0:req1_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r2_ack_o" "read_top_0:r2_ack_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r2_data_valid_o" "read_top_0:r2_data_valid_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r2_done_o" "read_top_0:r2_done_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r2_req_i" "read_top_0:req2_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r3_ack_o" "read_top_0:r3_ack_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r3_data_valid_o" "read_top_0:r3_data_valid_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r3_done_o" "read_top_0:r3_done_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r3_req_i" "read_top_0:req3_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w0_ack_o" "write_top_0:w0_ack_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w0_data_valid_i" "write_top_0:w0_data_valid_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w0_done_o" "write_top_0:w0_done_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w0_req_i" "write_top_0:w0_req_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w1_ack_o" "write_top_0:w1_ack_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w1_data_valid_i" "write_top_0:w1_data_valid_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w1_done_o" "write_top_0:w1_done_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w1_req_i" "write_top_0:w1_req_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w2_ack_o" "write_top_0:w2_ack_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w2_data_valid_i" "write_top_0:w2_data_valid_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w2_done_o" "write_top_0:w2_done_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w2_req_i" "write_top_0:w2_req_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w3_ack_o" "write_top_0:w3_ack_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w3_data_valid_i" "write_top_0:w3_data_valid_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w3_done_o" "write_top_0:w3_done_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w3_req_i" "write_top_0:w3_req_i" }

# Add bus net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_rw_arbiter_0:beats_to_r_i" "read_top_0:burst_size_o[7:0]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_rw_arbiter_0:beats_to_w_i" "write_top_0:burst_size_o[7:0]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_rw_arbiter_0:rdata_o" "rdata_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_rw_arbiter_0:rstart_addr_i" "read_top_0:rstart_addr_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_rw_arbiter_0:wdata_i" "write_top_0:data_o_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_rw_arbiter_0:wstart_addr_i" "write_top_0:wstart_addr_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r0_burst_size_i" "read_top_0:r0_burst_size_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r0_rstart_addr_i" "read_top_0:r0_rstart_addr_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r1_burst_size_i" "read_top_0:r1_burst_size_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r1_rstart_addr_i" "read_top_0:r1_rstart_addr_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r2_burst_size_i" "read_top_0:r2_burst_size_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r2_rstart_addr_i" "read_top_0:r2_rstart_addr_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r3_burst_size_i" "read_top_0:r3_burst_size_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"r3_rstart_addr_i" "read_top_0:r3_rstart_addr_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w0_burst_size_i" "write_top_0:w0_burst_size_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w0_data_i" "write_top_0:w0_data_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w0_wstart_addr_i" "write_top_0:w0_wstart_addr_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w1_burst_size_i" "write_top_0:w1_burst_size_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w1_data_i" "write_top_0:w1_data_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w1_wstart_addr_i" "write_top_0:w1_wstart_addr_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w2_burst_size_i" "write_top_0:w2_burst_size_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w2_data_i" "write_top_0:w2_data_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w2_wstart_addr_i" "write_top_0:w2_wstart_addr_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w3_burst_size_i" "write_top_0:w3_burst_size_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w3_data_i" "write_top_0:w3_data_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"w3_wstart_addr_i" "write_top_0:w3_wstart_addr_i" }

# Add bus interface net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIF_1" "ddr_rw_arbiter_0:BIF_1" }

# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Save the SmartDesign 
save_smartdesign -sd_name ${sd_name}
# Generate SmartDesign "Video_arbiter_top"
generate_component -component_name ${sd_name}
