///1ps

module iiitb_ptvm(
	input clk,
	input rst,
	input [1:0]in,
	output reg out
);

parameter s0 = 2'b00;
parameter s1 = 2'b01;
parameter s2 = 2'b10;

reg [1:0]c_state; reg [1:0]n_state;

always @(posedge clk)
	begin
	if(rst)
		begin
		c_state = 0;
		n_state = 0;
		end
	else
		begin
		c_state = n_state;
		case(c_state)
		s0: if(in == 0)
			begin
			n_state = s0;
			out = 0;
			end
		
		else if(in== 2'b01)
			begin
			n_state = s1;
			out = 0;
			end
			
		else if(in == 2'b10)
			begin
			n_state = s2;
			out = 0;
			end
			
		s1: if(in == 0)
			begin
			n_state = s0;
			out = 0;
			end
		
		else if(in== 2'b01)
			begin
			n_state = s2;
			out = 0;
			end
			
		else if(in == 2'b10)
			begin
			n_state = s0;
			out = 1;
			end
			
		s2: if(in == 0)
			begin
			n_state = s0;
			out = 0;
			end
		
		else if(in== 2'b01)
			begin
			n_state = s0;
			out = 1;
			end
			
		else if(in == 2'b10)
			begin
			n_state = s0;
			out = 1;
			end 
			
		endcase
		
		end
	end
	
endmodule
		
			
/*		
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
	$dumpvars(0,vending_machine_tb);
	rst = 1;
	clk = 0;
	
	#6 rst = 0;
	in = 1;
	
	#19 in = 2; #10;
	end
	
	
	always #5 clk = ~clk;
	
endmodule
*/
