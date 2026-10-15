
`timescale 1ns/1ps

module ALU_tb;

    reg  [15:0] input_a;
    reg  [15:0] input_b;
    reg  [2:0]  alu_op;
    wire [15:0] result;

    integer passed;
    integer failed;

    // Instantiating 
    alu dut (
        .input_a(input_a),
        .input_b(input_b),
        .alu_op(alu_op),
        .result(result)
    );

    
    task check;
        input [15:0] a;
        input [15:0] b;
        input [2:0] op;
        input [15:0] expected;
        begin
            input_a = a;
            input_b = b;
            alu_op = op;
            #1;

            if (result === expected) begin
                $display("PASS: op=%b A=%h B=%h result=%h",
                         op, a, b, result);
                passed = passed + 1;
            end
            else begin
                $display("FAIL: op=%b A=%h B=%h expected=%h actual=%h",
                         op, a, b, expected, result);
                failed = failed + 1;
            end
        end
    endtask

    initial begin
        passed = 0;
        failed = 0;

        // Multiplication
        $display("\n--- MULTIPLICATION ---");
        check(16'd12,   16'd10,   3'b000, 16'h0078);
        check(16'h00FF, 16'h0002, 3'b000, 16'h01FE);
        check(16'h0100, 16'h0100, 3'b000, 16'h0000);

        // Addition
        $display("\n--- ADDITION ---");
        check(16'd100,  16'd50,   3'b001, 16'h0096);
        check(16'hFFFF, 16'h0001, 3'b001, 16'h0000);
        check(16'h1234, 16'h4321, 3'b001, 16'h5555);

        // Subtraction
        $display("\n--- SUBTRACTION ---");
        check(16'd100,  16'd30,   3'b010, 16'h0046);
        check(16'h0000, 16'h0001, 3'b010, 16'hFFFF);
        check(16'hFFFF, 16'hFFFF, 3'b010, 16'h0000);

        // Shifting 
        // Non-negative input_a means left shift.
        // Negative input_a means logical right shift.
        $display("\n--- SHIFT ---");
        check(16'h0000, 16'h1234, 3'b011, 16'h1234);
        check(16'h0002, 16'h1234, 3'b011, 16'h48D0);
        check(16'h0001, 16'h8001, 3'b011, 16'h0002);
        check(16'h0010, 16'h0001, 3'b011, 16'h0000);
        check(16'hFFFE, 16'h00F0, 3'b011, 16'h003C);
        check(16'hFFFC, 16'hFFF0, 3'b011, 16'h0FFF);

        //summary of results 
        $display("Total tests: %0d", passed + failed);
        $display("Passed:      %0d", passed);
        $display("Failed:      %0d", failed);

        if (failed == 0)
            $display("ALL TESTS PASSED");
        else
            $display("SOME TESTS FAILED");

        $finish;
    end

endmodule
