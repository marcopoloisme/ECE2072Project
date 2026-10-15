module tick_FSM_tb;

    reg enable;
    reg rst;
    reg clk;
    wire [3:0] tick;

    integer passed;
    integer failed;

    //instantiating FSM 
    tick_FSM dut (
        .enable(enable),
        .rst(rst),
        .clk(clk),
        .tick(tick)
    );

    // clock with 10-time period 
    always #5 clk = ~clk;

    // current tick against expected value 
    task check_tick;
        input [3:0] expected;
        begin
            if (tick === expected) begin
                $display("PASS: Expected tick %b, got %b",
                         expected, tick);
                passed = passed + 1;
            end else begin
                $display("FAIL: Expected tick %b, got %b",
                         expected, tick);
                failed = failed + 1;
            end
        end
    endtask

    initial begin
        passed = 0;
        failed = 0;
        clk = 0;
        rst = 0;
        enable = 0;

        // Test 1 synchronous reset
        @(negedge clk);
        rst = 1;
        @(posedge clk);
        #1;
        check_tick(4'b0001);

        // Release reset and enable the FSM
        @(negedge clk);
        rst = 0;
        enable = 1;

        // Test 2 Tick 1 -> Tick 2
        @(posedge clk);
        #1;
        check_tick(4'b0010);

        // Test 3 Tick 2 -> Tick 3
        @(posedge clk);
        #1;
        check_tick(4'b0100);

        // Test 4 Tick 3 -> Tick 4
        @(posedge clk);
        #1;
        check_tick(4'b1000);

        // Test 5 Tick 4 -> Tick 1 
        @(posedge clk);
        #1;
        check_tick(4'b0001);

        // Test 6 Disable FSM and check that it holds
        @(negedge clk);
        enable = 0;
        @(posedge clk);
        #1;
        check_tick(4'b0001);

        // Test 7 Re-enable FSM and check that it advances
        @(negedge clk);
        enable = 1;
        @(posedge clk);
        #1;
        check_tick(4'b0010);

        // Test 8 Reset must take priority over enable
        @(negedge clk);
        rst = 1;
        enable = 1;
        @(posedge clk);
        #1;
        check_tick(4'b0001);

        // Test 9 Reset released, disabled FSM holds state
        @(negedge clk);
        rst = 0;
        enable = 0;
        @(posedge clk);
        #1;
        check_tick(4'b0001);

        // Final summary
       
        $display("TICK FSM TEST SUMMARY");
        $display("Tests passed: %0d", passed);
        $display("Tests failed: %0d", failed);
       

        if (failed == 0)
            $display("ALL TESTS PASSED");
        else
            $display("SOME TESTS FAILED");

        $finish;
    end

endmodule
