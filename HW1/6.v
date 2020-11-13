module signed_mult(result, mp, mc);
parameter N= 4;
output [2*N-1:0] result;
input [N-1:0] mp, mc;

wire [N-1:0] mp_pos, mc_pos;
wire [2*N-1:0] result_initial;
wire sign_detection;

negative #(N)in1(mp_pos, mp, mp[N-1]);
negative #(N)in2(mc_pos, mc, mc[N-1]);
negative #(2*N) out(result, result_initial, sign_detection);

xor (sign_detection, mp[N-1], mc[N-1]);

unsigned_mult #(N) mult(result_initial, mp_pos, mc_pos);

endmodule