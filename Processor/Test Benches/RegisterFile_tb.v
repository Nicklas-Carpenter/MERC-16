`timescale 1ns / 1ps

module RegisterFile_tb;

	// Simulation Signals
	integer i = 0;

	// Inputs
	reg [3:0] RsAddr;
	reg [2:0] RsShortAddr;
	reg [2:0] RtAddr;
	reg [3:0] RdAddr;
	reg [2:0] RdShortAddr;
	reg [3:0] WriteAddr;
	reg [15:0] WriteData;
	reg WriteEnable;
	reg Reset;
	reg Clock;

	// Outputs
	wire [15:0] Rs;
	wire [15:0] RsShort;
	wire [15:0] Rt;
	wire [15:0] Rd;
	wire [15:0] RdShort;

	// Instantiate the Unit Under Test (UUT)
	RegisterFile uut (
		.RsAddr(RsAddr), 
		.RsShortAddr(RsShortAddr), 
		.RtAddr(RtAddr), 
		.RdAddr(RdAddr), 
		.RdShortAddr(RdShortAddr), 
		.WriteAddr(WriteAddr), 
		.WriteData(WriteData), 
		.WriteEnable(WriteEnable), 
		.Reset(Reset), 
		.Clock(Clock), 
		.Rs(Rs), 
		.RsShort(RsShort), 
		.Rt(Rt), 
		.Rd(Rd), 
		.RdShort(RdShort)
	);
	
	// Generate Clock
	always #1 Clock = ~Clock;

	initial begin
		// Initialize Inputs
		RsAddr = 0;
		RsShortAddr = 0;
		RtAddr = 0;
		RdAddr = 0;
		RdShortAddr = 0;
		WriteAddr = 0;
		WriteData = 0;
		WriteEnable = 0;
		Reset = 1;
		Clock = 0;
		#2;
		Reset = 0;
		
		// Test writing to the zero register. Writing should not succeed.
		RsAddr = 4'b0;
		RsShortAddr = 3'b0;
		RtAddr = 3'b0;
		RdAddr = 4'b0;
		RdShortAddr = 3'b0;
		WriteAddr = 4'b0;
		WriteData = 16'hA5A5;
		#4;
			
		if (Rs != 0) begin
				$display("Error in Rs:\n\tExpected: ", 0, "\n\tActual: ", Rs);
				$stop;
		end
		
			if (RsShort != 0) begin
				$display("Error in RsShort:\n\tExpected: ", 0, "\n\tActual: ", RsShort);
				$stop;
			end
		
		if (Rt != 0) begin
			$display("Error in Rt:\n\tExpected: ", 0, "\n\tActual: ", Rt);
			$stop;
		end
		
		if (Rd != 0) begin
			$display("Error in Rd:\n\tExpected: ", 0, "\n\tActual: ", Rd);
			$stop;
		end
		
		if (RdShort != 0) begin
			$display("Error in RdShort:\n\tExpected: ", 0, "\n\tActual: ", RdShort);
			$stop;
		end
		
		// Test writing to all registers expressable in 3 bits. Writing enabled.
		WriteEnable = 1;
		for (i = 1; i < 8; i = i + 1) begin
			RsAddr = i;
			RsShortAddr = i;
			RtAddr = i;
			RdAddr = i;
			RdShortAddr = i;
			WriteAddr = i;
			WriteData = i;
			#4;
			
			if (Rs != i) begin
				$display("Error in Rs:\n\tExpected: ", i, "\n\tActual: ", Rs);
				$stop;
			end
			
			if (RsShort != i) begin
				$display("Error in RsShort:\n\tExpected: ", i, "\n\tActual: ", RsShort);
				$stop;
			end
			
			if (Rt != i) begin
				$display("Error in Rt:\n\tExpected: ", i, "\n\tActual: ", Rt);
				$stop;
			end
			
			if (Rd != i) begin
				$display("Error in Rd:\n\tExpected: ", i, "\n\tActual: ", Rd);
				$stop;
			end
			
			if (RdShort != i) begin
				$display("Error in RdShort:\n\tExpected: ", i, "\n\tActual: ", RdShort);
				$stop;
			end
		end
		
		// Test writing to all registers expressable in 4 bits. Writing enabled.
		WriteEnable = 1;
		for (i = 8; i < 16; i = i + 1) begin
			RsAddr = i;
			RsShortAddr = i;
			RtAddr = i;
			RdAddr = i;
			RdShortAddr = i;
			WriteAddr = i;
			WriteData = i;
			#4;
			
			if (Rs != i) begin
				$display("Error in Rs:\n\tExpected: ", i, "\n\tActual: ", Rs);
				$stop;
			end
			
			if (Rd != i) begin
				$display("Error in Rd:\n\tExpected: ", i, "\n\tActual: ", Rd);
				$stop;
			end
		end
		
		/* Disable Writing */
		WriteEnable = 0;
				
		// Test writing to all registers expressable in 3 bits. Writing disabled.
		WriteData = 16'hA5A5;
		for (i = 0; i < 8; i = i + 1) begin
			RsAddr = i;
			RsShortAddr = i;
			RtAddr = i;
			RdAddr = i;
			RdShortAddr = i;
			WriteAddr = i;
			#4;
			
			if (Rs != i) begin
				$display("Error in Rs:\n\tExpected: ", i, "\n\tActual: ", Rs);
				$stop;
			end
			
			if (RsShort != i) begin
				$display("Error in RsShort:\n\tExpected: ", i, "\n\tActual: ", RsShort);
				$stop;
			end
			
			if (Rt != i) begin
				$display("Error in Rt:\n\tExpected: ", i, "\n\tActual: ", Rt);
				$stop;
			end
			
			if (Rd != i) begin
				$display("Error in Rd:\n\tExpected: ", i, "\n\tActual: ", Rd);
				$stop;
			end
			
			if (RdShort != i) begin
				$display("Error in RdShort:\n\tExpected: ", i, "\n\tActual: ", RdShort);
				$stop;
			end
		end
		
		// Test writing to all registers expressable in 4 bits. Writing disabled.
		WriteEnable = 1;
		for (i = 8; i < 16; i = i + 1) begin
			RsAddr = i;
			RsShortAddr = i;
			RtAddr = i;
			RdAddr = i;
			RdShortAddr = i;
			WriteAddr = i;
			WriteData = i;
			#4;
			
			if (Rs != i) begin
				$display("Error in Rs:\n\tExpected: ", i, "\n\tActual: ", Rs);
				$stop;
			end
			
			if (Rd != i) begin
				$display("Error in Rd:\n\tExpected: ", i, "\n\tActual: ", Rd);
				$stop;
			end
		end
		
		$display("All tests passed without error!");
		$stop;
	end
endmodule

