// combinational generic multiplier
`timescale 1ns / 1ns
module legup_mult_core(
    dataa,
    datab,
    result  
);

parameter widtha = 32;
parameter widthb = 32;
parameter widthp = 64;
parameter representation = "UNSIGNED";

input [widtha-1:0] dataa;
input [widthb-1:0] datab;
output [widthp-1:0] result;

generate
if (representation == "UNSIGNED")
begin

    reg [widthp-1:0] result;
    always @(*) begin
        result = dataa * datab;
    end   

end else begin

    reg signed [widthp-1:0] result;
    always @(*) begin
        result = dataa * datab;
    end  

end
endgenerate

endmodule
