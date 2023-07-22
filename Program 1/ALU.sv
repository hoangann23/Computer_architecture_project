// Module Name:    ALU
// Project Name:   CSE141L
//
// Additional Comments:
//   combinational (unclocked) ALU

// includes package "Definitions"
// be sure to adjust "Definitions" to match your final set of ALU opcodes
module ALU #(parameter W=8)(
  input        [W-1:0]   InputA,       // data inputs
                         InputB,
  input        [3:0]     OP,           // ALU opcode, part of microcode
  input                  SC_in,        // shift or carry in
  output logic [W-1:0]   Out,          // data output
  output logic           Zero,         // output = zero flag    !(Out)
                         Parity,       // outparity flag        ^(Out)
                         Odd,          // output odd flag        (Out[0])
								 Negative,     // output negative flag
						 SC_out        // shift or carry out
  // you may provide additional status flags, if desired
  // comment out or delete any you don't need
);

always_comb begin
// No Op = default
// add desired ALU ops, delete or comment out any you don't need
  Out = 8'b0;				                        
  SC_out = 1'b0;		 							// 	 will flag any illegal opcodes
  case(OP)
    'b0000 : {SC_out,Out} = InputA + InputB + SC_in;   // unsigned add with carry-in and carry-out
	 'b0110 : Out = InputA << InputB; 						 // logical shift left
	 'b0111 : Out = InputA >> InputB;						 // logical shift right
    'b0100 : Out = InputA ^ InputB;                    // bitwise exclusive OR
    'b0010 : Out = InputA & InputB;                    // bitwise AND
	 'b0011  : Out = InputA | InputB;							 // bitwise OR
	 'b0101 : Out = ~InputB;								    // bitwise NOT
    'b0001 : {SC_out,Out} = InputA + (~InputB) + 1;	// InputA - InputB;
    'b1000 : {SC_out,Out} = 'b0;
	 'b1001 : {SC_out,Out} = {SC_in, InputA};				
	 'b1010 : {SC_out,Out} = {SC_in, InputB};
	 'b1011 : Out = ^InputB;
  endcase
end

assign Zero   = ~|Out;                  // reduction NOR	 Zero = !Out; 
assign Parity = ^Out;                   // reduction XOR
assign Odd    = Out[0];                 // odd/even -- just the value of the LSB
assign Negative = Out[W-1];

endmodule
