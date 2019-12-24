`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:19:48 11/05/2019 
// Design Name: 
// Module Name:    FiniteStateMachineInVerilog 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module FiniteStateMachineInVerilog(
		input Clock,Reset,
		input [4:0] opcode,
		output reg PCWrite, MemRead, MemWrite, IRWrite, ALUSrcA, InstData, WriteReg, ZeSe, UpperLower, BNE, BEQ, BLT, BLET, BGT, BGET, HoldOldPCValue, OldNew,
		output reg[1:0] ALUSrcB, PCSource, RegDest, RegData, RsRd, RsRt,
		output reg[2:0] ALUOp
	);
	
	//integer InstructionCount = 0;
	//integer CycleCount = 0;
	
	reg[4:0] currentState, nextState;
	// States
	localparam startState = 5'd0, nextPCState = 5'd1, jumpState = 5'd2, callState = 5'd3, Load1State = 5'd4, load2State = 5'd5, 
				  store2State = 5'd6, luiState = 5'd7, lliState = 5'd8, addiState = 5'd9, srlState = 5'd10, sllState = 5'd11, 
				  beqState = 5'd12, bneState = 5'd13, bltState = 5'd14, bgtState = 5'd15, bletState = 5'd16, bgetState = 5'd17, 
				  addState = 5'd18, subState = 5'd19, andState = 5'd20, orState = 5'd21, notState = 5'd22, compState = 5'd23, 
				  nopState = 5'd25, jrState = 5'd26, regstoreState = 5'd27, ResetState = 5'd28, Load3State = 5'd29, Store3State = 5'd30, Store1State = 5'd31;

	// Opcodes
	localparam add=5'b00000, addi=5'b00001, sub=5'b00010, jump=5'b00011, call=5'b00100, beq=5'b00101, bne=5'b00110, load=5'b00111,
				  lli=5'b01000, lui=5'b01001, store=5'b01010, OR=5'b01011, AND=5'b01100, NOT=5'b01101, nop=5'b01110, comp=5'b01111, 
				  sll=5'b10000, srl=5'b10001, blt=5'b10010, bgt=5'b10011, blet=5'b10100, bget=5'b10101, jr=5'b10110; 

	//Defining "Next State" combinational logic
	always @(currentState, opcode)
		case (currentState)
		ResetState: 	nextState <= startState;
		startState:		nextState <= nextPCState;
		nextPCState:	case(opcode)
							jump:		nextState <= jumpState;
							call:		nextState <= callState;
							load:	   nextState <= Load1State;
							store:   nextState <= Store1State;
							lui:		nextState <= luiState;
							lli: 		nextState <= lliState;
							srl:	 	nextState <= srlState;
							sll:	 	nextState <= sllState;
							bne:	 	nextState <= bneState;
							beq:	 	nextState <= beqState;
							blt:	 	nextState <= bltState;
							bgt:	 	nextState <= bgtState;
							blet:	 	nextState <= bletState;
							bget:	 	nextState <= bgetState;
							addi:	 	nextState <= addiState;
							add:	 	nextState <= addState;
							sub:	 	nextState <= subState;
							AND:	 	nextState <= andState;
							OR:		nextState <= orState;
							NOT:	 	nextState <= notState;
							comp:	 	nextState <= compState;
							nop:		nextState <= nopState;
							jr:		nextState <= jrState;
							default: nextState <= currentState;
							endcase
		jumpState:		nextState <= ResetState;
		callState:		nextState <= ResetState;
		Load1State:		nextState <= load2State;
		load2State:		nextState <= Load3State;
		Load3State:		nextState <= ResetState;
		Store1State: 	nextState <= store2State;
		store2State:	nextState <= Store3State;
		Store3State: 	nextState <= ResetState;
		luiState:		nextState <= startState;
		lliState: 		nextState <= startState;
		srlState:	 	nextState <= regstoreState;
		sllState:	 	nextState <= regstoreState;
		bneState:	 	nextState <= ResetState;
		beqState:	 	nextState <= ResetState;
		bltState:	 	nextState <= ResetState;
		bgtState:	 	nextState <= ResetState;
		bletState:	 	nextState <= ResetState;
		bgetState:	 	nextState <= ResetState;
		addiState:	 	nextState <= regstoreState;
		addState:	 	nextState <= regstoreState;
		subState:	 	nextState <= regstoreState;
		andState:	 	nextState <= regstoreState;
		orState:		nextState <= regstoreState;
		notState:	 	nextState <= regstoreState;
		nopState:		nextState <= startState;
		compState:	 	nextState <= regstoreState;
		jrState:			nextState <= ResetState;
		regstoreState:	nextState <= startState;
					default:		nextState <= currentState;
		endcase
	
	//Define "State Update" sequential logic
	always @(posedge Reset, posedge Clock) begin
		if(Reset) currentState <= ResetState;
		else currentState <= nextState;
		//CycleCount = CycleCount + 1;
	end
	
	//Define "Output"	combinational logic
	always @(currentState)
		case(currentState)
		ResetState: begin
			PCWrite <= 0;
			InstData <= 0;
			MemRead <= 0;
			MemWrite <= 0;
			IRWrite <= 0;
			InstData <= 0;
			ALUSrcA <= 0;
			ALUSrcB <= 2'b00;
			PCSource <= 2'b00;
			WriteReg <= 0;
			ZeSe <= 0;
			UpperLower <= 0;
			RsRt <= 0;
			BNE <= 0;
			BEQ <= 0;
			BLT <= 0;
			BLET <= 0;
			BGT <= 0;
			BGET <= 0;
			RegDest <= 2'b00;
			RegData <= 2'b00;
			RsRd <= 2'b00;
			ALUOp = 3'b000;
		end
		startState: begin 
						PCWrite <= 1;
						InstData <= 0;
						OldNew <= 0;
						MemRead <= 1;
						MemWrite <= 0;
						IRWrite <= 1;
						ALUSrcA <= 0;
						ALUSrcB <= 2'b01;
						PCSource <= 2'b01;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 0;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b00;
						ALUOp = 3'b000;
						HoldOldPCValue = 0;
						//InstructionCount = InstructionCount + 1;
						end
				 
		nextPCState:		begin 
						PCWrite <= 0;
						InstData <= 0;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 0;
						ALUSrcB <= 2'b10;
						PCSource <= 2'b01;
						WriteReg <= 0;
						ZeSe <= 1;
						UpperLower <= 0;
						RsRt <= 0;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b00;
						ALUOp = 3'b000;
						HoldOldPCValue = 1;
						end
				 
		jumpState:	begin 
						PCWrite <= 1;
						InstData <= 0;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 0;
						ALUSrcB <= 2'b00;
						PCSource <= 2'b00;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 0;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b00;
						ALUOp = 3'b000;
						end
		
		callState:	begin 
						PCWrite <= 1;
						OldNew <= 1;
						InstData <= 0;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 0;
						ALUSrcB <= 2'b00;
						PCSource <= 2'b00;
						WriteReg <= 1;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 0;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b10;
						RegData <= 2'b10;
						RsRd <= 00;
						ALUOp = 3'b000;
						end	
				
		Load1State:begin 
						PCWrite <= 0;
						InstData <= 1;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 1;
						ALUSrcB <= 2'b11;
						PCSource <= 2'b00;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 0;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b01;
						RsRt <= 2;
						ALUOp = 3'b000;
						end
				
		load2State: begin 
						PCWrite <= 0;
						InstData <= 1;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 0;
						ALUSrcB <= 2'b00;
						PCSource <= 2'b00;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 2;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b01;
						ALUOp = 3'b000;
						end
		
		Load3State: begin 
			PCWrite <= 0;
			InstData <= 1;
			MemRead <= 1;
			MemWrite <= 0;
			IRWrite <= 0;
			ALUSrcA <= 0;
			ALUSrcB <= 2'b00;
			PCSource <= 2'b00;
			WriteReg <= 1;
			ZeSe <= 0;
			UpperLower <= 0;
			RsRt <= 0;
			BNE <= 0;
			BEQ <= 0;
			BLT <= 0;
			BLET <= 0;
			BGT <= 0;
			BGET <= 0;
			RegDest <= 2'b00;
			RegData <= 2'b00;
			RsRd <= 2'b00;
			ALUOp = 3'b000;
		end
		
		Store1State: begin
						PCWrite <= 0;
						InstData <= 1;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 1;
						ALUSrcB <= 2'b11;
						PCSource <= 2'b00;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 0;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b01;
						RsRt <= 2;
						ALUOp = 3'b000;
						end
				
		store2State:begin 
						PCWrite <= 0;
						InstData <= 1;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 1;
						ALUSrcB <= 2'b11;
						PCSource <= 2'b00;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 2;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b01;
						ALUOp = 3'b000;
						end
			
		Store3State:begin 
						PCWrite <= 0;
						InstData <= 1;
						MemRead <= 0;
						MemWrite <= 1;
						IRWrite <= 0;
						ALUSrcA <= 0;
						ALUSrcB <= 2'b00;
						PCSource <= 2'b00;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 2;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b01;
						ALUOp = 3'b000;
						end
						
		luiState:	begin 
						PCWrite <= 0;
						InstData <= 0;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 0;
						ALUSrcB <= 2'b00;
						PCSource <= 2'b00;
						WriteReg <= 1;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 0;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b01;
						RegData <= 2'b11;
						RsRd <= 2'b00;
						ALUOp = 3'b000;
						end
		
		lliState: 	begin 
						PCWrite <= 0;
						InstData <= 0;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 0;
						ALUSrcB <= 2'b00;
						PCSource <= 2'b00;
						WriteReg <= 1;
						ZeSe <= 0;
						UpperLower <= 1;
						RsRt <= 0;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b01;
						RegData <= 2'b11;
						RsRd <= 2'b00;
						ALUOp = 3'b000;
						end
		
		addiState:	begin 
						PCWrite <= 0;
						InstData <= 0;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 1;
						ALUSrcB <= 2'b11;
						PCSource <= 2'b00;
						WriteReg <= 0;
						ZeSe <= 1;
						UpperLower <= 0;
						RsRt <= 0;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b01;
						ALUOp = 3'b000;
						end
		
		srlState:	begin 
						PCWrite <= 0;
						InstData <= 0;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 1;
						ALUSrcB <= 2'b11;
						PCSource <= 2'b00;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 0;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b01;
						ALUOp = 3'b110;
						end
		
		sllState:	begin 
						PCWrite <= 0;
						InstData <= 0;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 1;
						ALUSrcB <= 2'b11;
						PCSource <= 2'b00;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 0;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b01;
						ALUOp = 3'b101;
						end
		
		bneState:	begin 
						PCWrite <= 0;
						InstData <= 0;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 1;
						ALUSrcB <= 2'b00;
						PCSource <= 2'b10;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 0;
						BNE <= 1;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b10;
						ALUOp = 3'b001;
						end
				 
		beqState:	begin 
						PCWrite <= 0;
						InstData <= 0;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 1;
						ALUSrcB <= 2'b00;
						PCSource <= 2'b10;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 0;
						BNE <= 0;
						BEQ <= 1;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b10;
						ALUOp = 3'b001;
						end
				 
		bltState:	begin 
						PCWrite <= 0;
						InstData <= 0;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 1;
						ALUSrcB <= 2'b00;
						PCSource <= 2'b10;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 0;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 1;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b10;
						ALUOp = 3'b001;
						end
				 
		bgtState:   begin 
						PCWrite <= 0;
						InstData <= 0;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 1;
						ALUSrcB <= 2'b00;
						PCSource <= 2'b10;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 0;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 1;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b10;
						ALUOp = 3'b001;
						end
				 
		bletState:	begin 
						PCWrite <= 0;
						InstData <= 0;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 1;
						ALUSrcB <= 2'b00;
						PCSource <= 2'b10;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 0;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 1;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b10;
						ALUOp = 3'b001;
						end
				 
		bgetState:	begin 
						PCWrite <= 0;
						InstData <= 0;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 1;
						ALUSrcB <= 2'b00;
						PCSource <= 2'b10;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 0;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 1;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b10;
						ALUOp = 3'b001;
						end
		
		addState:	begin 
						PCWrite <= 0;
						InstData <= 0;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 1;
						ALUSrcB <= 2'b00;
						PCSource <= 2'b01;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 1;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b00;
						ALUOp = 3'b000;
						end
		
		subState: 	begin 
						PCWrite <= 0;
						InstData <= 0;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 1;
						ALUSrcB <= 2'b00;
						PCSource <= 2'b01;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 1;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b00;
						ALUOp = 3'b001;
						end
		
		andState: 	begin 
						PCWrite <= 0;
						InstData <= 0;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 1;
						ALUSrcB <= 2'b00;
						PCSource <= 2'b01;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 1;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b00;
						ALUOp = 3'b010;
						end
		
		orState:	 	begin 
						PCWrite <= 0;
						InstData <= 0;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 1;
						ALUSrcB <= 2'b00;
						PCSource <= 2'b01;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 1;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b00;
						ALUOp = 3'b011;
						end
		
		notState:	begin 
						PCWrite <= 0;
						InstData <= 0;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 1;
						ALUSrcB <= 2'b00;
						PCSource <= 2'b01;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 1;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b00;
						ALUOp = 3'b100;
						end
						
		nopState:	begin 
						PCWrite <= 0;
						InstData <= 0;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 0;
						ALUSrcB <= 2'b00;
						PCSource <= 2'b00;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 0;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b00;
						ALUOp = 3'b000;
						end
		
		compState:	begin 
						PCWrite <= 0;
						InstData <= 0;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 1;
						ALUSrcB <= 2'b00;
						PCSource <= 2'b01;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 1;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b00;
						ALUOp = 3'b111;
						end
						
		jrState:		begin
						PCWrite <= 1;
						InstData <= 0;
						MemRead <= 0;
						MemWrite <= 0;
						IRWrite <= 0;
						ALUSrcA <= 1;
						ALUSrcB <= 2'b00;
						PCSource <= 2'b11;
						WriteReg <= 0;
						ZeSe <= 0;
						UpperLower <= 0;
						RsRt <= 0;
						BNE <= 0;
						BEQ <= 0;
						BLT <= 0;
						BLET <= 0;
						BGT <= 0;
						BGET <= 0;
						RegDest <= 2'b00;
						RegData <= 2'b00;
						RsRd <= 2'b10;
						ALUOp = 3'b000;
						end
		
		regstoreState: begin 
							PCWrite <= 0;
							InstData <= 0;
							MemRead <= 0;
							MemWrite <= 0;
							IRWrite <= 0;
							ALUSrcA <= 0;
							ALUSrcB <= 2'b00;
							PCSource <= 2'b00;
							WriteReg <= 1;
							ZeSe <= 0;
							UpperLower <= 0;
							RsRt <= 1;
							BNE <= 0;
							BEQ <= 0;
							BLT <= 0;
							BLET <= 0;
							BGT <= 0;
							BGET <= 0;
							RegDest <= 2'b00;
							RegData <= 2'b01;
							RsRd <= 2'b00;
							ALUOp = 3'b000;
							end
					default: begin
								PCWrite <= 0;
								InstData <= 0;
								MemRead <= 0;
								MemWrite <= 0;
								IRWrite <= 0;
								ALUSrcA <= 0;
								ALUSrcB <= 2'b00;
								PCSource <= 2'b00;
								WriteReg <= 1;
								ZeSe <= 0;
								UpperLower <= 0;
								RsRt <= 1;
								BNE <= 0;
								BEQ <= 0;
								BLT <= 0;
								BLET <= 0;
								BGT <= 0;
								BGET <= 0;
								RegDest <= 2'b00;
								RegData <= 2'b01;
								RsRd <= 2'b00;
								ALUOp = 3'b000;
								end
		endcase
endmodule
