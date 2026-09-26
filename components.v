/*
Monash University ECE2072: Assignment 
This file contains Verilog code to implement individual components to be used in 
    the CPU.

Please enter your name and student ID:

*/
module sign_extend(in, ext);
	input [8:0] in;
	output [15:0] ext;

	assign ext = {{7{in[8]}}, in};
endmodule



module tick_FSM(rst, clk, enable, tick);
	module tick_FSM(tick, enable, reset, clock);
    input enable;
    input reset;
    input clock;
    output reg [3:0] tick;

    always @(posedge clock) begin
        if (reset) begin
            tick <= 4'b0001;
        end
        else if (enable) begin
            case (tick)
                4'b0001: tick <= 4'b0010;
                4'b0010: tick <= 4'b0100;
                4'b0100: tick <= 4'b1000;
                4'b1000: tick <= 4'b0001;
                default: tick <= 4'b0001;
            endcase
        end
    end
endmodule

module multiplexer(SignExtDin, R0, R1, R2, R3, R4, R5, R6, R7, G, sel, Bus);
	/* 
	 * This module takes 10 inputs and places the correct input onto the bus.
	 */
	// TODO: Declare inputs and outputs
	
	// TODO: implement logic


endmodule

module ALU (input_a, input_b, alu_op, result);
	 input [15:0] input_a;
    input [15:0] input_b;
    input [2:0] alu_op;
    output reg [15:0] result;
	 always @(*)begin 
	 case (alu_op)
            3'b000: result = input_a * input_b;
            3'b001: result = input_a + input_b;
            3'b010: result = input_a - input_b;
            3'b011: result = $signed(input_b) >>> $signed(input_a);

            default: result = 16'b0;
        endcase
    end
	 
endmodule

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
	
	// TODO: Implement register logic:
endmodule

