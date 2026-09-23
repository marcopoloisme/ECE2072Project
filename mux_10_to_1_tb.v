module mux_10_to_1_tb;
	reg [15:0] R0,R1,R2,R3,R4,R5,R6,R7,G,SignExtDIN;
	reg [3:0] sel;
	wire [15:0] result;

	reg [15:0] expectedArray [0:9];
	reg [15:0] expectedOut;

	integer i, fail, pass;
	
	
	mux_10_to_1 dut (
			.R0(R0), .R1(R1), .R2(R2), .R3(R3),
         .R4(R4), .R5(R5), .R6(R6), .R7(R7),
         .G(G),   .SignExtDIN(SignExtDIN),
         .sel(sel),
         .result(result)
    );
	 
	
	initial begin
		pass = 0;
		fail = 0;
		i = 0;
	
		R0  = 16'h0000;  expectedArray[0] = R0;
      R1  = 16'h1111;  expectedArray[1] = R1;
      R2  = 16'h2222;  expectedArray[2] = R2;
      R3  = 16'h3333;  expectedArray[3] = R3;
      R4  = 16'h4444;  expectedArray[4] = R4;
      R5  = 16'h5555;  expectedArray[5] = R5;
      R6  = 16'h6666;  expectedArray[6] = R6;
      R7  = 16'h7777;  expectedArray[7] = R7;
      G   = 16'h8888;  expectedArray[8] = G;
      SignExtDIN = 16'h9999;  expectedArray[9] = SignExtDIN;
		
	for (i = 0; i < 16; i = i + 1) begin
            sel = i[3:0];
            #10; // Wait 10ns for combinational logic propagation

            // Determine expected outcome
            if (sel < 4'd10) begin
                expectedOut = expectedArray[sel];
                
                // Compare MUX output with reference value
                if (result == expectedOut) begin
                    $display("[PASS] sel = %d (4'b%b) | Output = 0x%h | Expected = 0x%h", 
                             sel, sel, result, expectedOut);
                    pass = pass + 1;
                end else begin
                    $display("[FAIL] sel = %d (4'b%b) | Output = 0x%h | Expected = 0x%h", 
                             sel, sel, result, expectedOut);
                    fail = fail + 1;
                end
            end else begin
                // Check default case for unused select values (10 to 15)
                if (result === 16'hXXXX) begin
                    $display("[PASS] sel = %d (4'b%b) | Default case handled properly (Output = 0x%h)", 
                             sel, sel, result);
                    pass = pass + 1;
                end else begin
                    $display("[WARN] sel = %d (4'b%b) | Output = 0x%h (Expected 'x)", 
                             sel, sel, result);
                end
            end
        end

        // Final Verification Summary
        $display("--------------------------------------------------");
        $display(" Verification Complete: %0d Passed, %0d Failed", pass, fail);
        $display("--------------------------------------------------");

        $finish;
    end

endmodule
	
	