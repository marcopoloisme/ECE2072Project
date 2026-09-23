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
	input [N:0] data_in,
	input r_in,
	input clk,
	input rst
	output Q
	
	always @(posedge clk) begin 
		if rst begin
		Q = N'd0
		end 
		if r_in begin
		Q = data_in
		end
endmodule