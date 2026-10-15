
module sign_extend_tb;
    reg  [8:0]  in;
    wire [15:0] ext;

    integer passed;
    integer failed;

    sign_extend dut (
        .in(in),
        .ext(ext)
    );

    initial begin
        passed = 0;
        failed = 0;

        // Test 1: Positive input
        in = 9'b000001010;
        #10;
        if (ext === 16'b0000000000001010) begin
            $display("PASS: Positive sign extension");
            passed = passed + 1;
        end else begin
            $display("FAIL: Positive sign extension, expected 0000000000001010, got %b", ext);
            failed = failed + 1;
        end

        // Test 2: Negative input
        in = 9'b100100010;
        #10;
        if (ext === 16'b1111111100100010) begin
            $display("PASS: Negative sign extension");
            passed = passed + 1;
        end else begin
            $display("FAIL: Negative sign extension, expected 1111111100100010, got %b", ext);
            failed = failed + 1;
        end

        // Test 3: Zero input
        in = 9'b000000000;
        #10;
        if (ext === 16'b0000000000000000) begin
            $display("PASS: Zero sign extension");
            passed = passed + 1;
        end else begin
            $display("FAIL: Zero sign extension, expected 0000000000000000, got %b", ext);
            failed = failed + 1;
        end

        // Test 4: Maximum positive 9-bit signed value
        in = 9'b011111111;
        #10;
        if (ext === 16'b0000000001111111) begin
            $display("PASS: Maximum positive input");
            passed = passed + 1;
        end else begin
            $display("FAIL: Maximum positive input, expected 0000000001111111, got %b", ext);
            failed = failed + 1;
        end

        // Test 5: Minimum negative 9-bit signed value
        in = 9'b100000000;
        #10;
        if (ext === 16'b1111111110000000) begin
            $display("PASS: Minimum negative input");
            passed = passed + 1;
        end else begin
            $display("FAIL: Minimum negative input, expected 1111111110000000, got %b", ext);
            failed = failed + 1;
        end

        //summmary 
    
        $display("SIGN EXTENDER TEST SUMMARY");
        $display("Tests passed: %0d", passed);
        $display("Tests failed: %0d", failed);
      
        if (failed == 0)
            $display("ALL TESTS PASSED");
        else
            $display("SOME TESTS FAILED");

        $finish;
    end
endmodule
