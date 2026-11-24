# Exporting Component Description of DDR_Read_C0 to TCL
# Family: PolarFire
# Part Number: MPF300T-1FCG1152E
# Create and Configure the core component DDR_Read_C0
create_and_configure_core -core_vlnv {Microchip:SolutionCore:DDR_Read:1.2.0} -component_name {DDR_Read_C0} -params {\
"g_AXI4S_FORMAT:0"  \
"g_DDR_AXI_DWIDTH_I:512"  \
"g_DDR_AXI_DWIDTH_O:32"  \
"g_FORMAT:1"  \
"g_FRAME_GAP:0"  \
"g_HORIZ_RESOL:1920"  \
"g_NO_OF_PIXEL:1"   }
# Exporting Component Description of DDR_Read_C0 to TCL done
