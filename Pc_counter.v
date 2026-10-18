//module for task 4 PC counter + 1 

module PC_counter (
    input clk,
    input rst,
    input pc_inc,
    input pc_load,
    input [15:0] branch_target,
    output reg [15:0] PC
);

    always @(posedge clk) begin
        if (rst)
            PC <= 16'd0; //when reset = 0, rest to zero 
        else if (pc_load)
            PC <= branch_target;  //load branch target 
        else if (pc_inc)
            PC <= PC + 16'd1; //increment by 1 
    end

endmodule
