`timescale 1ns/1ps

// ECE2072 TASK 1 COMPONENT TESTBENCH
// Tests:
// 1. Sign extender
// 2. Tick FSM
// 3. ALU
// 4. Multiplexer
// 5. Register

module components_tb;

   
    reg clk = 0;
    integer passed = 0;
    integer failed = 0;

    always #5 clk = ~clk;



  // 1. Sign Extender 


    reg  [8:0]  sign_in;
    wire [15:0] sign_ext;

    sign_extend sign_ext_inst (
        .in(sign_in),
        .ext(sign_ext)
    );


    
    // 2. Tick FSM
   

    reg tick_enable;
    reg tick_rst;
    wire [3:0] tick;

    tick_FSM tick_inst (
        .enable(tick_enable),
        .rst(tick_rst),
        .clk(clk),
        .tick(tick)
    );


   
    // 3. ALU
 

    reg  [15:0] alu_a;
    reg  [15:0] alu_b;
    reg  [2:0]  alu_op;
    wire [15:0] alu_result;

    alu alu_inst (
        .input_a(alu_a),
        .input_b(alu_b),
        .alu_op(alu_op),
        .result(alu_result)
    );



   //4. Mutiplexer 

    reg  [15:0] SignExtDIN;
    reg  [15:0] R0, R1, R2, R3;
    reg  [15:0] R4, R5, R6, R7;
    reg  [15:0] G;
    reg  [15:0] PC;
    reg  [15:0] Add1;
    reg  [3:0]  sel;
    wire [15:0] Bus;

    multiplexer mux_inst (
        .SignExtDin(SignExtDIN),
        .R0(R0),
        .R1(R1),
        .R2(R2),
        .R3(R3),
        .R4(R4),
        .R5(R5),
        .R6(R6),
        .R7(R7),
        .G(G),
        .PC(PC),
        .Add1(Add1),
        .sel(sel),
        .Bus(Bus)
    );



    //5. Register 

    parameter N = 16;

    reg  [N-1:0] data_in;
    reg          r_in;
    reg          rst;
    wire [N-1:0] Q;

    register_n #(.N(N)) register_inst (
        .data_in(data_in),
        .r_in(r_in),
        .clk(clk),
        .Q(Q),
        .rst(rst)
    );


   
    // tasks check 
   

    task check16;
        input [255:0] test_name;
        input [15:0] actual;
        input [15:0] expected;
        begin
            if (actual === expected) begin
                $display(
                    "[PASS] %0s: got %04h, expected %04h",
                    test_name, actual, expected
                );
                passed = passed + 1;
            end
            else begin
                $display(
                    "[FAIL] %0s: got %04h, expected %04h",
                    test_name, actual, expected
                );
                failed = failed + 1;
            end
        end
    endtask


    task check_tick;
        input [255:0] test_name;
        input [3:0] actual;
        input [3:0] expected;
        begin
            if (actual === expected) begin
                $display(
                    "[PASS] %0s: got %04b, expected %04b",
                    test_name, actual, expected
                );
                passed = passed + 1;
            end
            else begin
                $display(
                    "[FAIL] %0s: got %04b, expected %04b",
                    test_name, actual, expected
                );
                failed = failed + 1;
            end
        end
    endtask


    task check_alu;
        input [255:0] test_name;
        input [15:0] a;
        input [15:0] b;
        input [2:0] operation;
        input [15:0] expected;
        begin
            alu_a  = a;
            alu_b  = b;
            alu_op = operation;
            #2;
            check16(test_name, alu_result, expected);
        end
    endtask


    
    // MAIN TEST SEQUENCE
   

    initial begin

        $display("ECE2072 COMPONENT TESTBENCH");



        // Initialise inputs
  

        sign_in = 0;

        tick_enable = 0;
        tick_rst = 1;

        alu_a = 0;
        alu_b = 0;
        alu_op = 0;

        SignExtDIN = 16'h9999;
        R0 = 16'h0000;
        R1 = 16'h1111;
        R2 = 16'h2222;
        R3 = 16'h3333;
        R4 = 16'h4444;
        R5 = 16'h5555;
        R6 = 16'h6666;
        R7 = 16'h7777;
        G = 16'h8888;
        PC = 16'hAAAA;
        Add1 = 16'hBBBB;
        sel = 0;

        data_in = 0;
        r_in = 0;
        rst = 1;


        // -----------------------------------------------------
        // SIGN EXTENDER: 5 tests
        // -----------------------------------------------------

        $display("");
        $display("--- SIGN EXTENDER ---");

        sign_in = 9'b000001010;
        #2;
        check16("Positive input", sign_ext, 16'h000A);

        sign_in = 9'b100100010;
        #2;
        check16("Negative input", sign_ext, 16'hFF22);

        sign_in = 9'b000000000;
        #2;
        check16("Zero input", sign_ext, 16'h0000);

        sign_in = 9'b011111111;
        #2;
        check16("Maximum positive input", sign_ext, 16'h00FF);

        sign_in = 9'b100000000;
        #2;
        check16("Minimum negative input", sign_ext, 16'hFF00);



        // TICK FSM: 9 tests
    

        $display("");
        $display("--- TICK FSM ---");

        // Reset the FSM
       @(negedge clk); // tells the clk to fall onto 0 from 1 before starting. 
        tick_rst = 1;
        tick_enable = 0;

        @(posedge clk);
        #1;
        check_tick("Reset to tick 1", tick, 4'b0001);

        // Release reset and enable the FSM
        @(negedge clk);
        tick_rst = 0;
        tick_enable = 1;

        @(posedge clk);
        #1;
        check_tick("Tick 1 to tick 2", tick, 4'b0010);

        @(posedge clk);
        #1;
        check_tick("Tick 2 to tick 3", tick, 4'b0100);

        @(posedge clk);
        #1;
        check_tick("Tick 3 to tick 4", tick, 4'b1000);

        @(posedge clk);
        #1;
        check_tick("Tick 4 wraps to tick 1", tick, 4'b0001);

        // Disable the FSM and check that its state holds
        @(negedge clk);
        tick_enable = 0;

        @(posedge clk);
        #1;
        check_tick("Disabled FSM holds state", tick, 4'b0001);

        // Re-enable the FSM
        @(negedge clk);
        tick_enable = 1;

        @(posedge clk);
        #1;
       check_tick("again enabled FSM advances", tick, 4'b0010);

        // Reset should take priority over enable
        @(negedge clk);
        tick_rst = 1;
        tick_enable = 1;

        @(posedge clk);
        #1;
        check_tick("Reset takes priority", tick, 4'b0001);

        // Disabled FSM should hold after reset
        @(negedge clk);
        tick_rst = 0;
        tick_enable = 0;

        @(posedge clk);
        #1;
        check_tick(
            "Disabled FSM holds after reset",
            tick,
            4'b0001
        );


       
        // ALU: 16 tests
    

        $display("");
        $display("--- ALU ---");

        // Multiplication: opcode 000
        check_alu(
            "Multiply 12 x 10",
            16'd12, 16'd10, 3'b000, 16'd120
        );

        check_alu(
            "Multiply FF x 2",
            16'h00FF, 16'd2, 3'b000, 16'h01FE
        );

        check_alu(
            "Multiply truncated result",
            16'h8000, 16'd2, 3'b000, 16'h0000
        );

        // Addition: opcode 001
        check_alu(
            "Addition",
            16'd100, 16'd50, 3'b001, 16'd150
        );

        check_alu(
            "Addition wraps at 16 bits",
            16'hFFFF, 16'd1, 3'b001, 16'h0000
        );

        check_alu(
            "Addition mixed values",
            16'h1234, 16'h4321, 3'b001, 16'h5555
        );

        // Subtraction: opcode 010
        check_alu(
            "Subtraction",
            16'd100, 16'd30, 3'b010, 16'd70
        );

        check_alu(
            "Subtraction wraps",
            16'h0000, 16'h0001, 3'b010, 16'hFFFF
        );

        check_alu(
            "Subtract equal values",
            16'h1234, 16'h1234, 3'b010, 16'h0000
        );

        // Signed shift: opcode 011
        check_alu(
            "Left shift by zero",
            16'h0000, 16'h1234, 3'b011, 16'h1234
        );

        check_alu(
            "Left shift by two",
            16'h0002, 16'h1234, 3'b011, 16'h48D0
        );

        check_alu(
            "Left shift truncates",
            16'h0001, 16'h8001, 3'b011, 16'h0002
        );

        check_alu(
            "Left shift by 16",
            16'h0010, 16'h1234, 3'b011, 16'h0000
        );

        check_alu(
            "Right shift by two",
            16'hFFFE, 16'h00F0, 3'b011, 16'h003C
        );

        check_alu(
            "Right shift negative B",
            16'hFFFF, 16'hFFFF, 3'b011, 16'h7FFF
        );

  


        // Mux: 16 tests 
       
        $display("");
        $display("--- MULTIPLEXER ---");

   
        sel = 4'd0;
        #1;
        check16("MUX selects R0", Bus, 16'h0000);

        sel = 4'd1;
        #1;
        check16("MUX selects R1", Bus, 16'h1111);

        sel = 4'd2;
        #1;
        check16("MUX selects R2", Bus, 16'h2222);

        sel = 4'd3;
        #1;
        check16("MUX selects R3", Bus, 16'h3333);

        sel = 4'd4;
        #1;
        check16("MUX selects R4", Bus, 16'h4444);

        sel = 4'd5;
        #1;
        check16("MUX selects R5", Bus, 16'h5555);

        sel = 4'd6;
        #1;
        check16("MUX selects R6", Bus, 16'h6666);

        sel = 4'd7;
        #1;
        check16("MUX selects R7", Bus, 16'h7777);

        sel = 4'd8;
        #1;
        check16("MUX selects G", Bus, 16'h8888);

        sel = 4'd9;
        #1;
        check16("MUX selects SignExtDIN", Bus, 16'h9999);

        sel = 4'd10;
        #1;
        check16("MUX selects PC", Bus, 16'hAAAA);

        sel = 4'd11;
        #1;
        check16("MUX selects Add1", Bus, 16'hBBBB);

        sel = 4'd12;
        #1;
        check16("MUX default selection 12", Bus, 16'h0000);

        sel = 4'd13;
        #1;
        check16("MUX default selection 13", Bus, 16'h0000);

        sel = 4'd14;
        #1;
        check16("MUX default selection 14", Bus, 16'h0000);

        sel = 4'd15;
        #1;
        check16("MUX default selection 15", Bus, 16'h0000);



        // REGISTER: 5 tests
     

        $display("");
        $display("--- REGISTER ---");

        // Reset register
        @(negedge clk);
        rst = 1;
        r_in = 0;
        data_in = 16'h0000;

        @(posedge clk);
        #1;
        check16("Register reset", Q, 16'h0000);

        // Load A5A5
        @(negedge clk);
        rst = 0;
        r_in = 1;
        data_in = 16'hA5A5;

        @(posedge clk);
        #1;
        check16("Register loads A5A5", Q, 16'hA5A5);

        // Hold the value while disabled
        @(negedge clk);
        r_in = 0;
        data_in = 16'hFFFF;

        @(posedge clk);
        #1;
        check16("Register holds when disabled", Q, 16'hA5A5);

        // Load 1234
        @(negedge clk);
        r_in = 1;
        data_in = 16'h1234;

        @(posedge clk);
        #1;
        check16("Register loads 1234", Q, 16'h1234);

        // Reset must take priority over load
        @(negedge clk);
        rst = 1;
        r_in = 1;
        data_in = 16'hFFFF;

        @(posedge clk);
        #1;
        check16("Reset takes priority over load", Q, 16'h0000);



        // Final summary of results from the testbench 


        $display("");
        $display("ECE2072 COMPONENT TEST SUMMARY");
        $display("Total tests : %0d", passed + failed);
        $display("Passed      : %0d", passed);
        $display("Failed      : %0d", failed);

        if (failed == 0)
            $display("Overall result: All tests passed");
        else
            $display("Overall result: Tests failed");

        $finish;

    end

endmodule
