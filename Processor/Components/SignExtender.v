`timescale 1ns / 1ps

module SignExtender(
		input [15:0] In,
		input Reset,
		output reg [15:0] Out
    );

	// Bits are zero indexed
	parameter SIGN_BIT = 3;
	
	
	// Determine sign bit
	reg [15 -(SIGN_BIT + 1): 0] SignRail;
	always @(In or Reset)
		if (In[SIGN_BIT])
			SignRail <= 16'hFFFF;
		else
			SignRail <= 16'h0;
	
	// Perform sign extension
	always @(In or Reset or SignRail)
		if (Reset == 1)
			Out <= 0;
		else
			Out <= {SignRail, In[SIGN_BIT:0]};

endmodule
