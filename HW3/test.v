module test;
reg clock = 0, reset = 0;
wire [7:0] rxdata;
reg rx;
wire rxfinish;
Receive#(10) t1(rxdata, rxfinish, rx, clock, reset);

always
begin
	#5 clock = ~clock;
end
initial
begin
	rx = 1;
	#100 rx = 0;
	#100 rx = 1;
	#100 rx = 0;
	#100 rx = 1;
	#100 rx = 0;
	#100 rx = 1;
	#100 rx = 0;
	#100 reset = 1;
	#100 reset = 0;
	#10 rx = 1;
	#100 rx = 0;
	#100 rx = 1;
	#100 rx = 0;
	#100 rx = 1;
	#100 rx = 0;
	#100 rx = 1;
	#100 rx = 0;
end
endmodule
