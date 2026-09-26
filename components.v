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
    input enable;
    input rst;
    input clk;
    output reg [3:0] tick;

    always @(posedge clk) begin
        if (rst) begin
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
    input  wire [15:0] SignExtDin;
    input  wire [15:0] R0;
    input  wire [15:0] R1;
    input  wire [15:0] R2;
    input  wire [15:0] R3;
    input  wire [15:0] R4;
    input  wire [15:0] R5;
    input  wire [15:0] R6;
    input  wire [15:0] R7;
    input  wire [15:0] G;
    input  wire [3:0]  sel;
    output reg  [15:0] Bus;


    always @(*) begin
        case (sel)
            4'd0: Bus = R0;
            4'd1: Bus = R1;
            4'd2: Bus = R2;
            4'd3: Bus = R3;
            4'd4: Bus = R4;
            4'd5: Bus = R5;
            4'd6: Bus = R6;
            4'd7: Bus = R7;
            4'd8: Bus = G;
            4'd9: Bus = SignExtDin;
            default: Bus = 16'hXXXX;
        endcase
    end

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
	input wire [N-1:0] data_in;
	input wire r_in;
	input wire clk;
	input wire rst;
	output reg [N-1:0] Q;
	
	always @(posedge clk) begin 
		if (rst) begin
		Q <= 'd0;
		end 
		else if (r_in) begin
		Q <= data_in;
		end
	end
endmodule 


