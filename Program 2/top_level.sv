// skeletal starter code top level of your DUT
module top_level(
  input clk, init, req,
  output logic ack);

  logic mem_wen;
  logic[7:0]  mem_addr,
              mem_in,
			  mem_out;
  logic[11:0] pctr;		  // temporary program counter
  logic flag;

// populate with program counter, instruction ROM, reg_file (if used),
//  accumulator (if used), 

wire jump, branch, memRead, memToReg, aluSRC, regWrite, regDst, sc,
		z, p, o, n;
wire[1:0] bcCond; // specifies branch type
wire[3:0] pcTarg, raddrA, raddrB, waddr, aluOp;
wire[7:0] dataOutA, dataOutB, dataIn, aluResult, dat;
wire[8:0] inst; //instruction
wire[11:0] targAddr, progCtr;

assign raddrA = 'b0; // first read address is always 0
assign raddrB = inst[5:2];
assign waddr = (regDst) ? raddrB : 'b0; // destination register is always r0 unless a mov instruction
assign mem_in = dataOutA;
assign dat = (aluSRC) ? {2'b00,inst[5:0]} : aluResult; // data to write to register is either immediate, alu result, or from data mem
assign dataIn = (memToReg) ? mem_out : dat;
assign mem_addr = dataOutB; // mem read address stored in second register operand

// determine which flag we are interested in based on branch
always_comb begin 
	case(bcCond) 
		2'b00: flag = z;
		2'b01: flag = !z;
		2'b10: flag = z || n;
		2'b11: flag = n;
	endcase
end

// data mem unit
DataMem DM(.Clk         (clk), 
           .Reset       (init), 
           .WriteEn     (mem_wen), 
           .DataAddress (mem_addr), 
           .DataIn      (mem_in), 
           .DataOut     (mem_out));

// control unit			  
Ctrl CT(.Instruction(inst), 
			.Jump(jump), 
			.Branch(branch), 
			.MemRead(memRead), .MemtoReg(memToReg), .MemWrite(mem_wen),
			.ALUSrc(aluSRC), .ALUOp(aluOp), 
			.RegWrite(regWrite), .RegDst(regDst), .BranchCond(bcCond), .PCTarg(pcTarg));
			
// alu unit
ALU alu(.InputA(dataOutA), .InputB(dataOutB), .OP(aluOp), .SC_in(sc), 
		  .Out(aluResult), .Zero(z), .Parity(p), .Odd(o), .Negative(n), .SC_out(sc));
		  
// lookup table
Immediate_LUT LT(.addr(pcTarg), .datOut(targAddr));

//instruction fetch
InstFetch IF(.Reset(init), .Start(req), .Clk(clk), 
			.JumpAbs(jump), .BranchAbsEn(branch), .ALU_flag(flag), 
			.Target(targAddr), .ProgCtr(progCtr));
			
//instruction
InstROM IR(.InstAddress(progCtr), .InstOut(inst));

//register file
RegFile RF(.Clk(clk), .Reset(init), .WriteEn(regWrite),
			.RaddrA(raddrA), .RaddrB(raddrB), .Waddr(waddr),
			.DataIn(dataIn), .DataOutA(dataOutA), .DataOutB(dataOutB));

// temporary circuit to provide ack (done) flag to test bench
//   remove or greatly increase the match value once you get a 
//   proper ack 
always @(posedge clk) 
  if(init || req) 
    pctr <= 'h0;
  else  
	pctr <= pctr+'h1;

assign ack = !inst;  //program done at instruction 0000000000
endmodule

