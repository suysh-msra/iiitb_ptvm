
‘include "fsm2.v"
\\THIS IS THE HIGHEST LEVEL OF THE MODULE: THE TEST BENCH.
module test;
\\THE INPUT IN THE FSM MODULE ARE REG HERE
reg clock,reset;
reg [2:0]coin;
\\THE OUTPUT IN THE FSM MODULE ARE WIRES HERE
wire vend;
wire [2:0]state;
wire [2:0]change;
 \\THE PARAMETERS AGAIN FOR THE COIN AND STATE
parameter [2:0]IDLE=3’b000;
parameter [2:0]FIVE=3’b001;
parameter [2:0]TEN=3’b010;
parameter [2:0]FIFTEEN=3’b011;
parameter [2:0]TWENTY=3’b100;
parameter [2:0]TWENTYFIVE=3’b101;
parameter [2:0]NICKEL=3’b001;
parameter [2:0]DIME=3’b010;
parameter [2:0]NICKEL_DIME=3’b011;
parameter [2:0]DIME_DIME=3’b100;
parameter [2:0]QUARTER=3’b101;
\\I MONITOR THE TIME,DRINK,RESET,CLOCK,STATE AND CHANGE FOR CHANGES.
initial begin
$display("Time\tcoin\tdrink\treset\tclock\tstate\tchange");
$monitor("%g\t%b\t%b\t%b\t%b\t%d\t%d",$time,coin,vend,reset,clock,state,change);
\\NEW FEATURE: MY MACHINE HAS THE FACILITY TO DUMP VARIABLES SO THAT
\\ I CAN VIEW THEM USING A VCD VIEWER.
$dumpvars;
$dumpfile("file.vcd"); // Dump output file.
\\THIS IS WHERE THE COINS ARE ADDED.
clock=0;
reset=1; \\FIRST LETS RESET THE MACHINE
#2 reset=0;
coin=NICKEL; \\CHECK FOR STATE 1
#2 reset=1; coin=2’b00;
#2 reset=0;
coin=DIME;
\\RESET AGAIN AND CHECK FOR STATE 2
#2 reset=1; coin=2’b00;
#2 reset=0;
\\RESET AGAIN AND CHECK FOR STATE 5
  coin=QUARTER;
#2 reset=1; coin=2’b00;
#2 reset=0;
\\RESET AGAIN AND CHECK FOR STATE 5
coin=NICKEL;
#2 coin=NICKEL;
#2 coin=NICKEL;
#2 coin=NICKEL;
#2 coin=NICKEL;
#2 reset=1; coin=2’b00;
#2 reset=0;
\\RESET AGAIN AND CHECK FOR STATE 5 AND SO ON
coin=NICKEL;
#2 coin=DIME;
#2 coin=DIME;
#2 reset=1; coin=2’b00;
#2 reset=0;
coin=NICKEL;
#2 coin=DIME;
#2 coin=QUARTER;
#2 reset=1; coin=2’b00;
#2 reset=0;
coin=NICKEL;
#2 coin=NICKEL;
#2 coin=NICKEL;
#2 coin=DIME;
#2 reset=1; coin=2’b00;
#2 reset=0;
  coin=NICKEL;
#2 coin=NICKEL;
#2 coin=NICKEL;
#2 coin=NICKEL;
#2 coin=DIME;
#2 reset=1; coin=2’b00;
#2 reset=0;
coin=NICKEL;
#2 coin=NICKEL;
#2 coin=QUARTER;
  
  #2 reset=1; coin=2’b00;
#2 reset=0;
coin=NICKEL;
#2 coin=QUARTER;
#2 reset=1; coin=2’b00;
#2 $finish;
end
\\THE CLOCK NEEDS TO TICK EVERY 2 TIME UNIT
always
#1 clock=~clock;
//always @(state)
// coin=!coin;
initial begin
if (reset)
coin=2’b00;
end
\\THIS IS WHERE I INSTANTIATE THE MACHINE
fsm inst1(clock,reset,coin,vend,state,change);
endmodule
