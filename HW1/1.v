module half_adder(s, c, a, b);
output s, c;
input a, b;
and(c, a, b);
xor(s, a, b);
endmodule
