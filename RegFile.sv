`timescale 1ns/10ps
`define JAL 7'b110_1111
`define R_type 7'b011_0011 
`define U_type 7'b011_0111
`define B_type 7'b110_0011
`define I_type 7'b001_0011 
`define I_type_LW 7'b000_0011
module reg_32x32(sel,
                 OUT_1,
				 OUT_2,
				 DIN,
				 clk,
				 rst,
				 id_ir,
				 pc_p,
				 wb_ir,
				 sw_data);
    parameter REGSize = 32;
    parameter DASize = 32;

    input clk, rst;
    input [31:0] DIN;
	input [31:0] id_ir,pc_p,wb_ir;
	output logic [31:0]sw_data;
    output logic [DASize-1:0] OUT_1,OUT_2;
	output logic sel;
    logic [DASize-1:0] mem [REGSize-1:0];
	
	always_ff@(posedge clk) begin
	  if(id_ir[6:0]==`JAL)begin//jal
        mem[id_ir[11:7]]<= pc_p - 32'd4;
	  end
	end
	
	always_ff@(posedge clk) begin
      if(rst)begin
		for(int i=0; i<REGSize; i=i+1)begin
          mem[i] <= 32'h0000_0000;
        end
      end
      else begin
	    OUT_1 <= mem[id_ir[19:15]];
	    OUT_2 <= mem[id_ir[24:20]];
		if(wb_ir[6:0] == `U_type || wb_ir[6:0] == `R_type || wb_ir[6:0] == `I_type_LW) 
		  mem[wb_ir[11:7]] <= DIN;
	    else if(wb_ir[6:0] == `I_type) begin
		  if(wb_ir == 32'h13)
		    mem[wb_ir[11:7]] <= mem[wb_ir[11:7]];
		  else 
		    mem[wb_ir[11:7]] <= DIN;
		end
		else
		  mem[wb_ir[11:7]] <= mem[wb_ir[11:7]];    
	  end
      if(id_ir[6:0] == `R_type || id_ir[6:0] == `B_type)
        sel <= 1'b0;
      else 
        sel <= 1'b1;
      sw_data <= mem[id_ir[24:20]];		
	end 
endmodule