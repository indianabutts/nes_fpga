/*
 DATA Register - Write Only
 Address : 0x2007
 
 Write VRAM Data here. Write will increment ADDR.
*/

module ppu_reg_data(
		       input logic 	  clk,
		       input logic 	  data_write_en,
		       input logic [7:0]  data_in,
		       output logic       data_write_complete,
		       output logic [7:0] data_out
		       );
   logic [7:0] 				 data_reg;

   //Sequential Write of the Data
   always_ff@(posedge clk)
     begin
	data_write_complete<=0;
	if (data_write_en==1)
	  begin
	     data_reg<=data_in;
	     data_write_complete<=1;
	  end
     end

   //This exposes the DATA to the PPU
   assign data_out=data_reg;
   
   
endmodule // ppu_reg_data


   
