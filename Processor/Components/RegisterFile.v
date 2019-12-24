`timescale 1ns / 1ps

module RegisterFile(
		input [3:0] RsAddr,
		input [2:0] RsShortAddr,
		input [2:0] RtAddr,
		input [3:0] RdAddr,
		input [2:0] RdShortAddr,
		input [3:0] WriteAddr,
		input [15:0] WriteData,
		input WriteEnable,
		input Reset,
		input Clock,
		output reg [15:0] Rs,
		output reg [15:0] RsShort,
		output reg [15:0] Rt,
		output reg [15:0] Rd,
		output reg [15:0] RdShort
	);
	
	wire [14:0] EnableLine;
	wire [15:0] OutputMatrix[15:0], DecodedAddr;
	
	// Register Write Address Decoder
	Decoder Addresser (
		 .In(WriteAddr), 
		 .Reset(Reset), 
		 .Out(DecodedAddr)
	);
	
	assign EnableLine = DecodedAddr[15:1];

	assign OutputMatrix[0] = 0;
	
	generate
		genvar i;
		for (i = 1; i < 16; i = i + 1) begin : RegisterMatrix
			Register Reg(
				.DIN(WriteData), 
				.WR_EN(~Reset & WriteEnable & EnableLine[i - 1]), 
				.Reset(Reset), 
				.CLK(Clock), 
				.DOUT(OutputMatrix[i])
			);
		end
	endgenerate
	
	// Decode output logic
	always @(Reset, RsAddr, RsShortAddr, RtAddr, RdAddr, RdShortAddr, OutputMatrix[RsAddr], OutputMatrix[RsShortAddr], OutputMatrix[RtAddr], OutputMatrix[RdAddr], OutputMatrix[RdShortAddr]) begin
		if (Reset) begin
			Rs <= 0;
			RsShort <= 0;
			Rt <= 0;
			Rd <= 0;
			RdShort <= 0;
		end
		else begin
			Rs <= OutputMatrix[RsAddr];
			RsShort <= OutputMatrix[RsShortAddr];
			Rt <= OutputMatrix[RtAddr];
			Rd <= OutputMatrix[RdAddr];
			RdShort <= OutputMatrix[RdShortAddr];
		end
	end
		
endmodule
