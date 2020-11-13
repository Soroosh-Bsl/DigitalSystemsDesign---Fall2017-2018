module RCA(sum, cout, in1, in2, cin);
parameter N = 4;
output [N - 1: 0] sum;
output cout;
input [N - 1: 0] in1, in2;
input cin;
wire [N - 1: 0] car;
wire c;
full_adder f0(sum[0], car[0], in1[0], in2[0], cin);
full_adder full_adders [N - 1: 1] (sum[N-1:1], car[N-1:1], in1[N - 1:1], in2[N - 1:1], car[N - 2:0]);
buf(cout, car[N-1]);
endmodule 
