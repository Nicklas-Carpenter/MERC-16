`timescale 1ns / 1ps

module DecodeSubsystem(
		input [10:0] InstrParam, 
		input [15:0] ALUIN, MemoryIn, PCIN,
		input UpperLower, WriteEnable, HoldOldPCValue, OldNew,
		input [1:0] RegDest, RegData, RsRd, RsRt,
		input Reset, Clock,
		output reg [15:0] A, B,
		output [10:0] JumpImmediate, 
		output [15: 0] ZE, SE, SEL1
	);
	
	reg [15:0] ImmediateLoad, WriteData;
	wire [15:0] Upper, Lower, RsOut, RsShortOut, RtOut, RdOut, RdShort;
	wire [15:0] Rs, RsShort, Rt, Rd;
	
	/*Handling the Register File*/
	
	// Multiplex WriteAddr
	reg [3:0] WriteAddr;
	always @(RegDest, InstrParam) begin
		case(RegDest)
			2'b00: 
				WriteAddr <= InstrParam[10:7]; // Rd
			2'b01: 
				WriteAddr <= {1'b0, InstrParam[10:8]}; // RdShort
			2'b10: 
				WriteAddr <= 4'd5; // ra
			3'b11:
				WriteAddr <= 4'd0;
		endcase
	end
	
	// OldPC
	wire [15:0] OldPCValue;
	Register OldPC (
		.DIN(PCIN), 
		.WR_EN(~HoldOldPCValue), 
		.Reset(Reset), 
		.CLK(Clock), 
		.DOUT(OldPCValue)
	);
	
	// Multiplex WriteData
	always @(RegData, RegDest, InstrParam, MemoryIn, ALUIN, PCIN, OldPCValue, ImmediateLoad, OldNew) begin
		case(RegData)
			2'b00: 
				WriteData <= MemoryIn;
			2'b01: 
				WriteData <= ALUIN;
			2'b10: 
				if (OldNew)
					WriteData <= PCIN;
				else 
					WriteData <= OldPCValue;
			3'b11:
				WriteData <= ImmediateLoad;
		endcase
	end

	// Load Immediates
	assign Upper = {InstrParam[7:0], RdShort[7:0]};
	assign Lower = {RdShort[15:8], InstrParam[7:0]};
	
	always @(Upper, Lower, UpperLower) begin
		if (UpperLower) begin
			ImmediateLoad <= Lower;
		end
		else begin
			ImmediateLoad <= Upper;
		end
	end
	
	// Instantiate the Register File
	RegisterFile RegFile (
		.RsAddr(InstrParam[6:3]), 
		.RsShortAddr(InstrParam[6:4]), 
		.RtAddr(InstrParam[2:0]), 
		.RdAddr(InstrParam[10:7]), 
		.RdShortAddr(InstrParam[10:8]), 
		.WriteAddr(WriteAddr), 
		.WriteData(WriteData), 
		.WriteEnable(WriteEnable), 
		.Reset(Reset), 
		.Clock(Clock), 
		.Rs(RsOut), 
		.RsShort(RsShortOut), 
		.Rt(RtOut), 
		.Rd(RdOut), 
		.RdShort(RdShort)
	);
	
	/* Handle Outputs */
	
	ZeroExtender #(.MSB(3)) Z (
		.In(InstrParam[3:0]), 
		.Reset(Reset), 
		.Out(ZE)
	);
	
	SignExtender #(.SIGN_BIT(3)) S (
		.In(InstrParam[3:0]), 
		.Reset(Reset), 
		.Out(SE)
    );

	assign SEL1 = SE << 1'b1;
	
	assign JumpImmediate = InstrParam[10:0];
	
	// Register File Output storage registers (to save a cycle for ALU operations)
	Register RsReg (
		.DIN(RsOut), 
		.WR_EN(1'b1), 
		.Reset(Reset), 
		.CLK(Clock), 
		.DOUT(Rs)
	);
	
	Register RsShortReg (
		.DIN(RsShortOut), 
		.WR_EN(1'b1), 
		.Reset(Reset), 
		.CLK(Clock), 
		.DOUT(RsShort)
	);
	
	Register RtReg (
		.DIN(RtOut), 
		.WR_EN(1'b1), 
		.Reset(Reset), 
		.CLK(Clock), 
		.DOUT(Rt)
	);
	
	Register RdReg (
		.DIN(RdOut), 
		.WR_EN(1'b1), 
		.Reset(Reset), 
		.CLK(Clock), 
		.DOUT(Rd)
	);
	
	// Assign output to A
	always @(Rs, RsShort, Rt, Rd, RsRd, RsRt) begin			
		case(RsRd)
			2'b00:
				A <= Rs;
			2'b01:
				A <= RsShort;
			2'b10:
				A <= Rd;
			2'b11:
				A <= SEL1;
		endcase
		
		case(RsRt)
			2'b00:
				B <= RsShort;
			2'b01:
				B <= Rt;
			2'b10:
				B <= Rd;
			2'b11:
				B <= 0;
				
		endcase
	end
		
endmodule
