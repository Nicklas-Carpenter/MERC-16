`timescale 1ns / 1ps

module PCMemorySubsystem(
		input [10:0] JumpImmediate,
		input [15:0] ALU_Result,
		input [15:0] ALU_Out,
		input [15:0] SrcA,
		input [15:0] SrcB,
		input [1:0] PC_Source,
		input PC_Write,
		input InstData,
		input IR_Write,
		input MemWrite,
		input Reset,
		input Clock,
		output [15:0] PC_Out,
		output [15:0] MemoryOut,
		output [15:0] Instruction
	);
	
	
	/* Instatiate Subsystems and Componenents */

	reg [15:0] MemoryAddress, PC_In;
	
	Register PC (
		.DIN(PC_In), 
		.WR_EN(PC_Write), 
		.Reset(Reset), 
		.CLK(Clock), 
		.DOUT(PC_Out)
	);
	
	MemorySubsystem Memory (
		.ByteAddress(MemoryAddress), 
		.DIN(SrcB), 
		.WriteEnable(MemWrite), 
		.Reset(Reset), 
		.Clock(Clock), 
		.DOUT(MemoryOut)
	);
	
	Register InstructionRegister (
		.DIN(MemoryOut), 
		.WR_EN(IR_Write), 
		.Reset(Reset), 
		.CLK(Clock), 
		.DOUT(Instruction)
	);
	
	/* Multiplex Inputs */
	
	// Multiplex data inputs to the PC
	always @(PC_Out, JumpImmediate, ALU_Result, ALU_Out, SrcA, PC_Source) begin
		case(PC_Source)
			2'b00:
				PC_In <= {PC_Out[15:11], JumpImmediate};
			2'b01:
				PC_In <= ALU_Result;
			2'b10:
				PC_In <= ALU_Out;
			2'b11:
				PC_In <= SrcA;
		endcase
	end
	
	// Multiplex memory address input
	always @(PC_Out, ALU_Out, InstData) begin
		if (InstData)
			MemoryAddress <= ALU_Out;
		else
			MemoryAddress <= PC_Out;
	end
	
endmodule
