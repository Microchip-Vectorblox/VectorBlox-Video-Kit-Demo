# Exporting core axi_passthru to TCL
# Exporting Create HDL core command for module axi_passthru
create_hdl_core -file {hdl/axi_passthru.vhd} -module {axi_passthru} -library {work} -package {}
# Exporting BIF information of  HDL core command for module axi_passthru
hdl_core_add_bif -hdl_core_name {axi_passthru} -bif_definition {AXI4:AMBA:AMBA4:master} -bif_name {m_axi} -signal_map {\
"AWID:m_axi_awid" \
"AWADDR:m_axi_awaddr" \
"AWLEN:m_axi_awlen" \
"AWSIZE:m_axi_awsize" \
"AWBURST:m_axi_awburst" \
"AWCACHE:m_axi_awcache" \
"AWPROT:m_axi_awprot" \
"AWVALID:m_axi_awvalid" \
"AWREADY:m_axi_awready" \
"WDATA:m_axi_wdata" \
"WSTRB:m_axi_wstrb" \
"WLAST:m_axi_wlast" \
"WVALID:m_axi_wvalid" \
"WREADY:m_axi_wready" \
"BID:m_axi_bid" \
"BRESP:m_axi_bresp" \
"BVALID:m_axi_bvalid" \
"BREADY:m_axi_bready" \
"ARID:m_axi_arid" \
"ARADDR:m_axi_araddr" \
"ARLEN:m_axi_arlen" \
"ARSIZE:m_axi_arsize" \
"ARBURST:m_axi_arburst" \
"ARCACHE:m_axi_arcache" \
"ARPROT:m_axi_arprot" \
"ARVALID:m_axi_arvalid" \
"ARREADY:m_axi_arready" \
"RID:m_axi_rid" \
"RDATA:m_axi_rdata" \
"RRESP:m_axi_rresp" \
"RLAST:m_axi_rlast" \
"RVALID:m_axi_rvalid" \
"RREADY:m_axi_rready" }
hdl_core_add_bif -hdl_core_name {axi_passthru} -bif_definition {AXI4:AMBA:AMBA4:slave} -bif_name {s_axi} -signal_map {\
"AWID:s_axi_awid" \
"AWADDR:s_axi_awaddr" \
"AWLEN:s_axi_awlen" \
"AWSIZE:s_axi_awsize" \
"AWBURST:s_axi_awburst" \
"AWVALID:s_axi_awvalid" \
"AWREADY:s_axi_awready" \
"WDATA:s_axi_wdata" \
"WSTRB:s_axi_wstrb" \
"WLAST:s_axi_wlast" \
"WVALID:s_axi_wvalid" \
"WREADY:s_axi_wready" \
"BID:s_axi_bid" \
"BRESP:s_axi_bresp" \
"BVALID:s_axi_bvalid" \
"BREADY:s_axi_bready" \
"ARID:s_axi_arid" \
"ARADDR:s_axi_araddr" \
"ARLEN:s_axi_arlen" \
"ARSIZE:s_axi_arsize" \
"ARBURST:s_axi_arburst" \
"ARVALID:s_axi_arvalid" \
"ARREADY:s_axi_arready" \
"RID:s_axi_rid" \
"RDATA:s_axi_rdata" \
"RRESP:s_axi_rresp" \
"RLAST:s_axi_rlast" \
"RVALID:s_axi_rvalid" \
"RREADY:s_axi_rready" }
