module full_adder(sum, cout, a, b, cin);
output sum, cout;
input a, b, cin;
wire s, c, c2;
half_adder h1(s, c, a, b);
half_adder h2(sum, c2, s, cin);
or(cout, c, c2);
endmodule 