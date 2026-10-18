
`timescale 1ns/1ps

module proc_extension_tb;

reg clk;
reg rst;
reg enable;
reg [8:0] din;

wire [15:0] bus;

wire [15:0] R0;
wire [15:0] R1;
wire [15:0] R2;
wire [15:0] R3;
wire [15:0] R4;
wire [15:0] R5;
wire [15:0] R6;
wire [15:0] R7;

wire [7:0] sevenSeg0;
wire [7:0] sevenSeg1;
wire [7:0] sevenSeg2;
wire [7:0] sevenSeg3;
wire [7:0] sevenSeg4;
wire [7:0] sevenSeg5;

integer tests_run;
integer tests_passed;
integer tests_failed;

proc_extension dut (
    .clk(clk),
    .rst(rst),
    .enable(enable),
    .din(din),
    .bus(bus),
    .R0(R0),
    .R1(R1),
    .R2(R2),
    .R3(R3),
    .R4(R4),
    .R5(R5),
    .R6(R6),
    .R7(R7),
    .sevenSeg0(sevenSeg0),
    .sevenSeg1(sevenSeg1),
    .sevenSeg2(sevenSeg2),
    .sevenSeg3(sevenSeg3),
    .sevenSeg4(sevenSeg4),
    .sevenSeg5(sevenSeg5)
);

initial clk = 1'b0;
always #5 clk = ~clk;


// 4 tick insruction 
task run_instruction;
    input [2:0] opcode;
    input [2:0] rx;
    input [2:0] operand;
    input use_immediate;
    input [8:0] immediate_value;

    reg [8:0] instruction;

    begin
        instruction = {opcode, rx, operand};

        // Tick 1 Capture instruction in IR
        @(negedge clk);
        din = instruction;
        @(posedge clk);
        #1;

        // Tick 2 Supply immediate if required
        @(negedge clk);
        if (use_immediate)
            din = immediate_value;
        else
            din = 9'b0;

        @(posedge clk);
        #1;

        // Tick 3 ALU operation
        @(posedge clk);
        #1;

        // Tick 4 Write back result
        @(posedge clk);
        #1;
    end
endtask


//read register 
task read_register;
    input [2:0] index;
    output [15:0] value;

    begin
        case (index)
            3'd0: value = R0;
            3'd1: value = R1;
            3'd2: value = R2;
            3'd3: value = R3;
            3'd4: value = R4;
            3'd5: value = R5;
            3'd6: value = R6;
            3'd7: value = R7;
            default: value = 16'bx;
        endcase
    end
endtask


// Check register value
task check_register;
    input [8*24-1:0] test_name;
    input [2:0] index;
    input [15:0] expected;

    reg [15:0] actual;

    begin
        tests_run = tests_run + 1;
        read_register(index, actual);

        if (actual === expected) begin
            tests_passed = tests_passed + 1;
            $display("PASS: %0s | R%0d = 0x%04h",
                     test_name, index, actual);
        end
        else begin
            tests_failed = tests_failed + 1;
            $display("FAIL: %0s | R%0d expected 0x%04h, got 0x%04h",
                     test_name, index, expected, actual);
        end
    end
endtask


// Check display register
task check_display;
    input [8*24-1:0] test_name;
    input [15:0] expected;

    begin
        tests_run = tests_run + 1;

        if (dut.H_out === expected) begin
            tests_passed = tests_passed + 1;
            $display("PASS: %0s | H = 0x%04h",
                     test_name, dut.H_out);
        end
        else begin
            tests_failed = tests_failed + 1;
            $display("FAIL: %0s | H expected 0x%04h, got 0x%04h",
                     test_name, expected, dut.H_out);
        end
    end
endtask


initial begin
    clk = 1'b0;
    rst = 1'b1;
    enable = 1'b1;
    din = 9'b0;

    tests_run = 0;
    tests_passed = 0;
    tests_failed = 0;

    $display("Task 3 proc_extension testbench");

    //asynchronous reset
    repeat (2) @(posedge clk);
    #1;
    rst = 1'b0;

    // movi R1 R2 
    run_instruction(3'b111, 3'd1, 3'd0, 1'b1, 9'd12);
    check_register("MOVI positive", 3'd1, 16'd12);

    // movi R2 
    run_instruction(3'b111, 3'd2, 3'd0, 1'b1, 9'd3);
    check_register("MOVI second register", 3'd2, 16'd3);

    // ADD R3, R2
    
    run_instruction(3'b111, 3'd3, 3'd0, 1'b1, 9'd12);
    check_register("MOVI R3", 3'd3, 16'd12);

    run_instruction(3'b001, 3'd3, 3'd2, 1'b0, 9'd0);
    check_register("ADD", 3'd3, 16'd15);

    // ADDI R1, -2
    run_instruction(3'b010, 3'd1, 3'd0, 1'b1, 9'b111111110);
    check_register("ADDI negative immediate", 3'd1, 16'd10);

    // MOVI R4, 12, then SUB R4, R2
    run_instruction(3'b111, 3'd4, 3'd0, 1'b1, 9'd12);
    check_register("MOVI R4", 3'd4, 16'd12);

    run_instruction(3'b011, 3'd4, 3'd2, 1'b0, 9'd0);
    check_register("SUB", 3'd4, 16'd9);

    // MOVI R5, 10, then MULT R5, R2
    run_instruction(3'b111, 3'd5, 3'd0, 1'b1, 9'd10);
    check_register("MOVI R5", 3'd5, 16'd10);

    run_instruction(3'b100, 3'd5, 3'd2, 1'b0, 9'd0);
    check_register("MULT", 3'd5, 16'd30);

    // MOVI R6, 8
    run_instruction(3'b111, 3'd6, 3'd0, 1'b1, 9'd8);
    check_register("MOVI shift operand", 3'd6, 16'd8);

    // SSI R6, 1
  run_instruction(3'b101, 3'd6, 3'd0, 1'b1, 9'b111111111);
    check_register("SSI right by one", 3'd6, 16'd4);

    // DISP R5
    run_instruction(3'b000, 3'd5, 3'd0, 1'b0, 9'd0);
    check_display("DISP copies register", 16'd30);

    // Check that the display remains unchanged after MOVI
    run_instruction(3'b111, 3'd7, 3'd0, 1'b1, 9'd9);
    check_display("Display persists after MOVI", 16'd30);

    // Final results

    $display("Tests run:    %0d", tests_run);
    $display("Tests passed: %0d", tests_passed);
    $display("Tests failed: %0d", tests_failed);
   
    if (tests_failed == 0)
        $display("Final result: All tests passed");
    else
        $display("Final result: Tests failed");

    $finish;
end

endmodule
