module IPCore(data, slowTerminated, receivedGet, index, value, readyGive, readyGet, receivedGive, fastClk, slowClk, reset);
input fastClk, slowClk, reset;
input readyGet;

output reg slowTerminated = 0;
output reg receivedGet = 0;
output reg value = 0;
inout [7:0] data;
input receivedGive;
output reg readyGive = 0;
output reg [7:0] index = 8'b0;
reg [7:0] dataOut;

assign data = (slowTerminated)? dataOut: 8'bz;

parameter idle = 3'b000;
parameter gotData = 3'b001;
parameter allDataReceived = 3'b010;
parameter calcHeaderBody = 3'b100;
parameter sendHeader_Body = 3'b101;
parameter handshaking = 3'b110;
parameter bodyCalculator = 3'b111;

parameter idle_calc = 2'b00;
parameter sigmaCalculation = 2'b01;
parameter alphasCalculation = 2'b10;
parameter FINISH = 2'b11;

parameter HALF = 16'b0000000000001000;
parameter RADICAL2_2 = 16'b0000000000001011;
parameter ONE = 16'b0000000000010000;

reg [199:0] body = 0;
reg [599:0] header = 0;
reg [3:0] zero = 0;
reg signed [9:0] numOfBody = 0;
reg [5:0] numOfHeader = 0;
reg [5:0] pivotHeader = 0;
reg signBit;


reg signed [69:0] B [7:0][7:0];
reg signed [15:0] g [7:0][7:0];
reg signed [69:0] G [7:0][7:0];
reg [7:0] i = 0;
reg [3:0] j = 0;
reg signed [5:0] counter = 0;

reg [2:0] state = idle;
reg [1:0] stateOfCalculation [7:0][7:0];
wire signed [15:0] cosinos [7:0][7:0];
wire signed [15:0] alpha [7:0][7:0];
wire [63:0] statesDone;

genvar n, m;
generate
	for (n = 0; n < 8; n = n + 1)
	begin
		for (m = 0; m < 8; m = m + 1)
		begin
			assign cosinos[n][m] = cos (((({((n<<<1) + 1), 4'b0000}>>>4)*({m, 4'b0000}))>>>4)%(32));
			case(m)
				3'd0 : assign alpha[m][n] = ((n == 0)?HALF:RADICAL2_2);
			default :
			begin
				assign alpha[m][n] = ((n == 0) ? RADICAL2_2: ONE);
			end
			endcase		
		end
	end
endgenerate


function signed [15:0] cos (input [4:0] in);
	begin
		case(in)
			5'd0 : cos = 16'd16384;
			5'd1 : cos = 16'd16069;
			5'd2 : cos = 16'd15137;
			5'd3 : cos = 16'd13623;
			5'd4 : cos = 16'd11585;
			5'd5 : cos = 16'd9102;
			5'd6 : cos = 16'd6270;
			5'd7 : cos = 16'd3196;
			5'd8 : cos = 16'd0;
			5'd9 : cos = -16'd3196;
			5'd10 : cos = -16'd6270;
			5'd11 : cos = -16'd9102;
			5'd12 : cos = -16'd11585;
			5'd13 : cos = -16'd13623;
			5'd14 : cos = -16'd15137;
			5'd15 : cos = -16'd16069;
			5'd16 : cos = -16'd16384;
			5'd17 : cos = -16'd16069;
			5'd18 : cos = -16'd15137;
			5'd19 : cos = -16'd13623;
			5'd20 : cos = -16'd11585;
			5'd21 : cos = -16'd9102;
			5'd22 : cos = -16'd6270;
			5'd23 : cos = -16'd3196;
			5'd24 : cos = 16'd0;
			5'd25 : cos = 16'd3196;
			5'd26 : cos = 16'd6270;
			5'd27 : cos = 16'd9102;
			5'd28 : cos = 16'd11585;
			5'd29 : cos = 16'd13623;
			5'd30 : cos = 16'd15137;
			5'd31 : cos = 16'd16069;
		endcase
	end
endfunction

