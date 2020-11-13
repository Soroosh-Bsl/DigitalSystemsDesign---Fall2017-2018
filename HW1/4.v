module unsigned_mult(result, mp, mc);

parameter N = 4;

output [2*N-1:0] result;
input [N-1:0] mp, mc;

wire [N-1:0] carry;
wire [N-1:0] result_and [N-1:0];
wire [N-1:0] s [N-1:0];

genvar i, j, k;
generate
for (i = 0; i < N; i = i+1)
begin
	for (j = 0; j < N; j=j+1)
	begin 
		and (result_and[i][j], mp[j], mc[i]);
	end
end
for (i = 0; i < N; i = i+1)
begin
buf buffers (s[0][i], result_and[0][i]);
end
buf (result[0], s[0][0]);
buf (carry[0], 1'b0);
for (k = 1; k < N; k=k+1)
begin

	 wire [N-1:0] temp;
	 for (i = 0; i < N - 1;i = i+1)
	 begin
	 	 buf (temp[i], s[k-1][i+1]);
	 end
	 buf (temp[N-1], carry[k-1]);
	 RCA #(N) rca(s[k], carry[k], result_and[k], temp[N-1:0], 1'b0);
	 	 
	 buf (result[k], s[k][0]);
end
for (i = 1; i < N; i = i+1)
begin
buf buffers2 (result[i+N-1], s[N-1][i]);
end
buf (result[2*N-1] , carry[N-1]);
endgenerate

endmodule