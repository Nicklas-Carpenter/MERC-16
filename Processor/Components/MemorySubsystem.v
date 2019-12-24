`timescale 1ns / 1ps

module MemorySubsystem(
		input [15:0] ByteAddress, DIN, 
		input WriteEnable,
		input Reset, Clock,
		output [15:0] DOUT
    );
	
	Memory MainMemory(
		.clka(Clock),
		.rsta(Reset), 
		.wea(WriteEnable), 
		.addra(ByteAddress[14:1]), 
		.dina(DIN), 
		.douta(DOUT) 
	);
	
	

endmodule
