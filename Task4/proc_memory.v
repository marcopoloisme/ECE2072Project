module proc_memory(clk, rst, din, bus, R0, R1, R2, R3, R4, R5, R6, R7, HEX, PC);

    // Note: The skeleton you are provided with includes output ports to output the values of the internal registers R0 - R7, for the purpose of test benching. When instantiating the processor to program your DE10-lite, you can leave these ports unused.

    // Declare inputs and outputs:
	input clk;
	input rst;
  
	input  [8:0] din;
	output reg [15:0]bus;
	output [15:0] R0;
	output [15:0] R1;
	output [15:0] R2;
	output [15:0] R3;
	output [15:0] R4;
	output [15:0] R5;
	output [15:0] R6; 
	output [15:0] R7;
	output [15:0] HEX;
  output [15:0] PC; //PC output 
  
  reg [15:0] pc_reg; //storing 16 bit program 

  assign PC = pc_reg; //pc's register's value available at the output

  //xounter control
  reg pc_inc;
  reg pc_load;

  //instruction and immediate control 
  // reg branch_taken; //should a bez branch be taken 

  //Branch instruction fields register and ofset information 
  reg [2:0] branch_Rx;
  reg [15:0] branch_offset;

    
	//some of these may need to be regs but i think it'll work with wires
	wire R0_in;
	wire R1_in;
	wire R2_in;
	wire R3_in;
	wire R4_in;
	wire R5_in;
	wire R6_in;
	wire R7_in;
	
  	wire[15:0] signExtDin;
	
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
	wire H_out;
	
	wire [2:0] Rx;
	wire [2:0] Ry;
	
	wire [3:0] tickOutput;
	wire [3:0] tickSevenSeg;
	wire negative;
	wire [15:0] unsignOut;
	wire [19:0] sevenSeg;
	
	wire [7:0] sevenSeg0;
	wire [7:0] sevenSeg1;
	wire [7:0] sevenSeg2;
	wire [7:0] sevenSeg3;
	wire [7:0] sevenSeg4;
	wire [7:0] sevenSeg5;
	
    // instantiate registers:
    shift_register #(.N(16)) Reg0 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus), 
		  .r_in (R0_in),
        .Q    (R0)
    );
	 
    shift_register #(.N(16)) Reg1 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus),
		  .r_in (R1_in),
        .Q    (R1)
    );
	 
	 shift_register #(.N(16)) Reg2 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus),
		  .r_in (R2_in),
        .Q    (R2)
    );
	 
	 shift_register #(.N(16)) Reg3 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus), 
		  .r_in (R3_in),
        .Q    (R3)
    );
	 
	 shift_register #(.N(16)) Reg4 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus), 
		  .r_in (R4_in),
        .Q    (R4)
    );
	 
	 shift_register #(.N(16)) Reg5 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus),
		  .r_in (R5_in), 
        .Q    (R5)
    );
	 
	 shift_register #(.N(16)) Reg6 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus), 
		  .r_in (R6_in),
        .Q    (R6)
    );
	 
	 shift_register #(.N(16)) Reg7 (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus), 
		  .r_in (R7_in),
        .Q    (R7)
    );
	 
	 shift_register #(.N(16)) A (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus),
		  .r_in (A_in),
        .Q    (A_out)
    );
	 
	 shift_register #(.N(16)) G (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (ALU_out),
		  .r_in (G_in),
        .Q    (G_out)
    );
    
	 	 shift_register #(.N(9)) IR (
        .clk  (clk_signal), 
        .rst  (rst), 
       .data_in (din),
		  .r_in (IR_in),
        .Q    (CU_in)
    );
  
  register_n #(.N(9)) InstructionReg ( //cotring the current instruction 
        .data_in(din),
        .r_in(instruction_in),
        .clk(clk),
        .Q(instruction),
        .rst(rst)
    );

  register_n #(.N(16)) ImmediateReg ( //storing the 16 bit immediate value 
        .data_in(signExtDin),
        .r_in(immediate_in),
        .clk(clk),
        .Q(immediate),
        .rst(rst)
    );
	 
	 shift_register #(.N(16)) H (
        .clk  (clk_signal), 
        .rst  (rst), 
        .data_in (bus),
		  .r_in (H_in),
        .Q    (H_out)
    );
    
    //instantiate Multiplexer:
    
    multiplexer inst1 (
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
    
	 ALU inst2 (
			.input_a (A_out),
			.input_b (bus),
			.alu_op (ALU_OP),
			.result (ALU_out)
	);
    
    //instantiate tick counter:
    
	 tick_FSM_task4 inst3 (
			.enable (enable),
			.clk (clk),
			.rst (rst),
			.tick (tick)
	 );
	 
	 // instantiate sign_extender
	 
	 sign_extend inst4 (
			.in (din),
			.ext (signExtDin)
	);
	

	twos_complement inst5 (
		.data_in (H_out),
		.negative (negative),
		.data_out (unsignOut)
		);
	
	binary_to_BCD #(.N(16), .N2 (5)) inst6 (
		.clk (clk),
		.data_in (unsignOut),
		.enable (H_in),
		.result (sevenSeg)
		);
	
	// tick BCD
	tick_to_binary inst7 (
		.tick (tick),
		.clk (clk),
		.result (tickOutput)
		);
	
	
	
	binary_to_BCD #(.N(4), .N2 (1)) inst8 (
		.clk (clk),
		.data_in (tickOutput),
		.enable (H_in),
		.result (tickSevenSeg)
		);
			
	BCD sevensegment0 (
			.data (sevenSeg[3:0]),
			.negative (negative),
			.result (sevenSeg0)
			);
			
	BCD sevensegment1 (
		.data (sevenSeg[7:4]),
		.negative (negative),
		.result (sevenSeg1)
		);
		
	BCD sevensegment2 (
		.data (sevenSeg[11:8]),
		.negative (negative),
		.result (sevenSeg2)
		);
		
	BCD sevensegment3 (
		.data (sevenSeg[15:12]),
		.negative (negative),
		.result (sevenSeg3)
		);
		
	BCD sevensegment4 (
		.data (sevenSeg[19:16]),
		.negative (negative),
		.result (sevenSeg4)
		);
	
	BCD sevensegment5 (
		.data (tickSevenSeg),
		.negative (negative),
		.result (sevenSeg5)
		);
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

	//PC controls 
		pc_inc <= 1'b0;
		pc_load <= 1'b0;

        // TODO: Turn on specific control signals based on current tick:
        case (tick)
            8'b00000001:
                begin
                   IR_in  <= 1'b1;
                end
            8'b00000010: 
				begin
					pc_inc <=1'b1;
					bus_control <= 4'd10;
				
				end
            8'b00000100: 
				begin
					pc_load <=1'b1;
					bus_control <= 4'd11;
				end

            8'b00001000: 
 				begin
                    case (CU_in[8:6])
						3'b000: // display a register's content on hex as a decimal task 3
							begin
								H_in <= 1'b1;
								case (CU_in[5:3])
									3'd0: bus_control <= 4'd0;
									3'd1: bus_control <= 4'd1;
									3'd2: bus_control <= 4'd2;
									3'd3: bus_control <= 4'd3;
									3'd4: bus_control <= 4'd4;
									3'd5: bus_control <= 4'd5;
									3'd6: bus_control <= 4'd6;
									3'd7:	bus_control <= 4'd7;
								endcase
							end
						  
						3'b001: //add Rx, Ry adds two register values
							begin
								// get the value in Rx, save to A
								A_in <= 1'b1;
								case (CU_in[5:3])
									3'd0: bus_control <= 4'd0;
									3'd1: bus_control <= 4'd1;
									3'd2: bus_control <= 4'd2;
									3'd3: bus_control <= 4'd3;
									3'd4: bus_control <= 4'd4;
									3'd5: bus_control <= 4'd5;
									3'd6: bus_control <= 4'd6;
									3'd7:	bus_control <= 4'd7;
								endcase
							end
							
						3'b010: //addi Rx, immi adds register and intermediate
							begin
								// get the immediate from DIN store in A
								A_in <= 1'b1;
								bus_control <= 4'd9;
							end
									
						3'b011:	//sub Rx, Ry subs two register values
							begin
								// get the Rx store in A
								A_in <= 1'b1;
								case (CU_in[5:3])
									3'd0: bus_control <= 4'd0;
									3'd1: bus_control <= 4'd1;
									3'd2: bus_control <= 4'd2;
									3'd3: bus_control <= 4'd3;
									3'd4: bus_control <= 4'd4;
									3'd5: bus_control <= 4'd5;
									3'd6: bus_control <= 4'd6;
									3'd7:	bus_control <= 4'd7;
								endcase
							end
							
						3'b100: // mult, multiplies the two register values
							begin
							//get the Rx store in A
								A_in <= 1'b1;
								case (CU_in[5:3])
									3'd0: bus_control <= 4'd0;
									3'd1: bus_control <= 4'd1;
									3'd2: bus_control <= 4'd2;
									3'd3: bus_control <= 4'd3;
									3'd4: bus_control <= 4'd4;
									3'd5: bus_control <= 4'd5;
									3'd6: bus_control <= 4'd6;
									3'd7:	bus_control <= 4'd7;
								endcase
							end
									
						3'b101: // ssi, shifts Rx by intermediate
							begin
								// get the immediate from DIN store in A
								A_in <= 1'b1;
								bus_control <= 4'd9;
							end
						
						3'b110: //beq
							begin
								if (CU_in[5:3] == 0)
									begin
										A_in <= 1'b1;
										bus_control <= 4'd9;
									end
							end
							
						3'b111:
							begin
								//move an intermediate into a register
								//move the intermediate given into the specified register
								bus_control <= 4'd9;
								case (CU_in[5:3])
									3'd0: R0_in <= 1'b1;
									3'd1: R1_in <= 1'b1;
									3'd2: R2_in <= 1'b1;
									3'd3: R3_in <= 1'b1;
									3'd4: R4_in <= 1'b1;
									3'd5: R5_in <= 1'b1;
									3'd6: R6_in <= 1'b1;
									3'd7:	R7_in <= 1'b1;
								endcase
							end
						default: //make it idle
						begin
						end
				endcase
			end
            8'b00010000:
                begin
							case (CU_in[8:6])
								3'b000: // display a register's content on hex as a decimal task 3
									begin
	
									end
						  
								3'b001: //add Rx, Ry adds two register values
									begin
										// get Ry to bus, tell ALU to add, store in G temp
										case (CU_in[2:0])
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
					
									end
									
								3'b010: //addi Rx, immi adds register and intermediate
									begin
										// get the value out of Rx, tell it to add, store in G
										case (CU_in[5:3])
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
			
									end
									
								3'b011:	//sub Rx, Ry subs two register values
									begin
											// get Ry to bus, tell ALU to subtract, store in G temp
										case (CU_in[2:0])
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
									end
									
								3'b100: // mult, multiplies the two register values
									begin
										// get Ry to bus, tell ALU to subtract, store in G temp
										case (CU_in[2:0])
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
									end
									
								3'b101: // ssi, shifts Rx by intermediate
									begin
										//get the value from Rx
										case (CU_in[5:3])
											3'd0: bus_control <= 4'd0;
											3'd1: bus_control <= 4'd1;
											3'd2: bus_control <= 4'd2;
											3'd3: bus_control <= 4'd3;
											3'd4: bus_control <= 4'd4;
											3'd5: bus_control <= 4'd5;
											3'd6: bus_control <= 4'd6;
											3'd7: bus_control <= 4'd7;
										endcase
										ALU_OP <= 3'b011;
									end
								
								3'b110: //beq
									begin
										// get the value out of Rx, tell it to add, store in G
										bus_control <= 4'd10
										ALU_OP <= 3'b001;
										G_in <= 1'b1;
									end
									
								3'b111: //move an intermediate into a register
									//do nothing
									begin
									end
								default: 
								begin
								end
							endcase
					 end
            4'b00100000:
                begin
					case (CU_in[8:6])
							3'b000: // display a register's content on hex as a decimal task 3
								begin
								end
						
							3'b001: //add Rx, Ry adds two register values
								begin
									//move the result from Register G to Rx
									bus_control <= 4'd8;
									case (CU_in[5:3])
										3'd0: R0_in <= 1'b1;
										3'd1: R1_in <= 1'b1;
										3'd2: R2_in <= 1'b1;
										3'd3: R3_in <= 1'b1;
										3'd4: R4_in <= 1'b1;
										3'd5: R5_in <= 1'b1;
										3'd6: R6_in <= 1'b1;
										3'd7: R7_in <= 1'b1;
									endcase
								end
								
							3'b010: //addi Rx, immi adds register and intermediate
								begin
									//move the result from Register G to Rx
									bus_control <= 4'd8;
									case (CU_in[5:3])
										3'd0: R0_in <= 1'b1;
										3'd1: R1_in <= 1'b1;
										3'd2: R2_in <= 1'b1;
										3'd3: R3_in <= 1'b1;
										3'd4: R4_in <= 1'b1;
										3'd5: R5_in <= 1'b1;
										3'd6: R6_in <= 1'b1;
										3'd7: R7_in <= 1'b1;
									endcase
								end
								
							3'b011:	//sub Rx, Ry subs two register values
								begin
									//move the result from Register G to Rx
									bus_control <= 4'd8;
									case (CU_in[5:3])
										3'd0: R0_in <= 1'b1;
										3'd1: R1_in <= 1'b1;
										3'd2: R2_in <= 1'b1;
										3'd3: R3_in <= 1'b1;
										3'd4: R4_in <= 1'b1;
										3'd5: R5_in <= 1'b1;
										3'd6: R6_in <= 1'b1;
										3'd7: R7_in <= 1'b1;
									endcase
								end
								
							3'b100: // mult, multiplies the two register values
								begin
									//move the result from Register G to Rx
									bus_control <= 4'd8;
									case (CU_in[5:3])
										3'd0: R0_in <= 1'b1;
										3'd1: R1_in <= 1'b1;
										3'd2: R2_in <= 1'b1;
										3'd3: R3_in <= 1'b1;
										3'd4: R4_in <= 1'b1;
										3'd5: R5_in <= 1'b1;
										3'd6: R6_in <= 1'b1;
										3'd7:	R7_in <= 1'b1;
									endcase
								end
								
							3'b101: // ssi, shifts Rx by intermediate task 3
								begin
									//move the result from Register G to Rx
									bus_control <= 4'd8;
									case (CU_in[5:3])
										3'd0: R0_in <= 1'b1;
										3'd1: R1_in <= 1'b1;
										3'd2: R2_in <= 1'b1;
										3'd3: R3_in <= 1'b1;
										3'd4: R4_in <= 1'b1;
										3'd5: R5_in <= 1'b1;
										3'd6: R6_in <= 1'b1;
										3'd7: R7_in <= 1'b1;
									endcase
								end
							
							3'b110: //beq
								begin
									//move result from G into pc_reg
									bus_control <= 4'd8;
									pc_inc
								end
								
							3'b111: //move an intermediate into a register
									//do nothing
									begin
									end
							default: //make it idle
							begin
							end
						endcase
				end

			4'b01000000:
				begin
					pc_inc <=1'b1;
					bus_control <= 4'd10;
				
				end
            8'b10000000: 
				begin
					pc_load <=1'b1;
					bus_control <= 4'd11;
				end

            default:
                begin
                    enable<=1'b1;
                end

        endcase

    end

endmodule
