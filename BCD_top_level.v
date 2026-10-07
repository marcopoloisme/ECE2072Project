module BCD_top_level (
input wire CLOCK_50,
input wire [9:0] SW,
input wire [1:0] KEY,

output wire [6:0] HEX0,
output wire [6:0] HEX1,
output wire [6:0] HEX2
);

wire [11:0] bcd_out;

//------------------------------------------------------------------
// Binary to BCD
//------------------------------------------------------------------
Binary_to_BCD #(
.N(8),
.N2(3)
) converter (
.clk(CLOCK_50),
.data_in(SW[7:0]),
.enable(~KEY[0]),
.result (bcd_out),
);

//------------------------------------------------------------------
// Seven-segment displays
//------------------------------------------------------------------
BCD seg0 (
.data(bcd_out[3:0]),
.X(HEX0)
);

BCD seg1 (
.data(bcd_out[7:4]),
.X(HEX1)
);

BCD seg2 (
.data(bcd_out[11:8]),
.X(HEX2)
);

endmodule