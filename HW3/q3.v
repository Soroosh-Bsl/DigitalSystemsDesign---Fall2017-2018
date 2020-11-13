module Transmit #(parameter clockperbit)(txdata, txdone, send, tx, reset, clock);
input reset;
input clock;
input send;
input [7:0] txdata;
output reg tx = 1;
output reg txdone = 1;

reg state = 0;
integer n = 1;
integer numOfBits = -1;

always @(posedge clock or reset)
begin
	if (reset == 1'b1)
	begin
		state = 0;
		tx = 1;
		txdone = 1;
		n = 1;
		numOfBits = -1;
	end
	else if (send == 1 && state != 1)
	begin
		state = 1;
		txdone = 0;
		tx = 0;
		n = 2;
		numOfBits = 0;
	end
	else if (state == 0)
	begin
		n = 1;
	end
	else if (state == 1 && n == 1 && numOfBits < 8)
	begin
		tx = (numOfBits >= 0)?txdata[numOfBits]:0;
		numOfBits = numOfBits + 1;
		n = n + 1;
	end
	else if (state == 1 && n == 1 && numOfBits == 8)
	begin
		tx = 1;	
		n = n + 1;
		numOfBits  = numOfBits + 1;
	end
	else if (state == 1 && n == 1 && numOfBits > 8)
	begin
		txdone = 1;
		numOfBits = -1;
		n = 1;
		state = 0;
	end
	else if (state == 1 && n < clockperbit)
	begin
		n = n + 1;
	end
	else if (state == 1 && n == clockperbit)
	begin
		n = 1;
	end	
end
endmodule 