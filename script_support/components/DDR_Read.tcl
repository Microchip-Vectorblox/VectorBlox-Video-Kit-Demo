# Creating SmartDesign DDR_Read
set sd_name {DDR_Read}
create_smartdesign -sd_name ${sd_name}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Scalar Ports
sd_create_scalar_port -sd_name ${sd_name} -port_name {ddr_data_valid_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {disp_clk_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {frame_end_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {read_ackn_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {read_done_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {read_en_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {reset_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {sys_clk_i} -port_direction {IN}

sd_create_scalar_port -sd_name ${sd_name} -port_name {data_valid_o} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {read_req_o} -port_direction {OUT}


# Create top level Bus Ports
sd_create_bus_port -sd_name ${sd_name} -port_name {frame_start_addr_i} -port_direction {IN} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {horz_resl_i} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {line_gap_i} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {wdata_i} -port_direction {IN} -port_range {[255:0]}

sd_create_bus_port -sd_name ${sd_name} -port_name {beats_to_read_o} -port_direction {OUT} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {data_o} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {read_start_addr_o} -port_direction {OUT} -port_range {[31:0]}


# Add AND2_0 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {AND2} -instance_name {AND2_0}
sd_invert_pins -sd_name ${sd_name} -pin_names {AND2_0:B}



# Add data_unpacker_0 instance
sd_instantiate_hdl_module -sd_name ${sd_name} -hdl_module_name {data_unpacker} -hdl_file {hdl\data_unpacker.vhd} -instance_name {data_unpacker_0}



# Add DDR_read_controller_0 instance
sd_instantiate_hdl_module -sd_name ${sd_name} -hdl_module_name {DDR_read_controller} -hdl_file {hdl\DDR_read_controller.vhd} -instance_name {DDR_read_controller_0}



# Add video_fifo_0 instance
sd_instantiate_hdl_core -sd_name ${sd_name} -hdl_core_name {video_fifo} -instance_name {video_fifo_0}
# Exporting Parameters of instance video_fifo_0
sd_configure_core_instance -sd_name ${sd_name} -instance_name {video_fifo_0} -params {\
"g_HALF_EMPTY_THRESHOLD:1280" \
"g_INPUT_VIDEO_DATA_BIT_WIDTH:256" \
"g_VIDEO_FIFO_AWIDTH:10" }\
-validate_rules 0
sd_save_core_instance_config -sd_name ${sd_name} -instance_name {video_fifo_0}
sd_update_instance -sd_name ${sd_name} -instance_name {video_fifo_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {video_fifo_0:wfull_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {video_fifo_0:wafull_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {video_fifo_0:rempty_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {video_fifo_0:raempty_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {video_fifo_0:rhempty_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {video_fifo_0:wdata_count_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {video_fifo_0:rdata_count_o}



# Add scalar net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:A" "DDR_read_controller_0:reset_i" "data_unpacker_0:reset_i" "reset_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:B" "DDR_read_controller_0:frame_end_i" "frame_end_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:Y" "video_fifo_0:rresetn_i" "video_fifo_0:wresetn_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_read_controller_0:read_ackn_i" "read_ackn_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_read_controller_0:read_done_i" "read_done_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_read_controller_0:read_en_i" "data_unpacker_0:read_en_i" "read_en_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_read_controller_0:read_req_o" "read_req_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_read_controller_0:sys_clk_i" "sys_clk_i" "video_fifo_0:wclock_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"data_unpacker_0:data_valid_o" "data_valid_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"data_unpacker_0:disp_clk_i" "disp_clk_i" "video_fifo_0:rclock_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"data_unpacker_0:fifo_data_valid_i" "video_fifo_0:rdata_rdy_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"data_unpacker_0:fifo_read_o" "video_fifo_0:ren_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ddr_data_valid_i" "video_fifo_0:wen_i" }

# Add bus net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_read_controller_0:frame_start_addr_i" "frame_start_addr_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_read_controller_0:line_gap_i" "line_gap_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_read_controller_0:read_start_addr_o" "read_start_addr_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"beats_to_read_o" "data_unpacker_0:beats_to_read_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"data_o" "data_unpacker_0:data_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"data_unpacker_0:data_i" "video_fifo_0:rdata_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"data_unpacker_0:horz_resl_i" "horz_resl_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"video_fifo_0:wdata_i" "wdata_i" }


# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Save the smartDesign
save_smartdesign -sd_name ${sd_name}
# Generate SmartDesign DDR_Read
generate_component -component_name ${sd_name}