function signed [15:0] Q (input [5:0] in);
	begin
		case(in)
			6'd0 : Q = 16'd2048;
			6'd1 : Q = 16'd2979;
			6'd2 : Q = 16'd3277;
			6'd3 : Q = 16'd2048;
			6'd4 : Q = 16'd1365;
			6'd5 : Q = 16'd819;
			6'd6 : Q = 16'd643;
			6'd7 : Q = 16'd537;
			6'd8 : Q = 16'd2731;
			6'd9 : Q = 16'd2731;
			6'd10 : Q = 16'd2341;
			6'd11 : Q = 16'd1725;
			6'd12 : Q = 16'd1260;
			6'd13 : Q = 16'd565;
			6'd14 : Q = 16'd546;
			6'd15 : Q = 16'd596;
			6'd16 : Q = 16'd2341;
			6'd17 : Q = 16'd2521;
			6'd18 : Q = 16'd2048;
			6'd19 : Q = 16'd1365;
			6'd20 : Q = 16'd819;
			6'd21 : Q = 16'd575;
			6'd22 : Q = 16'd475;
			6'd23 : Q = 16'd585;
			6'd24 : Q = 16'd2341;
			6'd25 : Q = 16'd1928;
			6'd26 : Q = 16'd1489;
			6'd27 : Q = 16'd1130;
			6'd28 : Q = 16'd643;
			6'd29 : Q = 16'd377;
			6'd30 : Q = 16'd410;
			6'd31 : Q = 16'd529;
			6'd32 : Q = 16'd1820;
			6'd33 : Q = 16'd1489;
			6'd34 : Q = 16'd886;
			6'd35 : Q = 16'd585;
			6'd36 : Q = 16'd482;
			6'd37 : Q = 16'd301;
			6'd38 : Q = 16'd318;
			6'd39 : Q = 16'd426;
			6'd40 : Q = 16'd1365;
			6'd41 : Q = 16'd936;
			6'd42 : Q = 16'd596;
			6'd43 : Q = 16'd512;
			6'd44 : Q = 16'd405;
			6'd45 : Q = 16'd315;
			6'd46 : Q = 16'd290;
			6'd47 : Q = 16'd356;
			6'd48 : Q = 16'd669;
			6'd49 : Q = 16'd512;
			6'd50 : Q = 16'd420;
			6'd51 : Q = 16'd377;
			6'd52 : Q = 16'd318;
			6'd53 : Q = 16'd271;
			6'd54 : Q = 16'd273;
			6'd55 : Q = 16'd324;
			6'd56 : Q = 16'd455;
			6'd57 : Q = 16'd356;
			6'd58 : Q = 16'd345;
			6'd59 : Q = 16'd334;
			6'd60 : Q = 16'd293;
			6'd61 : Q = 16'd328;
			6'd62 : Q = 16'd318;
			6'd63 : Q = 16'd331;
		endcase
	end
endfunction

function [5:0] next (input [5:0] in);
begin
	case(in)
		6'd0 : next = 6'd1;
		6'd1 : next = 6'd8;
		6'd2 : next = 6'd3;
		6'd3 : next = 6'd10;
		6'd4 : next = 6'd5;
		6'd5 : next = 6'd12;
		6'd6 : next = 6'd7;
		6'd7 : next = 6'd14;
		6'd8 : next = 6'd16;
		6'd9 : next = 6'd2;
		6'd10 : next = 6'd17;
		6'd11 : next = 6'd4;
		6'd12 : next = 6'd19;
		6'd13 : next = 6'd6;
		6'd14 : next = 6'd21;
		6'd15 : next = 6'd23;
		6'd16 : next = 6'd9;
		6'd17 : next = 6'd24;
		6'd18 : next = 6'd11;
		6'd19 : next = 6'd26;
		6'd20 : next = 6'd13;
		6'd21 : next = 6'd28;
		6'd22 : next = 6'd15;
		6'd23 : next = 6'd30;
		6'd24 : next = 6'd32;
		6'd25 : next = 6'd18;
		6'd26 : next = 6'd33;
		6'd27 : next = 6'd20;
		6'd28 : next = 6'd35;
		6'd29 : next = 6'd22;
		6'd30 : next = 6'd37;
		6'd31 : next = 6'd39;
		6'd32 : next = 6'd25;
		6'd33 : next = 6'd40;
		6'd34 : next = 6'd27;
		6'd35 : next = 6'd42;
		6'd36 : next = 6'd29;
		6'd37 : next = 6'd44;
		6'd38 : next = 6'd31;
		6'd39 : next = 6'd46;
		6'd40 : next = 6'd48;
		6'd41 : next = 6'd34;
		6'd42 : next = 6'd49;
		6'd43 : next = 6'd36;
		6'd44 : next = 6'd51;
		6'd45 : next = 6'd38;
		6'd46 : next = 6'd53;
		6'd47 : next = 6'd55;
		6'd48 : next = 6'd41;
		6'd49 : next = 6'd56;
		6'd50 : next = 6'd43;
		6'd51 : next = 6'd58;
		6'd52 : next = 6'd45;
		6'd53 : next = 6'd60;
		6'd54 : next = 6'd47;
		6'd55 : next = 6'd62;
		6'd56 : next = 6'd57;
		6'd57 : next = 6'd50;
		6'd58 : next = 6'd59;
		6'd59 : next = 6'd52;
		6'd60 : next = 6'd61;
		6'd61 : next = 6'd54;
		6'd62 : next = 6'd63;
		6'd63 : next = 6'd0;
	endcase
