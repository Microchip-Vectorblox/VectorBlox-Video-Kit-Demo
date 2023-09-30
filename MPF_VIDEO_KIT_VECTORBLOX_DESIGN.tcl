
# // PF Video Kit VBX HDMI demo Libero design
#
# // Check Libero version and path lenth to verify project can be created
#

if {[string compare [string range [get_libero_version] 0 end-4] "2023.1"]==0} {
	puts "Libero v2023.1 detected."
} else {
	error "Incorrect Libero version. Please use Libero v2023.1 to run these scripts."
}

if { [lindex $tcl_platform(os) 0]  == "Windows" } {
	if {[string length [pwd]] < 90} {
		puts "Project path length ok."
	} else {
		error "Path to project is too long, please reduce the path and try again."
	}
}

#
# // Process arguments
#

if { $::argc > 0 } {
    set i 1
    foreach arg $::argv {
        if {[string match "*:*" $arg]} {
            set temp [split $arg ":"]
            puts "Setting parameter [lindex $temp 0] to [lindex $temp 1]"
            set [lindex $temp 0] "[lindex $temp 1]"
        } else {
            set $arg 1
            puts "set $arg to 1"
        }
        incr i
    }
} else {
    puts "no command line argument passed"
}

#
# // Set required variables and add functions
#

set install_loc [defvar_get -name ACTEL_SW_DIR]
set local_dir [pwd]
set src_path ./script_support
set constraint_path ./script_support/constraint
set release_tag "2023.1"

set project_name "VKPF_VECTORBLOX"
set project_dir "$local_dir/$project_name"

source ./script_support/additional_configurations/functions.tcl

