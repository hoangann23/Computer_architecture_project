// CSE141L
// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input[ 8:0]   Instruction,	   // machine code
  output logic  Jump      ,        // absolute branch?
                Branch    ,        // conditional branch?
					 MemRead   ,        // reading from memory?
                MemtoReg  ,        // writing from memory to register?
                MemWrite  ,        // writing to memory?
                ALUSrc    ,        // ALU operand immediate or register?
                RegWrite  ,        // Writing to register?
                RegDst    ,        // Destination register R0 or specified register?
  output logic[3:0] PCTarg,
  output logic[1:0] BranchCond,
  output logic [3:0] ALUOp
  );

/* ***** All numerical values are completely arbitrary and for illustration only *****
*/

// alternative -- case format
always_comb	begin
// list the defaults here
   Jump       = 'b0;
   Branch     = 'b0;
   RegWrite   = 'b1; 
   MemWrite   = 'b0;
   MemRead    = 'b0;
   MemtoReg   = 'b0;
   ALUSrc     = 'b0;
   RegDst     = 'b0;
   ALUOp      = 'b1000;
   //TapSel    ' 'b0;     //
   BranchCond = 'b0;
   PCTarg    = Instruction[5:2];     // branch "where to?"
   case(Instruction[8:6])  // list just the exceptions 
     3'b000:   begin
                  if (Instruction[1:0] == 'b00) begin 
                    ALUOp = 'b0000; //add
                  end
                  else if (Instruction[1:0] == 'b01) begin 
                    ALUOp = 'b0001; //sub
                  end
                  else if (Instruction[1:0] == 'b10) begin
                    ALUOp = 'b0010;//and
                  end
                  else if (Instruction[1:0] == 'b11) begin
                    ALUOp = 'b0011;
                  end
			   end
     3'b001:   begin 
                  if (Instruction[1:0] == 'b00) begin 
                    RegDst = 'b1;
						  ALUOp = 'b1001; //mov
                  end
						else if (Instruction[1:0] == 'b01) begin
						  ALUOp = 'b1010;	//set
						end
                  else if (Instruction[1:0] == 'b10) begin 
                    ALUOp = 'b0100; //xor
                  end
                  else if (Instruction[1:0] == 'b11) begin 
                    ALUOp = 'b0101; //not
                  end
     end
     3'b010:   begin 
                  ALUSrc = 'b1; // immediate instruction
						ALUOp  = 'b1010;
               end
     3'b011:   begin 
                  if (Instruction[1:0] == 'b00) begin 
                    ALUOp = 'b0110; //left shift
                  end
                  else if (Instruction[1:0] == 'b01) begin 
                    ALUOp = 'b0111; //right shift
                  end
						else if (Instruction[1:0] == 'b10) begin
						  ALUOp = 'b1011; //reduction xor
						end
               end
     3'b100:   begin //conditional branch
						RegWrite = 'b0;
						Branch = 'b1;
                  BranchCond = Instruction[1:0];
						ALUOp = 'b1001;
               end
     3'b101:   begin 
                  if (Instruction[1:0] == 'b00) begin 
                    Jump = 'b1; //unconditional branch
                    RegWrite = 'b0;
                  end
                  if (Instruction[1:0] == 'b01) begin
                    ALUOp = 'b0001; //cmp
                  end
               end
     3'b110:   begin 
                  if (Instruction[1:0] == 'b00) begin 
                    MemRead = 'b1;
                    MemtoReg = 'b1; //ld
                  end
                  else if (Instruction[1:0] == 'b01) begin 
                    RegWrite = 'b0;
                    MemWrite = 'b1;
						  ALUOp = 'b1001; //str
                  end
                end
// no default case needed -- covered before "case"
   endcase
end

endmodule




