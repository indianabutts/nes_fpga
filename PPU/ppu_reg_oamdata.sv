/*
 OAMDATA Register - Write Only
 Address : 0x2004
 
Write OAM Data here. Write will increment OAMADDR.
*/

module ppu_reg_oamdata(
		       input logic 	  clk,
		       input logic 	  oamdata_write_en,
		       input logic [7:0]  oamdata_in,
		       output logic       oamdata_write_complete,
		       output logic [7:0] oamdata_out
		       );
   logic [7:0] 				 oamdata_reg;

   //Sequential Write of the Oamdata
   always_ff@(posedge clk)
     begin
	oamdata_write_complete<=0;
	if (oamdata_write_en==1)
	  begin
	     oamdata_reg<=oamdata_in;
	     oamdata_write_complete<=1;
	  end
     end

   //This exposes the OAMDATA to the PPU
   assign oamdata_out=oamdata_reg;
   
   
endmodule // ppu_reg_oamdata


   
