download_core -vlnv {Microchip:SolutionCore:core_vectorblox:1.1.12} -location {www.microchip-ip.com/repositories/DirectCore} 
cd $local_dir/script_support/additional_configurations/Vectorblox/
source Vectorblox_ss_recursive.tcl
sd_instantiate_component -sd_name {SEVPFSOC_TOP} -component_name {Vectorblox_ss} -instance_name {Vectorblox_ss_0} 

source FIC0_INITIATOR_VBX.tcl
sd_instantiate_component -sd_name {SEVPFSOC_TOP} -component_name {FIC0_INITIATOR} -instance_name {FIC0_INITIATOR} 


# Add axi_master_scale_updown_bilinear_top_0 instance
sd_instantiate_hdl_core -sd_name {SEVPFSOC_TOP} -hdl_core_name {axi_master_scale_updown_bilinear_top} -instance_name {axi_master_scale_updown_bilinear_top_0}
sd_invert_pins -sd_name {SEVPFSOC_TOP} -pin_names {axi_master_scale_updown_bilinear_top_0:reset}
sd_connect_pins_to_constant -sd_name {SEVPFSOC_TOP} -pin_names {axi_master_scale_updown_bilinear_top_0:start} -value {GND}
sd_mark_pins_unused -sd_name {SEVPFSOC_TOP} -pin_names {axi_master_scale_updown_bilinear_top_0:ready}
sd_mark_pins_unused -sd_name {SEVPFSOC_TOP} -pin_names {axi_master_scale_updown_bilinear_top_0:finish}
sd_mark_pins_unused -sd_name {SEVPFSOC_TOP} -pin_names {Vectorblox_ss_0:vbx_resetn}


# Add axi_master_warpPerspective_top_0 instance
sd_instantiate_hdl_core -sd_name {SEVPFSOC_TOP} -hdl_core_name {axi_master_warpPerspective_top} -instance_name {axi_master_warpPerspective_top_0}
sd_invert_pins -sd_name {SEVPFSOC_TOP} -pin_names {axi_master_warpPerspective_top_0:reset}
sd_connect_pins_to_constant -sd_name {SEVPFSOC_TOP} -pin_names {axi_master_warpPerspective_top_0:start} -value {GND}
sd_mark_pins_unused -sd_name {SEVPFSOC_TOP} -pin_names {axi_master_warpPerspective_top_0:ready}
sd_mark_pins_unused -sd_name {SEVPFSOC_TOP} -pin_names {axi_master_warpPerspective_top_0:finish}

# Add draw_assist_0 instance
sd_instantiate_hdl_core -sd_name {SEVPFSOC_TOP} -hdl_core_name {draw_assist} -instance_name {draw_assist_0}
# Exporting Parameters of instance draw_assist_0
sd_configure_core_instance -sd_name {SEVPFSOC_TOP} -instance_name {draw_assist_0} -params {\
"M_AXI_DATA_WIDTH:256" \
"MAX_LOG2_BURSTLENGTH:6" }\
-validate_rules 0
sd_save_core_instance_config -sd_name {SEVPFSOC_TOP} -instance_name {draw_assist_0}
sd_update_instance -sd_name {SEVPFSOC_TOP} -instance_name {draw_assist_0}



# sd_disconnect_pins -sd_name {SEVPFSOC_TOP} -pin_names {MSS:FIC_2_ACLK} 
# sd_disconnect_pins -sd_name {SEVPFSOC_TOP} -pin_names {MSS:FIC_0_ACLK} 
#connect pins 
sd_connect_pins -sd_name {SEVPFSOC_TOP} -pin_names { "Vectorblox_ss_0:S_control"    "FIC0_INITIATOR:AXI4mslave2" } 
sd_connect_pins -sd_name {SEVPFSOC_TOP} -pin_names { "Vectorblox_ss_0:vbx_clk" "FIC0_INITIATOR:S_CLK2" "COREAXI4INTERCONNECT_C0_0:M_CLK1"} 
sd_connect_pins -sd_name {SEVPFSOC_TOP} -pin_names { "Vectorblox_ss_0:EXT_RST_N"    "MSS:MSS_RESET_N_M2F"} 
sd_connect_pins -sd_name {SEVPFSOC_TOP} -pin_names { "Vectorblox_ss_0:M_AXI"  "COREAXI4INTERCONNECT_C0_0:AXI4mmaster1"}
sd_connect_pins -sd_name {SEVPFSOC_TOP} -pin_names { "Vectorblox_ss_0:INIT_DONE"    "CLOCKS_AND_RESETS:DEVICE_INIT_DONE"}
sd_connect_pins -sd_name {SEVPFSOC_TOP} -pin_names { "Vectorblox_ss_0:REF_CLK_0"    "CLOCKS_AND_RESETS:CLK_50MHz" } 


