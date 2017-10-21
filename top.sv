`include "CPU.sv"
module top (clk,
            rst,
            IM_out,
            DM_out,
            IM_enable,
            IM_address,
            DM_write,
            DM_enable,
            DM_in,
            DM_address
			);
input clk,rst;
input [31:0] IM_out,DM_out;
output DM_write;
output logic [31:0] DM_in;
output logic [31:0] IM_address,DM_address;
output logic IM_enable,DM_enable;
CPU CPU1(.clk(clk),  
	     .rst(rst),
		 .IM_enable(IM_enable),
		 .IM_out(IM_out),
		 .IM_address(IM_address),
		 .IM_write(IM_write),
		 .DM_write(DM_write),
		 .DM_enable(DM_enable),
		 .DM_in(DM_in),
		 .DM_address(DM_address),
		 .DM_out(DM_out)
        );
endmodule
