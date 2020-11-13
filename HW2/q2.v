module top; 
reg C; 
wire #5 A; 
assign #10 A = C; 
wire #10 B; 
assign #5 B = C; 
initial 
begin 
 	#0 C = 1'b0;
	#7 C = 1'b1;
	#1 C = 1'b0;
	#11 C = 1'b1;	
end 
endmodule
