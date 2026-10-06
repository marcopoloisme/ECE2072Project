
module sign_extend_tb;
	reg[8:0] in;
	wire[15:0] ext;

sign_extend dut(
    .in(in),
	 .ext(ext)
	 
); 

integer passed;
integer failed;

initial begin 
   passed = 0;
	failed = 0; 
	
//test 1 positive input 

in = 9'b000001010;
#10;

if(ext === 16'b0000000000001010)begin
   $display("PASS positive sign extension works");
	passed = passed + 1;
end 

else begin 
  $display("FAIL Positive sign extension failed, expected:0000000000001010, got:%b",ext);
  failed = failed + 1;
 
end 

//Test 2 negative input 

in = 9'b100100010;
#10; 

if(ext === 16'b1111111100100010)begin
  $display("PASS negative sign extension works");
  passed = passed + 1;
  
end 

else begin 
  $display("FAIL negative sign extension failed, expected 1111111100100010, got:%b",ext);
  failed = failed + 1; 
end 

//test 3 = 0

in[8:0] = 9'b00000000;
#10;

if(ext===16'b0000000000000000)begin 
  $display("PASS zero sign extension works");
  passed = passed + 1; 
end 

else begin 

$display("FAIL zero sign extension failed);
failed = failed + 1;

end 

$display("Test summary");
$display("Tests Passed: %0d",passed);
$display("Tests failed: %0d",failed);

$finish; 

end 


endmodule 