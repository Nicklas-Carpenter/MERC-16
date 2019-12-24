`timescale 1ns / 1ps


module ZeroExtender_tb;

	// Test signals
	integer i = 0;
	integer simTime = 0;
	
	wire [3:0] In4;
	wire [7:0] In8;
	wire [10:0] In11;

	// Inputs
	reg [15:0] In;
	reg Reset;

	// Outputs
	wire [15:0] Out4, Out8, Out11;

	// Instantiate the Unit Under Test (UUT)
	ZeroExtender Immediate4Bit (
		.In(In),
		.Reset(Reset),
		.Out(Out4)
	);
	assign In4 = In;
	
	ZeroExtender #(.MSB(7))Immediate8Bit (
		.In(In), 
		.Reset(Reset),
		.Out(Out8)
	);
	assign In8 = In;
	
	ZeroExtender #(.MSB(10))Immediate11Bit (
		.In(In), 
		.Reset(Reset),
		.Out(Out11)
	);
	assign In11 = In;

	initial begin
		// Initialize Inputs
		In = 0;
		Reset = 1;
		#1;
		
		Reset = 0;
		
		for (i = 0; i < 16; i = i + 1) begin
			In = i;
			simTime = $time;
			#1;
			
			if (In4 != Out4) begin
				$display("4-bit Zero Extension Failed at time: ", simTime, " \t", "Expected: ", In, "\tActual: ", Out4);
				$stop;
			end
			
			if (In8 != Out8) begin
				$display("8-bit Zero Extension Failed at time: ", simTime, " \t", "Expected: ", In, "\tActual: ", Out8);
				$stop;
			end
			
			if (In11 != Out11) begin
				$display("11-bit Zero Extension Failed at time: ", simTime, " \t", "Expected: ", In, "\tActual: ", Out11);
				$stop;
			end
		end
	
		for (i = 16; i < 256; i = i + 1) begin
			In = i;
			simTime = $time;
			#1;
			
			if (In8 != Out8) begin
				$display("8-bit Zero Extension Failed at time: ", simTime, " \t", "Expected: ", In, "\tActual: ", Out8);
				$stop;
			end
			
			if (In11 != Out11) begin
				$display("11-bit Zero Extension Failed at time: ", simTime, " \t", "Expected: ", In, "\tActual: ", Out11);
				$stop;
			end
		end
		
		for (i = 256; i < 65536; i = i + 1) begin
			In = i;
			simTime = $time;
			#1;
			
			if (In11 != Out11) begin
				$display("11-bit Zero Extension Failed at time: ", simTime, " \t", "Expected: ", In, "\tActual: ", Out11);
				$stop;
			end
		end
		
		$display("All tests passed without error!");
		
	end
      
endmodule

