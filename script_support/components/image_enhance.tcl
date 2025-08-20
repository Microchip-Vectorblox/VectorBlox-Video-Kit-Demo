# Creating SmartDesign "image_enhance"
set sd_name {image_enhance}
create_smartdesign -sd_name ${sd_name}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Scalar Ports
sd_create_scalar_port -sd_name ${sd_name} -port_name {DATA_VALID_I} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {ENABLE_I} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {RESETN_I} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SYS_CLK_I} -port_direction {IN}

sd_create_scalar_port -sd_name ${sd_name} -port_name {DATA_VALID_O} -port_direction {OUT}


# Create top level Bus Ports
sd_create_bus_port -sd_name ${sd_name} -port_name {B_CONST_I} -port_direction {IN} -port_range {[9:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {B_I_0} -port_direction {IN} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {B_I_1} -port_direction {IN} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {B_I_2} -port_direction {IN} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {B_I_3} -port_direction {IN} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {COMMON_CONST_I} -port_direction {IN} -port_range {[19:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {G_CONST_I} -port_direction {IN} -port_range {[9:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {G_I_0} -port_direction {IN} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {G_I_1} -port_direction {IN} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {G_I_2} -port_direction {IN} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {G_I_3} -port_direction {IN} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {R_CONST_I} -port_direction {IN} -port_range {[9:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {R_I_0} -port_direction {IN} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {R_I_1} -port_direction {IN} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {R_I_2} -port_direction {IN} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {R_I_3} -port_direction {IN} -port_range {[7:0]}

sd_create_bus_port -sd_name ${sd_name} -port_name {B_O_0} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {B_O_1} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {B_O_2} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {B_O_3} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {G_O_0} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {G_O_1} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {G_O_2} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {G_O_3} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {R_O_0} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {R_O_1} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {R_O_2} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {R_O_3} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {blue_mean_o} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {blue_var_o} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {green_mean_o} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {green_var_o} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {red_mean_o} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {red_var_o} -port_direction {OUT} -port_range {[31:0]}


# Add Image_Enhancement_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {Image_Enhancement_C0} -instance_name {Image_Enhancement_C0_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {Image_Enhancement_C0_0:DATA_VALID_O}



# Add Image_Enhancement_C0_1 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {Image_Enhancement_C0} -instance_name {Image_Enhancement_C0_1}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {Image_Enhancement_C0_1:DATA_VALID_O}



# Add Image_Enhancement_C0_2 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {Image_Enhancement_C0} -instance_name {Image_Enhancement_C0_2}



# Add Image_Enhancement_C0_3 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {Image_Enhancement_C0} -instance_name {Image_Enhancement_C0_3}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {Image_Enhancement_C0_3:DATA_VALID_O}



# Add pixel_average_0 instance
sd_instantiate_hdl_module -sd_name ${sd_name} -hdl_module_name {pixel_average} -hdl_file {hdl/pixel_average.vhd} -instance_name {pixel_average_0}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {pixel_average_0:red_i} -pin_slices {[15:8]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {pixel_average_0:red_i} -pin_slices {[23:16]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {pixel_average_0:red_i} -pin_slices {[31:24]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {pixel_average_0:red_i} -pin_slices {[7:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {pixel_average_0:green_i} -pin_slices {[15:8]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {pixel_average_0:green_i} -pin_slices {[23:16]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {pixel_average_0:green_i} -pin_slices {[31:24]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {pixel_average_0:green_i} -pin_slices {[7:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {pixel_average_0:blue_i} -pin_slices {[15:8]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {pixel_average_0:blue_i} -pin_slices {[23:16]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {pixel_average_0:blue_i} -pin_slices {[31:24]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {pixel_average_0:blue_i} -pin_slices {[7:0]}



# Add scalar net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"DATA_VALID_I" "Image_Enhancement_C0_0:DATA_VALID_I" "Image_Enhancement_C0_1:DATA_VALID_I" "Image_Enhancement_C0_2:DATA_VALID_I" "Image_Enhancement_C0_3:DATA_VALID_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DATA_VALID_O" "Image_Enhancement_C0_2:DATA_VALID_O" "pixel_average_0:pix_valid_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ENABLE_I" "Image_Enhancement_C0_0:ENABLE_I" "Image_Enhancement_C0_1:ENABLE_I" "Image_Enhancement_C0_2:ENABLE_I" "Image_Enhancement_C0_3:ENABLE_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Image_Enhancement_C0_0:RESETN_I" "Image_Enhancement_C0_1:RESETN_I" "Image_Enhancement_C0_2:RESETN_I" "Image_Enhancement_C0_3:RESETN_I" "RESETN_I" "pixel_average_0:resetn" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Image_Enhancement_C0_0:SYS_CLK_I" "Image_Enhancement_C0_1:SYS_CLK_I" "Image_Enhancement_C0_2:SYS_CLK_I" "Image_Enhancement_C0_3:SYS_CLK_I" "SYS_CLK_I" "pixel_average_0:clk" }

# Add bus net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"B_CONST_I" "Image_Enhancement_C0_0:B_CONST_I" "Image_Enhancement_C0_1:B_CONST_I" "Image_Enhancement_C0_2:B_CONST_I" "Image_Enhancement_C0_3:B_CONST_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"B_I_0" "Image_Enhancement_C0_0:B_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"B_I_1" "Image_Enhancement_C0_1:B_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"B_I_2" "Image_Enhancement_C0_2:B_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"B_I_3" "Image_Enhancement_C0_3:B_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"B_O_0" "Image_Enhancement_C0_0:B_O" "pixel_average_0:blue_i[7:0]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"B_O_1" "Image_Enhancement_C0_1:B_O" "pixel_average_0:blue_i[15:8]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"B_O_2" "Image_Enhancement_C0_2:B_O" "pixel_average_0:blue_i[23:16]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"B_O_3" "Image_Enhancement_C0_3:B_O" "pixel_average_0:blue_i[31:24]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COMMON_CONST_I" "Image_Enhancement_C0_0:COMMON_CONST_I" "Image_Enhancement_C0_1:COMMON_CONST_I" "Image_Enhancement_C0_2:COMMON_CONST_I" "Image_Enhancement_C0_3:COMMON_CONST_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"G_CONST_I" "Image_Enhancement_C0_0:G_CONST_I" "Image_Enhancement_C0_1:G_CONST_I" "Image_Enhancement_C0_2:G_CONST_I" "Image_Enhancement_C0_3:G_CONST_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"G_I_0" "Image_Enhancement_C0_0:G_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"G_I_1" "Image_Enhancement_C0_1:G_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"G_I_2" "Image_Enhancement_C0_2:G_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"G_I_3" "Image_Enhancement_C0_3:G_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"G_O_0" "Image_Enhancement_C0_0:G_O" "pixel_average_0:green_i[7:0]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"G_O_1" "Image_Enhancement_C0_1:G_O" "pixel_average_0:green_i[15:8]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"G_O_2" "Image_Enhancement_C0_2:G_O" "pixel_average_0:green_i[23:16]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"G_O_3" "Image_Enhancement_C0_3:G_O" "pixel_average_0:green_i[31:24]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Image_Enhancement_C0_0:R_CONST_I" "Image_Enhancement_C0_1:R_CONST_I" "Image_Enhancement_C0_2:R_CONST_I" "Image_Enhancement_C0_3:R_CONST_I" "R_CONST_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Image_Enhancement_C0_0:R_I" "R_I_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Image_Enhancement_C0_0:R_O" "R_O_0" "pixel_average_0:red_i[7:0]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Image_Enhancement_C0_1:R_I" "R_I_1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Image_Enhancement_C0_1:R_O" "R_O_1" "pixel_average_0:red_i[15:8]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Image_Enhancement_C0_2:R_I" "R_I_2" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Image_Enhancement_C0_2:R_O" "R_O_2" "pixel_average_0:red_i[23:16]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Image_Enhancement_C0_3:R_I" "R_I_3" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Image_Enhancement_C0_3:R_O" "R_O_3" "pixel_average_0:red_i[31:24]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"blue_mean_o" "pixel_average_0:blue_mean_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"blue_var_o" "pixel_average_0:blue_var_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"green_mean_o" "pixel_average_0:green_mean_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"green_var_o" "pixel_average_0:green_var_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"pixel_average_0:red_mean_o" "red_mean_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"pixel_average_0:red_var_o" "red_var_o" }


# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Save the SmartDesign 
save_smartdesign -sd_name ${sd_name}
# Generate SmartDesign "image_enhance"
generate_component -component_name ${sd_name}
