module IM(clk,
          rst,
          IM_out,
          IM_write,
          IM_enable,
          IM_in,
          IM_address);
  input clk,rst,IM_enable,IM_write;
  input [31:0] IM_in;
  input [31:0] IM_address;

  output logic [31:0] IM_out;
  logic [31:0] mem_data [65535:0];

  always_ff@(posedge clk or posedge rst) 
    begin
      if(rst) begin
	    IM_out <= 32'h0000_0000;
		for(integer i=0;i<65536;i=i+1)
	      mem_data[i] <= 'd0;
		end
   	  else 
        begin
          if(!IM_write & IM_enable)
	        IM_out  <= mem_data [IM_address];
          else if (IM_write & IM_enable)
            mem_data[IM_address] <= IM_in; 
          else
            IM_out <= 32'h0000_0000;
          end
      end
endmodule 
