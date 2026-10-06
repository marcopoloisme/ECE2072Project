/*
Monash University ECE2072: Assignment 
This file contains Verilog code to implement the extended version of CPU.

Please enter your student ID:

*/

module simple_proc(clk, rst, din, bus, R0, R1, R2, R3, R4, R5, R6, R7, HEX);

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
	output Hex;
	
    // TODO: declare wires:
    
	//some of these may need to be regs but i think it'll work with wires
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
	
	wire IR_in;
	wire [8:0] CU_in;
	wire opcode;
	
	wire enable;
	wire [3:0] tick;
	
	wire H_in;
	
    // instantiate registers:
    shift_register R0 
	 #(.N(16))
	 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus), 
		  .r_in (R0_in)
        .Q    (R0)
    );
	 
    shift_register R1 
	 #(.N(16))
	 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus),
		  .r_in (R1_in)
        .Q    (R1)
    );
	 
	 shift_register R2 
	 #(.N(16))
	 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus),
		  .r_in (R2_in)
        .Q    (R2)
    );
	 
	 shift_register R3
	 #(.N(16))
	 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus), 
		  .r_in (R3_in)
        .Q    (R3)
    );
	 
	 shift_register R4
	 #(.N(16))
	 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus), 
		  .r_in (R4_in)
        .Q    (R4)
    );
	 
	 shift_register R5 
	 #(.N(16))
	 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus),
		  .r_in (R5_in), 
        .Q    (R5)
    );
	 
	 shift_register R6 
	 #(.N(16))
	 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus), 
		  .r_in (R6_in),
        .Q    (R6)
    );
	 
	 shift_register R7 
	 #(.N(16))
	 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus), 
		  .r_in (R7_in)
        .Q    (R7)
    );
	 
	 shift_register A 
	 #(.N(16))
	 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus),
		  .r_in (A_in)
        .Q    (A_out)
    );
	 
	 shift_register G
	 #(.N(16))
	 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (ALU_out),
		  .r_in (G_in),
        .Q    (G_out)
    );
    
	 	 shift_register IR
	 #(.N(9))
	 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (DIN),
		  .r_in (IR_in),
        .Q    (CU_in)
    );
	 
	 shift_register H
	 #(.N(16))
    	 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus),
		  .r_in (H_in),
        .Q    (HEX)
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
			.sel (bus_control), 
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
    always @(posedge clk_signal) begin
        // TODO: Turn off all control signals:
			IR_in <= 1'b0;
			enable<= 1'b0;
			R0_in <= 1'b0;
			R1_in <= 1'b0;
			R2_in <= 1'b0;
			R3_in <= 1'b0;
			R4_in <= 1'b0;
			R5_in <= 1'b0;
			R6_in <= 1'b0;
			R7_in <= 1'b0;
			A_in  <= 1'b0;
			G_in  <= 1'b0;
			ALU_OP<= 3'b111;

        // TODO: Turn on specific control signals based on current tick:
        case (tick)
            4'b0001:
                begin
                   IR_in  <= 1'b1;
						 // I dont know if this structure works might need clock 
						 opcode <= Ir_out[8:6];
						 enable <= 1'b1;
						 Rx	  <= Ir_out[5:3];
						 Ry 	  <= Ir_out[2:0];
                end
            
            4'b0010:
                begin
                    case (opcode)
								3'b000: // display a register's content on hex as a decimal task 3
									begin
										H_in <= 1'b1;
										case (Rx)
											3'd0: bus_control <= 4'd0;
											3'd1: bus_control <= 4'd1;
											3'd2: bus_control <= 4'd2;
											3'd3: bus_control <= 4'd3;
											3'd4: bus_control <= 4'd4;
											3'd5: bus_control <= 4'd5;
											3'd6: bus_control <= 4'd6;
											3'd7:	bus_control <= 4'd7;
										endcase
										enable <= 1'b1;
									end
						  
								3'b001: //add Rx, Ry adds two register values
									begin
										// get the value in Rx, save to A
										A_in = 1'b1;
										case (Rx)
											3'd0: bus_control <= 4'd0;
											3'd1: bus_control <= 4'd1;
											3'd2: bus_control <= 4'd2;
											3'd3: bus_control <= 4'd3;
											3'd4: bus_control <= 4'd4;
											3'd5: bus_control <= 4'd5;
											3'd6: bus_control <= 4'd6;
											3'd7:	bus_control <= 4'd7;
										endcase
										enable <= 1'b1;
									end
									
								3'b010: //addi Rx, immi adds register and intermediate
									begin
										// get the immediate from DIN store in A
										A_in = 1'b1;
										bus_control <= 4'd9;
										enable <= 1'b1;
									end
									
								3'b011:	//sub Rx, Ry subs two register values
									begin
										// get the Rx store in A
										A_in = 1'b1;
										case (Rx)
											3'd0: bus_control <= 4'd0;
											3'd1: bus_control <= 4'd1;
											3'd2: bus_control <= 4'd2;
											3'd3: bus_control <= 4'd3;
											3'd4: bus_control <= 4'd4;
											3'd5: bus_control <= 4'd5;
											3'd6: bus_control <= 4'd6;
											3'd7:	bus_control <= 4'd7;
										endcase
										enable <= 1'b1;
									end
									
								3'b100: // mult, multiplies the two register values
									begin
									//get the Rx store in A
										A_in = 1'b1;
										case (Rx)
											3'd0: bus_control <= 4'd0;
											3'd1: bus_control <= 4'd1;
											3'd2: bus_control <= 4'd2;
											3'd3: bus_control <= 4'd3;
											3'd4: bus_control <= 4'd4;
											3'd5: bus_control <= 4'd5;
											3'd6: bus_control <= 4'd6;
											3'd7:	bus_control <= 4'd7;
										endcase
										enable <= 1'b1;
									end
									
								3'b101: // ssi, shifts Rx by intermediate
									begin
										// get the immediate from DIN store in A
										A_in = 1'b1;
										bus_control <= 4'd9;
										enable <= 1'b1;
									end
									
								3'b111: //move an intermediate into a register
										//move the intermediate given into the specified register
										bus_control <= 4'd0;
										case (Rx)
											3'd0: R0_in <= 1'b1;
											3'd1: R1_in <= 1'b1;
											3'd2: R2_in <= 1'b1;
											3'd3: R3_in <= 1'b1;
											3'd4: R4_in <= 1'b1;
											3'd5: R5_in <= 1'b1;
											3'd6: R6_in <= 1'b1;
											3'd7:	R7_in <= 1'b1;
										endcase
										enable <=1'b1;
								default: //make it idle
										enable <= 1'b1;
                endcase
            
            4'b0100:
                begin
							case (opcode)
								3'b000: // display a register's content on hex as a decimal task 3
									begin
										enable <= 1'b1;
									end
						  
								3'b001: //add Rx, Ry adds two register values
									begin
										// get Ry to bus, tell ALU to add, store in G temp
										case (Ry)
											3'd0: bus_control <= 4'd0;
											3'd1: bus_control <= 4'd1;
											3'd2: bus_control <= 4'd2;
											3'd3: bus_control <= 4'd3;
											3'd4: bus_control <= 4'd4;
											3'd5: bus_control <= 4'd5;
											3'd6: bus_control <= 4'd6;
											3'd7:	bus_control <= 4'd7;
										endcase
										ALU_OP <= 3'b001;
										G_in <= 1'b1;
										enable <= 1'b1;
									end
									
								3'b010: //addi Rx, immi adds register and intermediate
									begin
										// get the value out of Rx, tell it to add, store in G
										case (Rx)
											3'd0: bus_control <= 4'd0;
											3'd1: bus_control <= 4'd1;
											3'd2: bus_control <= 4'd2;
											3'd3: bus_control <= 4'd3;
											3'd4: bus_control <= 4'd4;
											3'd5: bus_control <= 4'd5;
											3'd6: bus_control <= 4'd6;
											3'd7:	bus_control <= 4'd7;
										endcase
										ALU_OP <= 3'b001;
										G_in <= 1'b1;
										enable <= 1'b1;
									end
									
								3'b011:	//sub Rx, Ry subs two register values
									begin
											// get Ry to bus, tell ALU to subtract, store in G temp
										case (Ry)
											3'd0: bus_control <= 4'd0;
											3'd1: bus_control <= 4'd1;
											3'd2: bus_control <= 4'd2;
											3'd3: bus_control <= 4'd3;
											3'd4: bus_control <= 4'd4;
											3'd5: bus_control <= 4'd5;
											3'd6: bus_control <= 4'd6;
											3'd7:	bus_control <= 4'd7;
										endcase
										ALU_OP <= 3'b010;
										G_in <= 1'b1;
										enable <= 1'b1;
									end
									
								3'b100: // mult, multiplies the two register values
									begin
										// get Ry to bus, tell ALU to subtract, store in G temp
										case (Ry)
											3'd0: bus_control <= 4'd0;
											3'd1: bus_control <= 4'd1;
											3'd2: bus_control <= 4'd2;
											3'd3: bus_control <= 4'd3;
											3'd4: bus_control <= 4'd4;
											3'd5: bus_control <= 4'd5;
											3'd6: bus_control <= 4'd6;
											3'd7:	bus_control <= 4'd7;
										endcase
										ALU_OP <= 3'b000;
										G_in <= 1'b1;
										enable <= 1'b1;
									end
									
								3'b101: // ssi, shifts Rx by intermediate
									begin
										//get the value from Rx
										case (Rx)
											3'd0: bus_control <= 4'd0;
											3'd1: bus_control <= 4'd1;
											3'd2: bus_control <= 4'd2;
											3'd3: bus_control <= 4'd3;
											3'd4: bus_control <= 4'd4;
											3'd5: bus_control <= 4'd5;
											3'd6: bus_control <= 4'd6;
											3'd7:	bus_control <= 4'd7;
										endcase
										ALU_OP <= 3'b011;
										enable <= 1'b1;
									end
									
								3'b111: //move an intermediate into a register
									//do nothing
									enable <= 1'b1;
								default: 
									enable <= 1'b1
							endcase
            
            4'b1000:
                begin
                    case (opcode)
								3'b000: // display a register's content on hex as a decimal task 3
									begin
										enable <= 1'b1;
									end
						  
								3'b001: //add Rx, Ry adds two register values
									begin
										//move the result from Register G to Rx
										bus_control = 4'd8;
										case (Rx)
											3'd0: R0_in <= 1'b1;
											3'd1: R1_in <= 1'b1;
											3'd2: R2_in <= 1'b1;
											3'd3: R3_in <= 1'b1;
											3'd4: R4_in <= 1'b1;
											3'd5: R5_in <= 1'b1;
											3'd6: R6_in <= 1'b1;
											3'd7:	R7_in <= 1'b1;
										endcase
										enable <= 1'b1
									end
									
								3'b010: //addi Rx, immi adds register and intermediate
									begin
										//move the result from Register G to Rx
										bus_control = 4'd8;
										case (Rx)
											3'd0: R0_in <= 1'b1;
											3'd1: R1_in <= 1'b1;
											3'd2: R2_in <= 1'b1;
											3'd3: R3_in <= 1'b1;
											3'd4: R4_in <= 1'b1;
											3'd5: R5_in <= 1'b1;
											3'd6: R6_in <= 1'b1;
											3'd7:	R7_in <= 1'b1;
										endcase
										enable <= 1'b1
									end
									
								3'b011:	//sub Rx, Ry subs two register values
									begin
										//move the result from Register G to Rx
										bus_control = 4'd8;
										case (Rx)
											3'd0: R0_in <= 1'b1;
											3'd1: R1_in <= 1'b1;
											3'd2: R2_in <= 1'b1;
											3'd3: R3_in <= 1'b1;
											3'd4: R4_in <= 1'b1;
											3'd5: R5_in <= 1'b1;
											3'd6: R6_in <= 1'b1;
											3'd7:	R7_in <= 1'b1;
										endcase
										enable <= 1'b1
									end
									
								3'b100: // mult, multiplies the two register values
									begin
										//move the result from Register G to Rx
										bus_control = 4'd8;
										case (Rx)
											3'd0: R0_in <= 1'b1;
											3'd1: R1_in <= 1'b1;
											3'd2: R2_in <= 1'b1;
											3'd3: R3_in <= 1'b1;
											3'd4: R4_in <= 1'b1;
											3'd5: R5_in <= 1'b1;
											3'd6: R6_in <= 1'b1;
											3'd7:	R7_in <= 1'b1;
										endcase
										enable <= 1'b1
									end
									
								3'b101: // ssi, shifts Rx by intermediate task 3
									begin
										//move the result from Register G to Rx
										bus_control = 4'd8;
										case (Rx)
											3'd0: R0_in <= 1'b1;
											3'd1: R1_in <= 1'b1;
											3'd2: R2_in <= 1'b1;
											3'd3: R3_in <= 1'b1;
											3'd4: R4_in <= 1'b1;
											3'd5: R5_in <= 1'b1;
											3'd6: R6_in <= 1'b1;
											3'd7:	R7_in <= 1'b1;
										endcase
										enable <= 1'b1
									end
									
								3'b111: //move an intermediate into a register
										//do nothing
										enable <= 1'b1;
								default: //make it idle
										enable <= 1'b1;
                end
            
            default:
                begin
                    // TODO
                end

        endcase

    end

endmodule