`timescale 1ns/1ps
module register_n_tb;

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
        #1; // Small delta delay to observe output after edge
        $display("Write En=1, Data=0xA5A5. Q = 0x%0h (Expected: 0xA5A5)", Q);

        //Hold Data with r_in Low (Write Disabled)
        @(posedge clk);
        data_in = 16'hFFFF;
        r_in    = 0;

        @(posedge clk);
        #1;
        $display("Write En=0, Data=0xFFFF. Q = 0x%0h (Expected: 0xA5A5 - Unchanged)", Q);

        //Overwrite with New Value
        @(posedge clk);
        data_in = 16'h1234;
        r_in    = 1;

        @(posedge clk);
        #1;
        $display("Write En=1, Data=0x1234. Q = 0x%0h (Expected: 0x1234)", Q);

        //Assert Reset during Write (Test Reset Priority)
        @(posedge clk);
        data_in = 16'h8888;
        r_in    = 1;
        rst     = 1;

        @(posedge clk);
        #1;
        $display("Reset & Write En active. Q = 0x%0h (Expected: 0x0 - Reset priority)", Q);

        // Clean up
        rst  = 0;
        r_in = 0;
        
        #(CLK_PERIOD * 2);
        $display("--------------------------------------------");
        $display("Testbench Completed Successfully.");
        $display("--------------------------------------------");
        $finish;
    end

endmodule