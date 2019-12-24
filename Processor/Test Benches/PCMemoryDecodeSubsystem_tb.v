`timescale 1ns / 1ps

module PCMemoryDecodeSubsystem_tb;

	// Inputs
	reg [15:0] ALU_Out;
	reg [1:0] PC_Source;
	reg [1:0] RegData;
	reg [1:0] RegDest;
	reg PC_Write;
	reg InstData;
	reg MemoryWrite;
	reg IR_Write;
	reg WriteReg;
	reg [1:0] RsRd;
	reg RsRt;
	reg UpperLower;
	reg Reset;
	reg Clock;

	// Outputs
	wire [15:0] A;
	wire [15:0] B;
	wire [15:0] PC_Out;
	wire [15:0] ZE;
	wire [15:0] SE;
	wire [15:0] SEL1;
	wire [4:0] Opcode;

	// Instantiate the Unit Under Test (UUT)
	PCMemoryDecodeSubsystem uut (
		.ALU_Out(ALU_Out),
		.PC_Source(PC_Source), 
		.RegData(RegData), 
		.RegDest(RegDest), 
		.PC_Write(PC_Write), 
		.InstData(InstData), 
		.MemoryWrite(MemoryWrite), 
		.IR_Write(IR_Write), 
		.WriteReg(WriteReg), 
		.RsRd(RsRd), 
		.RsRt(RsRt), 
		.UpperLower(UpperLower), 
		.Reset(Reset), 
		.Clock(Clock), 
		.A(A), 
		.B(B),
		.PC_Out(PC_Out),
		.ZE(ZE), 
		.SE(SE), 
		.SEL1(SEL1), 
		.Opcode(Opcode)
	);
	
	always #1 Clock = ~Clock;

	initial begin
		// Initialize Inputs
		ALU_Out = 0;
		PC_Source = 0;
		RegData = 0;
		RegDest = 0;
		PC_Write = 0;
		InstData = 0;
		MemoryWrite = 0;
		IR_Write = 0;
		WriteReg = 0;
		RsRd = 0;
		RsRt = 0;
		UpperLower = 0;
		Reset = 1;
		Clock = 0;
        #2;
		Reset = 0;
		
		// Write to PC
		PC_Write = 1;
		PC_Source = 1;
		ALU_Out = 2;
		#2;
		PC_Write = 0;
		#2;
		IR_Write = 1;
		#2;
		IR_Write = 0;
		
		// Write 0xA5A5 to t0;
		ALU_Out = 16'hA5A5;
		RegData = 1;
		WriteReg = 1;
		#2;
		WriteReg = 0;
		
		// Display t0
		RsRd = 2;
		#2;
		
		// Write to memory from B
		InstData = 1;
		ALU_Out = 4;
		MemoryWrite = 1;
		#2;
		MemoryWrite = 0;
		
		$stop;
	end
      
endmodule

