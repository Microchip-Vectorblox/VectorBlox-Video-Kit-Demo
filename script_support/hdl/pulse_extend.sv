module pulse_extend (
    input logic clk,
    input logic resetn,
    input logic sync_in,
    output logic sync_out
);

//logic [3:0] cnt;
logic [5:0] cnt;
always_ff @ (posedge clk or negedge resetn) begin
    if (!resetn) begin
        cnt <= '0;
        sync_out <= 0;
    end else if (sync_in) begin
        cnt <= '0;
        sync_out <= 1;
//    end else if (cnt == 7) begin
    end else if (cnt == 62) begin
        sync_out <= 0;
    end else begin
        cnt <= cnt + 1;
    end
end

endmodule