module HCA(sum, cout, a, b, cin); 
output [15:0] sum; 
output cout; 
input [15:0] a, b;
input cin;
wire P_00, G_00, G_11, P_11, G_22, P_22, G_33, P_33, G_44, P_44, G_55, P_55, G_66, P_66, G_77, P_77, G_88, P_88, G_99, P_99, G_1010, P_1010, G_1111, P_1111, G_1212, P_1212, G_1313, P_1313, G_1414, P_1414, G_1515, P_1515, G_1616, P_1616;
wire G_10, G_20, G_32, P_32, G_30, G_40, G_54, P_54, G_52, P_52, G_50, G_60, G_76,  P_76, G_74, P_74, G_70, G_80, G_98, P_98, G_96, P_96, G_90, G_100, G_1110, P_1110, G_118, P_118, G_110, G_120, G_1312;
wire P_1312, G_1310, P_1310, G_130, G_140, G_1514, P_1514, G_1512, P_1512, G_150, G_160;

	assign P_00 = 0;
	assign   G_00 = cin;
	
	assign G_11 = a[0] & b[0];
	assign P_11 = a[0] ^ b[0]; 
	assign G_22 = a[1] & b[1];
	assign P_22 = a[1] ^ b[1];
	assign G_33 = a[2] & b[2];
	assign P_33 = a[2] ^ b[2];
	assign G_44 = a[3] & b[3];
	assign P_44 = a[3] ^ b[3];
	assign G_55 = a[4] & b[4];
	assign P_55 = a[4] ^ b[4];
	assign G_66 = a[5] & b[5];
	assign P_66 = a[5] ^ b[5];
	assign G_77 = a[6] & b[6];
	assign P_77 = a[6] ^ b[6];
	assign G_88 = a[7] & b[7];
	assign P_88 = a[7] ^ b[7];
	assign G_99 = a[8] & b[8];
	assign P_99 = a[8] ^ b[8];
	assign G_1010 = a[9] & b[9];
	assign P_1010 = a[9] ^ b[9];
	assign G_1111 = a[10] & b[10];
	assign P_1111 = a[10] ^ b[10];
	assign G_1212 = a[11] & b[11];
	assign P_1212 = a[11] ^ b[11];
	assign G_1313 = a[12] & b[12];
	assign P_1313 = a[12] ^ b[12];
	assign G_1414 = a[13] & b[13];
	assign P_1414 = a[13] ^ b[13];
	assign G_1515 = a[14] & b[14];
	assign P_1515 = a[14] ^ b[14];
	assign G_1616 = a[15] & b[15];
	assign P_1616 = a[15] ^ b[15];

	
	
	assign G_10 = G_11 | (P_11 & G_00); //Gray Cell 1
	assign G_20 = G_22 | (P_22 & G_10); //Gray Cell 2
	
	assign G_32 = G_33 | (P_33 & G_22);
	assign P_32 = P_33 & P_22; //Black Cell 3
	assign G_30 = G_32 | (P_32 & G_10); //Gray Cell 3

	assign G_40 = G_44 | (P_44 & G_30); //Gray Cell 4

	assign G_54 = G_55 | (P_55 & G_44);
	assign P_54 = P_55 & P_44; //Black Cell 5.1
	assign G_52 = G_54 | (P_54 & G_32);
	assign P_52 = P_54 & P_32; //Black Cell 5.2
	assign G_50 = G_52 | (P_52 & G_10); //Gray Cell 5

	assign G_60 = G_66 | (P_66 & G_50); //Gray Cell 6

	assign G_76 = G_77 | (P_77 & G_66);
	assign P_76 = P_77 & P_66; //Black Cell 7.1
	assign G_74 = G_76 | (P_76 & G_54);
	assign P_74 = P_76 & P_54; //Black Cell 7.2
	assign G_70 = G_74 | (P_74 & G_30); //Gray Cell 7

	assign G_80 = G_88 | (P_88 & G_70); //Gray Cell 8

	assign G_98 = G_99 | (P_99 & G_88);
	assign P_98 = P_99 & P_88; // Black Cell 9.1
	assign G_96 = G_98 | (P_98 & G_76);
	assign P_96 = P_98 & P_76; // Black Cell 9.2
	assign G_90 = G_96 | (P_96 & G_50); //Gray Cell 9
	
	assign G_100 = G_1010 | (P_1010 & G_90); //Gray Cell 10

	assign G_1110 = G_1111 | (P_1111 & G_1010);
	assign P_1110 = P_1111 & P_1010; // Black Cell 11.1
	assign G_118 = G_1110 | (P_1110 & G_98);
	assign P_118 = P_1110 & P_98; // Black Cell 11.2
	assign G_110 = G_118 | (P_118 & G_70); //Gray Cell 11

	assign G_120 = G_1212 | (P_1212 & G_110); //Gray Cell 12
	
	assign G_1312 = G_1313 | (P_1313 & G_1212);
	assign P_1312 = P_1313 & P_1212; // Black Cell 13.1
	assign G_1310 = G_1312 | (P_1312 & G_1110);
	assign P_1310 = P_1312 & P_1110; // Black Cell 13.2
	assign G_130 = G_1310 | (P_1310 & G_90); //Gray Cell 13

	assign G_140 = G_1414 | (P_1414 & G_130); //Gray Cell 14

	assign G_1514 = G_1515 | (P_1515 & G_1414);
	assign P_1514 = P_1515 & P_1414; // Black Cell 15.1
	assign G_1512 = G_1514 | (P_1514 & G_1312);
	assign P_1512 = P_1514 & P_1312; // Black Cell 15.2
	assign G_150 = G_1512 | (P_1512 & G_110); //Gray Cell 15

	assign G_160 = G_1616 | (P_1616 & G_150); //Gray Cell 16
	
	assign sum[0] = P_11 ^ G_00;
	assign sum[1] = P_22 ^ G_10;
	assign sum[2] = P_33 ^ G_20;
	assign sum[3] = P_44 ^ G_30;
	assign sum[4] = P_55 ^ G_40;
	assign sum[5] = P_66 ^ G_50;
	assign sum[6] = P_77 ^ G_60;
	assign sum[7] = P_88 ^ G_70;
	assign sum[8] = P_99 ^ G_80;
	assign sum[9] = P_1010 ^ G_90;
	assign sum[10] = P_1111 ^ G_100;
	assign sum[11] = P_1212 ^ G_110;
	assign sum[12] = P_1313 ^ G_120;
	assign sum[13] = P_1414 ^ G_130;
	assign sum[14] = P_1515 ^ G_140;
	assign sum[15] = P_1616 ^ G_150;
	assign cout = G_160;

endmodule