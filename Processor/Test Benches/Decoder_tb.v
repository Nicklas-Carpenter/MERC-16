`timescale 1ns / 1ps

module Decoder_tb;
	// Simulation signals
	integer i = 0;
	localparam N = 4;

	// Inputs
	reg [3:0] In;
	reg Reset;

	// Outputs
	wire [15:0] Out;

	// Instantiate the Unit Under Test (UUT)
	Decoder #(.N(N), .M(2 ** N)) uut(
		.In(In), 
		.Reset(Reset), 
		.Out(Out)
	);

	initial begin
		// Initialize Inputs
		In = 0;
		Reset = 1;
		#1;
		Reset = 0;
		
		for (i = 0; i < 2 ** N; i = i + 1) begin
			In = i;
			#1;
			if (Out != 2 ** i) begin
				$display("Error in Decoder\tIn: ", In, "\tExpected: ", 2 ** i, "\tActual: ", Out);
				$stop;
			end
		end
		$display("All tests passed successfully");
		$stop;
	end
endmodule

