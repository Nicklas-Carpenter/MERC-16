`timescale 1ns / 1ns

module ALU_tb;
	// Variables for testing
	integer i;
	integer j;
	integer o;
	integer z;

	// Inputs
	reg [15:0] A;
	reg [15:0] B;
	reg [2:0] S;

	// Outputs
	wire GR;
	wire EQ;
	wire LT;
	wire OVFL;
	wire Z;
	wire [15:0] R;

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.A(A), 
		.B(B), 
		.S(S), 
		.GR(GR), 
		.EQ(EQ), 
		.LT(LT), 
		.OVFL(OVFL), 
		.Z(Z), 
		.R(R)
	);
	
	always #1 Clock = ~Clock;

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		S = 0;
		o = 0;
		z = 0;
		i = 0;
		j = 0;
		#1;
		
		// Test Add
		for (i = 0; i < 65535; i = i + 1) begin
			for (j = 0; j < 65535; j = j + 1) begin
				A = i;
				B = j;
				#1
				
				$display("A = ", A, "\tB = ", B, "\tExpected: ", A + B, "\tResult: ", R);
				if (R != A + B) begin
					$display("Error in Add - Sum:\n\tA = ", A, ", B = ", B, "\n\tExpected: ", A + B, "\n\tActual: ", R);
					$stop;
				end
				
				o = (A[15] &  B[15] & ~R[15]) | (~A[15] & ~B[15] & R[15]);
				if(OVFL != o) begin
					$display("Error in Add - Overflow:\n\tA = ", A, ", B = ", B, "\n\tExpected: ",o , "\n\tActual: ", OVFL);
					$stop;
				end
			end
		end
		$display("Add passed all tests");
		
		// Test Subtract
		S = 1;
		for (i = 0; i < 2 * (65535); i = i + 1) begin
			{A, B} = i;
			
			if (R != A - B) begin
				$display("Error in Subtract - Difference:\n\tA = ", A, ", B = ", B, "\n\tExpected: ", A - B, "\n\tActual: ", R);
				$stop;
			end
			
			o = (A[15] &  ~B[15] & ~R[15]) | (~A[15] & B[15] & R[15]);
			if(OVFL != o) begin
				$display("Error in Subtract - Overflow:\n\tA = ", A, ", B = ", B, "\n\tExpected: ",o , "\n\tActual: ", OVFL);
				$stop;
			end
			
			z = A - B == 0;
			if(Z != z) begin
				$display("Error in Subtract - Zero Detection:\n\tA = ", A, ", B = ", B, "\n\tExpected: ",z , "\n\tActual: ", Z);
				$stop;
			end
		
			#1;
		end
		$display("Subtract passed all tests");
		
		// Test AND
		S = 2;
		for (i = 0; i < 2 * (65535); i = i + 1) begin
			{A, B} = i;
			
			if (R != A & B) begin
				$display("Error in AND:\n\tA = ", A, ", B = ", B, "\n\tExpected: ", A & B, "\n\tActual: ", R);
				$stop;
			end
			
			z = A & B == 0;
			if(Z != z) begin
				$display("Error in AND - Zero Detection:\n\tA = ", A, ", B = ", B, "\n\tExpected: ",z , "\n\tActual: ", Z);
				$stop;
			end
		
			#1;
		end
		$display("And passed all tests");
      
		// Test OR
		S = 3;
		for (i = 0; i < 2 * (65535); i = i + 1) begin
			{A, B} = i;
			
			if (R != A | B) begin
				$display("Error in OR:\n\tA = ", A, ", B = ", B, "\n\tExpected: ", A | B, "\n\tActual: ", R);
				$stop;
			end
			
			z = A | B == 0;
			if(Z != z) begin
				$display("Error in OR - Zero Detection:\n\tA = ", A, ", B = ", B, "\n\tExpected: ",z , "\n\tActual: ", Z);
				$stop;
			end
		
			#1;
		end
		$display("OR passed all tests");
		
		// Test NOT
		S = 4;
		for (i = 0; i < 2 * (65535); i = i + 1) begin
			{A, B} = i;
			
			if (R != ~A) begin
				$display("Error in NOT - Sum:\n\tA = ", A, "\n\tExpected: ", ~A, "\n\tActual: ", R);
				$stop;
			end
			
			z = ~A == 0;
			if(Z != z) begin
				$display("Error in NOT - Zero Detection:\n\tA = ", ~A, "\n\tExpected: ",z , "\n\tActual: ", Z);
				$stop;
			end
		
			#1;
		end
		$display("NOT passed all tests");
		
		// Test Compare
		S = 5;
		for (i = 0; i < 2 * (65535); i = i + 1) begin
			{A, B} = i;
			
			if (((A > B) & ~R) | ((A == B) & R) | ((A < B) & R != -1)) begin
				$display("Error in Compare:\n\tA = ", A, ", B = ", B, "\n\tActual: ", R);
				$stop;
			end
			
			z = A == B;
			if(Z != z) begin
				$display("Error in Compare - Zero Detection:\n\tA = ", A, ", B = ", B, "\n\tExpected: ",z , "\n\tActual: ", Z);
				$stop;
			end
		
			#1;
		end
		$display("Compare passed all tests");
		
		$display("All tests passsed");
	end
      
endmodule

