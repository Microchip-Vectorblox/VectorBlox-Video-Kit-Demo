# Exporting core axi_master_warpPerspective_top to TCL
# Exporting Create HDL core command for module axi_master_warpPerspective_top
create_hdl_core -file {hdl/warp.v} -module {axi_master_warpPerspective_top} -library {work} -package {}
# Exporting BIF information of  HDL core command for module axi_master_warpPerspective_top
hdl_core_add_bif -hdl_core_name {axi_master_warpPerspective_top} -bif_definition {AXI4:AMBA:AMBA4:slave} -bif_name {axi_s} -signal_map {\
"ARADDR:axi_s_ar_addr" \
"ARBURST:axi_s_ar_burst" \
"ARLEN:axi_s_ar_len" \
"ARREADY:axi_s_ar_ready" \
"ARSIZE:axi_s_ar_size" \
"ARVALID:axi_s_ar_valid" \
"AWADDR:axi_s_aw_addr" \
"AWBURST:axi_s_aw_burst" \
"AWLEN:axi_s_aw_len" \
"AWREADY:axi_s_aw_ready" \
"AWSIZE:axi_s_aw_size" \
"AWVALID:axi_s_aw_valid" \
"BRESP:axi_s_b_resp" \
"BREADY:axi_s_b_resp_ready" \
"BVALID:axi_s_b_resp_valid" \
"RDATA:axi_s_r_data" \
"RLAST:axi_s_r_last" \
"RREADY:axi_s_r_ready" \
"RRESP:axi_s_r_resp" \
"RVALID:axi_s_r_valid" \
"WDATA:axi_s_w_data" \
"WLAST:axi_s_w_last" \
"WREADY:axi_s_w_ready" \
"WSTRB:axi_s_w_strb" \
"WVALID:axi_s_w_valid" }
hdl_core_add_bif -hdl_core_name {axi_master_warpPerspective_top} -bif_definition {AXI4:AMBA:AMBA4:master} -bif_name {master} -signal_map {\
"ARADDR:master_ar_addr" \
"ARBURST:master_ar_burst" \
"ARLEN:master_ar_len" \
"ARREADY:master_ar_ready" \
"ARSIZE:master_ar_size" \
"ARVALID:master_ar_valid" \
"AWADDR:master_aw_addr" \
"AWBURST:master_aw_burst" \
"AWLEN:master_aw_len" \
"AWREADY:master_aw_ready" \
"AWSIZE:master_aw_size" \
"AWVALID:master_aw_valid" \
"BRESP:master_b_resp" \
"BREADY:master_b_resp_ready" \
"BVALID:master_b_resp_valid" \
"RDATA:master_r_data" \
"RLAST:master_r_last" \
"RREADY:master_r_ready" \
"RRESP:master_r_resp" \
"RVALID:master_r_valid" \
"WDATA:master_w_data" \
"WLAST:master_w_last" \
"WREADY:master_w_ready" \
"WSTRB:master_w_strb" \
"WVALID:master_w_valid" }
