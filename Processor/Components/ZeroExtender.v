`timescale 1ns / 1ps

module ZeroExtender(
		input [15:0] In,
		input Reset,
		output reg [15:0] Out
	);
	 
	// Bit starts at zero
	parameter MSB = 3;
	 
	// Obtain appropriate number of zeroes
	wire [15 - (MSB + 1) : 0] ZeroRail = 16'h0;
	
	// Perform zero extension
	always @(In or Reset or ZeroRail)
		if (Reset)
			Out <= 16'b0;
		else 
			Out <= {ZeroRail, In[MSB:0]};
	
endmodule
