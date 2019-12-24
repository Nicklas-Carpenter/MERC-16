`timescale 1ns / 1ps

module Register_tb;

	integer i = 0;

	// Inputs
	reg [15:0] DIN;
	reg WR_EN;
	reg Reset;
	reg CLK;

	// Outputs
	wire [15:0] DOUT;

	// Instantiate the Unit Under Test (UUT)
	Register uut (
		.DIN(DIN), 
		.WR_EN(WR_EN),
		.Reset(Reset),
		.CLK(CLK), 
		.DOUT(DOUT)
	);
	
	always #1 CLK = ~CLK;
	initial begin
		// Initialize Inputs
		DIN = 0;
		WR_EN = 1;
		Reset = 1;
		CLK = 0;
		#2;
		Reset = 0;
		
		// Test Writing
		for (i = 0; i < 65535; i = i + 1) begin
			DIN <= i;
			#2;
			if (DOUT != i) begin
				$display("Improper output\t", "Expected: ", i, "\tActual: ", DOUT);
				$stop;
			end
		end
		
		// Test Write Lock
		
		WR_EN <= 0;
		for (i = 0; i < 65535; i = i + 1) begin
			DIN <= 16'hA5A5;
			#2;
			
			if (DOUT == 16'hA5A5) begin
				$display("Improper output\t", "Output: ", DOUT);
				$stop;
			end
		end
		
		$display("All tests passed");
		
		$stop;
		
	end

endmodule

