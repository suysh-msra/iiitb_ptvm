module iiitb_fsm(clock,reset,coin,vend,state,change);
//\\these are the inputs and the outputs.
input clock;
input reset;
input [2:0]coin;
output vend;
output [2:0]state;
output [2:0]change;

  
 // \\i need to define the registers as change,coin and vend
reg vend;
reg [2:0]change;
wire [2:0]coin;
//\\my coins are declared as parameters to make reading better.
parameter [2:0]NICKEL=3’b001;
parameter [2:0]DIME=3’b010;
parameter [2:0]NICKEL_DIME=3’b011;
parameter [2:0]DIME_DIME=3’b100;
parameter [2:0]QUARTER=3’b101;
//\\MY STATES ARE ALSO PARAMETERS . I DONT WANT TO MAKE YOU READ
//\\IN MACHINE LANGUAGE
parameter [2:0]IDLE=3’b000;
parameter [2:0]FIVE=3’b001;
parameter [2:0]TEN=3’b010;
parameter [2:0]FIFTEEN=3’b011;
parameter [2:0]TWENTY=3’b100;
parameter [2:0]TWENTYFIVE=3’b101;
//\\AS ALWAYS THE STATES ARE DEFINED AS REG
reg [2:0]state,next_state;
//\\MY MACHINE WORKS ON STATE AND COIN
always @(state or coin)
begin
next_state=0; \\VERYFIRST NEXT STATE IS GIVEN ZERO
case(state)
IDLE: case(coin) \\THIS IS THE IDLE STATENICKEL: next_state=FIVE;
DIME: next_state=TEN;
QUARTER: next_state=TWENTYFIVE;
default: next_state=IDLE;
endcase
FIVE: case(coin) \\THIS IS THE SECOND STATE
7
NICKEL: next_state=TEN;
DIME: next_state=FIFTEEN;
QUARTER: next_state=TWENTYFIVE; //change=NICKEL
default: next_state=FIVE;
  endcase
TEN: case(coin) \\THIS IS THE THIRD STATE
NICKEL: next_state=FIFTEEN;
DIME: next_state=TWENTY;
QUARTER: next_state=TWENTYFIVE; //change=DIME
default: next_state=TEN;
endcase
FIFTEEN: case(coin) \\THIS IS THE FOURTH STATE
NICKEL: next_state=TWENTY;
DIME: next_state=TWENTYFIVE;
QUARTER: next_state=TWENTYFIVE; //change==NICKEL_DIME
default: next_state=FIFTEEN;
endcase
TWENTY: case(coin) \\THIS IS THE FIFTH STATE
NICKEL: next_state=TWENTYFIVE;
DIME: next_state=TWENTYFIVE; //change=NICKEL
QUARTER: next_state=TWENTYFIVE; //change==DIME_DIME
default: next_state=TWENTY;
endcase
TWENTYFIVE: next_state=IDLE; \\THE NEXT STATE HERE IS THE RESET
default : next_state=IDLE;
endcase
end
always @(clock)
  begin //\\WHENEVER I GIVE A RESET I HAVE TO MAKE THE STATE TO IDLE AND VEND TO 1
if(reset) begin
state <= IDLE;
vend <= 1’b0;
// change <= 3’b000;
end //\\THE CHANGE ALSO HAS TO BECOME NONE
else state <= next_state;
    case (state) \\HERE WE DECIDE THE NEXT STATE
//\\ALL THE STATES ARE DEFINED HERE AND THE OUTPUT IS ALSO GIVEN
IDLE: begin vend <= 1’b0; change <=3’d0; end
FIVE: begin vend <= 1’b0; if (coin==QUARTER) change <=NICKEL; else change <=3’dTEN: begin vend <= 1’b0; if (coin==QUARTER) change <=DIME; else change <= 3’dFIFTEEN : begin vend <= 1’b0; if (coin==QUARTER) change <=NICKEL_DIME; else chaTWENTY : begin vend <= 1’b0; if (coin==DIME) change <=NICKEL; else if (coin==QUTWENTYFIVE : begin vend <= 1’b1; change <=3’d0; end
default: state <= IDLE;
endcase
end
endmodule
