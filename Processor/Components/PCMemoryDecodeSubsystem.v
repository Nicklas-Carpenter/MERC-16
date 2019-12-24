`timescale 1ns / 1ps

module PCMemoryDecodeSubsystem(
		input [15:0] ALU_Out, ALU_Result,
		input [1:0] PC_Source, RegData, RegDest, RsRd, RsRt,
		input PC_Write, InstData, MemoryWrite, IR_Write, WriteReg, UpperLower, HoldOldPCValue, OldNew,
		input Reset, Clock,
		output [15:0] A, B, PC_Out, ZE, SE, SEL1,
		output [4:0] Opcode
	);
	
	wire [10:0] JumpImmediate;
	wire [15:0] DataMemory, Instruction;
	
	assign Opcode = Instruction[15:11];
	
	PCMemorySubsystem PC_Memory (
		.JumpImmediate(JumpImmediate), 
		.ALU_Out(ALU_Out), 
		.ALU_Result(ALU_Result),
		.SrcA(A), 
		.SrcB(B), 
		.PC_Source(PC_Source), 
		.PC_Write(PC_Write), 
		.InstData(InstData), 
		.IR_Write(IR_Write), 
		.MemWrite(MemoryWrite), 
		.Reset(Reset), 
		.Clock(Clock), 
		.PC_Out(PC_Out), 
		.MemoryOut(DataMemory), 
		.Instruction(Instruction)
	);
	
	DecodeSubsystem RegFileOutputs (
		.InstrParam(Instruction[10:0]), 
		.ALUIN(ALU_Out),
		.PCIN(PC_Out),
		.MemoryIn(DataMemory),  
		.RsRt(RsRt), 
		.UpperLower(UpperLower), 
		.WriteEnable(WriteReg), 
		.RegDest(RegDest), 
		.RegData(RegData), 
		.RsRd(RsRd), 
		.HoldOldPCValue(HoldOldPCValue),
		.OldNew(OldNew),
		.Reset(Reset), 
		.Clock(Clock), 
		.A(A), 
		.B(B), 
		.JumpImmediate(JumpImmediate), 
		.ZE(ZE), 
		.SE(SE), 
		.SEL1(SEL1)
	);


endmodule
