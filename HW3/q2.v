module Receive#(parameter clockperbit)(rxdata, rxfinish, rx, clock, reset);
input clock;
input rx;
input reset;
output reg rxfinish = 0;
output reg [7:0] rxdata;
reg state = 0;
integer n = 0;
integer numOfBits = 0;
always @ (posedge clock or posedge reset)
begin
	n = n+1;
	if (rxfinish == 1)
	begin
		rxfinish = 0;
	end
	if (reset == 1'b1)
	begin
		rxfinish = 0;
		state = 0;
		n = 0;
		numOfBits = 0;
	end
	
	else if (n == (clockperbit>>1) && state == 0 && rx == 0)
	begin
		state = 1;
	end
	
	else if (n == (clockperbit>>1) && state == 1 && numOfBits < 8)
	begin
		rxdata[numOfBits] = rx;
		numOfBits = numOfBits + 1;	
	end
	
	else if (n == (clockperbit>>1) && numOfBits > 7 && state == 1)
	begin
		rxfinish = 1;
		numOfBits = 0;
		state = 0;
	end

	if (n == clockperbit)
	begin
		n = 0;
	end
end
endmodule
