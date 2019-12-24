`timescale 1ns / 1ps

module Decoder#(parameter N = 4, M = 16)(
		 input [N - 1 : 0] In,
		 input Reset,
		 output [M - 1 : 0] Out
    );
	 
	 assign Out = (1 << In) & (~Reset);

endmodule
