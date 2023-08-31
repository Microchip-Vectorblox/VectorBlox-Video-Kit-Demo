#This Tcl file sources other Tcl files to build the design(on which recursive export is run) in a bottom-up fashion

#Sourcing the Tcl files for creating individual components under the top level
source components/CORERESET_PF_C4.tcl 
source components/core_vectorblox_C0.tcl 
source components/PF_CCC_C1.tcl 
source components/Vectorblox_ss.tcl 
build_design_hierarchy