#
# // Create Libero project
#
if { [file exists $project_dir/$project_name.prjx] } {
    puts "Open existing project"
    open_project -file $project_dir/$project_name.prjx
} else {
    puts "Creating a new project"
    new_project \
	    -location $project_name \
	    -name $project_name \
	    -project_description {} \
	    -block_mode 0 \
	    -standalone_peripheral_initialization 0 \
	    -instantiate_in_smartdesign 1 \
	    -ondemand_build_dh 1 \
	    -use_relative_path 0 \
	    -linked_files_root_dir_env {} \
	    -hdl {VHDL} \
	    -family {PolarFire} \
	    -die {MPF300T} \
	    -package {FCG1152} \
	    -speed {-1} \
	    -die_voltage {1.0} \
	    -part_range {EXT} \
	    -adv_options {IO_DEFT_STD:LVCMOS 1.8V} \
	    -adv_options {RESTRICTPROBEPINS:1} \
	    -adv_options {RESTRICTSPIPINS:0} \
	    -adv_options {SYSTEM_CONTROLLER_SUSPEND_MODE:0} \
	    -adv_options {TEMPR:EXT} \
	    -adv_options {VCCI_1.2_VOLTR:EXT} \
	    -adv_options {VCCI_1.5_VOLTR:EXT} \
	    -adv_options {VCCI_1.8_VOLTR:EXT} \
	    -adv_options {VCCI_2.5_VOLTR:EXT} \
	    -adv_options {VCCI_3.3_VOLTR:EXT} \
	    -adv_options {VOLTR:EXT}

    #
    # // Download required cores
    #

    download_core -vlnv {Actel:DirectCore:CoreAHBLite:5.5.101} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Actel:DirectCore:COREAHBTOAPB3:3.2.101} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Actel:DirectCore:CoreAPB3:4.2.100} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Actel:DirectCore:COREAXI4INTERCONNECT:2.8.103} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Actel:DirectCore:COREAXITOAHBL:3.6.101} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Actel:DirectCore:CoreGPIO:3.2.102} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Actel:DirectCore:COREI2C:7.2.101} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Actel:DirectCore:COREJTAGDEBUG:3.1.100} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Actel:DirectCore:CORERESET_PF:2.3.100} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Actel:DirectCore:CORERXIODBITALIGN:2.2.100} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Actel:DirectCore:CORESPI:5.2.104} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Actel:DirectCore:CoreUARTapb:5.7.100} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Actel:SgCore:PF_CCC:2.2.220} -location {www.microchip-ip.com/repositories/SgCore}
    download_core -vlnv {Actel:SgCore:PF_INIT_MONITOR:2.0.307} -location {www.microchip-ip.com/repositories/SgCore}
    download_core -vlnv {Actel:SgCore:PF_XCVR_REF_CLK:1.0.103} -location {www.microchip-ip.com/repositories/SgCore}
    download_core -vlnv {Actel:SystemBuilder:PF_DDR4:2.5.111} -location {www.microchip-ip.com/repositories/SgCore}
    download_core -vlnv {Actel:SystemBuilder:PF_IOD_GENERIC_RX:2.1.110} -location {www.microchip-ip.com/repositories/SgCore}
    download_core -vlnv {Actel:SystemBuilder:PF_SRAM_AHBL_AXI:1.2.110} -location {www.microchip-ip.com/repositories/SgCore}
    download_core -vlnv {Actel:SystemBuilder:PF_XCVR_ERM:3.1.200} -location {www.microchip-ip.com/repositories/SgCore}
    download_core -vlnv {Microchip:SolutionCore:core_vectorblox:1.1.15} -location {www.microchip-ip.com/repositories/DirectCore} 
    download_core -vlnv {Microsemi:MiV:MIV_RV32IMA_L1_AXI:2.1.100}
    download_core -vlnv {Microsemi:SolutionCore:Bayer_Interpolation:3.0.2} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Microsemi:SolutionCore:Display_Controller:3.1.2} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Microsemi:SolutionCore:HDMI_RX:1.3.0} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Microsemi:SolutionCore:Image_Enhancement:3.0.0} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Microsemi:SolutionCore:mipicsi2rxdecoderPF:2.6.0} -location {www.microchip-ip.com/repositories/DirectCore}


    #This Tcl file sources other Tcl files to build the design(on which recursive export is run) in a bottom-up fashion

    #Sourcing the Tcl file in which all the HDL source files used in the design are imported or linked
    source ${src_path}/hdl_source.tcl
    build_design_hierarchy

    #Sourcing the Tcl files in which HDL+ core definitions are created for HDL modules
    source ${src_path}/components/video_fifo.tcl 
    source ${src_path}/components/data_packer.tcl 
    source ${src_path}/components/draw_assist.tcl 
    source ${src_path}/components/axi_passthru.tcl 
    source ${src_path}/components/axi_master_scale_updown_bilinear_top.tcl 
    source ${src_path}/components/axi_master_warpPerspective_top.tcl 
    source ${src_path}/components/ddr_rw_arbiter.tcl 
    source ${src_path}/components/apb3_if.tcl 
    source ${src_path}/components/axi_arbiter.tcl 
    source ${src_path}/components/ff_bus.tcl 
    source ${src_path}/components/vector_mux.tcl 
    build_design_hierarchy

    #Sourcing the Tcl files for creating individual ${src_path}/components under the top level
    source ${src_path}/components/Bayer_Interpolation_C0.tcl 
    source ${src_path}/components/CORERESET_PF_C1.tcl 
    source ${src_path}/components/DDR_Read.tcl 
    source ${src_path}/components/DDR_Write.tcl 
    source ${src_path}/components/Display_Controller_C0.tcl 
    source ${src_path}/components/CORERXIODBITALIGN_C0.tcl 
    source ${src_path}/components/CORERXIODBITALIGN_C1.tcl 
    source ${src_path}/components/CORERXIODBITALIGN_C2.tcl 
    source ${src_path}/components/CORERXIODBITALIGN_C3.tcl 
    source ${src_path}/components/PF_IOD_GENERIC_RX_C1.tcl 
    source ${src_path}/components/CAM_IOD_TIP_TOP.tcl 
    source ${src_path}/components/PF_CCC_C2.tcl 
    source ${src_path}/components/mipicsi2rxdecoderPF_C0.tcl 
    source ${src_path}/components/IMX334_IF_TOP.tcl 
    source ${src_path}/components/PF_CCC_C0.tcl 
    source ${src_path}/components/PF_CCC_C1.tcl 
    source ${src_path}/components/PF_DDR4_C0.tcl 
    source ${src_path}/components/PF_INIT_MONITOR_C0.tcl 
    source ${src_path}/components/COREAXITOAHBL_C0.tcl 
    source ${src_path}/components/COREI2C_C0.tcl 
    source ${src_path}/components/COREJTAGDEBUG_C0.tcl 
    source ${src_path}/components/CORESPI_C0.tcl 
    source ${src_path}/components/CoreUARTapb_MiV.tcl 
    source ${src_path}/components/DDR_Interconnect.tcl 
    source ${src_path}/components/MIV_RV32IMA_L1_AXI_C0.tcl 
    source ${src_path}/components/MiV_Interconnect.tcl 
    source ${src_path}/components/PF_SRAM_AHBL_AXI_C1.tcl 
    source ${src_path}/components/core_vectorblox_C1.tcl 
    source ${src_path}/components/PROC_SUBSYSTEM.tcl 
    source ${src_path}/components/read_top.tcl 
    source ${src_path}/components/write_top.tcl 
    source ${src_path}/components/Video_arbiter_top.tcl 
    source ${src_path}/components/CCC_EDID.tcl 
    source ${src_path}/components/DDR_Write_HDMI_RX.tcl 
    source ${src_path}/components/HDMI_RX_C1.tcl 
    source ${src_path}/components/PF_XCVR_ERM_C0.tcl 
    source ${src_path}/components/PF_XCVR_REF_CLK_C0.tcl 
    source ${src_path}/components/hdmi_rx_ss.tcl 
    source ${src_path}/components/Image_Enhancement_C0.tcl 
    source ${src_path}/components/image_enhance.tcl 
    source ${src_path}/components/VIDEO_KIT_TOP.tcl 
    build_design_hierarchy
    set_root -module {VIDEO_KIT_TOP::work}
    #
    # // Derive timing constraints
    #
    derive_constraints_sdc
    #
    # // Import I/O constraints
    #

    import_files \
	    -convert_EDN_to_HDL 0 \
	    -io_pdc "${constraint_path}/io/user.pdc" \
	    -io_pdc "${constraint_path}/io/hdmi_rx.pdc" \

    set_as_target -type {io_pdc} -file "${constraint_path}/io/user.pdc"
    set_as_target -type {io_pdc} -file "${constraint_path}/io/hdmi_rx.pdc"

    #
    # // Import timing constraint
    #

    import_files \
	    -convert_EDN_to_HDL 0 \
	    -sdc "${constraint_path}/user.sdc" \
	    -sdc "${constraint_path}/user1.sdc"

    set_as_target -type {sdc} -file "${constraint_path}/user.sdc"    
    set_as_target -type {sdc} -file "${constraint_path}/user1.sdc"    

    #
    # // Associate imported constraints with the design flow
    #
    organize_tool_files -tool {SYNTHESIZE} \
      -file "${project_dir}/constraint/VIDEO_KIT_TOP_derived_constraints.sdc" \
      -module {VIDEO_KIT_TOP::work} \
      -input_type {constraint} 
      
    organize_tool_files -tool {PLACEROUTE} \
	-file "${project_dir}/constraint/io/user.pdc" \
	-file "${project_dir}/constraint/io/hdmi_rx.pdc" \
	-file "${project_dir}/constraint/VIDEO_KIT_TOP_derived_constraints.sdc" \
	-file "${project_dir}/constraint/user.sdc" \
	-file "${project_dir}/constraint/user1.sdc" \
	-module {VIDEO_KIT_TOP::work} \
	-input_type {constraint}

    set_as_target -type {io_pdc} -file "${project_dir}/constraint/io/user.pdc"
    save_project 

    organize_tool_files -tool {VERIFYTIMING} \
	-file "${project_dir}/constraint/VIDEO_KIT_TOP_derived_constraints.sdc" \
	-file "${project_dir}/constraint/user.sdc" \
	-file "${project_dir}/constraint/user1.sdc" \
	-module {VIDEO_KIT_TOP::work} \
	-input_type {constraint}

    save_project 
}; # Create project

