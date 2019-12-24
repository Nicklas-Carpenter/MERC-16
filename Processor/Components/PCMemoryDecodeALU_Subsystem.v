`timescale 1ns / 1ps

module PCMemoryDecodeALU_Subsystem(
		input WritePC,
		input InstData,
		input WriteMemory,
		input WriteIR,
		input HoldOldPCValue,
		input OldNew,
		input [1:0] RegData,
		input [1:0] RegDest,
		input WriteRegister,
		input [1:0] RsRd,
		input [1:0] RsRt,
		input ZE_SE,
		input ALU_SrcA,
		input [1:0] ALU_SrcB,
		input UpperLower,
		input [2:0] ALU_Op,
		input [1:0] PC_Src,
		input Reset, 
		input Clock,
		output [4:0] Opcode,
		output EQ, GR, LT, Zero, Ovfl
	);
	
	wire [15:0] ALU_Out, ALU_Result, A, B, ZE, SE, SEL1, PC_Out;
	
	PCMemoryDecodeSubsystem OperandsAndMemory (
		.ALU_Out(ALU_Out),
		.ALU_Result(ALU_Result),
		.PC_Source(PC_Src), 
		.RegData(RegData), 
		.RegDest(RegDest), 
		.RsRd(RsRd), 
		.PC_Write(WritePC), 
		.InstData(InstData), 
		.MemoryWrite(WriteMemory), 
		.IR_Write(WriteIR), 
		.WriteReg(WriteRegister), 
		.RsRt(RsRt), 
		.UpperLower(UpperLower), 
		.HoldOldPCValue(HoldOldPCValue),
		.OldNew(OldNew),
		.Reset(Reset), 
		.Clock(Clock),
		.PC_Out(PC_Out),
		.A(A), 
		.B(B), 
		.ZE(ZE), 
		.SE(SE), 
		.SEL1(SEL1), 
		.Opcode(Opcode)
	);
	
	ALU_Subsystem ALU (
		.A(A), 
		.B(B), 
		.PC_In(PC_Out), 
		.SE(SE), 
		.SEL1(SEL1), 
		.ZE(ZE), 
		.ALU_SrcA(ALU_SrcA), 
		.ZE_SE(ZE_SE), 
		.ALU_SrcB(ALU_SrcB), 
		.ALU_Op(ALU_Op), 
		.Reset(Reset), 
		.Clock(Clock), 
		.ALU_Out(ALU_Out), 
		.ALU_Result(ALU_Result),
		.EQ(EQ), 
		.GR(GR), 
		.LT(LT), 
		.Zero(Zero), 
		.Ovfl(Ovfl)
	);
	
endmodule
