`timescale 1ns/1ns
/*
Monash University ECE2072: Assignment 
This file contains a Verilog test bench to test the correctness of the individual 
    components used in the processor.

Please enter your student ID:

*/
module components_tb.v;
//register testbench

// Parameter definition
    parameter N = 16;
    parameter CLK_PERIOD = 10; // 100 MHz Clock

    // Testbench signals (reg for inputs to DUT, wire for outputs from DUT)
    reg          clk;
    reg          rst;
    reg          r_in;
    reg  [N-1:0] data_in;
    wire [N-1:0] Q;

    // Instantiate the test
    register_n #(.N(N)) dut (
        .data_in (data_in),
        .r_in    (r_in),
        .clk     (clk),
        .rst     (rst),
        .Q       (Q)
    );


    always #(CLK_PERIOD / 2) clk = ~clk;


    initial begin
	 
        // Initialise Signals
        clk     = 0;
        rst     = 0;
        r_in    = 0;
        data_in = 0;

		  $display("--------------------------------------------");
        $display("Starting Register Testbench...");
        $display("--------------------------------------------");

        // Reset Test
        #2;
        rst = 1;
        #(CLK_PERIOD);
        rst = 0;
        $display("Reset released. Q = 0x%0h (Expected: 0x0)", Q);

        // Write Data with r_in High
        @(posedge clk);
        data_in = 16'hA5A5;
        r_in    = 1;
        
        @(posedge clk);
        #1; // Small delay
        $display("Write En=1, Data=0xA5A5. Q = 0x%0h (Expected: 0xA5A5)", Q);

        @(posedge clk);
        data_in = 16'hFFFF;
        r_in    = 0;

        @(posedge clk);
        #1;
        $display("Write En=0, Data=0xFFFF. Q = 0x%0h (Expected: 0xA5A5 - Unchanged)", Q);

        @(posedge clk);
        data_in = 16'h1234;
        r_in    = 1;

        @(posedge clk);
        #1;
        $display("Write En=1, Data=0x1234. Q = 0x%0h (Expected: 0x1234)", Q);

        @(posedge clk);
        data_in = 16'h8888;
        r_in    = 1;
        rst     = 1;

        @(posedge clk);
        #1;
        $display("Reset & Write En active. Q = 0x%0h (Expected: 0x0 - Reset priority)", Q);

        rst  = 0;
        r_in = 0;
        
        #(CLK_PERIOD * 2);
        $display("--------------------------------------------");
        $display("Testbench Completed Successfully.");
        $display("--------------------------------------------");
        $finish;
    end

//mux 10 to 1 testbecnh 
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
	
	