module mux2x1( input sel,
               input   [31:0] IN_1,
               input   [31:0] IN_2,
               output reg [31:0]  OUT
             );

  always_comb begin
    case (sel)
      1'd0 : OUT = IN_1;
      1'd1 : OUT = IN_2;
      default : OUT = 32'h0000_0000;
    endcase 
   end
endmodule 