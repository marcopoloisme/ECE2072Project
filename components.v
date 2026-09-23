/*
Monash University ECE2072: Assignment 
This file contains Verilog code to implement individual components to be used in 
    the CPU.

Please enter your name and student ID:

*/
module sign_extend(in, ext);
	/* 
	 * This module sign extends the 9-bit Din to a 16-bit output.
	 */
	// TODO: Declare inputs and outputs
	
	// TODO: implement logic
endmodule



module tick_FSM(rst, clk, enable, tick);
	/* 
	 * This module implements a tick FSM that will be used to
	 * control the actions of the control unit
	 */

	// TODO: Declare inputs and outputs
	
    // TODO: implement FSM
endmodule

module multiplexer(SignExtDin, R0, R1, R2, R3, R4, R5, R6, R7, G, sel, Bus);
    input wire [15:0] R0; //registor 0 
    input wire [15:0] R1; //registor 1
    input wire [15:0] R2; //..
	 input wire [15:0] R3;
	 input wire [15:0] R4;
	 input wire [15:0] R5;
	 input wire [15:0] R6;
	 input wire [15:0] R7;//registor 7
	 input wire [15:0] G; //registor G
	 input wire [15:0] SignExtDIN; //sign extended DIN
	 input wire [3:0]  sel;// selection
    output reg  [15:0] result; //output


    always @(*) begin
        case (sel)
            4'd0  :  result = A0;
            4'd1  :  result = A1;
            4'd2  :  result = A2;
            4'd3  :  result = A3;
				4'd4  :  result = A4;
				4'd5  :  result = A5;
				4'd6  :  result = A6;
				4'd7  :  result = A7;
				4'd8  :  result = G;
				4'd9  :  result = SignExtDin;
				default : result = 16'hXXXX;
        endcase
    end
endmodule


module ALU (input_a, input_b, alu_op, result);
	/* 
	 * This module implements the arithmetic logic unit of the processor.
	 */
	// TODO: declare inputs and outputs


	// TODO: Implement ALU Logic:
endmodule



module register_n(data_in, r_in, clk, Q, rst);


	// To set parameter N during instantiation, you can use:
	// register_n #(.N(num_bits)) reg_IR(.....), 
	// where num_bits is how many bits you want to set N to
	// and "..." is your usual input/output signals
	
	parameter N = 16;


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
