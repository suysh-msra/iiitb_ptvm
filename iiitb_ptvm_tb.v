
‘include "vending.v"
//testbench
//'include "vending.v"
module iiitbptvending_machine_tb;

	reg clk;
	reg rst;
	reg [1:0]in;
	
	wire out;
	
	iiitb_ptv_machine uut(
		.in(in),
		.clk(clk),
		.rst(rst),
		.out(out)
	);
	
	initial begin
	$dumpfile("ticketvending.vcd");
		$dumpvars(0,iiitbptvending_machine_tb);
	rst = 1;
	clk = 0;
	
	#6 rst = 0;
	in = 1;
	
	#19 in = 2; #10;
	end
	
	
	always #5 clk = ~clk;
	
endmodule
