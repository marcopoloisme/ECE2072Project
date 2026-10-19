/*
Monash University ECE2072: Assignment 
This file contains Verilog code to implement the extended version of CPU.

Please enter your student ID:

*/

module proc_extension(clk, rst,enable, din, bus, R0, R1, R2, R3, R4, R5, R6, R7, sevenSeg0,sevenSeg1,sevenSeg2,sevenSeg3,sevenSeg4,sevenSeg5);

    // Note: The skeleton you are provided with includes output ports to output the values of the internal registers R0 - R7, for the purpose of test benching. When instantiating the processor to program your DE10-lite, you can leave these ports unused.

    // Declare inputs and outputs:
	input clk;
	input rst;
	input enable;
	input  [8:0]  din;
	output [15:0] bus;
	output [15:0] R0;
	output [15:0] R1;
	output [15:0] R2;
	output [15:0] R3;
	output [15:0] R4;
	output [15:0] R5;
	output [15:0] R6; 
	output [15:0] R7;
  	output [7:0]  sevenSeg0;
	output [7:0]  sevenSeg1;
	output [7:0]  sevenSeg2;
	output [7:0]  sevenSeg3;
	output [7:0]  sevenSeg4;
	output [7:0]  sevenSeg5;


   
	//register control
	reg R0_in;
	reg R1_in;
	reg R2_in;
	reg R3_in;
	reg R4_in;
	reg R5_in;
	reg R6_in;
	reg R7_in;
	reg pc_in;
	reg A_in;	
	reg  G_in;
	reg IR_in;
	reg H_in;
	
	
	//non primary register / components outputs
	
	wire [15:0] signExtDin;
	wire [15:0] A_out;
	wire [15:0] G_out;
	wire [15:0] H_out;
	wire [15:0] ALU_out;
	wire [3:0] tick;
	wire [3:0] tickOutput;
	wire [15:0] unsignOut;
	wire [19:0] sevenSeg;
	wire [15:0] PC;
	wire negative;
	
	// controls
	
	reg [3:0] bus_control;
	reg [2:0] ALU_OP;
	wire [8:0] CU_in;


	
    // instantiate registers:
   register_n #(.N(16)) Reg0 (
        .clk  (clk), 
        .rst  (rst), 
        .data_in (bus), 
		  .r_in (R0_in),
        .Q    (R0)
    );
	 
   register_n #(.N(16)) Reg1 (
        .clk  (clk), 
        .rst  (rst), 
        .data_in (bus),
		  .r_in (R1_in),
        .Q    (R1)
    );
	 
	register_n #(.N(16)) Reg2 (
        .clk  (clk), 
        .rst  (rst), 
        .data_in (bus),
		  .r_in (R2_in),
        .Q    (R2)
    );
	 
	register_n #(.N(16)) Reg3 (
        .clk  (clk), 
        .rst  (rst), 
        .data_in (bus), 
		  .r_in (R3_in),
        .Q    (R3)
    );
	 
	register_n #(.N(16)) Reg4 (
        .clk  (clk), 
        .rst  (rst), 
        .data_in (bus), 
		  .r_in (R4_in),
        .Q    (R4)
    );
	 
	 register_n #(.N(16)) Reg5 (
        .clk  (clk), 
        .rst  (rst), 
        .data_in (bus),
		  .r_in (R5_in), 
        .Q    (R5)
    );
	 
	 register_n #(.N(16)) Reg6 (
        .clk  (clk), 
        .rst  (rst), 
        .data_in (bus), 
		  .r_in (R6_in),
        .Q    (R6)
    );
	 
	 register_n #(.N(16)) Reg7 (
        .clk  (clk), 
        .rst  (rst), 
        .data_in (bus), 
		  .r_in (R7_in),
        .Q    (R7)
    );
	 
	register_n #(.N(16)) A (
        .clk  (clk), 
        .rst  (rst), 
        .data_in (bus),
		  .r_in (A_in),
        .Q    (A_out)
    );
	 
	register_n #(.N(16)) G (
        .clk  (clk), 
        .rst  (rst), 
        .data_in (ALU_out),
		  .r_in (G_in),
        .Q    (G_out)
    );
    
	register_n #(.N(9)) IR (
        .clk  (clk), 
        .rst  (rst), 
       .data_in (din),
		  .r_in (IR_in),
        .Q    (CU_in)
    );

   register_n #(.N(16)) AddressReg (
        .data_in(bus),
        .r_in(pc_in),
        .clk(clk),
        .Q(PC),
        .rst(rst)
    );
	 
	register_n #(.N(16)) H (
        .clk  (clk), 
        .rst  (rst), 
        .data_in (bus),
		  .r_in (H_in),
        .Q    (H_out)
    );
    
    //instantiate Multiplexer:
    
    multiplexer inst1 (
			.SignExtDin (signExtDin),
			.R0 (R0),
			.R1 (R1),
			.R2 (R2),
			.R3 (R3),
			.R4 (R4),
			.R5 (R5),
			.R6 (R6),
			.R7 (R7),
			.G (G_out),
			.PC (PC),
			.sel (bus_control), 
			.Bus (bus)
		);
		
		
    // instantiate ALU:
    
	 alu inst2 (
			.input_a (A_out),
			.input_b (bus),
			.alu_op (ALU_OP),
			.result (ALU_out)
	);
    
    //instantiate tick counter:
    
	 tick_FSM inst3 (
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
	
	Binary_to_BCD #(.N(16), .N2 (5)) inst6 (
		.data_in (unsignOut),
		.result (sevenSeg)
		);
	

	tick_to_binary inst7 (
		.tick ({4'b0000, tick}),
		.result (tickOutput)
		);
	
	

			
	BCD sevensegment0 (
		.data (sevenSeg[3:0]),
		.negative (negative),
		.X (sevenSeg0)
		);
			
	BCD sevensegment1 (
		.data (sevenSeg[7:4]),
		.negative (negative),
		.X (sevenSeg1)
		);
		
	BCD sevensegment2 (
		.data (sevenSeg[11:8]),
		.negative (negative),
		.X (sevenSeg2)
		);
		
	BCD sevensegment3 (
		.data (sevenSeg[15:12]),
		.negative (negative),
		.X (sevenSeg3)
		);
		
	BCD sevensegment4 (
		.data (sevenSeg[19:16]),
		.negative (negative),
		.X (sevenSeg4)
		);
	
	BCD sevensegment5 (
		.data (tickOutput),
		.negative (negative),
		.X (sevenSeg5)
		);
 
    // TODO: define control unit:
    always @(*) begin
        // TODO: Turn off all control signals:
			IR_in <= 1'b0;
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
			H_in  <= 1'b0;
			bus_control <= 4'd15;
			ALU_OP<= 3'b111;

        // TODO: Turn on specific control signals based on current tick:
        case (tick)
            4'b0001:
                begin
                   IR_in  <= 1'b1;
                end
            
            4'b0010:
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
            4'b0100:
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
											3'd7:	bus_control <= 4'd7;
										endcase
										ALU_OP <= 3'b011;
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
            4'b1000:
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
											3'd7:	R7_in <= 1'b1;
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
											3'd7:	R7_in <= 1'b1;
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
											3'd7:	R7_in <= 1'b1;
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
											3'd7:	R7_in <= 1'b1;
										endcase
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
            default:
                begin
                end

        endcase
	end
endmodule