sd_connect_pins -sd_name {SEVPFSOC_TOP} -pin_names { "FIC0_INITIATOR:ACLK"    "CLOCKS_AND_RESETS:CLK_125MHz" } 
sd_connect_pins -sd_name {SEVPFSOC_TOP} -pin_names { "FIC0_INITIATOR:ARESETN" "CLOCKS_AND_RESETS:RESETN_125MHz" } 
sd_connect_pins -sd_name {SEVPFSOC_TOP} -pin_names { "FIC0_INITIATOR:AXI4mmaster0" "MSS:FIC_0_AXI4_INITIATOR"} 
# sd_connect_pins -sd_name {SEVPFSOC_TOP} -pin_names { "CLOCKS_AND_RESETS:CLK_125MHz" "MSS:FIC_0_ACLK" "COREAXI4INTERCONNECT_C0_0:M_CLK0" } 

sd_connect_pins -sd_name {SEVPFSOC_TOP} -pin_names { "CLOCKS_AND_RESETS:RESETN_100MHz" "axi_master_scale_updown_bilinear_top_0:reset" "axi_master_warpPerspective_top_0:reset"  "draw_assist_0:resetn"} 
sd_connect_pins -sd_name {SEVPFSOC_TOP} -pin_names { "CLOCKS_AND_RESETS:CLK_100MHz" "COREAXI4INTERCONNECT_C0_0:M_CLK2" "COREAXI4INTERCONNECT_C0_0:M_CLK3" "COREAXI4INTERCONNECT_C0_0:M_CLK4" }
sd_connect_pins -sd_name {SEVPFSOC_TOP} -pin_names { "CLOCKS_AND_RESETS:CLK_100MHz" "FIC0_INITIATOR:S_CLK3" "FIC0_INITIATOR:S_CLK4" "FIC0_INITIATOR:S_CLK5"}
sd_connect_pins -sd_name {SEVPFSOC_TOP} -pin_names { "CLOCKS_AND_RESETS:CLK_100MHz" "axi_master_scale_updown_bilinear_top_0:clk" "axi_master_warpPerspective_top_0:clk" "draw_assist_0:clk" } 

sd_connect_pins -sd_name {SEVPFSOC_TOP} -pin_names { "axi_master_scale_updown_bilinear_top_0:axi_s" "FIC0_INITIATOR:AXI4mslave3" } 
sd_connect_pins -sd_name {SEVPFSOC_TOP} -pin_names { "axi_master_warpPerspective_top_0:axi_s" "FIC0_INITIATOR:AXI4mslave4" } 
sd_connect_pins -sd_name {SEVPFSOC_TOP} -pin_names { "draw_assist_0:s_axi" "FIC0_INITIATOR:AXI4mslave5" } 

sd_connect_pins -sd_name {SEVPFSOC_TOP} -pin_names { "axi_master_scale_updown_bilinear_top_0:master" "COREAXI4INTERCONNECT_C0_0:AXI4mmaster2" } 
sd_connect_pins -sd_name {SEVPFSOC_TOP} -pin_names { "axi_master_warpPerspective_top_0:master" "COREAXI4INTERCONNECT_C0_0:AXI4mmaster3" } 
sd_connect_pins -sd_name {SEVPFSOC_TOP} -pin_names { "draw_assist_0:m_axi" "COREAXI4INTERCONNECT_C0_0:AXI4mmaster4" } 


