module register_n(data_in, r_in, clk, Q, rst);


	// To set parameter N during instantiation, you can use:
	// register_n #(.N(num_bits)) reg_IR(.....), 
	// where num_bits is how many bits you want to set N to
	// and "..." is your usual input/output signals
	
	parameter N = 16;

	/* 
	 * This module implements registers that will be used in the processor.
	 */
	// TODO: Declare inputs, outputs, and parameter:
	input wire [N-1:0] data_in;
	input wire r_in;
	input wire clk;
	input wire rst;
	output wire [N-1:0] Q;
	
	always @(posedge clk) begin 
		if (rst) begin
		Q <= 'd0;
		end 
		else if (r_in) begin
		Q <= data_in;
		end
	end
endmodule