/* CSE141L
   possible lookup table for PC target
   leverage a few-bit pointer to a wider number
   Lookup table acts like a function: here Target = f(Addr);
 in general, Output = f(Input); lots of potential applications 
*/
module Immediate_LUT #(PC_width = 12)(
  input               [ 3:0] addr,
  output logic[PC_width-1:0] datOut
  );

always_comb begin
  datOut = 'h001;	          // default to 1 (or PC+1 for relative)
  case(addr)		   
	3'b000:   datOut = 'h19;   // -4, i.e., move back 16 lines of machine code
	3'b001:	 datOut = 'h3b;
	3'b010:	 datOut = 'h3d;
	3'b011:	 datOut = 'h55;
	3'b100:	 datOut = 'hb;
	3'b101:	 datOut = 'hf;
	3'b110:	 datOut = 'h17;
	3'b111:	 datOut = 'h37;
	4'b1000:	 datOut = 'h3c;
	4'b1001:	 datOut = 'h44;
	4'b1010:	 datOut = 'h5c;
	4'b1011:  datOut = 'h5d;
	4'b1100:	 datOut = 'h7f;
	4'b1101:  datOut = 'h9b;
	4'b1110:  datOut = 'ha4;
  endcase
end

endmodule


			 // 3fc = 1111111100 -4
			 // PC    0000001000  8
			 //       0000000100  4  