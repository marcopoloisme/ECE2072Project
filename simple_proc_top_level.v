module simple_proc_top_level(SW,KEY,LEDR,HEX5);

	//define the inputs and outputs to our module
	input 	[8:0] SW;
	input 	[1:0] KEY;
	output 	[9:0] LEDR;
	output 	[6:0] HEX5;
	
	wire reset 	= ~KEY[0];
	wire clk   	= ~KEY[1];
	wire [15:0] bus;
	assign LEDR = bus[9:0];
	wire [3:0] result; 
	wire [3:0] tick; 
	wire negative = 1'b0;
	
	wire [15:0] R0;
	wire [15:0] R1;
	wire [15:0] R2;
	wire [15:0] R3;
	wire [15:0] R4;
	wire [15:0] R5;
	wire [15:0] R6;
	wire [15:0] R7;

	simple_proc manual(
		.clk (clk),
		.rst (reset),
		.din (SW),
		.bus (bus),
		.R0 (R0),
		.R1 (R1),
		.R2 (R2),
		.R3 (R3),
		.R4 (R4),
		.R5 (R5),
		.R6 (R6),
		.R7 (R7),
		.tick (tick)
	);

	tick_to_binary inst1 (
		.tick (tick),
		.result (result)
	);
	
	BCD inst2 (
    .data (result),
	 .negative (1'b0),
    .X (HEX5)
);

endmodule