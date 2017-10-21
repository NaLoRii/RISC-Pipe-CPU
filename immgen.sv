`define I_type 7'b001_0011 
`define I_type_LW 7'b000_0011			//lw instruction 
`define SW 7'b010_0011
`define U_type 7'b011_0111
module immgen(input [31:0]        id_ir,
              output reg [31:0]   imm,
			  input clk,
			  input rst
             );

  always_ff@(posedge clk) begin
    if(rst) 
      imm <= 32'h0000_0000;	
	else begin
      if(id_ir[6:0] == `I_type || id_ir[6:0] == `I_type_LW)  //IMM_I
        imm <= {{21{id_ir[31]}}, id_ir[30:20]};
	  else if(id_ir[6:0]== `SW)
        imm <= { {21{id_ir[31]}}, id_ir[30:25], id_ir[11:7] };
      else if(id_ir[6:0] == `U_type)//U_TYPE
        imm <= {id_ir[31:12],12'b0};
      else
        imm <= imm;	
    end
  end
endmodule // vscale_imm_gen