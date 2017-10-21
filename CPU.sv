`include "RegFile.sv"
`include "immgen.sv"
`include "ALU.sv"
`include "mux.sv"
`include "wb_mux2x1.sv"

`define R_type 7'b011_0011 
`define I_type 7'b001_0011 
`define I_type_LW 7'b000_0011 
`define SW 7'b010_0011
`define B_type 7'b110_0011
`define U_type 7'b011_0111
`define J_type 7'b110_1111 

`define ADD 3'b000
`define SLL 3'b001
`define SLT 3'b010
`define XOR 3'b100
`define SRL 3'b101
`define OR  3'b110
`define AND 3'b111
//I_type
//`define NOP 12'b0000_0000_0000
`define ADDI 3'b000
`define SLTI 3'b010
`define XORI 3'b100
`define ORI  3'b110
`define ANDI 3'b111
`define SLLI 3'b001
`define SRLI 3'b101
//BEQ
`define BEQ 000
`define BNE 001
module CPU(clk,  
		   rst,
		   IM_enable,
		   IM_out,
		   IM_address,
		   IM_write,
		   DM_enable,
		   DM_write,
		   DM_address,
		   DM_in,
		   DM_out
        );
  input clk,rst;
  input [31:0] IM_out,DM_out;
	
  output logic [31:0] IM_address,DM_address,DM_in;
  output logic IM_enable,DM_enable,IM_write,DM_write;
  
  logic [31:0] imm;
  logic [31:0] rs,rs1,rs2,rt,rt_p;
  logic [31:0] id_ir,ex_ir,mem_ir,mem_ir_1,wb_ir,wb_ir_p;
  logic [31:0] pc_p;
  logic [31:0] alu_in2,alu_out,alu_out_p,alu_out_p1,alu_out_p2,alu_out_p3;
  logic zero;
  logic reg_en,s_id;  
  logic [31:0] sw_data,sw_data_p,sw_data_p1,sw_data_p2;
  logic [31:0] wb_out;
  logic [31:0] lui_p,lui_p1,lui_p2;
reg_32x32 RF1 (.sel(s_id),
               .sw_data(sw_data),
			   .OUT_1(rs),
               .pc_p(IM_address),
               .id_ir(id_ir),
			   .wb_ir(wb_ir),
			   .OUT_2(rt), 
			   .DIN(wb_out), 
			   .clk(clk),
			   .rst(rst)
			   );	
immgen immgenator(
            .clk(clk),
			.rst(rst),
            .id_ir(id_ir),
			.imm(imm)
               );
mux2x1  id_MUX(
            .sel(s_id),
			.IN_1(rt),
			.IN_2(imm),
			.OUT(alu_in2)
			);
			
ALU  ALU1(//.clk(clk),
          //.rst(rst),
          .ex_ir(ex_ir),
		  .IN_1(rs),
		  .IN_2(alu_in2),
		  .out(alu_out),
		  .zero(zero),
		  .DM_enable(DM_enable_p),
		  .DM_write(DM_write_p)
	    );
wb_mux2x1	wb_mux(.wb_ir(wb_ir), 
               .IN_1(alu_out_p1), 
			   .IN_2(DM_out),
               .IN_3(lui_p1),			   
			   .wb_out(wb_out));
//===========IF=============
  always_ff@(posedge clk) begin
    if(rst) begin
      IM_address <= 32'h0000_0000;
	  id_ir <= 32'h0000_0000;
	  IM_enable <= 1'b1;
    end
    else begin
	  id_ir <= IM_out;
	  if((zero) && (mem_ir[6:0] == `B_type)) begin//7-bit
		IM_address <= IM_address - 32'd16 + {{20{mem_ir[31]}},mem_ir[7],mem_ir[30:25],mem_ir[11:8],1'b0};               
      end    
      else if(id_ir[6:0] == `JAL) begin
        IM_address <= IM_address + {{12{id_ir[31]}},id_ir[19:12],id_ir[20],id_ir[30:21],1'b0}-32'd8;
        pc_p <= IM_address;		
	  end
      else   
        IM_address <= IM_address + 32'd4;  
    end				
end
//===========ID============== 
  always_ff@(posedge clk) begin
    if(rst) begin
	  lui_p <= 32'h0000_0000;
	  ex_ir <= 32'h0000_0000;
	  rs1 <= 32'h0000_0000;	
      rs2 <= 32'h0000_0000;
	  sw_data_p <= 32'h0000_0000; 
 end
	else begin
	  lui_p <= imm;
	  ex_ir <= id_ir;
	  rs1 <= rs;
      rs2 <= alu_in2;
	  sw_data_p <= sw_data;
	end
end 
//===========EXE============
  always_ff@(posedge clk) begin
    if(rst) begin
      mem_ir <= 32'h0000_0000;
	//  DM_enable <= 1'b0;
	//  DM_write <= 1'b0;
      DM_in <= 32'hzzzz_zzzz;
    end
	else begin 
	  DM_enable <= DM_enable_p;
	  DM_write <= DM_write_p;
	  DM_address <= alu_out;
	  alu_out_p <= alu_out;
	  alu_out_p1 <= alu_out_p;
	  alu_out_p2 <= alu_out_p1;
	  alu_out_p3 <= alu_out_p2;
	  mem_ir <= ex_ir;
	  mem_ir_1 <= mem_ir;
	 // sw_data_p1 <= sw_data_p;
	  DM_in <= sw_data;
	  lui_p1 <= lui_p;
	 // lui_p2 <= lui_p1;
	end  
end
//=======================
  always_ff@(posedge clk) begin
    if(rst) begin
	  wb_ir <= 32'h0000_0000;
	end
	else begin
	  wb_ir <= mem_ir;
   end 
  end
endmodule