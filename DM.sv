module DM(clk,
          rst,
          DM_out,
          DM_write,
          DM_enable,
          DM_in,
          DM_address);
input clk,rst,DM_enable;
input [31:0] DM_in,DM_write;
input [31:0] DM_address;

output logic [31:0] DM_out;
logic [31:0] mem_data [65535:0];

always_ff@ (posedge clk) 
//always_ff@(posedge clk or posedge rst) 
    begin
        if(rst) 
           for(integer i=0;i<65536;i=i+1)
	            mem_data[i] <= 'd0;
	    else 
           begin
            if(!DM_write & DM_enable)
	            DM_out  <= mem_data [DM_address];
            else if (DM_write & DM_enable)
                mem_data[DM_address] <= DM_in; 
            else
                DM_out <= 32'h0000_0000;
           end
        end
endmodule 
