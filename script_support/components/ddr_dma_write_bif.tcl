# Exporting core ddr_dma_write_bif to TCL
# Exporting Create HDL core command for module ddr_dma_write_bif
create_hdl_core -file {hdl/ddr_dma_write_bif.vhd} -module {ddr_dma_write_bif} -library {work} -package {}
# Exporting BIF information of  HDL core command for module ddr_dma_write_bif
hdl_core_add_bif -hdl_core_name {ddr_dma_write_bif} -bif_definition {AXI4:AMBA:AMBA4:master} -bif_name {Write_Channel} -signal_map {\
"AWADDR:AWADDR" \
"AWSIZE:AWLEN" \
"AWVALID:AWVALID" \
"AWREADY:AWREADY" \
"WDATA:WDATA" \
"WVALID:WVALID" \
"BUSER:BUSER" }
