`timescale 1ns / 1ps

module Register(
		input [15:0] DIN,
		input WR_EN,
		input Reset,
		input CLK,
		output reg [15:0] DOUT
    );
	
	always @(posedge CLK or posedge Reset) begin
		if(Reset == 1)
			DOUT <= 0;
		else if (WR_EN == 1'b1)
				DOUT <= DIN;
		else
			DOUT <= DOUT;
	end
		
endmodule
