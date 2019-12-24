`timescale 1ns / 1ps

module IntegratedDatapath_tb;

	// Inputs
	reg Reset;
	reg Clock;
	
	
	wire [31:0] CycleCount = uut.Control.CycleCount;
	wire [31:0] InstructionCount = uut.Control.InstructionCount;
//	wire [15:0] PC_In = uut.Datapath.OperandsAndMemory.PC_Memory.PC_In;
	wire [15:0] PC_Out = uut.Datapath.OperandsAndMemory.PC_Memory.PC_Out;
	wire [15:0] MemoryOut = uut.Datapath.OperandsAndMemory.PC_Memory.MemoryOut;
	wire [15:0] Instruction = uut.Datapath.OperandsAndMemory.Instruction;
	wire [4:0] CurrentState = uut.Control.currentState;
	wire [4:0] NextState = uut.Control.nextState;
//	wire WritePC = uut.WritePC;
//	wire ALU_SrcA = uut.ALU_SrcA;
//	wire [1:0] ALU_SrcB = uut.ALU_SrcB;
//	wire [1:0] PC_Src = uut.PC_Src;
	wire [15:0] SrcA = uut.Datapath.ALU.SrcA;
	wire [15:0] SrcB = uut.Datapath.ALU.SrcB;
//	wire [15:0] ALU_Result = uut.Datapath.ALU.ALU_Result;
	wire [15:0] ALU_Out = uut.Datapath.ALU.ALU_Out;

	wire [15:0] sp = uut.Datapath.OperandsAndMemory.RegFileOutputs.RegFile.OutputMatrix[1];
	wire [15:0] t0 = uut.Datapath.OperandsAndMemory.RegFileOutputs.RegFile.OutputMatrix[2];
	wire [15:0] t1 = uut.Datapath.OperandsAndMemory.RegFileOutputs.RegFile.OutputMatrix[3];
	wire [15:0] t2 = uut.Datapath.OperandsAndMemory.RegFileOutputs.RegFile.OutputMatrix[4];
	wire [15:0] ra = uut.Datapath.OperandsAndMemory.RegFileOutputs.RegFile.OutputMatrix[5];
	wire [15:0] s0 = uut.Datapath.OperandsAndMemory.RegFileOutputs.RegFile.OutputMatrix[6];
	wire [15:0] s1 = uut.Datapath.OperandsAndMemory.RegFileOutputs.RegFile.OutputMatrix[7];
	wire [15:0] s2 = uut.Datapath.OperandsAndMemory.RegFileOutputs.RegFile.OutputMatrix[8];
	wire [15:0] rv0 = uut.Datapath.OperandsAndMemory.RegFileOutputs.RegFile.OutputMatrix[9];
	wire [15:0] rv1 = uut.Datapath.OperandsAndMemory.RegFileOutputs.RegFile.OutputMatrix[10];
	wire [15:0] arg0 = uut.Datapath.OperandsAndMemory.RegFileOutputs.RegFile.OutputMatrix[11];
	wire [15:0] arg1 = uut.Datapath.OperandsAndMemory.RegFileOutputs.RegFile.OutputMatrix[12];

	// Instantiate the Unit Under Test (uut)
	IntegratedDatapath uut (
		.Reset(Reset), 
		.Clock(Clock)
	);
	
	always #1 Clock = ~Clock;

	initial begin
		// Initialize Inputs
		Reset = 1;
		Clock = 0;
		#2;
		Reset = 0;
		
		#327850;
		$stop;
		
	end
      
endmodule

