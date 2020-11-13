module test_wave;
wire out; 
reg a, b, c, d;
wire e, f, g; 
or #(2,3) (e, a, b); 
and #(3,4) (f, e, c); 
nor #(3,5) (g, f, d); 
xor #(4,6) (out, e, g); 

initial 
begin 
	a = 1'b1;
	c = 1'b1; 
	#8 a = 1'b0;
	b = 1'b0; 
	#6 d = 1'b0; 
end 
endmodule