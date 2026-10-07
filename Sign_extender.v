
module sign_extend(
	input [8:0] in, //9 bit input received 
	output [15:0] ext //processors data bus is 16 bit wide 
);

	assign ext = {{7{in[8]}}, in}; //[15:9] will be the in[8] value repeated 7 times using concatenation. 
endmodule 
