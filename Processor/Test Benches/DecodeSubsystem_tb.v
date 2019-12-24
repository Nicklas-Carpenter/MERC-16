`timescale 1ns / 1ps

module DecodeSubsystem_tb;

	// Inputs
	reg [10:0] InstrParam;
	reg [15:0] ALUIN;
	reg [15:0] MemoryIn;
	reg [15:0] PCIN;
	reg RsRt;
	reg UpperLower;
	reg WriteEnable;
	reg [1:0] RegDest;
	reg [1:0] RegData;
	reg [1:0] RsRd;
	reg Reset;
	reg Clock;

	// Outputs
	wire [15:0] A;
	wire [15:0] B;
	wire [10:0] JumpImmediate;
	wire [15:0] ZE;
	wire [15:0] SE;
	wire [15:0] SEL1;

	// Instantiate the Unit Under Test (UUT)
	DecodeSubsystem uut (
		.InstrParam(InstrParam), 
		.ALUIN(ALUIN), 
		.MemoryIn(MemoryIn), 
		.PCIN(PCIN), 
		.RsRt(RsRt), 
		.UpperLower(UpperLower), 
		.WriteEnable(WriteEnable), 
		.RegDest(RegDest), 
		.RegData(RegData), 
		.RsRd(RsRd), 
		.Reset(Reset), 
		.Clock(Clock), 
		.A(A), 
		.B(B), 
		.JumpImmediate(JumpImmediate), 
		.ZE(ZE), 
		.SE(SE), 
		.SEL1(SEL1)
	);
	
	always #1 Clock = ~Clock;

	initial begin
		// Initialize Inputs
		InstrParam = 0;
		ALUIN = 0;
		MemoryIn = 0;
		PCIN = 0;
		RsRt = 0;
		UpperLower = 0;
		WriteEnable = 0;
		RegDest = 0;
		RegData = 0;
		RsRd = 0;
		Reset = 1;
		Clock = 0;
		#2; 
		Reset = 0;
		
		/* Test Full Input/Output */
		// Write to t0
		InstrParam = 11'b00100000000; // Set Rd to 2 (address of t0), ignore other bits.
		RegDest = 0; // Use Rd as the address to write to. 
		MemoryIn = 16'hA5A5; // Write 0xA5A5 to t0
		WriteEnable = 1; // Enable writing
		#2; // Wait a clock cycle to write
		
		// Write to t2
		InstrParam = 11'b01000000000; // Set Rd to 4 (address of t2), ignore other bits.
		MemoryIn = 16'hA5A5; // Write 0xA5A5 to t2
		#2; // Wait a clock cycle to write
		
		/* Examine output values */
		InstrParam = 11'b01000100010; // SEt
		WriteEnable = 0; // Disable Writing
		#4; // Allow time to examine results
		$stop;

	end
      
endmodule

