/*
Monash University ECE2072: Assignment 
This file contains Verilog code to implement individual the CPU.

Please enter your student ID:

*/
module simple_proc(clk, rst, din, bus, R0, R1, R2, R3, R4, R5, R6, R7);

    // Note: The skeleton you are provided with includes output ports to output the values of the internal registers R0 - R7, for the purpose of test benching. When instantiating the processor to program your DE10-lite, you can leave these ports unused.

    // TODO: Declare inputs and outputs:
	input clk;
	input rst;
	input din;
	output bus;
	output R0;
	output R1;
	output R2;
	output R3;
	output R4;
	output R5;
	output R6; 
	output R7;
	
    // TODO: declare wires:
    
	//some of these may need to be inputs
	wire R0_in;
	wire R1_in;
	wire R2_in;
	wire R3_in;
	wire R4_in;
	wire R5_in;
	wire R6_in;
	wire R7_in;
	
	wire signExtDin;
	
	wire [3:0] bus_control;
	
	wire A_in;	
	wire [15:0] A_out;
	
	wire [2:0] ALU_OP;
	wire [15:0] ALU_out;
	
	wire [15:0] G_in;
	wire [15:0] G_out;
	
	wire enable;
	wire [3:0] tick;
	
    // instantiate registers:
    shift_register R0 
	 #(.N(16)
	 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus), 
		  .r_in (R0_in)
        .Q    (R0)
    );
	 
    shift_register R1 
	 #(.N(16)
	 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus),
		  .r_in (R1_in)
        .Q    (R1)
    );
	 
	 shift_register R2 
	 #(.N(16)
	 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus),
		  .r_in (R2_in)
        .Q    (R2)
    );
	 
	 shift_register R3
	 #(.N(16)
	 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus), 
		  .r_in (R3_in)
        .Q    (R3)
    );
	 
	 shift_register R4
	 #(.N(16)
	 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus), 
		  .r_in (R4_in)
        .Q    (R4)
    );
	 
	 shift_register R5 
	 #(.N(16)
	 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus),
		  .r_in (R5_in), 
        .Q    (R5)
    );
	 
	 shift_register R6 
	 #(.N(16)
	 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus), 
		  .r_in (R6_in),
        .Q    (R6)
    );
	 
	 shift_register R7 
	 #(.N(16)
	 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus), 
		  .r_in (R7_in)
        .Q    (R7)
    );
	 
	 shift_register A 
	 #(.N(16)
	 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus),
		  .r_in (A_in)
        .Q    (A_out)
    );
	 
	 shift_register G
	 #(.N(16)
	 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (ALY_out),
		  .r_in (G_in),
        .Q    (G_out)
    );
    
    
    //instantiate Multiplexer:
    
    multiplexer inst1 
	 (
			.signExtDin (signExtDin),
			.R0 (R0),
			.R1 (R1),
			.R2 (R2),
			.R3 (R3),
			.R4 (R4),
			.R5 (R5),
			.R6 (R6),
			.R7 (R7),
			.G (G_out),
			.sel (bus_control), //havent defined sel yet
			.Bus (bus)
		);
		
		
    // instantiate ALU:
    
	 ALU inst1 
	 (
			.input_a (A_out),
			.input_b (bus),
			.alu_op (ALU_OP),
			.result (ALU_out)
	);
    
    //instantiate tick counter:
    
	 tick_FSM inst1
	 (
			.enable (enable),
			.clk (clk),
			.rst (rst),
			.tick (tick)
	 );
	 
	 // instantiate sign_extender
	 
	 sign_extend inst1
	 (
			.in (DIN),
			.ext (signExtDin)
	);
    
    // TODO: define control unit:
    always @(/* List signals that can change the control unit's output */) begin
        // TODO: Turn off all control signals:


        // TODO: Turn on specific control signals based on current tick:
        case (/* your counter value goes here */)
            /* Tick 1 */:
                begin
                    // TODO
                end
            
            /* Tick 2 */:
                begin
                    // TODO
                end
            
            /* Tick 3 */:
                begin
                    // TODO
                end
            
            /* Tick 4 */:
                begin
                    // TODO
                end
            
            default:
                begin
                    // TODO
                end

        endcase

    end

endmodule