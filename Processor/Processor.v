`timescale 1ns / 1ps

module IntegratedDatapath(
	input Reset,
	input Clock
);

wire WritePC, PCWrite, WriteMemory, WriteIR, WriteRegister, ZE_SE, UpperLower, ALU_SrcA, HoldOldPCValue, OldNew; 

wire BNE, BEQ, BLT, BLET, BGT, BGET;

wire EQ, GR, LT, Ovfl, Zero;

wire [1:0] PC_Src, ALU_SrcB, RsRd, RsRt, RegDest, RegData;

wire [2:0] ALU_Op;

wire [4:0] Opcode;

assign WritePC = PCWrite | (BEQ & EQ) | (BNE & ~EQ) | (BLT & LT) | (BGT & GR) | (BLET & (EQ | LT)) | (BGET & (EQ | GR));

FiniteStateMachineInVerilog Control (
		.Clock(Clock), 
		.Reset(Reset), 
		.opcode(Opcode), 
		.PCWrite(PCWrite), 
		.MemRead(), 
		.MemWrite(WriteMemory), 
		.IRWrite(WriteIR), 
		.ALUSrcA(ALU_SrcA), 
		.InstData(InstData), 
		.WriteReg(WriteRegister), 
		.ZeSe(ZE_SE), 
		.UpperLower(UpperLower), 
		.RsRt(RsRt), 
		.BNE(BNE), 
		.BEQ(BEQ), 
		.BLT(BLT), 
		.BLET(BLET), 
		.BGT(BGT), 
		.BGET(BGET), 
		.ALUSrcB(ALU_SrcB), 
		.PCSource(PC_Src), 
		.RegDest(RegDest), 
		.RegData(RegData), 
		.RsRd(RsRd),
		.ALUOp(ALU_Op),
		.HoldOldPCValue(HoldOldPCValue),
		.OldNew(OldNew)
	);
	
	PCMemoryDecodeALU_Subsystem Datapath (
		.WritePC(WritePC), 
		.InstData(InstData), 
		.WriteMemory(WriteMemory), 
		.WriteIR(WriteIR), 
		.RegData(RegData), 
		.RegDest(RegDest), 
		.WriteRegister(WriteRegister), 
		.RsRd(RsRd), 
		.RsRt(RsRt), 
		.ZE_SE(ZE_SE), 
		.ALU_SrcA(ALU_SrcA), 
		.ALU_SrcB(ALU_SrcB), 
		.UpperLower(UpperLower), 
		.ALU_Op(ALU_Op), 
		.PC_Src(PC_Src), 
		.HoldOldPCValue(HoldOldPCValue),
		.OldNew(OldNew),
		.Reset(Reset), 
		.Clock(Clock), 
		.Opcode(Opcode), 
		.EQ(EQ), 
		.GR(GR), 
		.LT(LT), 
		.Zero(Zero), 
		.Ovfl(Ovfl)
	);
endmodule
