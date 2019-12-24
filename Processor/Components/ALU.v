`timescale 1ns / 1ns

module ALU(
		input [15:0] A,
		input [15:0] B,
		input [2:0] S,
		output GR,
		output EQ,
		output LT,
		output OVFL,
		output Z,
		output reg [15:0] R
    );
	 
	 parameter Add = 3'd0, Sub = 3'd1, And = 3'd2, Or = 3'd3, Not = 3'd4, LeftShift = 3'd5, RightShift = 3'd6, Comp = 3'd7;
	 
	 assign GR = A > B;
	 assign EQ = A == B;
	 assign LT = A < B;
	 assign Z = R == 0;
	 assign OVFL = ((S == Add) & ((A[15] & B[15] & ~R[15]) | (~A[15] & ~B[15] & R[15])))
						| ((S == Sub) & ((A[15] & ~B[15] & ~R[15]) | (~A[15] & B[15] & ~R[15])));
	 
	 always @(S, A, B)
		case(S)
			Add: 
				R <= A + B;	
			Sub:
				R <= A - B;
			And:
				R <= A & B;
			Or:
				R <= A | B;
			Not:
				R <= ~A;
			LeftShift:
				R <= A << B;
			RightShift:
				R <= A >> B;
			Comp: begin
				if (A > B) 
					R <= 16'b1;
				else if (A < B)
					R <= 16'hFFFF;
				else
					R <= 16'b0;
			end
			default:
				R <= 16'd0;
		endcase
					
endmodule
