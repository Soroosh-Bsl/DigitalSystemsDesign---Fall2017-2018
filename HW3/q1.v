module UART#(parameter clockperbit)(rx, send, clock, reset, tx, txdata, rxdata, rxfinish, txdone);
input [7:0] txdata;
output [7:0] rxdata;
input clock, reset;
input rx;
output tx;
input send;
output rxfinish, txdone;

Receive #(clockperbit) receiveModule(rxdata, rxfinish, rx, clock, reset);
Transmit #(clockperbit) transmitModule(txdata, txdone, send, tx, reset, clock);

endmodule