#get ready for building
generate_component -component_name {SEVPFSOC_TOP} -recursive 0 
build_design_hierarchy 
derive_constraints_sdc

 
configure_tool -name {SYNTHESIZE} \
-params {AUTO_COMPILE_POINT:false} \
-params {BLOCK_MODE:false} \
-params {BLOCK_PLACEMENT_CONFLICTS:ERROR} \
-params {BLOCK_ROUTING_CONFLICTS:LOCK} \
-params {CLOCK_ASYNC:800} \
-params {CLOCK_DATA:5000} \
-params {CLOCK_GATE_ENABLE:false} \
-params {CLOCK_GATE_ENABLE_THRESHOLD_GLOBAL:1000} \
-params {CLOCK_GATE_ENABLE_THRESHOLD_ROW:100} \
-params {CLOCK_GLOBAL:2} \
-params {PA4_GB_COUNT:36} \
-params {PA4_GB_MAX_RCLKINT_INSERTION:16} \
-params {PA4_GB_MIN_GB_FANOUT_TO_USE_RCLKINT:1000} \
-params {RAM_OPTIMIZED_FOR_POWER:0} \
-params {RETIMING:true} \
-params {ROM_TO_LOGIC:true} \
-params {SEQSHIFT_TO_URAM:1} \
-params {SYNPLIFY_OPTIONS:} \
-params {SYNPLIFY_TCL_FILE:} 

configure_tool -name {PLACEROUTE} \
-params {DELAY_ANALYSIS:MAX} \
-params {EFFORT_LEVEL:true} \
-params {GB_DEMOTION:true} \
-params {INCRPLACEANDROUTE:false} \
-params {IOREG_COMBINING:false} \
-params {MULTI_PASS_CRITERIA:VIOLATIONS} \
-params {MULTI_PASS_LAYOUT:true} \
-params {NUM_MULTI_PASSES:20} \
-params {PDPR:false} \
-params {RANDOM_SEED:0} \
-params {REPAIR_MIN_DELAY:true} \
-params {REPLICATION:true} \
-params {SLACK_CRITERIA:WORST_SLACK} \
-params {SPECIFIC_CLOCK:} \
-params {START_SEED_INDEX:1} \
-params {STOP_ON_FIRST_PASS:true} \
-params {TDPR:true} 


configure_tool -name {VERIFYTIMING} \
-params {CONSTRAINTS_COVERAGE:1} \
-params {FORMAT:XML} \
-params {MAX_EXPANDED_PATHS_TIMING:1} \
-params {MAX_EXPANDED_PATHS_VIOLATION:0} \
-params {MAX_PARALLEL_PATHS_TIMING:1} \
-params {MAX_PARALLEL_PATHS_VIOLATION:1} \
-params {MAX_PATHS_INTERACTIVE_REPORT:1000} \
-params {MAX_PATHS_TIMING:5} \
-params {MAX_PATHS_VIOLATION:20} \
-params {MAX_TIMING_FAST_HV_LT:1} \
-params {MAX_TIMING_MULTI_CORNER:1} \
-params {MAX_TIMING_SLOW_LV_HT:1} \
-params {MAX_TIMING_SLOW_LV_LT:1} \
-params {MAX_TIMING_VIOLATIONS_FAST_HV_LT:1} \
-params {MAX_TIMING_VIOLATIONS_MULTI_CORNER:1} \
-params {MAX_TIMING_VIOLATIONS_SLOW_LV_HT:1} \
-params {MAX_TIMING_VIOLATIONS_SLOW_LV_LT:1} \
-params {MIN_TIMING_FAST_HV_LT:1} \
-params {MIN_TIMING_MULTI_CORNER:1} \
-params {MIN_TIMING_SLOW_LV_HT:1} \
-params {MIN_TIMING_SLOW_LV_LT:1} \
-params {MIN_TIMING_VIOLATIONS_FAST_HV_LT:1} \
-params {MIN_TIMING_VIOLATIONS_MULTI_CORNER:1} \
-params {MIN_TIMING_VIOLATIONS_SLOW_LV_HT:1} \
-params {MIN_TIMING_VIOLATIONS_SLOW_LV_LT:1} \
-params {SLACK_THRESHOLD_VIOLATION:0.0} \
-params {SMART_INTERACTIVE:1} 


cd $local_dir
