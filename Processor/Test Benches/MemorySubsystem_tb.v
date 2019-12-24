`timescale 1ns / 1ps

module MemorySubsystem_tb;

	// Simulation Signals
	integer i = 0;

	// Inputs
	reg [15:0] ByteAddress;
	reg [15:0] DIN;
	reg WriteEnable;
	reg Reset;
	reg Clock;
	
	// Outputs
	wire [15:0] DOUT;

	// Instantiate the Unit Under Test (UUT)
	MemorySubsystem uut (
		.ByteAddress(ByteAddress), 
		.DIN(DIN), 
		.WriteEnable(WriteEnable), 
		.Reset(Reset), 
		.Clock(Clock),
		.DOUT(DOUT)
	);

	always #1 Clock = ~Clock;

	initial begin
		// Initialize Inputs
		ByteAddress = 0;
		DIN = 0;
		WriteEnable = 0;
		Reset = 1;
		Clock = 0;
		#1;
		Reset = 0;
		
		
		// Test Writing
		for (i = 0; i < 10; i = i + 1) begin
			ByteAddress = 2 * i;
			#2;
		end
		
		// Test Writing - Write Disabled
		for (i = 10; i >= 0; i = i - 1) begin
			ByteAddress = 2 * i;
			DIN = i;
			#2;
		end
		
		// Test Writing - Write Enabled
		WriteEnable = 1;
		for (i = 10; i >= 0; i = i - 1) begin
			ByteAddress = 2 * i;
			DIN = i;
			#2;
		end
		
		$stop;
	end
      
endmodule