end
endfunction

function [3:0] numbers(input [15:0] in);
begin
	//$display("%d %d", in, ((16'b11111111111111111111 ^ in)+1));
	if (in == 0)
	begin
		numbers = 4'd0;
	end
	else if(in < 2 || ((16'b1111111111111111 ^ in)+1) < 2)
	begin
		numbers = 4'd1;
	end
	else if(in < 4 || ((16'b1111111111111111 ^ in)+1) < 4)
	begin
		numbers = 4'd2;
	end
	else if(in < 8 || ((16'b1111111111111111 ^ in)+1) < 8)
	begin
		numbers = 4'd3;
	end
	else if(in < 16 || ((16'b1111111111111111 ^ in)+1) < 16)
	begin
		numbers = 4'd4;
	end
	else if(in < 32 || ((16'b1111111111111111 ^ in)+1) < 32)
	begin
		numbers = 4'd5;
	end
	else if(in < 64 || ((16'b1111111111111111 ^ in)+1) < 64)
	begin
		numbers = 4'd6;
	end
	else if(in <128 || ((16'b1111111111111111 ^ in)+1) < 128)
	begin
		numbers = 4'd7;
	end
	else if(in < 256 || ((16'b1111111111111111 ^ in)+1) < 256)
	begin
		numbers = 4'd8;
	end
	else if(in < 512 || ((16'b1111111111111111 ^ in)+1) < 512)
	begin
		numbers = 4'd9;
	end
	else if(in <1024 || ((16'b1111111111111111 ^ in)+1) < 1024)
	begin
		numbers = 4'd10;
	end
	else if(in <2048 || ((16'b1111111111111111 ^ in)+1) < 2048)
	begin
		numbers = 4'd11;
	end
end
endfunction

function [15:0] mag (input [15:0] in);
begin
	mag = ((in>>15) == 1) ? ((16'b1111111111111111 ^ in)+1) : in;
end
endfunction

always @(posedge fastClk or posedge reset)
begin
	
	//$display("state = %d, fast recGive = %d, readyGive = %d", state, receivedGive, readyGive);
	if (reset == 1'b1)
	begin
		state <= idle;
		index <= 0;
		i <= 0;
		j <= 0;
		numOfBody <= 0;
		numOfHeader <= 0;
		pivotHeader <= 0;
		header <= 0;
		body <= 0;
		zero <= 0;
		signBit <= 0;
	end
	else
	begin
		if (state == idle)
		begin
			if (readyGet == 1'b1)
			begin
				receivedGet <= 1'b1;
			
				g[i][j] <= { ({4'b0000, data} - 12'd128), 4'b0000 };
				if (j == 7)
				begin
					i <= i + 1;
					j <= 0;
					state <= gotData;
				end
				else
				begin
					j <= j + 1;
					state <= gotData;
				end
			end
			else
			begin
				state <= idle;
			end
		end
		else if (state == gotData)
		begin
			if (readyGet == 1'b1)
			begin
				state <= gotData;
			end
			else
			begin
				receivedGet <= 0;
				if (i == 8)
				begin
					state <= allDataReceived;
				end
				else
				begin
					state <= idle;
				end
			end
		end
		else if (state == allDataReceived)
		begin
				if (slowTerminated == 1)
				begin
					//$display("SLOW=1");
					i <= 0;
					j <= 0;
					state <= calcHeaderBody;
				end
				else
				begin
					state <= allDataReceived;
				end
		end
		else if (state == calcHeaderBody)
		begin
			//$display("G[%d][%d] = %d",i, j, G[i][j]);
			if (G[i[2:0]][j[2:0]] == 0)
			begin
				//$display("zeros = %d", zero);
				if (zero <= 14)
				begin
					zero <= zero + 1;
					if (next({i[2:0], j[2:0]}) == 0)
					begin
						state <= sendHeader_Body;
						i <= 0;
					end
					else 
					begin
						//$display("i = %d, j = %d, nexxt = %d", i, j, next({i[2:0], j[2:0]}));
						state <= calcHeaderBody;
						i[2:0] <= next({i[2:0], j[2:0]})>>3;
						j[2:0] <= next({i[2:0], j[2:0]});
					end
				end
				else if (zero == 15)
				begin
					//$display("zero 16 G[%d][%d] = %d, num = %d", i, j, G[i][j], numOfHeader);
					header[599 - (numOfHeader<<3)-:8] <= 8'b11110000;
					numOfHeader <= numOfHeader + 1;
					zero <= 0;
					if (next({i[2:0], j[2:0]}) == 0)
					begin
						state <= sendHeader_Body;
						i <= 0;
					end
					else 
					begin
						//$display("i = %d, j = %d, nexxt = %d", i, j, next({i[2:0], j[2:0]}));
						state <= calcHeaderBody;
						i[2:0] <= next({i[2:0], j[2:0]})>>3;
						j[2:0] <= next({i[2:0], j[2:0]});
					end
				end
			end
			else
			begin
				//$display("%d", numOfHeader);
				//$display("usual G[%d][%d] = %d , num = %d, pivot = %d, zero = %d, header = %b, range : [%d-:8]", i[2:0], j[2:0], G[i[2:0]][j[2:0]], numOfHeader, pivotHeader, zero, {zero, numbers(G[i[2:0]][j[2:0]])}, 599 - (numOfHeader<<3));
				header[599 - (numOfHeader<<3)-:8] <= {zero, numbers(G[i[2:0]][j[2:0]])};
				numOfHeader <= numOfHeader + 1;	
				//$display("pivot = %d", pivotHeader);
				pivotHeader <= (numOfHeader+1);
				zero <= 0;
				numOfBody <= numOfBody + numbers(G[i[2:0]][j[2:0]]);
				state <= bodyCalculator;
				signBit <= (G[i[2:0]][j[2:0]] > 0) ? 1'b1:1'b0;
				B[i[2:0]][j[2:0]] <= mag(G[i[2:0]][j[2:0]]);
				counter <= numbers(G[i[2:0]][j[2:0]]) - 2;
			end
		end
		else if (state == bodyCalculator)
		begin
			body[200 - numOfBody + numbers(B[i[2:0]][j[2:0]]) - 1] <= signBit;
			if (counter >= 0)
			begin
				//$display("100 - numOfBody + counter = %d, counter = %d, body = %b, g[counter] = %b",100 - numOfBody + counter, counter, body, G[i[2:0]][j[2:0]][counter]);
				body[200 - numOfBody + counter] <= B[i[2:0]][j[2:0]][counter];
				counter <= counter - 1;
				state <= bodyCalculator;
			end
			else if (next({i[2:0], j[2:0]}) == 0)
			begin
				//$display("why");
				state <= sendHeader_Body;
				i <= 0;
			end
			else 
			begin
				//$display("i = %d, j = %d, nexxt = %d", i, j, next({i[2:0], j[2:0]}));
				state <= calcHeaderBody;
				i[2:0] <= next({i[2:0], j[2:0]})>>3;
				j[2:0] <= next({i[2:0], j[2:0]});
			end
		end
		else if (state == sendHeader_Body)
		begin
			if (index == 0)
				index <= numOfBody;
			//$display("header = %d, pivot = %d", numOfHeader, pivotHeader);
			//$display("body = %d", numOfBody);
			
			if (i < pivotHeader)
			begin
				
				//$display("i = %d : header = %b", i, header[599:592]);
				dataOut <= header[599:592];
				header <= header<<8;
				i <= i + 1;
				state <= handshaking;
				value <= 1'b0;
				readyGive <= 1'b1;
			end
			else if (numOfBody > 0)
			begin
				//$display("numOfBody = %d, body = %b", numOfBody, body[199:192]);
				dataOut <= body[199:192];
				body <= body<<8;
				state <= handshaking;
				value <= 1'b1;
				readyGive <= 1'b1;
				numOfBody <= numOfBody - 8;
				counter <= 0;
			end
			//else if (numOfBody > 0)
			//begin
				//
				//$display("numOfBody = %d, ");
			//	dataOut <= body[99:92];
			//	numOfBody <= 0;
			//	state <= handshaking;
			//	value <= 1'b1;
			//	readyGive <= 1'b1;
			//end
			else
			begin
				if (value != 0)
				begin
				//$display("Finish");
				dataOut <= 8'b00000000;
				value <= 1'b0;
				readyGive <= 1'b1;
				state <= handshaking;
				end
				else
				begin
					state <= idle;
					index <= 0;
					i <= 0;
					j <= 0;
					numOfBody <= 0;
					numOfHeader <= 0;
					pivotHeader <= 0;
					header <= 0;
					body <= 0;
					zero <= 0;
					signBit <= 0;
				end
			end
		end
		else if (state == handshaking)
		begin
			//$display("hand recGive = %d, readyGive = %d", receivedGive, readyGive);
			
			if ((readyGive == 1) && (receivedGive == 1))
			begin
				//$display("REC = 1");
				readyGive <= 0;
				state <= handshaking;
			end
			else if (readyGive == 0 && receivedGive == 0)
			begin
				//$display("BACK TO SEND");
				state <= sendHeader_Body;
			end
			else
			begin
				//$display("STAY");
				state <= handshaking;
			end
		end
	end
end
genvar u, v;
generate
	for (u = 0; u < 8; u = u + 1)
	begin
		for (v = 0; v < 8; v = v + 1)
		begin
			reg [3:0] x;
			reg [3:0] y;
			always @(posedge slowClk or posedge reset)
			begin
				//$display("G[%d][%d] = %d", u, v, G[u][v]);
				if (reset == 1'b1)
				begin
					G[u][v] <= 0;
					stateOfCalculation[u][v] <= idle_calc;
					x <= 0;
					y <= 0;
				end
				else if (state >= allDataReceived)
				begin
					if (stateOfCalculation[u][v] == idle_calc)
					begin
						if (state >= allDataReceived)
						begin
							stateOfCalculation[u][v] <= sigmaCalculation;
						end
						else
						begin
							stateOfCalculation[u][v] <= idle_calc;
						end
					end
					else if (stateOfCalculation[u][v] == sigmaCalculation)
					begin
						G[u][v] <= (G[u][v] + ((g[x][y] * (cosinos[x][u]>>>4) * (cosinos[y][v]>>>4))));
						if (y < 7)
						begin
							y <= y + 1;
							stateOfCalculation[u][v] <= sigmaCalculation;
						end
						else
						begin
							y <= 0;
							if (x == 7)
							begin
								stateOfCalculation[u][v] <= alphasCalculation;
							end
							else
							begin
								x <= x + 1;
								stateOfCalculation[u][v] <= sigmaCalculation;
							end
						end
					end
					else if (stateOfCalculation[u][v] == alphasCalculation)
					begin
						G[u][v] <= (((G[u][v] * (alpha[u][v]))>>>4) * (Q({u[2:0], v[2:0]})>>>4))>>>37;
						stateOfCalculation[u][v] <= FINISH;
					end
					else if (stateOfCalculation[u][v] == FINISH)
					begin
						stateOfCalculation[u][v] <= FINISH;
					end
				end
				else if (state < allDataReceived)
				begin
					G[u][v] <= 0;
					stateOfCalculation[u][v] <= idle_calc;
					x <= 0;
					y <= 0;
				end
			end
		end
	end
endgenerate

genvar z, t;
generate
	for (z = 0; z < 8; z = z + 1)
	begin
		for (t = 0; t < 8; t = t + 1)
		begin
			assign statesDone[z*8+t] = &stateOfCalculation[z][t];
		end
	end
endgenerate

always @(posedge fastClk)
begin
	if (reset == 1'b1)
	begin
		slowTerminated <= 1'b0;
	end
	else if (statesDone == 64'b1111111111111111111111111111111111111111111111111111111111111111)
	begin
		slowTerminated <= 1'b1;
	end
	else
	begin
		slowTerminated <= 1'b0;
	end
end

//always @(numOfHeader)
//begin
	//$display("%d", numOfHeader);
//end

endmodule