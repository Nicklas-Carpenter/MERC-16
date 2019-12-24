`timescale 1ns / 1ps

module ALU_Subsystem_tb;

	// Inputs
	reg [15:0] A;
	reg [15:0] B;
	reg [15:0] PC_In;
	reg [15:0] SE;
	reg [15:0] SEL1;
	reg [15:0] ZE;
	reg ALU_SrcA;
	reg ZE_SE;
	reg [1:0] ALU_SrcB;
	reg [2:0] ALU_Op;
	reg Reset;
	reg Clock;

	// Outputs
	wire [15:0] ALU_Result;
	wire [15:0] ALU_Out;
	wire EQ;
	wire GR;
	wire LT;
	wire Zero;
	wire Ovfl;

	// Instantiate the Unit Under Test (UUT)
	ALU_Subsystem uut (
		.A(A), 
		.B(B), 
		.PC_In(PC_In), 
		.SE(SE), 
		.SEL1(SEL1), 
		.ZE(ZE), 
		.ALU_SrcA(ALU_SrcA), 
		.ZE_SE(ZE_SE), 
		.ALU_SrcB(ALU_SrcB), 
		.ALU_Op(ALU_Op), 
		.Reset(Reset), 
		.Clock(Clock), 
		.ALU_Result(ALU_Result), 
		.ALU_Out(ALU_Out), 
		.EQ(EQ), 
		.GR(GR), 
		.LT(LT), 
		.Zero(Zero), 
		.Ovfl(Ovfl)
	);
	
	always #1 Clock = ~Clock;

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		PC_In = 0;
		SE = 0;
		SEL1 = 0;
		ZE = 0;
		ALU_SrcA = 0;
		ZE_SE = 0;
		ALU_SrcB = 0;
		ALU_Op = 0;
		Reset = 1;
		Clock = 0;
		#1;
		Reset = 0;
		ALU_SrcA = 1;
		
		// Add
		A = 10;
		B = 5;
		ALU_Op = 0;
		#3;
		
		//Subtract
		ALU_Op = 1;
		#3;
		
		// AND
		A = 16'b0000000000001011;
		B = 16'b0000000000000100;
		ALU_Op = 2;
		#3;
		
		// OR
		A = 16'hA5A5;
		B = 16'h5A5A;
		ALU_Op = 3;
		#3;
		
		// NOT
		A = 16'hFFFF;
		ALU_Op = 4;
		#3;
		
		// Left Shift
		A = 16'd1;
		B = 16'd1;
		ALU_Op = 5;
		#3;
		
		// Right Shift
		ALU_Op = 6;
		#3;
		
		/* Compare */
		ALU_Op = 7;
		
		// Greater Than
		A = 16'd2;
		B = 16'd1;
		#3;
		
		// Equal To
		B = 16'd2;
		#3;
		
		// Less Than
		A = 16'd1;
		#3;
		
		$stop;
		
	end
      
endmodule

