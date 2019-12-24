`timescale 1ns / 1ps

// This test requires memory to be loaded with PCMemorySubsystemTest.coe
module PCMemorySubsystem_tb;
	// Simulator Signals
	integer i = 0;

	// Inputs
	reg [10:0] JumpImmediate;
	reg [15:0] ALU_Out;
	reg [15:0] SrcA;
	reg [15:0] SrcB;
	reg [1:0] PC_Source;
	reg PC_Write;
	reg InstData;
	reg IR_Write;
	reg MemWrite;
	reg Reset;
	reg Clock;

	// Outputs
	wire [15:0] PC_Out;
	wire [15:0] RegData;
	wire [15:0] Instruction;

	// Instantiate the Unit Under Test (UUT)
	PCMemorySubsystem uut (
		.JumpImmediate(JumpImmediate),  
		.ALU_Out(ALU_Out), 
		.SrcA(SrcA), 
		.SrcB(SrcB), 
		.PC_Source(PC_Source), 
		.PC_Write(PC_Write), 
		.InstData(InstData), 
		.IR_Write(IR_Write), 
		.MemWrite(MemWrite), 
		.Reset(Reset), 
		.Clock(Clock), 
		.PC_Out(PC_Out), 
		.RegData(RegData), 
		.Instruction(Instruction)
	);
	
	always #1 Clock = ~Clock;

	initial begin
		// Initialize Inputs
		JumpImmediate = 0;
		ALU_Out = 0;
		SrcA = 0;
		SrcB = 0;
		PC_Source = 0;
		PC_Write = 0;
		InstData = 0;
		IR_Write = 0;
		MemWrite = 0;
		Reset = 1;
		Clock = 0;
		#2;
		Reset = 0;
		
		// Test writing to PC and memory output
		PC_Source = 1; // Use ALU_Combination as input to PC
		PC_Write = 1;
		IR_Write = 1;
		for (i = 0; i < 9; i = i + 1) begin 
			ALU_Out = 2 * i;
			#6; // Wait for effects of PC update to propogate to output registers
			
			if (Instruction != i + 1) begin
				$display("Error - Wrong value in Instruction Register:\n\tExpected: ", i + 1, "\n\tActual: ", Instruction);
				$stop;
			end
			
			if (RegData != i + 1) begin
				$display("Error - Wrong value in RegData:\n\tExpected: ", i + 1, "\n\tActual: ", RegData);
				$stop;
			end
		end
		
		// Test writing to memory
		PC_Source = 1;
		ALU_Out = 2 * 10;
		MemWrite = 1;
		SrcB = 5;
		#4; 
		
		if (Instruction != 5) begin
				$display("Error - Wrong value in Instruction Register:\n\tExpected: 10\n\tActual: ", Instruction);
				$stop;
			end
			
		if (RegData != 5) begin
			$display("Error - Wrong value in RegData:\n\tExpected: 10\n\tActual: ", RegData);
			$stop;
		end
		
		$display("\nAll test passed without error!\n");
		$stop;
	end
      
endmodule

