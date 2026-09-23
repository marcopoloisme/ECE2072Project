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
    wire [15:0] R0, //registor 0 
    wire [15:0] R1, //registor 1
    wire [15:0] R2, //..
	 wire [15:0] R3, 
	 wire [15:0] R4,
	 wire [15:0] R5,
	 wire [15:0] R6,
	 wire [15:0] R7,//registor 7
	 wire [15:0] G, //registor G
	 wire [15:0] SignExtDIN, //sign extended DIN
	 wire [3:0] sel, // selection
    reg  [15:0] result //output


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

	register_n #(.N(num_bits)) reg_IR()
	
	parameter N = 16;

	/* 
	 * This module implements registers that will be used in the processor.
	 */
	// TODO: Declare inputs, outputs, and parameter:
	
	// TODO: Implement register logic:
endmodule

