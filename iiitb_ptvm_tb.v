
‘include "iiitb_ptvm.v"
//testbench
//'include "vending.v"
module iiitb_ptvm_tb;

	reg clk;
	reg rst;
	reg [1:0]in;
	
	wire out;
	
	iiitb_ptvm uut(
		.in(in),
		.clk(clk),
		.rst(rst),
		.out(out)
	);
	
	initial begin
	$dumpfile("ticketvending.vcd");
		$dumpvars(0,iiitb_ptvm_tb);
	rst = 1;
	clk = 0;
	
	#6 rst = 0;
	in = 1;
	
	#19 in = 2; #10;
	end
	
	
	always #5 clk = ~clk;
	
endmodule
