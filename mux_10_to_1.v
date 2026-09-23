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
