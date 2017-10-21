module wb_mux2x1(
                  input [31:0]  wb_ir,
                  input [31:0]  IN_1, 
                  input [31:0]  IN_2,                 
                  input [31:0]  IN_3,
                  output logic [31:0] wb_out
                  );
  always_comb begin
    if(wb_ir[6:0]==7'b000_0011)
      wb_out = IN_2;
    else if(wb_ir[6:0]==7'b011_0111)begin
      wb_out  = IN_3 ; 
    end
    else
      wb_out = IN_1;
  end

endmodule                 
