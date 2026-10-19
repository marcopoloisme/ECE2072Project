
`timescale 1ns/1ps

module simple_proc_tb;

    reg clk;
    reg rst;
    reg [8:0] din;

    wire [15:0] bus;
    wire [15:0] R0, R1, R2, R3;
    wire [15:0] R4, R5, R6, R7;
    wire [3:0] tick;

    // Processor under test
    simple_proc DUT (
        .clk(clk),
        .rst(rst),
        .din(din),
        .bus(bus),
        .R0(R0), .R1(R1),
        .R2(R2), .R3(R3),
        .R4(R4), .R5(R5),
        .R6(R6), .R7(R7),
        .tick(tick)
    );

    // 20 ns clock period
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Print processor activity
    initial begin
        $monitor(
            "Time=%0t Tick=%b R0=%0d R1=%0d",
            $time, tick, R0, R1
        );
    end

    // Check a register against its expected value
    task check_register;
        input [8*40-1:0] name;
        input [15:0] actual;
        input [15:0] expected;
        begin
            if (actual === expected)
                $display("[PASS] %0s = %0d", name, actual);
            else
                $display(
                    "[FAIL] %0s: got %0d, expected %0d",
                    name, actual, expected
                );
        end
    endtask

    initial begin

        // RESET
        rst = 1;
        din = 9'b0;

        repeat (2) @(posedge clk);
        @(negedge clk);
        rst = 0;

        // ----------------------------------
        // MOVI R0, 5
        // ----------------------------------
        // T1: send instruction
        din = 9'b111_000_000;
        @(posedge clk);
        #1;

        // T2: send immediate value
        @(negedge clk);
        din = 9'd5;
        @(posedge clk);
        #1;

        // Complete T3 and T4
        @(posedge clk);
        #1;
        @(posedge clk);
        #1;

        check_register("MOVI R0, 5", R0, 16'd5);

    
  
        @(negedge clk);
        din = 9'b111_001_000;
        @(posedge clk);
        #1;

        @(negedge clk);
        din = 9'd3;
        @(posedge clk);
        #1;

        @(posedge clk);
        #1;
        @(posedge clk);
        #1;

        check_register("MOVI R1, 3", R1, 16'd3);


        // ADD R0, R1
       
        @(negedge clk);
        din = 9'b001_000_001;
        @(posedge clk);
        #1;

        @(negedge clk);
        din = 9'd0;
        @(posedge clk);
        #1;

        @(posedge clk);
        #1;
        @(posedge clk);
        #1;

        check_register("ADD R0, R1", R0, 16'd8);

        //ADDI
      
        @(negedge clk);
        din = 9'b010_000_000;
        @(posedge clk);
        #1;

        @(negedge clk);
        din = 9'd2;
        @(posedge clk);
        #1;

        @(posedge clk);
        #1;
        @(posedge clk);
        #1;

        check_register("ADDI R0, 2", R0, 16'd10);

      
        @(negedge clk);
        din = 9'b011_000_001;
        @(posedge clk);
        #1;

        @(negedge clk);
        din = 9'd0;
        @(posedge clk);
        #1;

        @(posedge clk);
        #1;
        @(posedge clk);
        #1;

        check_register("SUB R0, R1", R0, 16'd7);

       //Final values of the register. 
        $display("------------------------------");
        $display("Final R0 = %0d", R0);
        $display("Final R1 = %0d", R1);
        $display("------------------------------");

        $finish;
    end

endmodule
