module testbench;

wire [7:0] result;
reg [3:0] mp;
reg [3:0] mc;
signed_mult #(4) mult(result, mp, mc); 
initial
begin
mp = 4'b1110;
mc = 4'b0100;
#100
$stop;
end
endmodule