module negative(out, in, neg);
parameter N = 4;
output [N-1:0] out;
input [N-1:0] in;
input neg;
wire [N-1:0] not_in, neg_for_xor, zeros;
genvar i;
generate
for(i = 0; i < N; i=i+1)
begin
buf(neg_for_xor[i], neg);
buf(zeros[i], 0);
end
endgenerate
wire garbage;
xor xors [N-1:0] (not_in, in, neg_for_xor);
RCA #(N) twos_complementer (out, garbage, not_in, zeros, neg);

endmodule
