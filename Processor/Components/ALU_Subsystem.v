`timescale 1ns / 1ps

module ALU_Subsystem(
		 input [15:0] A, B, PC_In, SE, SEL1, ZE,
		 input ALU_SrcA, ZE_SE,
		 input [1:0] ALU_SrcB,
		 input [2:0] ALU_Op,
		 input Reset, Clock,
		 output reg [15:0] ALU_Out, 
		 output [15:0] ALU_Result,
		 output EQ, GR, LT, Zero, Ovfl
    );
	 
	 reg [15:0] SrcA, SrcB, ZE_Or_SE;
	 
	 // Instantiate the ALU
	 ALU MainALU (
		 .A(SrcA), 
		 .B(SrcB), 
		 .S(ALU_Op), 
		 .GR(GR), 
		 .EQ(EQ), 
		 .LT(LT), 
		 .OVFL(Ovfl), 
		 .Z(Zero), 
		 .R(ALU_Result)
    );
	
	// ALU_Out (Register)
	always @(posedge Clock or posedge Reset)
		if (Reset)
			ALU_Out <= 0;
		else
			ALU_Out <= ALU_Result;
	 
	 // SrcA
	 always @(A, PC_In, ALU_SrcA)
        if (ALU_SrcA)
            SrcA <= A;
        else
            SrcA <= PC_In;
	 
	 // SrcB
	 always @(B, ZE_Or_SE, SEL1, ALU_SrcB) 
        case(ALU_SrcB)
            2'b00:
                SrcB <= B;
            2'b01:
                SrcB <= 16'd2;
            2'b10:
                SrcB <= SEL1;
            2'b11:
                SrcB <= ZE_Or_SE;
        endcase
	 
	 // ZE_Or_SE
	 always @(ZE, SE, ZE_SE)
        if (ZE_SE)
            ZE_Or_SE <= SE;
        else
            ZE_Or_SE <= ZE;


endmodule