#
# // Run the design flow and add eNVM clients 
#

if {[info exists SYNTHESIZE]} {
    run_tool -name {SYNTHESIZE}
} 


configure_tool -name {PLACEROUTE} \
    -params {EFFORT_LEVEL:true} \
    -params {REPAIR_MIN_DELAY:true} \
    -params {IOREG_COMBINING:true} \
    -params {REPLICATION:true} \
    -params {RANDOM_SEED:1}

configure_tool -name {VERIFYTIMING} \
    -params {CONSTRAINTS_COVERAGE:1} \
    -params {FORMAT:XML} \
    -params {MAX_EXPANDED_PATHS_TIMING:1} \
    -params {MAX_EXPANDED_PATHS_VIOLATION:0} \
    -params {MAX_PARALLEL_PATHS_TIMING:1} \
    -params {MAX_PARALLEL_PATHS_VIOLATION:1} \
    -params {MAX_PATHS_INTERACTIVE_REPORT:1} \
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

if {[info exists PLACEROUTE]} {
    run_tool -name {PLACEROUTE}
} 

if {[info exists VERIFY_TIMING]} {
    run_tool -name {VERIFYTIMING}
}

if {[info exists GENERATE_PROGRAMMING_DATA]} {
run_tool -name {GENERATEPROGRAMMINGFILE} 

set spiflash_cfg hex/spiflash.cfg;
set ram_cfg script_support/RAM.cfg;

configure_ram -cfg_file $ram_cfg
configure_design_initialization_data \
-second_stage_start_address {0x00000000} \
-third_stage_uprom_start_address {0x00000000} \
-third_stage_snvm_start_address {0x00000000} \
-third_stage_spi_start_address {0x400} \
-third_stage_spi_type {SPIFLASH_NO_BINDING_PLAINTEXT} \
-third_stage_spi_clock_divider {6} \
-init_timeout 128 \
-auto_calib_timeout {3000} \
-broadcast_RAMs {1} 
generate_design_initialization_data 
configure_spiflash -cfg_file $spiflash_cfg
generate_design_initialization_data 

run_tool -name {GENERATE_SPI_FLASH_IMAGE} 
run_tool -name {GENERATEPROGRAMMINGFILE} 
}


if {[info exists EXPORT_FPE]} {   
export_prog_job \
         -export_dir $local_dir \
         -bitstream_file_type {TRUSTED_FACILITY} \
         -bitstream_file_components {FABRIC SNVM} \
         -zeroization_likenew_action 0 \
         -zeroization_unrecoverable_action 0 \
         -program_design 1 \
         -program_spi_flash 1 \
         -include_plaintext_passkey 0 \
         -design_bitstream_format {PPD} \
         -prog_optional_procedures {} \
         -skip_recommended_procedures {} \
         -sanitize_snvm 0 
 }

save_project
