`timescale 1ns / 1ps

module PCMemoryDecodeALU_Subsystem_tb;

	// Inputs
	reg WritePC;
	reg InstData;
	reg WriteMemory;
	reg WriteIR;
	reg [1:0] RegData;
	reg [1:0] RegDest;
	reg WriteRegister;
	reg [1:0] RsRd;
	reg RsRt;
	reg ZE_SE;
	reg ALU_SrcA;
	reg [1:0] ALU_SrcB;
	reg UpperLower;
	reg [2:0] ALU_Op;
	reg [1:0] PC_Src;
	reg Reset;
	reg Clock;

	// Instantiate the Unit Under Test (UUT)
	PCMemoryDecodeALU_Subsystem uut (
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
		.Reset(Reset), 
		.Clock(Clock),
		.EQ(EQ),
		.GR(GR),
		.LT(LT),
		.Zero(Zero),
		.Ovfl(Ovfl)
	);
	
	wire [15:0] PC_In = uut.OperandsAndMemory.PC_Memory.PC_In;
	wire [15:0] PC_Out = uut.OperandsAndMemory.PC_Memory.PC_Out;
	wire [15:0] MemoryOut = uut.OperandsAndMemory.PC_Memory.MemoryOut;
	wire [15:0] Instruction = uut.OperandsAndMemory.Instruction;
	wire [15:0] A_Out = uut.OperandsAndMemory.A;
	wire [15:0] B_Out = uut.OperandsAndMemory.B;
	wire [15:0] SE_Out = uut.OperandsAndMemory.SE;
	wire [15:0] ZE_Out = uut.OperandsAndMemory.ZE;
	wire [15:0] t0 = uut.OperandsAndMemory.RegFileOutputs.RegFile.OutputMatrix[2];
	wire [15:0] t1 = uut.OperandsAndMemory.RegFileOutputs.RegFile.OutputMatrix[3];
	wire [15:0] t2 = uut.OperandsAndMemory.RegFileOutputs.RegFile.OutputMatrix[4];
	wire [15:0] sp = uut.OperandsAndMemory.RegFileOutputs.RegFile.OutputMatrix[5];
	wire EQ, GR, LT, Zero, Ovfl;
	
	always #1 Clock = ~Clock;

	initial begin
		// Initialize Inputs
		WritePC = 0;
		InstData = 0;
		WriteMemory = 0;
		WriteIR = 0;
		RegData = 0;
		RegDest = 0;
		WriteRegister = 0;
		RsRd = 0;
		RsRt = 0;
		ZE_SE = 0;
		ALU_SrcA = 0;
		ALU_SrcB = 0;
		UpperLower = 0;
		ALU_Op = 0;
		PC_Src = 0;
		Reset = 1;
		Clock = 0;
		#2;
		Reset = 0;
		
		// Load initial value of t0 - lli
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		RegData = 3;
		RegDest = 1;
		WriteRegister = 1;
		UpperLower = 0;
		#2;
		WriteRegister = 0;
		
		// Advance the PC
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		
		// Load initial value of t1 - addi
		ALU_SrcA = 1;
		ALU_SrcB = 3;
		ZE_SE = 1;
		#4;
		RegDest = 0;
		RegData = 1;
		RsRd = 1;
		WriteRegister = 1;
		#2;
		WriteRegister = 0;
		
		// Advance the PC
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		
		// Load initial value of s0 lli
		RegData = 3;
		RegDest = 1;
		WriteRegister = 1;
		UpperLower = 0;
		#2;
		WriteRegister = 0;
		
		// Advance the PC
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		
		// Load initial value of s1 - addi
		ALU_SrcA = 1;
		ALU_SrcB = 3;
		ZE_SE = 1;
		#4;
		RegDest = 0;
		RegData = 1;
		RsRd = 1;
		WriteRegister = 1;
		#2;
		WriteRegister = 0;
		
		// Advance the PC
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		
		// Add 
		ALU_SrcA = 1;
		RsRd = 0;
		RsRt = 1;
		ALU_SrcB = 0;
		#4;
		RegDest = 0;
		RegData = 1;
		WriteRegister = 1;
		#2;
		WriteRegister = 0;
		
		// Advance the PC
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		
		// Addi
		ALU_SrcA = 1;
		ALU_SrcB = 3;
		ZE_SE = 1;
		RsRd = 1;
		#4;
		RegDest = 0;
		RegData = 1;
		WriteRegister = 1;
		#2;
		WriteRegister = 0;
		
		// Advance the PC
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		
		// Sub
		ALU_Op = 1;
		ALU_SrcA = 1;
		RsRd = 0;
		RsRt = 1;
		ALU_SrcB = 0;
		#4;
		RegDest = 0;
		RegData = 1;
		WriteRegister = 1;
		#2;
		WriteRegister = 0;
		
		// Advance the PC
		ALU_Op = 0;
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		
		// Comp
		ALU_Op = 7;
		ALU_SrcA = 1;
		ALU_SrcB = 0;
		RsRt = 1;
		RsRd = 0;
		#4;
		RegDest = 0;
		WriteRegister = 1;
		RegData = 1;
		#2;
		WriteRegister = 0;
		
		// Advance the PC
		ALU_Op = 0;
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		
		// And
		ALU_Op = 2;
		ALU_SrcA = 1;
		ALU_SrcB = 0;
		RsRt = 1;
		RsRd = 0;
		#4;
		RegDest = 0;
		WriteRegister = 1;
		RegData = 1;
		#2;
		WriteRegister = 0;
		
		// Advance the PC
		ALU_Op = 0;
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		
		// Or
		ALU_Op = 3;
		ALU_SrcA = 1;
		ALU_SrcB = 0;
		RsRt = 1;
		RsRd = 0;
		#4;
		RegDest = 0;
		WriteRegister = 1;
		RegData = 1;
		#2;
		WriteRegister = 0;
		
		// Advance the PC
		ALU_Op = 0;
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		
		// Not
		ALU_Op = 4;
		ALU_SrcA = 1;
		ALU_SrcB = 0;
		RsRt = 1;
		RsRd = 0;
		#4;
		RegDest = 0;
		WriteRegister = 1;
		RegData = 1;
		#2;
		WriteRegister = 0;
		
		// Advance the PC
		ALU_Op = 0;
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		
		// SLL
		ALU_Op = 5;
		ALU_SrcA = 1;
		ALU_SrcB = 3;
		RsRd = 1;
		ZE_SE = 0;
		#4;
		RegDest = 0;
		RegData = 1;
		WriteRegister = 1;
		#2;
		WriteRegister = 0;
		
		// Advance the PC
		ALU_Op = 0;
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		
		// SRL
		ALU_Op = 6;
		ALU_SrcA = 1;
		ALU_SrcB = 3;
		RsRd = 1;
		ZE_SE = 0;
		#4;
		RegDest = 0;
		RegData = 1;
		WriteRegister = 1;
		#2;
		WriteRegister = 0;
		
		// Advance the PC
		ALU_Op = 0;
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		
		// lli
		UpperLower = 1;
		RegData = 3;
		RegDest = 1;
		WriteRegister = 1;
		#6;
		WriteRegister = 0;
		
		// Advance the PC
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		
		// lui
		UpperLower = 0;
		RegData = 3;
		RegDest = 1;
		WriteRegister = 1;
		#6;
		WriteRegister = 0;
		
		// Advance the PC
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		
		// Load
		RsRd = 1;
		ALU_SrcA = 1;
		ALU_SrcB = 2;
		ALU_Op = 0;
		InstData = 1;
		#6;
		RegDest = 0;
		RegData = 0;
		WriteRegister = 1;
		#2;
		WriteRegister = 0;
		
		// Advance the PC
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		
		// Store
		RsRd = 2;
		RsRt = 0;
		ALU_SrcA = 1;
		ALU_SrcB = 3;
		ALU_Op = 0;
		InstData = 1;
		#4;
		WriteMemory = 1;
		#2;
		WriteMemory = 0;
		InstData = 0;
		
		
		// Advance the PC
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		
		
		// Jump
		PC_Src = 0;
		WritePC = 1;
		#2;
		WritePC = 0;
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		
		// lli
		WriteIR = 1;
		#4;
		WriteIR = 0;
		RegData = 3;
		RegDest = 1;
		WriteRegister = 1;
		UpperLower = 0;
		#2;
		WriteRegister = 0;
		
		// Advance the PC
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		
		// lui
		WriteIR = 1;
		#4;
		WriteIR = 0;
		RegData = 3;
		RegDest = 1;
		WriteRegister = 1;
		UpperLower = 1;
		#2;
		WriteRegister = 0;
		
		// Advance the PC
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		
		// Jump Register
		RsRd = 2;
		ALU_SrcA = 1;
		ALU_SrcB = 0;
		PC_Src = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		
		// call
		PC_Src = 0;
		RegDest = 2;
		RegData = 2;
		WriteRegister = 1;
		WritePC = 1;
		#2;
		WriteRegister = 0;
		WritePC = 0;
		
		// Pre-advance the PC
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		
		/* beq */
		
		// Write comparison values to A and B
		RsRd = 2;
		RsRt = 0;
		
		//Compute branch target
		ALU_SrcA = 0;
		ALU_SrcB = 2;
		ALU_Op = 0;
		#2;
		
		// Determine whether to jump
		ALU_SrcA = 1;
		ALU_SrcB = 0;
		PC_Src = 1;
		WritePC = EQ;
		if (~WritePC) begin
			WriteIR = 1;
			#2;
			WriteIR = 0;
			PC_Src = 1;
			ALU_SrcA = 0;
			ALU_SrcB = 1;
			#2;
			WritePC = 1;
			#2;
			WritePC = 0;
		end
		else begin	
			#2;
			WritePC = 0;
		end
		
		// Pre-advance the PC
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		
		/* bne */
		
		// Write comparison values to A and B
		RsRd = 2;
		RsRt = 0;
		
		//Compute branch target
		ALU_SrcA = 0;
		ALU_SrcB = 2;
		ALU_Op = 0;
		#2;
		
		// Determine whether to jump
		ALU_SrcA = 1;
		ALU_SrcB = 0;
		WritePC = ~EQ;
		if (~WritePC) begin
			WriteIR = 1;
			#2;
			WriteIR = 0;
			PC_Src = 1;
			ALU_SrcA = 0;
			ALU_SrcB = 1;
			#2;
			WritePC = 1;
			#2;
			WritePC = 0;
		end
		else begin	
			#2;
			WritePC = 0;
		end
		
		// Pre-advance the PC
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		
		/* blt */
		
		// Write comparison values to A and B
		RsRd = 2;
		RsRt = 0;
		
		//Compute branch target
		ALU_SrcA = 0;
		ALU_SrcB = 2;
		ALU_Op = 0;
		#2;
		
		// Determine whether to jump
		ALU_SrcA = 1;
		ALU_SrcB = 0;
		PC_Src = 1;
		WritePC = LT;
		if (~WritePC) begin
			WriteIR = 1;
			#2;
			WriteIR = 0;
			PC_Src = 1;
			ALU_SrcA = 0;
			ALU_SrcB = 1;
			#2;
			WritePC = 1;
			#2;
			WritePC = 0;
		end
		else begin	
			#2;
			WritePC = 0;
		end
		
		// Pre-advance the PC
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		
		/* bgt */
		
		// Write comparison values to A and B
		RsRd = 2;
		RsRt = 0;
		
		//Compute branch target
		ALU_SrcA = 0;
		ALU_SrcB = 2;
		ALU_Op = 0;
		#2;
		
		// Determine whether to jump
		ALU_SrcA = 1;
		ALU_SrcB = 0;
		PC_Src = 1;
		WritePC = GR;
		if (~WritePC) begin
			WriteIR = 1;
			#2;
			WriteIR = 0;
			PC_Src = 1;
			ALU_SrcA = 0;
			ALU_SrcB = 1;
			#2;
			WritePC = 1;
			#2;
			WritePC = 0;
		end
		else begin	
			#2;
			WritePC = 0;
		end
		
		// Pre-advance the PC
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		
		/* blet */
		
		// Write comparison values to A and B
		RsRd = 2;
		RsRt = 0;
		
		//Compute branch target
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		ALU_Op = 0;
		#2;
		
		// Determine whether to jump
		ALU_SrcA = 1;
		ALU_SrcB = 0;
		PC_Src = 1;
		WritePC = LT | EQ;
		if (~WritePC) begin
			WriteIR = 1;
			#2;
			WriteIR = 0;
			PC_Src = 1;
			ALU_SrcA = 0;
			ALU_SrcB = 1;
			#2;
			WritePC = 1;
			#2;
			WritePC = 0;
		end
		else begin	
			#2;
			WritePC = 0;
		end
		
		// Pre-advance the PC
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		
		/* bget */
		
		// Write comparison values to A and B
		RsRd = 2;
		RsRt = 0;
		
		//Compute branch target
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		ALU_Op = 0;
		#2;
		
		// Determine whether to jump
		ALU_SrcA = 1;
		ALU_SrcB = 0;
		PC_Src = 1;
		WritePC = GR | EQ;
		if (~WritePC) begin
			WriteIR = 1;
			#2;
			WriteIR = 0;
			PC_Src = 1;
			ALU_SrcA = 0;
			ALU_SrcB = 1;
			#2;
			WritePC = 1;
			#2;
			WritePC = 0;
		end
		else begin	
			#2;
			WritePC = 0;
		end
		
		// Pre-advance the PC
		#2;
		WriteIR = 1;
		#2;
		WriteIR = 0;
		PC_Src = 1;
		ALU_SrcA = 0;
		ALU_SrcB = 1;
		#4;
		WritePC = 1;
		#2;
		WritePC = 0;
		
		$stop;
		
	end
      
endmodule

