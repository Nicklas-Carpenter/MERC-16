`timescale 1ns / 1ps

module SignExtender_tb;

	// Test signals
	integer signed i = 0;
	wire signed [3:0] In4;
	wire signed [7:0] In8;
	wire signed [10:0] In11;

	// Inputs
	reg signed [15:0] In;
	reg Reset;

	// Outputs
	wire signed [15:0] Out4, Out8, Out11;
	wire [15:0] Rail4, Rail8, Rail11;

	// Instantiate the Unit Under Test (UUT)
	SignExtender Immediate4Bit (
		.In(In),
		.Reset(Reset),
		.Out(Out4)
	);
	assign Rail4 = Immediate4Bit.SignRail;
	assign In4 = In;
	
	SignExtender #(.SIGN_BIT(7))Immediate8Bit (
		.In(In),
		.Reset(Reset),
		.Out(Out8)
	);
	assign Rail8 = Immediate8Bit.SignRail;
	assign In8 = In;
	
	SignExtender #(.SIGN_BIT(10))Immediate11Bit (
		.In(In), 
		.Reset(Reset),
		.Out(Out11)
	);
	assign Rail11= Immediate11Bit.SignRail;
	assign In11 = In;

	initial begin
		// Initialize Inputs
		In = 0;
		Reset = 0;
		#1;
		
		for (i = 0; i < 16; i = i + 1) begin
			In = i;
			#1;
			
			if (In4 != Out4) begin
				$display("4-bit Sign Extension Failed at time: ", $time, "\t", "Expected: ", In, "\tActual: ", Out4);
				$stop;
			end
			
			if (In8 != Out8) begin
				$display("8-bit Sign Extension Failed\t", "Expected: ", In, "\tActual: ", Out8);
				$stop;
			end
			
			if (In11 != Out11) begin
				$display("11-bit Sign Extension Failed\t", "Expected: ", In, "\tActual: ", Out11);
				$stop;
			end
		end
		
		for(i = 16; i < 256; i = i + 1) begin
			In = i;
			#1;
			
			if (In8 != Out8) begin
				$display("Sign Extension Failed\t", "Expected: ", In, "\tActual: ", Out8);
				$stop;
			end
			
			if (In11 != Out11) begin
				$display("11-bit Sign Extension Failed\t", "Expected: ", In, "\tActual: ", Out11);
				$stop;
			end
		end
		
		for(i = 256; i < 2048; i = i + 1) begin
			In = i;
			#1;
			
			if (In11 != Out11) begin
				$display("11-bit Sign Extension Failed\t", "Expected: ", In, "\tActual: ", Out11);
				$stop;
			end
		end
		
		$display("All tests passed without error!");
		
	end
      
endmodule

