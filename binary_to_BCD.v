
//module uses double dabble algorithm see https://en.wikipedia.org/wiki/Double_dabble
//https://nandland.com/binary-to-bcd-the-double-dabbler/


module Binary_to_BCD
  #(parameter N =16,
    parameter N2 =5)
  (
   input                         clk,
   input [N-1:0]       data_in,
   input                         enable,
	
   output [N2*4-1:0] result                
	);
	
  parameter s_IDLE              = 3'b000;
  parameter s_SHIFT             = 3'b001;
  parameter s_CHECK_SHIFT_INDEX = 3'b010;
  parameter s_ADD               = 3'b011;
  parameter s_CHECK_DIGIT_INDEX = 3'b100;
  parameter s_BCD_DONE          = 3'b101;
   
  reg [2:0] r_SM_Main = s_IDLE;
   
  // The vector that contains the output BCD
  reg [N2*4-1:0] r_BCD = 0;
    
  // The vector that contains the input binary value being shifted.
  reg [N-1:0]      r_Binary = 0;
      
  // Keeps track of which Decimal Digit we are indexing
  reg [N2-1:0]   r_Digit_Index = 0;
    
  // Keeps track of which loop iteration we are on.
  // Number of loops performed = INPUT_WIDTH
  reg [7:0]                  r_Loop_Count = 0;
 
  wire [3:0]                 w_BCD_Digit;
  reg                        r_DV = 1'b0;                       
    
  always @(posedge clk)
    begin
 
      case (r_SM_Main) 
  
        // Stay in this state until i_Start comes along
        s_IDLE :
          begin
            r_DV <= 1'b0;
             
            if (enable == 1'b1)
              begin
                r_Binary  <= data_in;
                r_SM_Main <= s_SHIFT;
                r_BCD     <= 0;
              end
            else
              r_SM_Main <= s_IDLE;
          end
                 
  
        // Always shift the BCD Vector until we have shifted all bits through
        // Shift the most significant bit of r_Binary into r_BCD lowest bit.
        s_SHIFT :
          begin
            r_BCD     <= r_BCD << 1;
            r_BCD[0]  <= r_Binary[N-1];
            r_Binary  <= r_Binary << 1;
            r_SM_Main <= s_CHECK_SHIFT_INDEX;
          end          
         
  
        // Check if we are done with shifting in r_Binary vector
        s_CHECK_SHIFT_INDEX :
          begin
            if (r_Loop_Count == N2-1)
              begin
                r_Loop_Count <= 0;
                r_SM_Main    <= s_BCD_DONE;
              end
            else
              begin
                r_Loop_Count <= r_Loop_Count + 1;
                r_SM_Main    <= s_ADD; 
              end
          end
 
        // Break down each BCD Digit individually. Check them one-by-one to 
        // see if they are greater than 4. If they are, increment by 3. 
        // Put the result back into r_BCD Vector. 
        s_ADD : 
          begin
            if (w_BCD_Digit > 4)
              begin                                     
                r_BCD[(r_Digit_Index*4)+:4] <= w_BCD_Digit + 3;  
              end
             
            r_SM_Main <= s_CHECK_DIGIT_INDEX; 
          end       
         
         
        // Check if we are done incrementing all of the BCD Digits
        s_CHECK_DIGIT_INDEX :
          begin
            if (r_Digit_Index == N2-1)
              begin
                r_Digit_Index <= 0;
                r_SM_Main     <= s_SHIFT;
              end
            else
              begin
                r_Digit_Index <= r_Digit_Index + 1;
                r_SM_Main     <= s_ADD;
              end
          end
  
  
        s_BCD_DONE :
          begin
            r_DV      <= 1'b1;
            r_SM_Main <= s_IDLE;
          end
         
         
        default :
          r_SM_Main <= s_IDLE;
            
      endcase
    end // always @ (posedge i_Clock)  
 
   
  assign w_BCD_Digit = r_BCD[r_Digit_Index*4 +: 4];
       
  assign result = r_BCD;
      
endmodule // Binary_to_BCD


module tick_to_binary (
	input [3:0] tick,
	input clk,
	output [3:0] result
	);
	always @(posedge clk) begin //clock ticking 
		case (tick)
			 4'b0001: result <= 4'd0;
			 4'b0010: result <= 4'd1;
			 4'b0100: result <= 4'd2;
			 4'b1000: result <= 4'd3;
			 default: result <= 4'd0; 
		endcase
	end
endmodule
	


module twos_complement 
	#(parameter N)
	
	(
	input [N-1:0] data_in,
	output negative,
	output [N-1:0] data_out
	);
	
	always @(*) begin
	
		negative = data_in[N-1];
		
		if (negative == 0) begin
		
			data_out = data_in;
		
		end else begin
			
			data_out = ~(data_in - 1'b1);
		end
	end
endmodule
	

module BCD (
    input [3:0] data,
	 input negative,
    output [7:0] X
);

assign X[0] = ~(data[1]|data[3]|~(data[2]^data[0]));
assign X[1] = ~(data[3]|~data[2]|~(data[0]^data[1]));
assign X[2] = data[1]&~data[2]&~data[3]&~data[0];
assign X[3] = ~((~data[1]&~data[0]&~data[2])|(~data[3]&data[2]&(data[0]^data[1]))|(~data[2]&~data[3]&data[1]));
assign X[4] = ~((~data[0] &~data[1]&~data[2])| data[1]&~data[0]);
assign X[5] = ~((~data[0] &~data[1])|(data[0]^data[1])&(data[2]^data[3]));
assign X[6] = ~((data[1]&~data[2]&~data[3])|~data[1]&(data[2]^data[3])|data[1]&~data[0]);
assign X[7] = ~negative;

endmodule
