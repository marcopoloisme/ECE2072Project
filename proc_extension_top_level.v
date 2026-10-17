module proc_extension_top_level(SW,KEY,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);

	//define the inputs and outputs to our module
	input 	[9:0] SW;
	input 	[1:0] KEY;
	output 	[9:0] LEDR;
	output 	[7:0] HEX0;
	output 	[7:0] HEX1;
	output 	[7:0] HEX2;
	output 	[7:0] HEX3;
	output 	[7:0] HEX4;
	output 	[7:0] HEX5;
	
	wire enable  		= SW[9]; 
	wire [8:0] DIN 	= SW[8:0];
	
	wire reset 	= ~KEY[0];
	wire clk   	= ~KEY[1];
	
	wire [15:0] bus;
	assign  LEDR = bus[9:0];
	
	
	wire [3:0] result; 
	wire [3:0] tick; 

	
	wire [15:0] R0;
	wire [15:0] R1;
	wire [15:0] R2;
	wire [15:0] R3;
	wire [15:0] R4;
	wire [15:0] R5;
	wire [15:0] R6;
	wire [15:0] R7;

	reg [3:0] test_counter;

	
	proc_extension manual(
		.clk (clk),
		.rst (reset),
		.enable (enable),
		.din (DIN),
		.bus (bus),
		.R0 (R0),
		.R1 (R1),
		.R2 (R2),
		.R3 (R3),
		.R4 (R4),
		.R5 (R5),
		.R6 (R6),
		.R7 (R7),
		.sevenSeg0 (HEX0),
		.sevenSeg1 (HEX1),
		.sevenSeg2 (HEX2),
		.sevenSeg3 (HEX3),
		.sevenSeg4 (HEX4),
		.sevenSeg5 (HEX5)
	);

endmodule