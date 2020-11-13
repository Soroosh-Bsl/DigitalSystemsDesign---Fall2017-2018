module testbench;
reg [15:0] a, b;
wire [15:0] sum;
wire cout;
HCA hca(sum, cout, a, b, 0);
initial
begin
	a = 16'd20;
	b = 16'd40;
	#20;
	a = 16'd1;
	b = 16'd1;
	#20;
	a = 16'd5;
	b = 16'd5;
	#20;
	a = 16'd6;
	b = 16'd2;
	#20;
end
endmodule
