module proc_memory_top_level(SW,KEY,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5, CLOCK_50);

	//define the inputs and outputs to our module
	input 	[9:0] SW;
	input 	[1:0] KEY;
	input 			CLOCK_50;
	output 	[9:0] LEDR;
	output 	[7:0] HEX0;
	output 	[7:0] HEX1;
	output 	[7:0] HEX2;
	output 	[7:0] HEX3;
	output 	[7:0] HEX4;
	output 	[7:0] HEX5;
	
	// 22 bits gives MSB toggle at ~12 Hz from 50 MHz
    reg [21:0] counter = 22'b0;
	 wire clk10;
	 

    always @(posedge CLOCK_50) begin
        counter <= counter + 1;
    end
	 
	 assign clk10 = counter[21];
	 
	wire enable  		= SW[9]; 
	wire [8:0] DIN;
	wire [15:0] PC;
	
	wire reset 	= ~KEY[0];
	
	wire [15:0] bus;
	assign  LEDR = bus[9:0];

	
	wire [15:0] R0;
	wire [15:0] R1;
	wire [15:0] R2;
	wire [15:0] R3;
	wire [15:0] R4;
	wire [15:0] R5;
	wire [15:0] R6;
	wire [15:0] R7;

	addressMemory rom_inst (
		.address (PC),
		.clock   (clk10),
		.q       (DIN)
	);
	
	proc_memory manual(
		.clk (clk10),
		.rst (reset),
		.enable (enable),
		.PC (PC),
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


